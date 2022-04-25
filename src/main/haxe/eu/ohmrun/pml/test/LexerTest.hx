package eu.ohmrun.pml.test;

class LexerTest extends TestCase{
  public function test_main(){
    var reader = "(s)".reader();
    var parser = Lexer.main;
    var result = parser.provide(reader).fudge();
    trace(result);
  }
  //@timeout(120000)
  public function test_main_2(async:Async){
    var t      = Timer.unit();
    var reader = __.resource("haxe_cpl").string().reader();
    var parser = Lexer.main;
    parser.provide(reader).environment(
      (x) -> {
        trace(x);
        trace(t.since());
        async.done();
      }
    ).submit();
    //async.done();
  }
  public function _test_haxe(){
    var reader = __.resource("haxe_cpl").string();
    var parser = PExpr.parse(reader);
    var result = parser.fudge().value;
    trace(result);
  }
}