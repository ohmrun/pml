package stx.assert.pml.comparable;

import eu.ohmrun.Pml.PExpr in PExprT;

class PExpr<T> extends ComparableCls<PExprT<T>>{
  var inner : Comparable<T>;
  public function new(inner){
    this.inner = inner;
  }
  public function eq(){
    return new stx.assert.pml.eq.PExpr(this.inner.eq());
  }
  public function lt(){
    return new stx.assert.pml.ord.PExpr(this.inner.lt());
  }
}