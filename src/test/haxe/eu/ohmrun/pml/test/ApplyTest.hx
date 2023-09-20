package eu.ohmrun.pml.test;

import eu.ohmrun.pml.pexpr.Apply;

class ApplyTest extends TestCase{
  static public function main(){
    __.test().run([
      new ApplyTest()
    ],[]);
  }
  public function test(){
    final v = __.resource('apply').string();
    final x = __.pml().parser()(v.reader()).fudge();
    final r = new SomeApply(this).apply(x);
    trace(r);
  }
}
class SomeApply extends Apply<Atom>{
  final test_case : TestCase;
  final values    : Array<Tup2<String,PExpr<Atom>>>;
  public function new(test_case){
    super();
    this.test_case = test_case;
    this.values    = [
      tuple2("first", PValue(N(NInt(1)))),
      tuple2("test", PValue(Sym("this"))),
      tuple2("again",PGroup(Cons(PValue(N(NInt(1))),Cons(PValue(N(NInt(2))),Nil)))),
      tuple2("thingle",PValue(Sym("a"))),
      tuple2("array",PValue(Sym("first"))),
      tuple2("array_rest",PValue(B(false))),
      tuple2("set",PValue(Sym("first_set"))),
      tuple2("second_set",PValue(B(true)))
    ];
  }
  public function comply(str:String,expr:PExpr<Atom>){
    final val = values.shift();
    test_case.equals(str,val.fst());
    test_case.same(expr,val.snd());
    return PEmpty;
  }
}