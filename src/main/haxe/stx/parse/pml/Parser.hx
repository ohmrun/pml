package stx.parse.pml;

using stx.parse.pml.Parser;

function id(wildcard:Wildcard,s:String){
  return __.parse().parsers().string().id(s);
}

class Parser{
  public function new(){}
  public function lparen_p(){
    return Parsers.Equals(PTLParen).tagged('lparen');
  }
  public function rparen_p(){
    return Parsers.Equals(PTRParen).tagged('rparen');
  }
  public function hash_lbracket_p(){
    return Parsers.Equals(PTHashLBracket).tagged('hash_lbracket');
  }
  public function lbracket_p(){
    return Parsers.Equals(PTLBracket).tagged('lbracket');
  }
  public function rbracket_p(){
    return Parsers.Equals(PTRBracket).tagged('rbracket');
  }
  public function l_square_bracket_p(){
    return Parsers.Equals(PTLSquareBracket).tagged('lbracket');
  }
  public function r_square_bracket_p(){
    return Parsers.Equals(PTRSquareBracket).tagged('rbracket');
  }
  public function val(){
    return stx.parse.Parsers.Choose(
      (t:Token) -> switch(t){
        case PTData(AnSym(s)) if (s.startsWith(":")) : Some(PLabel(s.substr(1)));
        case PTData(atm)                             : Some(PValue(atm));
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
      set_p(),
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
  public function set_p(){
    return hash_lbracket_p()._and(expr_p.cache().many()).and_(rbracket_p()).then(
      (arr) -> PSet(arr)
    );
  }
  private function bracketed(p:stx.parse.Parser<Token,Cluster<PExpr<Atom>>>):stx.parse.Parser<Token,PExpr<Atom>>{
    return lparen_p()._and(p).and_(rparen_p()).then(
      (arr:Cluster<PExpr<Atom>>) -> {
        return PGroup(arr.toLinkedList());
      }
    );
  }
  private function square_bracketed(p:stx.parse.Parser<Token,Cluster<PExpr<Atom>>>):stx.parse.Parser<Token,PExpr<Atom>>{
    return l_square_bracket_p()._and(p).and_(r_square_bracket_p()).then(
      (arr:Cluster<PExpr<Atom>>) -> {
        return PArray(arr);
      }
    );
  }
}
