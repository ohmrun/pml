package stx.assert.pml.ord;


import eu.ohmrun.pml.Atom as TAtom;

final Ord = __.assert().Ord();

class Atom extends OrdCls<TAtom>{

  public function new(){}

  public function comply(a:TAtom,b:TAtom):Ordered{
    return switch([a,b]){
      case [Sym(sI),Sym(sII)]   : Ord.String().comply(sI,sII);
      case [B(bI),B(bII)]           : Ord.Bool().comply(bI,bII);
      case [N(flI),N(flII)]         : Ord.pml().Num.comply(flI,flII);
      case [Str(strI),Str(strII)]   : Ord.String().comply(strI,strII);
      case [Nul,Nul]                : NotLessThan;
      default                       : NotLessThan;
    }
  }
}