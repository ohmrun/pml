package stx.parse.pml;


using stx.parse.pml.Lexer;

import stx.parse.parsers.StringParsers in SParse;

inline function id(string) return SParse.id(string);
inline function reg(string) return SParse.reg(string);

class Lexer{
  static public var tl_bracket              = "{".id().then((_) -> PTLBracket).tagged("lbracket");
  static public var tr_bracket              = "}".id().then((_) -> PTRBracket).tagged("rbracket");

  static public var tl_square_bracket       = "[".id().then((_) -> PTLSquareBracket).tagged("l_square_bracket");
  static public var tr_square_bracket       = "]".id().then((_) -> PTRSquareBracket).tagged("r_square_bracket");

  static public var tl_paren                = "(".id().then((_) -> PTLParen).tagged("lparen");
  static public var tr_paren                = ")".id().then((_) -> PTRParen).tagged("rparen");

  static public var whitespace              = SParse.whitespace.tagged("whitespace");
  
  static public function t_hash_lbracket(){
    return id("#").and(tl_bracket).then(_ -> PTHashLBracket);
  }
  static public function float(str:String){
    return PTData(N(NFloat(Std.parseFloat(str))));
  }
  static public var k_float                 = SParse.float.then(float).tagged('float');
  static public function int(str:String){
    return PTData(N(NInt(Std.parseInt(str))));
  }
  static public var k_int                   = SParse.integer.and_(id(".").not().lookahead()).then(int).tagged('int');

  static function between(current:String){
    return current.substr(1,current.length - 2).trim();
  }
  static public var k_string      = SParse.literal
    .then(
      (x) -> PTData(Str(x))
    ).tagged('string');

  static public var k_bool        = "^(true|false)".reg()
    .then(
      (x) -> {
        //trace('((($x)))');
        return PTData(B(__.tracer()(x) == "true" ? true : false));
      }
    ).tagged('bool');
      
  static public var k_atom        = "[^ {}\\[\\],\r\t\n\\(\\)]+".reg()
    .then(
      (x:String) -> PTData(Sym((x:Symbol)))
    ).tagged('atom');
    
  static public var main : Parser<String,Cluster<Token>> = (
    whitespace.many()._and(
      [
        tl_paren,
        tr_paren,
        t_hash_lbracket(),
        tl_square_bracket,
        tr_square_bracket,
        tl_bracket,
        tr_bracket,
        k_bool,
        k_int,
        k_float,
        k_string,
        ",".id().and_then(_ -> Parsers.Nothing()),
        k_atom,
      ].ors()
      ).one_many()
       .and_(whitespace.or(','.id()).many())
       .and_(Parsers.Eof())
  );
  static function print_ipt(ipt){
    trace(ipt);
  }
  static function print_opt(opt){
    trace(opt);
  }
}