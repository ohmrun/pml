package stx.assert.pml.ord;

import eu.ohmrun.Pml.PExpr in PExprT;

class PExpr<T> extends OrdCls<PExprT<T>>{
  var inner : Ord<T>;
  public function new(inner){
    this.inner = inner;
  }
  public function comply(lhs:PExprT<T>,rhs:PExprT<T>){
    return switch([lhs,rhs]){
      case [PLabel(lhs),PLabel(rhs)]        : Ord.String().comply(lhs,rhs);
      case [PGroup(lhs),PGroup(rhs)]        : 
        lhs.zip(rhs.toIterable()).lfold(
          (tp:Couple<PExprT<T>,PExprT<T>>,m:Ordered) -> switch(m){
            case LessThan : LessThan;
            default       : comply(tp.fst(),tp.snd());
          },
          NotLessThan
        );
      case [PValue(lhs),PValue(rhs)]      : inner.comply(lhs,rhs);
      case [PEmpty,PEmpty]                : NotLessThan;
      case [null, null]                   : NotLessThan;
      case [null,_]                       : LessThan;
      case [_,null]                       : NotLessThan;
      default                             : 
        EnumValue.pure(lhs).index < EnumValue.pure(rhs).index ? LessThan : NotLessThan;
    }
  }
}