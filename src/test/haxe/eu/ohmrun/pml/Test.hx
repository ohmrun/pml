package eu.ohmrun.pml;

import stx.parse.pml.Lexer;
using stx.Test;
using stx.Log;
using stx.Nano;

import eu.ohmrun.pml.test.*;


class Test{
  static public function main(){
    
    __.logger().global().configure(
      logger -> logger.with_logic(
        logic -> logic.or(
          logic.tags(
            [
            //"stx/parse",
             "eu/ohmrun/pml",
             //"stx/stream"
            ]
          )
        )
      )
    );

    //final log = __.log().global;
          //log.includes.push("**/*");
          //log.level = BLANK;

    __.test().run([
      new GeneralTraversalTest(),
      //new LexerTest(),
      //new ExtractTest(),
      //new V2Test(),
      //new PTypeTest(),
      //new HaxeV4_3_0_RegularExpressionsTest()
    ],[]);
  }
}
