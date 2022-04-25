package stx.assert.pml.ord;

import eu.ohmrun.Pml.PExpr in PExprT;

class PExpr<T> extends OrdCls<PExprT<T>>{
  var inner : Ord<T>;
  public function new(inner){
    this.inner = inner;
  }
  public function comply(lhs:PExprT<T>,rhs:PExprT<T>){
    return switch([lhs,rhs]){
      case [Label(lhs),Label(rhs)]        : Ord.String().comply(lhs,rhs);
      case [Group(lhs),Group(rhs)]        : 
        lhs.zip(rhs.toIterable()).lfold(
          (tp:Couple<PExprT<T>,PExprT<T>>,m:Ordered) -> switch(m){
            case LessThan : LessThan;
            default       : comply(tp.fst(),tp.snd());
          },
          NotLessThan
        );
      case [Value(lhs),Value(rhs)]      : inner.comply(lhs,rhs);
      case [Empty,Empty]                : NotLessThan;
      case [null, null]                 : NotLessThan;
      case [null,_]                     : LessThan;
      case [_,null]                     : NotLessThan;
      default                           : 
        EnumValue.pure(lhs).index() < EnumValue.pure(rhs).index() ? LessThan : NotLessThan;
    }
  }
}