package eu.ohmrun.pml;

//final PSpec = __.pml().PSpec;

class PSignatureCtr extends Clazz{
  // public function Primate(p:CTR<PItemKindCtr,PItemKind>){
  //   return PSigPrimate(p.apply(PSpec.PItemKind));
  // }
  // public function Collect(sig:CTR<PSignatureCtr,PSignature>,kind){
  //   return PSigCollect(sig.apply(this),)
  // }
}
enum PSignatureSum{
  PSigPrimate(p:PItemKind);
  PSigCollect(c:PSignature,kind:PChainKind);  
  PSigCollate(key:PSignature,vals:OneOrMany<PSignature>);
  PSigOutline(arr:Cluster<Tup2<PSignature,PSignature>>);
  PSigBattery(arr:Cluster<PSignature>,kind:PChainKind);
}
@:using(eu.ohmrun.pml.PSignature.PSignatureLift)
abstract PSignature(PSignatureSum) from PSignatureSum to PSignatureSum{
  static public var _(default,never) = PSignatureLift;
  public inline function new(self:PSignatureSum) this = self;
  @:noUsing static inline public function lift(self:PSignatureSum):PSignature return new PSignature(self);

  public function prj():PSignatureSum return this;
  private var self(get,never):PSignature;
  private function get_self():PSignature return lift(this);
}
class PSignatureLift{
  static public inline function lift(self:PSignatureSum):PSignature{
    return PSignature.lift(self);
  }
}