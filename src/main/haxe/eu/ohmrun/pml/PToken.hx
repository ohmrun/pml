package eu.ohmrun.pml;

/**
 * Represents a valid input token.
 */
@stx.meta.sum
enum PTokenSum<T>{
  PTLParen;
  PTRParen;
  PTHashLBracket;
  PTLBracket;
  PTRBracket;
  PTLSquareBracket;
  PTRSquareBracket;
  PTData(v:T);
  PTEof;
}
/**
 * Represents a valid input token.
 */
@stx.meta.using
@:using(eu.ohmrun.pml.PToken.PTokenLift)
abstract PToken<T>(PTokenSum<T>) from PTokenSum<T> to PTokenSum<T>{
  @stx.meta.using
  static public var _(default,never) = PTokenLift;
  public inline function new(self:PTokenSum<T>) this = self;
  @stx.meta.lift
  @:noUsing static inline public function lift<T>(self:PTokenSum<T>):PToken<T> return new PToken(self);

  @stx.meta.prj
  public function prj():PTokenSum<T> return this;
  private var self(get,never):PToken<T>;
  private function get_self():PToken<T> return lift(this);
}
@stx.meta.using
class PTokenLift{
  @stx.meta.lift
  static public inline function lift<T>(self:PTokenSum<T>):PToken<T>{
    return PToken.lift(self);
  }
}