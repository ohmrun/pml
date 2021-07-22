package eu.ohmrun.pml;
import stx.parse.pml.Lexer;
using stx.Test;
import eu.ohmrun.pml.test.*;


class Test{
  static public function main(){
    __.test([
      new LexerTest(),
    ],[]);
  }
}
