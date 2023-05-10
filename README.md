# PML  (Paranthetical Markup Language)

PML is a data format very like EDN.

## Usage

```haxe
  using stx.Nano;
  using eu.ohmrun.Fletcher;
  using eu.ohmrun.Pml;

  function parse_something(){
    final provide = __.pml().parse(__.resource("test.pml"));
    __.ctx().load(provide)
  }
```
```haxe
enum Token{
  TLParen;
  TRParen;
  PTLBracket;
  PTRBracket;
  PTData(v:Atom);
  PTEof;
}

typedef Symbol = String;

enum Atom{//Data, Eq, Show, Typeable)
  AnSym(s:Symbol);
  B(b:Bool);
  N(fl:Num);
  Str(str:String);
  Nul;
} 

enum PExprSum<T>{
  PLabel(name:String);//:
  PApply(name:String);//#
  PGroup(list:LinkedList<PExpr<T>>);//(...)
  PArray(array:Cluster<PExpr<T>>);//[...]
  PValue(value:T);//
  PEmpty;
  PAssoc(map:Cluster<Tup2<PExpr<T>,PExpr<T>>>);//{}
  PSet(arr:Cluster<PExpr<T>>);//#{}
}

```

I might add parsing of labels such as `label:(exprs...)` for AST construction. Not sure if it's needed.

