package eu.ohmrun;

using stx.Nano;
class Pml{
  //#end
  static public function pml(wildcard:Wildcard){
    return new eu.ohmrun.pml.Module();
  }
}

typedef Lexer         = stx.parse.pml.Lexer;

typedef AtomDef       = eu.ohmrun.pml.Atom.AtomDef;
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
typedef Num             = eu.ohmrun.pml.Num;
typedef Symbol          = eu.ohmrun.pml.Symbol;
typedef Token           = eu.ohmrun.pml.Token;
typedef PExprDef<T>     = eu.ohmrun.pml.PExpr.PExprDef<T>;
typedef PExpr<T>        = eu.ohmrun.pml.PExpr<T>;
typedef PTypeSum<T>     = eu.ohmrun.pml.PType.PTypeSum<T>;
typedef PType<T>        = eu.ohmrun.pml.PType<T>;
typedef PSchemaSum<T>   = eu.ohmrun.pml.PSchema.PSchemaSum<T>;
typedef PSchema<T>      = eu.ohmrun.pml.PSchema<T>;

typedef PmlFailure    = stx.fail.PmlFailure;
typedef PmlFailureSum = stx.fail.PmlFailure.PmlFailureSum;