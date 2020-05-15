package pml.pack;

enum Token{
  TLParen;
  TRParen;
  TAtom(v:Atom);
  TEof;
}

