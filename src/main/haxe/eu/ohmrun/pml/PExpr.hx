package eu.ohmrun.pml;

@:using(eu.ohmrun.pml.pexpr.ToString)
@:using(eu.ohmrun.pml.pexpr.Mod)
@:using(eu.ohmrun.pml.pexpr.Signature)
@:using(eu.ohmrun.pml.PExpr.PExprLift)
enum PExprSum<T>{
	PEmpty;
	PLabel(name:String);
	PApply(name:String);
	PValue(value:T);

	PGroup(list:LinkedList<PExpr<T>>);
	PArray(array:Cluster<PExpr<T>>);
	PSet(arr:Cluster<PExpr<T>>);//Cannot enforce Open type Set
	PAssoc(map:Cluster<Tup2<PExpr<T>, PExpr<T>>>);
}

@:using(eu.ohmrun.pml.pexpr.ToString)
@:using(eu.ohmrun.pml.pexpr.Mod)
@:using(eu.ohmrun.pml.pexpr.Signature)
@:using(eu.ohmrun.pml.PExpr.PExprLift)
abstract PExpr<T>(PExprSum<T>) from PExprSum<T> to PExprSum<T> {
	static public var _(default, never) = PExprLift;

	public function new(self)
		this = self;

	// TODO make parse synchronous

	@stability(1)
	@:noUsing static public function parse(str:String):Provide<ParseResult<Token, PExpr<Atom>>> {
		var timer = Timer.unit();
		__.log().debug('lex');
		var p = new stx.parse.pml.Parser();
		var l = stx.parse.pml.Lexer;

		var reader = str.reader();
		return Modulate.pure(l.main.apply(reader))
			.reclaim((tkns:ParseResult<String, Cluster<Token>>) -> {
				__.log().debug('lex expr: ${timer.since()}');
				timer = timer.start();
				__.log().trace('${tkns}');
				return tkns.is_ok().if_else(() -> {
					var reader:ParseInput<Token> = tkns.value.defv([]).reader();
					return Produce.pure(p.main().apply(reader)).convert(((_) -> {
						__.log().debug('parse expr: ${timer.since()}');
					}).promote());
				}, () -> {
					return Produce.pure(ParseResult.make([].reader(), null, tkns.error));
				});
			})
			.produce(__.accept(reader))
			.provide();
	}

	@:noUsing static public function lift<T>(self:PExprSum<T>):PExpr<T>
		return new PExpr(self);

	public function prj():PExprSum<T>
		return this;

	private var self(get, never):PExpr<T>;

	private function get_self():PExpr<T>
		return lift(this);

	public function toString():String {
		return this.toString_with(Std.string);
	}
}

class PExprLift {
	static public function eq<T>(inner:Eq<T>):Eq<PExpr<T>> {
		return new stx.assert.pml.eq.PExpr(inner);
	}
	static public function lt<T>(inner:Ord<T>):Ord<PExpr<T>> {
		return new stx.assert.pml.ord.PExpr(inner);
	}
	static public function comparable<T>(inner:Comparable<T>):Comparable<PExpr<T>> {
		return new stx.assert.pml.comparable.PExpr(inner);
	}

