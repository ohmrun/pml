package eu.ohmrun.pml.test;

@stx.test.async
class V2Test extends TestCase{
  public function test(async:stx.test.Async){
    final v               = __.resource("v2").string();
    final provide         = __.pml().parse(v); 
    __.ctx(
      Noise,
      (x:ParseResult<Token,PExpr<Atom>>) -> {
        final v = x.toUpshot().option().flat_map(x -> x).defv(null);
        trace(v.toString_with((x:Atom) -> x.toString()));
        async.done();
      }
    ).load(provide)
     .submit();
  }
}