package stx.assert.pml;

import stx.assert.pml.eq.Num;
import stx.assert.pml.eq.PExpr;
import stx.assert.pml.eq.Atom;
import stx.assert.pml.eq.PChainKind;
import stx.assert.pml.eq.PItemKind;
import stx.assert.pml.eq.PSignature;

class EqCtr extends Clazz{
  /**
   * Static extension for `Eq` constructors in the `eu.ohmrun.pml` namespace.
   * @param tag 
   * @return STX<stx.assert.Eq<eu.ohmrun.pml.Module>>
   */
  static public function pml(tag:STX<stx.Eq<Dynamic>>){
    return new EqCtr();
  }
  public inline function PExpr<T>(inner:stx.assert.Eq<T>){
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
  @:isVar public var PChainKind(get,null):PChainKind;
  private function get_PChainKind():PChainKind{
    return __.option(this.PChainKind).def(() -> this.PChainKind = new PChainKind());
  }

  @:isVar public var PItemKind(get,null):PItemKind;
  private function get_PItemKind():PItemKind{
    return __.option(this.PItemKind).def(() -> this.PItemKind = new PItemKind());
  }
  @:isVar public var PSignature(get,null):PSignature;
  private function get_PSignature():PSignature{
    return __.option(this.PSignature).def(() -> this.PSignature = new PSignature());
  }
}