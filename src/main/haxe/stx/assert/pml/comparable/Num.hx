package stx.assert.pml.comparable;

import eu.ohmrun.pml.Num in NumT;

class Num extends ComparableCls<NumT>{
  public function new(){
  }
  public function eq(){
    return new stx.assert.pml.eq.Num();
  }
  public function lt(){
    return new stx.assert.pml.ord.Num();
  }
}