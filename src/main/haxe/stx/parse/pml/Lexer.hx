package stx.parse.pml;

using stx.parse.pml.Lexer;

inline function id(string) return __.parse().id(string);
inline function reg(string) return __.parse().reg(string);

//TODO new regular expression situation.
class Lexer{
  static public var tl_bracket              = "{".id().then((_) -> TLBracket).tagged("lbracket");
  static public var tr_bracket              = "}".id().then((_) -> TRBracket).tagged("rbracket");

  static public var tl_paren                = "(".id().then((_) -> TLParen).tagged("lparen");
  static public var tr_paren                = ")".id().then((_) -> TRParen).tagged("rparen");
  static public var whitespace              = Parse.whitespace.tagged("whitespace");
  
  static public function float(str:String){
    return TAtom(N(KLFloat(Std.parseFloat(str))));
  }
  static public final k_float_r             = "(-?[0-9]+(.[0-9]+)?)";
  static public var k_float                 = k_float_r.reg().then(float).tagged('float');
  static public var k_number                = k_float.tagged('number');

  static function between(current:String){
    return current.substr(1,current.length - 2).trim();
  }
  static public var k_string      = Parse.literal
    .then(
      (x) -> TAtom(Str(x))
    ).tagged('string');

  static public var k_bool        = '\\(true|false\\)'.reg()
    .then(
      (x) -> TAtom(B(x == "true" ? true : false))
    ).tagged('bool');
      
  static public var k_atom        = "[^ \r\t\n\\(\\)]+".reg()
    .then(
      (x:String) -> TAtom(AnSym((x:Symbol)))
    ).tagged('atom');
    
  static public var main : Parser<String,Cluster<Token>> = (
    whitespace.many()._and(
      [
        tl_paren,
        tr_paren,
        tl_bracket,
        tr_bracket,
        k_number,
        k_string,
        k_bool,
        k_atom,
      ].ors()
      ).one_many()
       .and_(whitespace.many())
       .and_(Parsers.Eof())
  );
  static function print_ipt(ipt){
    trace(ipt);
  }
  static function print_opt(opt){
    trace(opt);
  }
}