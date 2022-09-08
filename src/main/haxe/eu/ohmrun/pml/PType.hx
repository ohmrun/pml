package eu.ohmrun.pml;

enum PTypeSum<T>{
 PAny;
 PAtm;
 PLst(t:PType<T>);
 PHsh(k:PType<T>,v:PType<T>);
 PObj(record:Record<PType<T>>);
 PInj(t:T); 
}
@:using(eu.ohmrun.pml.PType.PTypeLift)
abstract PType<T>(PTypeSum<T>) from PTypeSum<T> to PTypeSum<T>{
  static public var _(default,never) = PTypeLift;
  public inline function new(self:PTypeSum<T>) this = self;
  @:noUsing static inline public function lift<T>(self:PTypeSum<T>):PType<T> return new PType(self);

  public function prj():PTypeSum<T> return this;
  private var self(get,never):PType<T>;
  private function get_self():PType<T> return lift(this);
}
class PTypeLift{
  static public inline function lift<T>(self:PTypeSum<T>):PType<T>{
    return PType.lift(self);
  }
}