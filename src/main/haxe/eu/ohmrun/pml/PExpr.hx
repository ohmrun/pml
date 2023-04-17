package eu.ohmrun.pml;

enum PExprSum<T>{
  PLabel(name:String);
  PGroup(list:LinkedList<PExpr<T>>);
  PValue(value:T);
  PEmpty;
  PAssoc(map:Cluster<Tup2<PExpr<T>,PExpr<T>>>);
  //PArray(xs:Cluster<PExpr<T>>);
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
    return Modulate.pure(l.main.apply(reader)).reclaim(
      (tkns:ParseResult<String,Cluster<Token>>) -> {
        __.log().debug('lex expr: ${timer.since()}');
        timer = timer.start();
        __.log().trace('${tkns}');
        return tkns.is_ok().if_else(
          ()               -> {
            var reader : ParseInput<Token> = tkns.value.defv([]).reader();
            return Produce.pure(p.main().apply(reader)).convert(
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
      case PAssoc(map) : PAssoc(map);
     }
  }  
  public function toString():String{
    return toString_with(Std.string);
  }
  public function toString_with(fn:T->String,?opt : { ?width : Int, ?indent : String }):String{
    if(opt == null){
      opt = { width : 130, indent : " "};
    }
    if(opt.width  == null) opt.width  = 130;
    if(opt.indent == null) opt.indent = " ";
    return (function rec(self:PExpr<T>,?ind=0):String{
      final gap = Iter.range(0,ind).lfold((n,m) -> '$m${opt.indent}',"");
      return switch(self){
        case PLabel(name)     : '$name';
        case PGroup(array)    : 
          var items         = array.map(rec.bind(_,ind+1));
          var length        = items.lfold((n,m) -> m + n.length,ind);
          var horizontal    = length < opt.width ? true : false;
          return horizontal.if_else(
            () -> '(' + items.join(",") + ')',
            () -> '(\n ${gap}' + items.join(',\n ${gap}') + '\n${gap})'
          );
        case PValue(value)    : fn(value);
        case PEmpty           : "()";
        case Pssoc(map)      : 
          final items           = map.map(
            __.detuple((k,v) -> {
             return __.couple(rec(k,ind + 1),rec(v,ind + 1));
            })
          );
          final horizontal_test = items.map(
            __.decouple((l,r) -> {
              return '$l $r';
            })
          );
          final length  = horizontal_test.lfold((n,m) -> m + n.length + 2,ind);
          final showing = if(length > opt.width){
            final widest = horizontal_test.lfold(
              (n,m) -> {
                final l = n.length;
                return l > m ? l : m;
              },
              0
            );
            if(widest > opt.width){
              items.map(
                __.decouple(
                  (l:String,r:String) -> '${gap}$l\n${gap}$r'
                )
              ).lfold(
                (n,m) -> '$m\n$n',
                ""
              );
            }else{
              items.map(
                __.decouple(
                  (l,r) -> '${gap}$l: $r'
                )
              ).lfold(
                (n,m) -> '$m\n$n',
                ""
              );
            }
          }else{
            var data = horizontal_test.lfold((n,m) -> '$m, $n',"");
            '${gap}$data';
          }
          showing;
          // var len           = items.lfold((n,m) -> m + n.length,0);
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
              default            : None;
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
  //TODO any rescueing map given the typing?
  // static public function map<T,TT>(expr:PExpr<T>,fn:T->TT):PExpr<TT>{
  //   return switch expr {
  //     case PLabel(name)      : PLabel(name);
  //     case PGroup(list)      : PGroup(list.map(e -> e.map(fn)));
  //     case PValue(value)     : PValue(fn(value));
  //     case PAssoc(map)       : 
  //     final next = RedBlackMap.make(map.with);
  //     for(key => val in map){
  //       next.set(map())
  //     }  
  //     PAssoc(

        
  //     );
  //     case PEmpty            : PEmpty;
  //   }
  // }
  static public function eq<T>(inner:Eq<T>):Eq<PExpr<T>>{
    return new stx.assert.pml.eq.PExpr(inner);
  }
  static public function lt<T>(inner:Ord<T>):Ord<PExpr<T>>{
    return new stx.assert.pml.ord.PExpr(inner);
  }
  static public function comparable<T>(inner:Comparable<T>):Comparable<PExpr<T>>{
    return new stx.assert.pml.comparable.PExpr(inner);
  }
  // static public function denote<T>(self:PExpr<T>,fn:T->GExpr){
  //   return new stx.g.denote.PExpr(fn).apply(self);
  // }
  //static public function fold<T>(self:PExpr<T>)
}

/**
  case PLabel(name)    :
        case PGroup(list)    :
        case PValue(value)   : 
        case PEmpty          : 
**/