package eu.ohmrun.pml;

import stx.om.Spine;

@:using(eu.ohmrun.pml.Atom.AtomLift)
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
  @:noUsing static public function lift(self:AtomSum):Atom return new Atom(self);

  
  public function prj():AtomSum return this;
  private var self(get,never):Atom;
  private function get_self():Atom return lift(this);
}
class AtomLift{
  static public function toString(self:Atom){
    return switch(self){
      case AnSym(s)           : '${s}';
      case B(b)               : Std.string(b);
      case N(fl)              : fl.toString();
      case Str(str)           : '$str';
      case Nul                : '';
    }
  }
  /**
   * Produce a Primitive from an Atom.
   * @param self 
   */
  static public function toPrimitive(self:Atom){
    return switch(self){
      case AnSym(s)           : Primate(PSprig(Textal(s)));
      case B(b)               : Primate(PBool(b));
      case N(NFloat(fl))     : Primate(PSprig(Byteal(NFloat(fl))));
      case N(NInt(fl))       : Primate(PSprig(Byteal(NInt(fl))));
      case Str(str)           : Primate(PSprig(Textal(str)));
      case Nul                : Unknown;
    }
  }
  static public function fromPrimitive(self:Primitive){
    return switch(self){
      case PSprig(Textal(s))            : AnSym(s);
      case PBool(b)                     : B(b);
      case PSprig(Byteal(NFloat(fl)))   : N(NFloat(fl));
      case PSprig(Byteal(NInt64(fl)))   : throw "64 bit unhandled here"; Nul;
      case PSprig(Byteal(NInt(fl)))     : N(NInt(fl));
      case PNull                        : Nul;
    }
  }
}