package eu.ohmrun.pml.pexpr;

class Signature{
  static public function signature<T>(self:PExpr<T>):PSignature {
		function has_consistent_types(next:Option<PSignature>, memo:Option<PSignature>) {
			return memo.fold((t) -> EqCtr.pml(STX)
				.PSignature.comply(next.fudge(), t)
				.is_ok()
				.if_else(() -> memo, () -> None), () -> None);
		}
		function get_chain_type(cls:Cluster<PExpr<T>>, t:PChainKind) {
			final types = cls.map(signature);
			final has_consistent_types = types.tail()
				.map(Some)
				.lscan(has_consistent_types, types.head())
				.lfold((next:Option<PSignature>, memo:Bool) -> memo.if_else(() -> next.is_defined(), () -> false), true);

			return has_consistent_types.if_else(() -> PSigCollect(types.head().fudge(), t), () -> PSigBattery(types, t));
		}

		return switch (self) {
			case PEmpty: PSigPrimate(PItmEmpty);
			case PLabel(name): PSigPrimate(PItmLabel);
			case PApply(name): PSigPrimate(PItmApply);
			case PValue(value): PSigPrimate(PItmValue);
			case PAssoc(list):
				final types:Cluster<Tup2<PSignature, PSignature>> = list.map(__.detuple((l, r) -> tuple2(signature(l), signature(r))));
				final has_consistent_keys = types.tail()
					.map(x -> Some(x.fst()))
					.lscan(has_consistent_types, types.head().map(x -> x.fst()))
					.lfold((next:Option<PSignature>, memo:Bool) -> memo.if_else(() -> next.is_defined(), () -> false), true);

				final consistent_key = has_consistent_keys.if_else(() -> types.head().map(x -> x.fst()), () -> None);
				final has_consistent_vals = types.tail()
					.map(x -> Some(x.snd()))
					.lscan(has_consistent_types, types.head().map(x -> x.snd()))
					.lfold((next:Option<PSignature>, memo:Bool) -> memo.if_else(() -> next.is_defined(), () -> false), true);

				final consistent_val = has_consistent_vals.if_else(() -> types.head().map(x -> x.snd()), () -> None);
				has_consistent_keys.if_else(() -> has_consistent_vals.if_else(() -> PSigCollate(consistent_key.fudge(), OneOf(consistent_val.fudge())),
					() -> PSigCollate(consistent_key.fudge(), ManyOf(types.map(x -> x.snd()))),),
					() -> PSigOutline(types));
			case PArray(array): get_chain_type(array, PCArray);
			case PSet(arr): get_chain_type(arr, PCSet);
			case PGroup(list): get_chain_type(list.toCluster(), PCGroup);
		}
	}
}