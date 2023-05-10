package stx.parse.pml;

using stx.parse.pml.Escape;

function reg(str:String){
  return __.parse().parsers().string().reg(str);
}
class Escape{
  static final escaped_double_quote = "\\\"".reg();
}