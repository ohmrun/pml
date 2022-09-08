# PML  (Paranthetical Markup Language)

PML is a data format much like a language that is known and loved but not mentioned here for the same reason actors don't mention the Scottish play.

It has no lambdas but the typed definitions are convenient enough where you have generics and sum types, and quite nice indeed when you add pattern matching.

```haxe

enum Token{
  TLParen;
  TRParen;
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

//n.b PLabel is not parsed in, the parsed in type is PExpr<Atom>
enum PExprDef<T>{
  PLabel(name:String);
  PGroup(list:LinkedList<PExpr<T>>);
  PValue(value:T);
  PEmpty;
}

```

I might add parsing of labels such as `label:(exprs...)` for AST construction. Not sure if it's needed.

