# PML  (Paranthetical Markup Language)

PML is a data format much like a language that is known and loved but not mentioned here for the same reason actors don't mention the Scotish play.

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
  UnboundSym(s:Symbol);
  B(b:Bool);
  N(fl:Num);
  Str(str:String);
  Nul;
} 

//n.b Label is not parsed in, the parsed in type is Expr<Atom>
enum ExprDef<T>{
  Label(name:String);
  Group(list:LinkedList<Expr<T>>);
  Value(value:T);
  Empty;
}

```

I might add parsing of labels such as `label:(exprs...)` for AST construction. Not sure if it's needed.

