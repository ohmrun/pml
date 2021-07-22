package stx.parse.pml;

using stx.parse.pml.Lexer;

inline function id(string) return __.parse().id(string);
inline function reg(string) return __.parse().reg(string);

class Lexer{
  static public var tl_paren      = "(".id().then((_) -> TLParen);
  static public var tr_paren      = ")".id().then((_) -> TRParen);
  static public var whitespace    = Parse.whitespace;
  
  static public function float(str:String){
    return TAtom(N(KLFloat(Std.parseFloat(str))));
  }
  static public var k_float               = "\\\\-?[0-9]+(\\\\.[0-9]+)?".reg().then(float);
  static public var k_number              = k_float;

  static function between(current:String){
    return current.substr(1,current.length - 2).trim();
  }
  static public var k_string      = Parse.literal
    .then(
      (x) -> TAtom(Str(x))
    );
  static public var k_bool        = '\\(true|false\\)'.reg()
    .then(
      (x) -> TAtom(B(x == "true" ? true : false))
    );
      
  static public var k_atom        = "[^ \r\t\n\\(\\)]+".reg()
    .then(
      (x:String) -> TAtom(AnSym((x:Symbol)))
    );
  static public var main : Parser<String,Array<Token>> = (
    Parser.Inspect(whitespace.many())._and(
      [
        tl_paren,
        tr_paren,
        k_number,
        k_string,
        k_bool,
        k_atom,
      ].ors()
      ).one_many()
       .and_(Parser.Eof())
  );
    static function print_ipt(ipt){
      trace(ipt);
    }
    static function print_opt(opt){
      trace(opt);
    }
}