package stx.assert.comparable.term;

import eu.ohmrun.Pml.Expr in ExprT;

class Expr<T> implements ComparableApi<ExprT<T>>{
  var inner : Comparable<T>;
  public function new(inner){
    this.inner = inner;
  }
  public function eq(){
    return new stx.assert.eq.term.Expr(this.inner.eq());
  }
  public function lt(){
    return new stx.assert.ord.term.Expr(this.inner.lt());
  }
}