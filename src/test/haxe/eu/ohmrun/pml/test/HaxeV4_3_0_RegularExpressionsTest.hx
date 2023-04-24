package eu.ohmrun.pml.test;

using stx.parse.pml.Lexer;

class HaxeV4_3_0_RegularExpressionsTest extends TestCase{
  public function test_float(){
    final p = Lexer.k_float;
    final s = '-0.1'.reader();
    final r = p.apply(s);
    for(x in r.toUpshot().fudge()){
      same(x,TAtom(N(KLFloat(-0.1))));
    }
  }
  public function test_bool(){
    final p = Lexer.k_bool;
    final s = 'false'.reader();
    final r = p.apply(s);
    for(x in r.toUpshot().fudge()){
      trace(x);
      same(x,TAtom(B(false)));
    }
  }
}