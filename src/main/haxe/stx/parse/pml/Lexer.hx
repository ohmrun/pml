package stx.parse.pml;

class Lexer{
  static public var tl_paren      = "(".id().then((_) -> TLParen);
  static public var tr_paren      = ")".id().then((_) -> TRParen);
  static public var whitespace    = "[ \r\t\n]".regexParser();
  
  static public function float(str:String){
    return TAtom(N(KLFloat(Std.parseFloat(str))));
  }
  static public var k_float               = "\\-?[0-9]+(\\.[0-9]+)?".regexParser().then(float);
  static public var k_number              = k_float;

  static function between(current:String){
    return current.substr(1,current.length - 2).trim();
  }
  static public var k_string      = '"[^"]*"'.regexParser()
    .then(
      (x) -> TAtom(Str(Lexer.between(x)))
    );
  static public var k_bool        = '(true|false)'.regexParser()
    .then(
      (x) -> TAtom(B(x == "true" ? true : false))
    );
  
  static public var k_atom        = "[^ \r\t\n\\(\\)]+".regexParser()
    .then(
      (x) -> TAtom(UnboundSym(x))
    );
  static public var main : Parser<String,Array<Token>> = (whitespace.many()._and([
    tl_paren,
    tr_paren,
    k_number,
    k_string,
    k_bool,
    k_atom,
  ].ors())).one_many().and_(Parse.eof());
}