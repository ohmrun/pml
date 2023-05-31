package eu.ohmrun;

using stx.Nano;
class Pml{
  static public function pml(wildcard:Wildcard){
    return new eu.ohmrun.pml.Module();
  }
}
typedef Lexer         = stx.parse.pml.Lexer;
typedef AtomSum       = eu.ohmrun.pml.Atom.AtomSum;
typedef Atom          = eu.ohmrun.pml.Atom;

class AtomLift{
  static public function toString(atom:Atom){
    return switch atom {
      case AnSym(s)         : '$s';
      
      case B(b)             : '$b';
      case N(fl)            : '$fl';
      case Str(str)         : str;
      case Nul              : '<null>';
    }
  }
}
typedef NumSum          = eu.ohmrun.pml.Num.NumSum;
typedef Num             = eu.ohmrun.pml.Num;
typedef Symbol          = eu.ohmrun.pml.Symbol;
typedef PTokenSum<T>    = eu.ohmrun.pml.PToken.PTokenSum<T>;
typedef PToken<T>       = eu.ohmrun.pml.PToken<T>;
typedef Token           = eu.ohmrun.pml.Token;
typedef PExprSum<T>     = eu.ohmrun.pml.PExpr.PExprSum<T>;
typedef PExpr<T>        = eu.ohmrun.pml.PExpr<T>;
typedef PListKind       = eu.ohmrun.pml.PListKind;
typedef PItemKind       = eu.ohmrun.pml.PItemKind;
typedef PAggregateKind  = eu.ohmrun.pml.PAggregateKind;
typedef PType           = eu.ohmrun.pml.PType;

typedef PmlFailure    = stx.fail.PmlFailure;
typedef PmlFailureSum = stx.fail.PmlFailure.PmlFailureSum;