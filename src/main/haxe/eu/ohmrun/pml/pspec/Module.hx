package eu.ohmrun.pml.pspec;

class Module extends Clazz{
  @:isVar public var PItemKind(get,null):PItemKindCtr;
  private function get_PItemKind():PItemKindCtr{
    return __.option(this.PItemKind).def(() -> this.PItemKind = new PItemKindCtr());
  }
}