package eu.ohmrun.pml;

enum PExprSum<T>{
  PLabel(name:String);
  PGroup(list:LinkedList<PExpr<T>>);
  PValue(value:T);
  PEmpty;
}
@:using(eu.ohmrun.pml.PExpr.PExprLift)
abstract PExpr<T>(PExprSum<T>) from PExprSum<T> to PExprSum<T>{
  static public var _(default,never) = PExprLift;
  public function new(self) this = self;

  @:noUsing static public function parse(str:String):Produce<ParseResult<Token,PExpr<Atom>>,Noise>{
    var timer = Timer.unit();
    __.log().debug('lex');
    var p = new stx.parse.pml.Parser();
    var l = stx.parse.pml.Lexer;
    
    var reader  = str.reader();
    return Modulate.fromFletcher(l.main.toFletcher()).reclaim(
      (tkns:ParseResult<String,Cluster<Token>>) -> {
        __.log().debug('lex expr: ${timer.since()}');
        timer = timer.start();
        __.log().trace('${tkns}');
        return tkns.is_ok().if_else(
          ()               -> {
            var reader : ParseInput<Token> = tkns.value.defv([]).reader();
            return p.main().provide(reader).toProduce().convert(
              (
                (_) -> {
                  __.log().debug('parse expr: ${timer.since()}');
                }
              ).promote()
            );
          },
          () -> {
            return Produce.pure(ParseResult.make([].reader(),null,tkns.error));
          }
        );
      }
    ).produce(__.accept(reader));
  }
  @:noUsing static public function lift<T>(self:PExprSum<T>):PExpr<T> return new PExpr(self);

  

  public function prj():PExprSum<T> return this;
  private var self(get,never):PExpr<T>;
  private function get_self():PExpr<T> return lift(this);

  public function conflate(that:PExpr<T>):PExpr<T>{
    return switch(this){
      case PEmpty                        : that;
      case PLabel(_) | PValue(_)          : PGroup(Cons(this,Cons(that,Nil)));
      case PGroup(array)                 : switch(that){
        case PGroup(list)  : PGroup(array.concat(list));
        default           : PGroup(array.snoc(that));
      }
    }
  }  
  public function toString():String{
    return toString_with(Std.string);
  }
  public function toString_with(fn:T->String,?width=130):String{
    return (function rec(self:PExpr<T>,?ind=""):String{
      return switch(self){
        case PLabel(name)     : '$name';
        case PGroup(array)    : 
          var items         = array.map(rec.bind(_,'$ind '));
          var length        = items.lfold((n,m) -> m + n.length,0);
          var horizontal    = length < width ? true : false;
          return horizontal.if_else(
            () -> '(' + items.join(",") + ')',
            () -> '(\n $ind' + items.join(',\n ${ind}') + '\n$ind)'
          );
        case PValue(value)    : fn(value);
        case PEmpty           : "()";
        case null             : "";
      }
    })(this);
  }
  public function data_only():Option<Cluster<T>>{
    return switch(this){
      case PGroup(xs) : 
        xs.lfold(
          (n,m:Option<Cluster<T>>) -> switch(m){
            case Some(arr) : switch(n){
              case PValue(value) : Some(arr.snoc(value));
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
class PExprLift{
  static public function map<T,TT>(expr:PExpr<T>,fn:T->TT):PExpr<TT>{
    return switch expr {
      case PLabel(name)      : PLabel(name);
      case PGroup(list)      : PGroup(list.map(e -> e.map(fn)));
      case PValue(value)     : PValue(fn(value));
      case PEmpty            : PEmpty;
    }
  }
  static public function eq<T>(inner:Eq<T>):Eq<PExpr<T>>{
    return new stx.assert.pml.eq.PExpr(inner);
  }
  static public function lt<T>(inner:Ord<T>):Ord<PExpr<T>>{
    return new stx.assert.pml.ord.PExpr(inner);
  }
  static public function comparable<T>(inner:Comparable<T>):Comparable<PExpr<T>>{
    return new stx.assert.pml.comparable.PExpr(inner);
  }
  static public function denote<T>(self:PExpr<T>,fn:T->GExpr){
    return new stx.g.denote.PExpr(fn).apply(self);
  }
}

/**
  case PLabel(name)    :
        case PGroup(list)    :
        case PValue(value)   : 
        case PEmpty          : 
**/