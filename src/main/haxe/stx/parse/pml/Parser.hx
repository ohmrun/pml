package stx.parse.pml;

import stx.parse.Parser in Prs;

class Parser{
  public function new(){}
  public function lparen_p(){
    return Parse.eq(TLParen);
  }
  public function rparen_p(){
    return Parse.eq(TRParen);
  }
  public function val(){
    return stx.parse.Parsers.Choose(
      (t:Token) -> switch(t){
        case TAtom(atm) : Some(Value(atm));
        case null       : None;
        default         : None;
      }
    );
  }
  function engroup(arr:Cluster<Expr<Atom>>){
    return Group(arr.toLinkedList());
  }
  public function main():Prs<Token,Expr<Atom>>{
    return expr_p().one_many().then(engroup);
  }
  public function expr_p():Prs<Token,Expr<Atom>>{
    return [
      val(),
      list_p()
    ].ors();
  }
  public function list_p():Prs<Token,Expr<Atom>>{
    return bracketed(expr_p.defer().many());
  }
  private function bracketed(p:Prs<Token,Cluster<Expr<Atom>>>):Prs<Token,Expr<Atom>>{
    return lparen_p()._and(p).and_(rparen_p()).then(
      (arr:Cluster<Expr<Atom>>) -> {
        return Group(arr.toLinkedList());
      }
    );
  }
}
