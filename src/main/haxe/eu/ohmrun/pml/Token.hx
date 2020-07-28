package eu.ohmrun.pml;

enum Token{
  TLParen;
  TRParen;
  TAtom(v:Atom);
  TEof;
}

