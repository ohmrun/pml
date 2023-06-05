package stx.assert.pml.eq;


import eu.ohmrun.pml.Atom as TAtom;

final Eq = __.assert().Eq();

class Atom extends EqCls<TAtom>{

  public function new(){}

  public function comply(a:TAtom,b:TAtom):Equaled{
    return switch([a,b]){
      case [AnSym(sI),AnSym(sII)]   : Eq.String().comply(sI,sII);
      case [B(bI),B(bII)]           : Eq.Bool().comply(bI,bII);
      case [N(flI),N(flII)]         : Eq.pml().Num.comply(flI,flII);
      case [Str(strI),Str(strII)]   : Eq.String().comply(strI,strII);
      case [Nul,Nul]                : AreEqual;
      default                       : NotEqual;
    }
  }
}