package eu.ohmrun.pml;

enum ExprDef<T>{
  Label(name:String);
  Group(list:LinkedList<Expr<T>>);
  Value(value:T);
  Empty;
  //Flect
}
@:using(eu.ohmrun.pml.Expr.ExprLift)
abstract Expr<T>(ExprDef<T>) from ExprDef<T> to ExprDef<T>{
  static public var _(default,never) = ExprLift;
  public function new(self) this = self;

  @:noUsing static public function parse(str:String){
    var timer = Timer.unit();
    __.log().debug('lex');
    var p = new stx.parse.pml.Parser();
    var l = stx.parse.pml.Lexer;
    
    var reader  = str.reader();
    return Modulate.fromFletcher(l.main.toFletcher()).reclaim(
      (tkns:ParseResult<String,Cluster<Token>>) -> {
        __.log().debug('lex expr: ${timer.since()}');
        timer = timer.start();
        return tkns.is_ok().if_else(
          ()               -> {
            var reader : ParseInput<Token> = tkns.value.defv([]).reader();
            return p.main().provide(reader).toProduce().convert(
              __.passthrough(
                (_) -> {
                  __.log().debug('parse expr: ${timer.since()}');
                }
              )
            );
          },
          () -> {
            return Produce.pure([].reader().fail('fail'));
          }
        );
      }
    ).produce(__.accept(reader));
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
  public function data_only():Option<Cluster<T>>{
    return switch(this){
      case Group(xs) : 
        xs.lfold(
          (n,m:Option<Cluster<T>>) -> switch(m){
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
  static public function eq<T>(inner:Eq<T>):Eq<Expr<T>>{
    return new stx.assert.eq.term.Expr(inner);
  }
  static public function lt<T>(inner:Ord<T>):Ord<Expr<T>>{
    return new stx.assert.ord.term.Expr(inner);
  }
  static public function comparable<T>(inner:Comparable<T>):Comparable<Expr<T>>{
    return new stx.assert.comparable.term.Expr(inner);
  }
}
