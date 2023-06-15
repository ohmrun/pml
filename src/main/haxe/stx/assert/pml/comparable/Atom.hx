package stx.assert.pml.comparable;

import eu.ohmrun.pml.Atom in AtomT;

class Atom extends ComparableCls<AtomT>{
  public function new(){
  }
  public function eq(){
    return new stx.assert.pml.eq.Atom();
  }
  public function lt(){
    return new stx.assert.pml.ord.Atom();
  }
}