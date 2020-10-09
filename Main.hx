import stx.log.Facade;
using stx.Log;
using stx.Nano;
using stx.Ext;
using stx.Async;
using stx.parse.Pack;

using eu.ohmrun.Pml;

class Main {
	static function main() {
		var f = Facade.unit();
				f.includes.push("eu.ohmrun.pml");
		//var timer = __.timer();
		eu.ohmrun.pml.Test.main();
		//trace(timer.since());
	}
}