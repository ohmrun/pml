package eu.ohmrun.pml.test;

using stx.parse.pml.Lexer;

class HaxeV4_3_0_RegularExpressionsTest extends TestCase{
  public function test(){
    final str = Lexer.k_float_r;
    trace(str);
    final reg = new EReg(str,"g");
    final res = reg.match("0.1");
    trace(res);
    var i = 0;
    while(true){
      trace(reg.matched(i));
      i++;
    }

  }
}