package stx.assert.pml.eq;

import eu.ohmrun.Pml.PExpr in PExprT;

class PExpr<T> implements EqApi<PExprT<T>>{
  var inner : Eq<T>;
  public function new(inner){
    this.inner = inner;
  }
  public function comply(lhs:PExprT<T>,rhs:PExprT<T>){
    return switch([lhs,rhs]){
      case [Label(lhs),Label(rhs)]      : Eq.String().comply(lhs,rhs);
      case [Group(lhs),Group(rhs)]      : 
        lhs.zip(rhs).lfold(
          (tp,m) -> switch(m){
            case NotEqual : NotEqual;
            default       : comply(tp.fst(),tp.snd());
          },
          AreEqual
        );
      case [Value(lhs),Value(rhs)]      : inner.comply(lhs,rhs);
      case [Empty,Empty]                : AreEqual;
      case [null, null]                 : AreEqual;
      case [null,_]                     : NotEqual;
      case [_,null]                     : NotEqual;
      default                           : NotEqual;
    }
  }
}