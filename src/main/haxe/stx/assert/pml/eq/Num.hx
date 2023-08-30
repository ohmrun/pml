package stx.assert.pml.eq;

import eu.ohmrun.pml.Num as TNum;

final Eq = __.assert().Eq();

class Num extends EqCls<TNum>{

  public function new(){}

  public function comply(a:TNum,b:TNum):Equaled{
    return switch([a,b]){
      case [NInt(iI),NInt(iII)]       : Eq.Int().comply(iI,iII);
      case [NFloat(flI),NFloat(flII)] : Eq.Float().comply(flI,flII);
      default                           : NotEqual;
    }
  }
}