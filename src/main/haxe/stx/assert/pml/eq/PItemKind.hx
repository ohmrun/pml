package stx.assert.pml.eq;

import eu.ohmrun.pml.PItemKind as TPItemKind;

final Eq = __.assert().Eq();

class PItemKind extends EqCls<TPItemKind>{

  public function new(){}

  public function comply(a:TPItemKind,b:TPItemKind):Equaled{
    return Eq.EnumValueIndex().comply(a,b);
  }
}