package eu.ohmrun.pml;

enum AtomDef{//Data, Eq, Show, Typeable)
  UnboundSym(s:Symbol);
  B(b:Bool);
  N(fl:Num);
  Str(str:String);
  Nul;
} 
@:using(eu.ohmrun.pml.Atom.AtomLift)
abstract Atom(AtomDef) from AtomDef to AtomDef{
  static public var _(default,never) = AtomLift;
  public function new(self) this = self;
  static public function lift(self:AtomDef):Atom return new Atom(self);

  

  public function prj():AtomDef return this;
  private var self(get,never):Atom;
  private function get_self():Atom return lift(this);
}
class AtomLift{
  static public function toString(self:Atom){
    return switch(self){
      case UnboundSym(s)      : '\\$${s}';
      case B(b)               : Std.string(b);
      case N(fl)              : Std.string(fl);
      case Str(str)           : '"$str"';
      case Nul                : 'nul';
    }
  }
}