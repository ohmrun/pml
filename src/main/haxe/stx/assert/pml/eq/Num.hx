package stx.assert.pml.eq;

import eu.ohmrun.pml.Num as TNum;

final Eq = __.assert().Eq();

class Num extends EqCls<TNum>{

  public function new(){}

  public function comply(a:TNum,b:TNum):Equaled{
    return switch([a,b]){
      case [KLInt(iI),KLInt(iII)]       : Eq.Int().comply(iI,iII);
      case [KLFloat(flI),KLFloat(flII)] : Eq.Float().comply(flI,flII);
      default                           : NotEqual;
    }
  }
}