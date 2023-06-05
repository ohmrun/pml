package stx.assert.pml.eq;

import eu.ohmrun.Pml.PExpr in PExprT;

final Eq = __.assert().Eq();

class PExpr<T> extends EqCls<PExprT<T>>{
  var inner : Eq<T>;
  public function new(inner){
    this.inner = inner;
  }
  public function comply(lhs:PExprT<T>,rhs:PExprT<T>){
    //trace('$lhs $rhs');
    return switch([lhs,rhs]){
      case [PLabel(lhs),PLabel(rhs)]      : Eq.String().comply(lhs,rhs);
      case [PGroup(lhs),PGroup(rhs)]      : 
        lhs.zip(rhs).lfold(
          (tp,m) -> switch(m){
            case NotEqual : NotEqual;
            default       : comply(tp.fst(),tp.snd());
          },
          AreEqual
        );
      case [PValue(lhs),PValue(rhs)]      : inner.comply(lhs,rhs);
      case [PAssoc(lhs),PAssoc(rhs)]      : Eq.Cluster(Eq.Tup2(this,this)).comply(lhs,rhs);
      case [PSet(lhs),PSet(rhs)]          : Eq.Cluster(this).comply(lhs,rhs);
      case [PEmpty,PEmpty]                : AreEqual;
      case [null, null]                   : AreEqual;
      case [null,_]                       : NotEqual;
      case [_,null]                       : NotEqual;
      default                             : NotEqual;
    }
  }
}