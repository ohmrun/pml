package eu.ohmrun.pml;

enum AtomSum{//Data, Eq, Show, Typeable)
  AnSym(s:Symbol);
  B(b:Bool);
  N(fl:Num);
  Str(str:String);
  Nul;
} 
@:using(eu.ohmrun.pml.Atom.AtomLift)
abstract Atom(AtomSum) from AtomSum to AtomSum{
  static public var _(default,never) = AtomLift;
  public function new(self) this = self;
  static public function lift(self:AtomSum):Atom return new Atom(self);

  

  public function prj():AtomSum return this;
  private var self(get,never):Atom;
  private function get_self():Atom return lift(this);
}
class AtomLift{
  static public function toString(self:Atom){
    return switch(self){
      case AnSym(s)           : '${s}';
      case B(b)               : Std.string(b);
      case N(fl)              : Std.string(fl);
      case Str(str)           : '$str';
      case Nul                : '';
    }
  }
}