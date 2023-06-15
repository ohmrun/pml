package stx.assert.pml;

import stx.assert.pml.comparable.Num;
import stx.assert.pml.comparable.PExpr;
import stx.assert.pml.comparable.Atom;

class ComparableCtr extends Clazz{
  /**
   * Static extension for `Eq` constructors in the `eu.ohmrun.pml` namespace.
   * @param tag 
   * @return STX<stx.assert.Eq<eu.ohmrun.pml.Module>>
   */
  static public inline function pml(tag:STX<stx.Comparable<Dynamic>>){
    return new ComparableCtr();
  }
  public inline function PExpr<T>(inner:stx.assert.Comparable<T>){
    return new PExpr(inner);
  }
  @:isVar public var Num(get,null):Num;
  private function get_Num():Num{
    return __.option(this.Num).def(() -> this.Num = new Num());
  }

  @:isVar public var Atom(get,null):Atom;
  private function get_Atom():Atom{
    return __.option(this.Atom).def(() -> this.Atom = new Atom());
  } 
}