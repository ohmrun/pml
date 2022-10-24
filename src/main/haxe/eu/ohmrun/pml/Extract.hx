package eu.ohmrun.pml;

using stx.Parse;


class Extract{
  static final e_not_a_group = 'Head not a group';

  private static function handle_head<T,Z>(f:PExpr<T>->ParseResult<PExpr<T>,Z>){
    return (input:ParseInput<PExpr<T>>) -> {
      input.head().fold(
        f,
        (e) -> e.toParseResult_with(input),
        ()  -> input.no('empty input')
      );
    } 
  }
  static public function unpack<Z>():Parser<PExpr<Atom>,Z>{
    return Parsers.Anon(
      (input:ParseInput<PExpr<Atom>>) -> 
      handle_head(
        x -> switch(x){
          case PGroup(xs)  : 
            var n = xs.rfold(
             (next,memo:ParseInput<PExpr<Atom>>) -> memo.prepend(__.tracer()(next))
             ,input.tail().prepend(PValue(Nul))
            );
            n.nil();
          default         : input.no(e_not_a_group);
        }
      )(input),
      Some('unpack')
    );
  }
  static public function wordish():Parser<PExpr<Atom>,String>{
    return Parsers.Anon(
      (input:ParseInput<PExpr<Atom>>) -> handle_head(
        x -> switch(__.tracer()(x)){
          case PValue(AnSym(s)) : input.tail().ok(s);
          case PValue(Str(s))   : input.tail().ok(s);
          case PLabel(x)        : input.tail().ok(x);
          default : input.no('not wordish but $x');
        }
      )(input),
      Some('wordish')
    );
  }
  static public function nul(name){
    return Parsers.Anon(
      (input) -> {
        trace(name);
        return handle_head(
          x -> switch(__.tracer()(x)){
            case PValue(Nul)  : input.tail().nil();
            default           : input.no('not Nul $name');
          }
        )(input);
      },
      Some('nul $name')
    );
  }
  static public function symbol(name:String){
    return Parsers.Anon(
      (input:ParseInput<PExpr<Atom>>) -> {
        trace(name);
        return handle_head(
          x -> switch(__.tracer()(x)){
            case PValue(AnSym(s)) if (s == name): input.tail().ok(s);
            case PValue(AnSym(s))               : input.no('symbol should be $name, but is $s');
            default                             : input.no('not a symbol');
          }
        )(input);
      },
      Some('symbol')
    );
  }
  /**
    Unpacks the items in head if its a PGroup, then uses the `nul` created by unpack to determine if a group has been fully parsed.
  **/
  static public function imbibe<T>(p:Parser<PExpr<Atom>,T>,name:String){
    return unpack()._and(p).and_(nul(name));
  }
  static public function fmap<T>(f:PExpr<Atom> -> Option<T>,name:String):Parser<PExpr<Atom>,T>{
    return Parsers.Anon(
      (input:ParseInput<PExpr<Atom>>) -> handle_head(
        (x) -> switch(f(x)){
          case Some(x)  : input.tail().ok(x);
          case None     : input.no('failed $name');
        }
      )(input),
      name
    );
  }
}