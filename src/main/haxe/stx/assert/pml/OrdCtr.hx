package stx.assert.pml;

import stx.assert.pml.ord.Num;
import stx.assert.pml.ord.PExpr;
import stx.assert.pml.ord.Atom;

class OrdCtr extends Clazz{
  /**
   * Static extension for `Ord` constructors in the `eu.ohmrun.pml` namespace.
   * @param tag 
   * @return STX<stx.assert.Ord<eu.ohmrun.pml.Module>>
   */
  static public inline function pml(tag:STX<stx.Ord<Dynamic>>){
    return new OrdCtr();
  }
  public inline function PExpr<T>(inner:stx.assert.Ord<T>){
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