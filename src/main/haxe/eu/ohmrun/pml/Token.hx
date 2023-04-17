package eu.ohmrun.pml;

enum Token{
  TLParen;
  TRParen;
  TLBracket;
  TRBracket;
  TAtom(v:Atom);
  TEof;
}

