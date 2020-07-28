package pml;


import stx.parse.pml.Lexer;

class Test{
  static public function main(){
    __.test([
      new LexerTest(),
    ]);
  }
}
class LexerTest extends haxe.unit.TestCase{
  public function _test_main(){
    var reader = "(s)".reader();
    var parser = Lexer.main;
    var result = parser.forward(reader).fudge();
    trace(result);
  }
  public function test_haxe(){
    var reader = __.resource("haxe_cpl").string();
    var parser = Expr.parse(reader);
    var result = parser.fudge().value();
    trace(result);
  }
}