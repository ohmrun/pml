import pml.pack.Expr;

class Pml{
  @:noUsing static public function parse(string:String){
    return Expr.parse(string);
  }
}