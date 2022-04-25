package stx.parse.pml;

import stx.parse.Parser in Prs;

class Parser{
  public function new(){}
  public function lparen_p(){
    return Parse.eq(TLParen).tagged('lparen');
  }
  public function rparen_p(){
    return Parse.eq(TRParen).tagged('rparen');
  }
  public function val(){
    return stx.parse.Parsers.Choose(
      (t:Token) -> switch(t){
        case TAtom(atm) : Some(Value(atm));
        case null       : None;
        default         : None;
      }
    ).tagged('val');
  }
  function engroup(arr:Cluster<PExpr<Atom>>){
    return Group(arr.toLinkedList());
  }
  public function main():Prs<Token,PExpr<Atom>>{
    return expr_p().one_many().then(engroup);
  }
  public function expr_p():Prs<Token,PExpr<Atom>>{
    return [
      val(),
      list_p()
    ].ors().tagged("expr");
  }
  public function list_p():Prs<Token,PExpr<Atom>>{
    return bracketed(expr_p.defer().tagged('expr').many().tagged('exprs')).tagged('list');
  }
  private function bracketed(p:Prs<Token,Cluster<PExpr<Atom>>>):Prs<Token,PExpr<Atom>>{
    return lparen_p()._and(p).and_(rparen_p()).then(
      (arr:Cluster<PExpr<Atom>>) -> {
        return Group(arr.toLinkedList());
      }
    );
  }
}
