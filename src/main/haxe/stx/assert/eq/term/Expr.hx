package stx.assert.eq.term;

import eu.ohmrun.Pml.Expr in ExprT;

class Expr<T> implements EqApi<ExprT<T>>{
  var inner : Eq<T>;
  public function new(inner){
    this.inner = inner;
  }
  public function applyII(lhs:ExprT<T>,rhs:ExprT<T>){
    return switch([lhs,rhs]){
      case [Label(lhs),Label(rhs)]      : Eq.String().applyII(lhs,rhs);
      case [Group(lhs),Group(rhs)]      : 
        lhs.zip(rhs).lfold(
          (tp,m) -> switch(m){
            case NotEqual : NotEqual;
            default       : applyII(tp.fst(),tp.snd());
          },
          AreEqual
        );
      case [Value(lhs),Value(rhs)]      : inner.applyII(lhs,rhs);
      case [Empty,Empty]                : AreEqual;
      case [null, null]                 : AreEqual;
      case [null,_]                     : NotEqual;
      case [_,null]                     : NotEqual;
      default                           : NotEqual;
    }
  }
}