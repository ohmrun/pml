using stx.Log;
using stx.Nano;
using stx.Parse;

using eu.ohmrun.Pml;

class Main {
	static function main() {
		trace('main');
		var f = __.log().global;
				f.includes.push("eu/ohmrun/pml");
		//var timer = __.timer();
		eu.ohmrun.pml.Test.main();
		//trace(timer.since());
	}
}