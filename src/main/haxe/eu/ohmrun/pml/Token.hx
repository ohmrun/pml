package eu.ohmrun.pml;

enum Token{
  TLParen;
  TRParen;
  THashLBracket;
  TLBracket;
  TRBracket;
  TLSquareBracket;
  TRSquareBracket;
  TAtom(v:Atom);
  TEof;
}

