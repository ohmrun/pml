package pml.pack;
 
enum Atom{//Data, Eq, Show, Typeable)
  UnboundSym(s:Symbol);
  B(b:Bool);
  N(fl:Num);
  Str(str:String);
  Nul;
} 
