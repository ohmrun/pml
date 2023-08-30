package eu.ohmrun.pml.test;

class LexerTest extends TestCase{
  // public function _test_main(){
  //   var reader = "(s)".reader();
  //   var parser = Lexer.main;
  //   var result = parser.apply(reader);
  //   trace(result);
  // }
  // //@timeout(120000)
  // public function test_main_2(async:Async){
  //   var t      = Timer.unit();
  //   var reader = __.resource("haxe_cpl").string().reader();
  //   var parser = Lexer.main;
  //   var value  = parser.apply(reader);
  //   trace(value);
  // }
  // public function _test_haxe(){
  //   var reader = __.resource("haxe_cpl").string();
  // }
  public function test_bool(){
    final v = "false ";
    final p = Lexer.k_bool;
    final v = p.apply(v.reader());
    trace(v);
  }
}