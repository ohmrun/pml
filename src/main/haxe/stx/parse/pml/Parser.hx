package stx.parse.pml;

using stx.parse.pml.Parser;

function id(wildcard:Wildcard,s:String){
  return __.parse().id(s);
}

class Parser{
  public function new(){}
  public function lparen_p(){
    return Parse.eq(TLParen).tagged('lparen');
  }
  public function rparen_p(){
    return Parse.eq(TRParen).tagged('rparen');
  }
  public function lbracket_p(){
    return Parse.eq(TLBracket).tagged('lbracket');
  }
  public function rbracket_p(){
    return Parse.eq(TRBracket).tagged('rbracket');
  }
  public function val(){
    return stx.parse.Parsers.Choose(
      (t:Token) -> switch(t){
        case TAtom(AnSym(s)) if (s.startsWith(":")) : Some(PLabel(s.substr(1)));
        case TAtom(atm)                             : Some(PValue(atm));
        case null                                   : None;
        default                                     : None;
      }
    ).tagged('val');
  }
  function engroup(arr:Cluster<PExpr<Atom>>){
    return PGroup(arr.toLinkedList());
  }
  public function main():stx.parse.Parser<Token,PExpr<Atom>>{
    return expr_p().one_many().then(engroup);
  }
  public function expr_p():stx.parse.Parser<Token,PExpr<Atom>>{
    return [
      map_p(),
      val(),
      list_p()
    ].ors().tagged("expr");
  }
  public function map_p(){
    return lbracket_p()._and(map_item_p().many()).and_(rbracket_p()).then(PAssoc);
  }
  public function map_item_p(){
    return expr_p.cache().and(expr_p.cache()).then(__.decouple(tuple2));
  }
  public function list_p():stx.parse.Parser<Token,PExpr<Atom>>{
    return bracketed(expr_p.cache().tagged('expr').many().tagged('exprs')).tagged('list');
  }
  private function bracketed(p:stx.parse.Parser<Token,Cluster<PExpr<Atom>>>):stx.parse.Parser<Token,PExpr<Atom>>{
    return lparen_p()._and(p).and_(rparen_p()).then(
      (arr:Cluster<PExpr<Atom>>) -> {
        return PGroup(arr.toLinkedList());
      }
    );
  }
}