	// static public function denote<T>(self:PExpr<T>,fn:T->GExpr){
	//   return new stx.g.denote.PExpr(fn).apply(self);
	// }
	// static public function fold<T>(self:PExpr<T>)
	static public function get_string(self:PExpr<Atom>) {
		return switch (self) {
			case PLabel(name) | PApply(name) | PValue(AnSym(name)) | PValue(Str(name)):
				Some(name);
			default:
				None;
		}
	}
	static public function tokenize<T>(self:PExpr<T>):Cluster<PToken<Either<String, T>>> {
		function rec(self:PExpr<T>):Cluster<PToken<Either<String, T>>> {
			return switch (self) {
				case PLabel(name): [PTData(Left(':$name'))].imm();
				case PApply(name): [PTData(Left('#$name'))].imm();
				case PGroup(list): [PTLParen].imm().concat(list.lfold((next:PExpr<T>, memo:Cluster<PToken<Either<String, T>>>) -> {
						return memo.concat(rec(next));
					}, [].imm())).snoc(PTRParen);
				case PArray(array):
					[PTLSquareBracket].imm().concat(array.lfold((next:PExpr<T>, memo:Cluster<PToken<Either<String, T>>>) -> {
						return memo.concat(rec(next));
					}, [].imm())).snoc(PTRSquareBracket);
				case PValue(value): [PTData(Right(value))];
				case PEmpty: [PTLParen, PTRParen];
				case PAssoc(map): [PTLBracket].imm().concat(map.lfold((next:Tup2<PExpr<T>, PExpr<T>>, memo:Cluster<PToken<Either<String, T>>>) -> {
						return switch (next) {
							case tuple2(l, r): memo.concat(rec(l).concat(rec(r)));
						}
					}, [].imm())).snoc(PTRBracket);
				case PSet(arr): [PTHashLBracket].imm().concat(arr.lfold((next:PExpr<T>, memo:Cluster<PToken<Either<String, T>>>) -> {
						return memo.concat(rec(next));
					}, [].imm())).snoc(PTRBracket);
			}
		}
		return rec(self);
	}
	static public function labels<T>(self:PExpr<T>):Cluster<Coord> {
		return switch (self) {
			case PLabel(name) 			: 
				[CoIndex(0)];
			case PApply(name) 			: 
				[CoIndex(0)];
			case PGroup(list)				: 
				list.toCluster().imap((idx, val) -> {
					return CoIndex(idx);
				});
			case PArray(array): 
				array.imap((idx, val) -> CoIndex(idx));
			case PValue(value): 
				[CoIndex(0)];
			case PEmpty: 
				[];
			case PAssoc(map): 
				is_label_map(self)
					.if_else(
						() -> map.imap((i, x) -> CoField(x.fst().get_label().fudge(), i)),
						() -> map.imap((i, x) -> CoIndex(i))
					);
			case PSet(arr): 
				arr.imap((i, _) -> CoIndex(i));
		}
	}
	static public function is_label_map<T>(self:PExpr<T>) {
		return switch(self){
			case PAssoc(map) 	: map.all(
				(tup) -> switch (tup.fst()) {
					case PLabel(_) 	: true;
					default 				: false;
				});
			default  					: false;
		}
	}
	static public function get_label<T>(self:PExpr<T>) {
		return switch (self) {
			case PLabel(str)	: __.option(str);
			default 					: __.option();
		}
	}
	static public function is_array<T>(self:PExpr<T>) {
		return switch (self) {
			case PArray(_) 	: true;
			default 				: false;
		}
	}
	static public function is_set<T>(self:PExpr<T>) {
		return switch (self) {
			case PSet(_)		: true;
			default					: false;
		}
	}
	static public function is_group<T>(self:PExpr<T>) {
		return switch (self) {
			case PGroup(_)	: true;
			default 				: false;
		}
	}
	static public function is_assoc<T>(self:PExpr<T>) {
		return switch (self) {
			case PAssoc(_)	: true;
			default					: false;
		}
	}
	static public function is_leaf<T>(self:PExpr<T>) {
		return switch (self) {
			case PLabel(name) 		: true;
			case PApply(name) 		: true;
			case PGroup(list)			: false;
			case PArray(array)		: false;
			case PValue(value)		: true;
			case PEmpty 					: true;
			case PAssoc(map)			: false;
			case PSet(arr)				: false;
		}
	}
	static public function size<T>(self:PExpr<T>):Int {
		return switch (self) {
			case PEmpty 					: 0;
			case PLabel(name)			: 1;
			case PApply(name)			: 1;
			case PValue(value)		: 1;

			case PGroup(list)			: list.size();
			case PArray(array)		: array.size();
			case PSet(arr)				: arr.size();
			case PAssoc(map)			: map.size();
		}
	}
	static public function traverse<T>(self:PExpr<T>,fn:PExpr<T>->Upshot<Option<PExpr<T>>,PmlFailure>){
		return fn(self).flat_map(
			(opt) -> opt.fold(
				function rec(ok){
					return switch(ok){
						case PGroup(_) | PArray(_) | PSet(_) | PAssoc(_) : 
							ok.mod(fn).flat_map(
								opt -> opt.fold(
									(x) -> x.mod(rec),
									() 	-> __.accept(__.option(ok))
								)
							);
						default : __.accept(__.option(ok));
					}
				},
				() -> __.accept(__.option(self))
			)
		);
	}
}
/**
	```

	return switch(self){
	case PEmpty:
	case PLabel(name):
	case PApply(name):
	case PValue(value):

	case PGroup(list):
	case PArray(array):
	case PSet(arr):
	case PAssoc(map):
		  
	}```
 */
