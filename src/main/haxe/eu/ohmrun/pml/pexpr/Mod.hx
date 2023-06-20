package eu.ohmrun.pml.pexpr;

class Mod{
  /**
   * runs fn on the first layer of subexpressions only, adds anything `Accept(Some(x))`, shortcuts on `Reject(x)`
   * @param self 
   * @param fn 
   * @param PmlFailure> 
   */
  static public function mod<T>(self:PExpr<T>, fn:PExpr<T>->Upshot<Option<PExpr<T>>,PmlFailure>) {
		return switch(self){
			case 			PGroup(list)		: Upshot.bind_fold(
				list,
				function(next:PExpr<T>,memo:Option<LinkedList<PExpr<T>>>){
					return fn(next).map(
						opt -> opt.map(
							ok -> memo.fold(
								memo 	-> memo.snoc(ok),
								() 		-> LinkedList.unit().snoc(ok)
							)
						)
					);
				}
				,None
			).map(
				opt -> opt.map(PGroup)
			);
			case 			PArray(array)		: 
				Upshot.bind_fold(
					array,
					function(next:PExpr<T>,memo:Option<Cluster<PExpr<T>>>){
						return fn(next).map(
							opt -> opt.map(
								ok -> memo.fold(
									memo 	-> memo.snoc(ok),
									() 		-> Cluster.unit().snoc(ok)
								)
							)
						);
					}
					,None
				).map(
					opt -> opt.map(PArray)
				);
			case 			PSet(arr)				: 
				Upshot.bind_fold(
					arr,
					function(next:PExpr<T>,memo:Option<Cluster<PExpr<T>>>){
						return fn(next).map(
							opt -> opt.map(
								ok -> memo.fold(
									memo 	-> memo.snoc(ok),
									() 		-> Cluster.unit().snoc(ok)
								)
							)
						);
					}
					,None
				).map(
					opt -> opt.map(PSet)
				);
			case 			PAssoc(map)			:
				(Upshot.bind_fold(
					map,
					function(next:Tup2<PExpr<T>,PExpr<T>>,memo:Option<Cluster<Tup2<PExpr<T>,PExpr<T>>>>){
						return 
							fn(next.fst())
								.flat_map(
									(x:Option<PExpr<T>>) -> 
										fn(next.snd())
											.map((y:Option<PExpr<T>>) -> (tuple2(x,y))))
							.map(
								__.detuple(
									(x:Option<PExpr<T>>,y:Option<PExpr<T>>) -> 
										x.zip(y).map(__.decouple(tuple2))
								)
							).map(
								(r:Option<Tup2<PExpr<T>,PExpr<T>>>) -> (r).flat_map(
									ok -> 
										memo.fold(
											okI -> Some(okI.snoc(ok)),
											() 	-> Some(Cluster.unit().snoc(ok))
										)
								)
							);
					}
					,None
				).map(
					opt -> opt.map(PAssoc)
				));
			default   								: __.accept(__.option(self));
		}
	}
}