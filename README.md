# PML  (Paranthetical Markup Language)

PML is a data format very like EDN sans sets because sets in Haxe are impossible to build generically.

```haxe

enum Token{
  TLParen;
  TRParen;
  TLBracket;
  TRBracket;
  TAtom(v:Atom);
  TEof;
}

typedef Symbol = String;

enum Atom{//Data, Eq, Show, Typeable)
  AnSym(s:Symbol);
  B(b:Bool);
  N(fl:Num);
  Str(str:String);
  Nul;
} 

//n.b PLabel is parsed in if the first character of the symbol is ":" , otherwise as PExpr<Atom>
enum PExprSum<T>{
  PApply(name:String);
  PLabel(name:String);
  PGroup(list:LinkedList<PExpr<T>>);
  PValue(value:T);
  PEmpty;
}

```

I might add parsing of labels such as `label:(exprs...)` for AST construction. Not sure if it's needed.

