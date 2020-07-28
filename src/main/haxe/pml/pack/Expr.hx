package pml.pack;

enum ExprDef<T>{
  Label(name:String);
  Group(list:LinkedList<Expr<T>>);
  Value(value:T);
  Empty;
  //Flect
}
@:using(pml.pack.Expr.ExprLift)
abstract Expr<T>(ExprDef<T>) from ExprDef<T> to ExprDef<T>{
  static public var _(default,never) = ExprLift;
  public function new(self) this = self;

  @:noUsing static public function parse(str:String){
    //var timer = __.timer();
    trace('lex expr:');
    var p = new stx.parse.pml.Parser();
    var l = stx.parse.pml.Lexer;
    
    var reader  = str.reader();
    return l.main.toArrowlet().toCascade().reclaim(
      (tkns:ParseResult<String,Array<Token>>) -> {
        //trace('lex expr: ${timer.since()}');
        return tkns.fold(
          (arr)               -> {
            var reader : Input<Token> = arr.with.defv([]).reader();
            return p.main().forward(reader).toProceed().process(
              __.passthrough(
                (_) -> {
                  //trace(timer.since());
                }
              )
            );
          },
          (err)   -> {
            return Proceed.pure(ParseFailure.at_with([].reader(),'fail').toParseResult());
          }
        );
      }
    ).forward(reader);
  }
  @:noUsing static public function lift<T>(self:ExprDef<T>):Expr<T> return new Expr(self);

  

  public function prj():ExprDef<T> return this;
  private var self(get,never):Expr<T>;
  private function get_self():Expr<T> return lift(this);

  public function conflate(that:Expr<T>):Expr<T>{
    return switch(this){
      case Empty                        : that;
      case Label(_) | Value(_)          : Group(Cons(this,Cons(that,Nil)));
      case Group(array)                 : switch(that){
        case Group(list)  : Group(array.concat(list));
        default           : Group(array.snoc(that));
      }
    }
  }  
  public function toString():String{
    return toString_with(Std.string);
  }
  public function toString_with(fn:T->String,?width=130):String{
    return (function rec(self:Expr<T>,?ind=""):String{
      return switch(self){
        case Label(name)    : '$name';
        case Group(array)   : 
          var items         = array.map(rec.bind(_,'$ind '));
          var length        = items.lfold((n,m) -> m + n.length,0);
          var horizontal    = length < width ? true : false;
          return horizontal.if_else(
            () -> '(' + items.join(",") + ')',
            () -> '(\n $ind' + items.join(',\n ${ind}') + '\n$ind)'
          );
        case Value(value)   : fn(value);
        case Empty          : "()";
        case null           : "";
      }
    })(this);
  }
  public function data_only():Option<Array<T>>{
    return switch(this){
      case Group(xs) : 
        xs.lfold(
          (n,m:Option<Array<T>>) -> switch(m){
            case Some(arr) : switch(n){
              case Value(value) : Some(arr.snoc(value));
              default           : None;
            }
            default : None;
          },
          Some([])
        );
      default : None;
    }
  }
}
class ExprLift{
  static public function map<T,TT>(expr:Expr<T>,fn:T->TT):Expr<TT>{
    return switch expr {
      case Label(name)      : Label(name);
      case Group(list)      : Group(list.map(e -> e.map(fn)));
      case Value(value)     : Value(fn(value));
      case Empty            : Empty;
    }
  }
}
