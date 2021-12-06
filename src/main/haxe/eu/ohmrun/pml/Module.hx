package eu.ohmrun.pml;

class Module extends Clazz{
  public function parse(string:String){
    return Expr.parse(string);
  }
}