package stx.assert.pml.eq;

import eu.ohmrun.pml.PChainKind as TPChainKind;

final Eq = __.assert().Eq();

class PChainKind extends EqCls<TPChainKind>{

  public function new(){}

  public function comply(a:TPChainKind,b:TPChainKind):Equaled{
    return Eq.EnumValueIndex().comply(a,b);
  }
}