package eu.ohmrun.pml;

enum PSchemaSum<T>{
  PSVal(t:PType<T>);
  PSAlt(l:PSchema<T>,r:PSchema<T>);
  PSSeq(l:PSchema<T>,r:PSchema<T>);
  PSOpt(s:PSchema<T>);
  PSMany(s:PSchema<T>);
}
@:using(eu.ohmrun.pml.PSchema.PSchemaLift)
abstract PSchema<T>(PSchemaSum<T>) from PSchemaSum<T> to PSchemaSum<T>{
  static public var _(default,never) = PSchemaLift;
  public inline function new(self:PSchemaSum<T>) this = self;
  @:noUsing static inline public function lift<T>(self:PSchemaSum<T>):PSchema<T> return new PSchema(self);

  public function prj():PSchemaSum<T> return this;
  private var self(get,never):PSchema<T>;
  private function get_self():PSchema<T> return lift(this);
}
class PSchemaLift{
  static public inline function lift<T>(self:PSchemaSum<T>):PSchema<T>{
    return PSchema.lift(self);
  }
}