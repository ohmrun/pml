package pml.pack;

enum Expr<T>{
  Label(name:String);
  Group(array:Array<Expr<T>>);
  Value(value:T);
  Empty;
}