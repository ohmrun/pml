package stx.assert.pml.eq;

import eu.ohmrun.pml.PSignature as TPSignature;

final Eq = __.assert().Eq();

class PSignature extends EqCls<TPSignature>{

  public function new(){}

  public function comply(a:TPSignature,b:TPSignature):Equaled{
    return switch([a,b]){
        case [PSigPrimate(kindI),PSigPrimate(kindII)] : 
          Eq.pml().PItemKind.comply(kindI,kindII);
        case [PSigCollect(xI),PSigCollect(xII)]       :
          comply(xI,xII);
        case [PSigCollate(keyI,valsI),PSigCollate(keyII,valsII)]       :
          var eq = comply(keyI,keyII);
          if(eq.is_ok()){
            eq = Eq.OneOrMany(this).comply(valsI,valsII);
          }
          eq;
        case [PSigOutline(arrI),PSigOutline(arrII)] : 
          var eq = Eq.Cluster(Eq.Tup2(this,this)).comply(arrI,arrII);
          eq;
        case [PSigBattery(xsI,chainI),PSigBattery(xsII,chainII)] : 
          var eq = Eq.OneOrMany(this).comply(xsI,xsII);
          if(eq.is_ok()){
            eq = Eq.pml().PChainKind.comply(chainI,chainII);
          }
          eq;
        default : 
          Eq.EnumValueIndex().comply(a,b);
    }
  }
}