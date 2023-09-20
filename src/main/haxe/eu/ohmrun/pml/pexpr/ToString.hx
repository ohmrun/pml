package eu.ohmrun.pml.pexpr;

class ToString{
  static public function toString_with<T>(self:PExpr<T>,fn:T->String, ?opt:{?width:Int, ?indent:String}):String {
		if (opt == null) {
			opt = {width: 130, indent: " "};
		}
		if (opt.width == null)
			opt.width = 130;
		if (opt.indent == null)
			opt.indent = " ";
		return (function rec(self:PExpr<T>, ?ind = 0):String {
			final gap = Iter.range(0, ind).lfold((n, m) -> '$m${opt.indent}', "");
			return switch (self) {
				case PLabel(name): ':$name';
				case PSet(array):
					var items = array.map(rec.bind(_, ind + 1));
					var length = items.lfold((n, m) -> m + n.length, ind);
					var horizontal = length < opt.width ? true : false;
					return horizontal.if_else(
						() -> '#{' + items.join(" ") + '}', 
						() -> '#{\n ${gap}' + items.join(' \n ${gap}') + '\n${gap}}'
					);
				case PArray(array):
					var items 			= array.map(rec.bind(_, ind + 1));
					var length 			= items.lfold((n, m) -> m + n.length, ind);
					var horizontal 	= length < opt.width ? true : false;
					return horizontal.if_else(
						() -> '[' + items.join(" ") + ']', 
						() -> '[\n ${gap}' + items.join(' \n ${gap}') + '\n${gap}]'
					);
				case PApply(name): '#$name';
				case PGroup(array):
					var items = array.map(rec.bind(_, ind + 1));
					var length = items.lfold((n, m) -> m + n.length, ind);
					var horizontal = length < opt.width ? true : false;
					return horizontal.if_else(() -> '(' + items.join(" ") + ')', () -> '(\n ${gap}' + items.join(' \n ${gap}') + '\n${gap})');
				case PValue(value): fn(value);
				case PEmpty: "()";
				case PAssoc(map):
					final items = map.map(__.detuple((k, v) -> {
						return __.couple(rec(k, ind + 1), rec(v, ind + 1));
					}));
					final horizontal_test = items.map(__.decouple((l, r) -> {
						return '$l $r';
					}));
					final length = horizontal_test.lfold((n, m) -> m + n.length + 2, ind);
					final showing = if (length > opt.width) {
						final widest = horizontal_test.lfold((n, m) -> {
							final l = n.length;
							return l > m ? l : m;
						}, 0);
						if (widest > opt.width) {
							final next = items.map(__.decouple((l:String, r:String) -> '${gap}$l\n${gap}$r')).lfold((n, m) -> '$m\n$n', "");
							'${gap}\n{\n${next}\n}';
						} else {
							final next = items.map(__.decouple((l, r) -> '${gap}$l $r')).lfold((n, m) -> '$m\n$n', "");
							'${gap}\n{\n${next}\n}';
						}
					} else {
						var data = horizontal_test.lfold((n, m) -> m == "" ? n : '$m $n', "");
						'{$data}';
					}
					showing;
				// var len           = items.lfold((n,m) -> m + n.length,0);
				case null: "";
			}
		})(self);
	}
	static public function toString<T>(self:PExpr<T>):String {
		return toString_with(self,Std.string);
	}
}