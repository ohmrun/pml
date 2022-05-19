package stx.g.denote;

using stx.g.Lang;
import eu.ohmrun.pml.PExpr in TPExpr;

class PExpr<T>{
  public final inner : T -> GExpr;
  public function new(inner){
    this.inner = inner;
  }
  public function apply(self:TPExpr<T>){
    final e = __.g().expr();
    return switch(self){
      case Label(name)      : 
        e.Call(
          e.Path('eu.ohmrun.pml.PExpr.PExprDef.Label'),
          [e.Const(c -> c.String(name))]
        );
      case Group(list)      : 
        final xs = list.toIter().foldr(
          (n,m) -> e.Call(
            e.Path('stx.ds.LinkedList.LinkedListSum.Cons'),
            [
              apply(n),m
            ]
          ),
          e.Path('stx.ds.LinkedList.LinkedListSum.Nil')
        );
        e.Call(
          e.Path('eu.ohmrun.pml.PExpr.PExprDef.Group'),
          [xs]
        );
      case Value(value)     : 
        e.Call(
          e.Path('eu.ohmrun.pml.PExpr.PExprDef.Value'),
          [inner(value)]
        );
      case Empty:
        e.Path('eu.ohmrun.pml.PExpr.PExprDef.Empty');
    }
  }
}