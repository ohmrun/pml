package eu.ohmrun.pml;

import stx.parse.pml.Lexer;
using stx.Test;
using stx.Log;

import eu.ohmrun.pml.test.*;


class Test{
  static public function main(){
    final log = __.log().global;
          //log.includes.push("**/*");
          //log.level = BLANK;

    __.test().run([
      new LexerTest(),
    ],[]);
  }
}
