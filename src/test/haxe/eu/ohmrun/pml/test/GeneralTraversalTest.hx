package eu.ohmrun.pml.test;

class GeneralTraversalTest extends TestCase{
  public function test(){
    final v = __.pml().parser()(__.resource("traversal").string().reader()).toUpshot();
    for(x in v.value()){
      $type(x);
      PExpr._.traverse(x,(x) -> {
        trace(x.toString());
        return __.accept(Some((x)));
      });
    }
  }
}
