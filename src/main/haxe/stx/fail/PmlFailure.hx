package stx.fail;

enum PmlFailureSum{

}
abstract PmlFailure(PmlFailureSum) from PmlFailureSum to PmlFailureSum{
  public function new(self) this = self;
  static public function lift(self:PmlFailureSum):PmlFailure return new PmlFailure(self);

  public function prj():PmlFailureSum return this;
  private var self(get,never):PmlFailure;
  private function get_self():PmlFailure return lift(this);
}