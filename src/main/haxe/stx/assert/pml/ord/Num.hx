package stx.assert.pml.ord;

import eu.ohmrun.pml.Num as TNum;

final Ord = __.assert().Ord();

class Num extends OrdCls<TNum>{

  public function new(){}

  public function comply(a:TNum,b:TNum):Ordered{
    trace('$a,$b');
    return switch([a,b]){
      case [NInt(iI),NInt(iII)]       : Ord.Int().comply(iI,iII);
      case [NFloat(flI),NFloat(flII)] : Ord.Float().comply(flI,flII);
      default                           : NotLessThan;
    }
  }
}