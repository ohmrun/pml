package eu.ohmrun.pml.test;

class V2Test extends TestCase{
  public function test(){
    final v = __.resource("v2").string();
    final p : PExpr<Atom> = __.pml().parse(v).provide().fudge().toRes().option().flat_map(x -> x).defv(null);
    trace(p.toString_with((x:Atom) -> x.toString()));
  }
}