package eu.ohmrun.pml;

class Module extends Clazz{
  @:deprecated
  public function parse(string:String){
    return PExpr.parse(string);
  }
  public function parser(){
    var p = new stx.parse.pml.Parser();
    var l = stx.parse.pml.Lexer;
    return (input:ParseInput<String>) -> {
      final a = l.main.apply(input);
      trace(a);
      return if(a.is_ok()){
        a.value.fold(
          ok -> p.main().apply(ok.reader()),
          () -> ParseInput.pure(stx.parse.core.Enumerable.Array([])).no('no lexed tokens')
        );
      }else{
        ParseResult.make([].reader(),None,a.error);
      }
    }
  }
}