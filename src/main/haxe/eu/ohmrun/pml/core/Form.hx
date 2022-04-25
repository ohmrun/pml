package eu.ohmrun.pml.core;

enum FormSum{
  FCluster(inner:Form);
  FOr(l:Form,r:Form);
}
abstract Form(FormSum) from FormSum to FormSum{
  public function new(self) this = self;
  static public function lift(self:FormSum):Form return new Form(self);

  public function prj():FormSum return this;
  private var self(get,never):Form;
  private function get_self():Form return lift(this);
}