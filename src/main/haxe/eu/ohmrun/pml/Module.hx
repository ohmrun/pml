package eu.ohmrun.pml;

class Module extends Clazz{
  public function parse(string:String){
    return PExpr.parse(string);
  }
}