package pml;

typedef AtomDef       = pml.pack.Atom.AtomDef;
typedef Atom          = pml.pack.Atom;
class AtomLift{
  static public function toString(atom:Atom){
    return switch atom {
      case UnboundSym(s)  : '$s';
      case B(b)           : '$b';
      case N(fl)          : '$fl';
      case Str(str)       : str;
      case Nul            : '<null>';
    }
  }
}
typedef Num           = pml.pack.Num;
typedef Symbol        = pml.pack.Symbol;
typedef Token         = pml.pack.Token;
typedef ExprDef<T>    = pml.pack.Expr.ExprDef<T>;
typedef Expr<T>       = pml.pack.Expr<T>;