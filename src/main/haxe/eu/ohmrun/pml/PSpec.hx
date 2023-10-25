package eu.ohmrun.pml;

enum PSpecSum<T>{
  PSig(sig:PSignature);
  PSeq(l:PSpec<T>,r:PSpec<T>);
  PAlt(l:PSpec<T>,r:PSpec<T>);
  POpt(spec:PSpec<T>);
  PNot(spec:PSpec<T>);
  PAny;
  PItm;//PLabel,PApply,PValue
  PLst;//PGroup,PArray,PSet
  PStr;//PLabel,PApply
  PNil;//PEmpty
  PVal(v:T);//PValue
}
@:using(eu.ohmrun.pml.PSpec.PSpecLift)
abstract PSpec<T>(PSpecSum<T>) from PSpecSum<T> to PSpecSum<T>{
  static public var _(default,never) = PSpecLift;
  public inline function new(self:PSpecSum<T>) this = self;
  @:noUsing static inline public function lift<T>(self:PSpecSum<T>):PSpec<T> return new PSpec(self);

  public function prj():PSpecSum<T> return this;
  private var self(get,never):PSpec<T>;
  private function get_self():PSpec<T> return lift(this);
}
class PSpecLift{
  static public inline function lift<T>(self:PSpecSum<T>):PSpec<T>{
    return PSpec.lift(self);
  }
} 