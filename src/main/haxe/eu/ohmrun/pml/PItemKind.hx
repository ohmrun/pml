package eu.ohmrun.pml;

class PItemKindCtr extends Clazz{
  public function Empty() { PItmEmpty; }
  public function Label() { PItmLabel; }
  public function Apply() { PItmApply; }
  public function Value() { PItmValue; }
}
enum PItemKindSum{
  PItmEmpty;
  PItmLabel;
  PItmApply;
  PItmValue;
}
@:using(eu.ohmrun.pml.PItemKind.PItemKindLift)
abstract PItemKind(PItemKindSum) from PItemKindSum to PItemKindSum{
  static public var _(default,never) = PItemKindLift;
  public inline function new(self:PItemKindSum) this = self;
  @:noUsing static inline public function lift(self:PItemKindSum):PItemKind return new PItemKind(self);

  public function prj():PItemKindSum return this;
  private var self(get,never):PItemKind;
  private function get_self():PItemKind return lift(this);
}
class PItemKindLift{
  static public inline function lift(self:PItemKindSum):PItemKind{
    return PItemKind.lift(self);
  }
}