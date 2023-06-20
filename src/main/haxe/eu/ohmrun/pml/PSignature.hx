package eu.ohmrun.pml;

enum PSignature{
  PSigPrimate(p:PItemKind);
  PSigCollect(c:PSignature,kind:PChainKind);  
  PSigCollate(key:PSignature,vals:OneOrMany<PSignature>);
  PSigOutline(arr:Cluster<Tup2<PSignature,PSignature>>);
  PSigBattery(arr:Cluster<PSignature>,kind:PChainKind);
}