package eu.ohmrun.pml.pexpr;

abstract class Apply<P> extends Clazz{
  abstract public function comply(key:String,val:PExpr<P>):PExpr<P>{

  }
  // public function apply<T>(self:PExpr<P>){
  //   return switch(self){
  //     case PEmpty         : __.accept(PEmpty);
  //     case PLabel(name)   : __.accept(PLabel(name)); 
  //     case PApply(name)   : __.comply(name,PEmpty);
  //     case PValue(value)  : __.accept(value);
    
  //     case PGroup(Cons(PApply(name),xs))  :
  //       comply(name,PGroup(xs)).flat_map(
  //         (r) -> Upshot.bind_fold(
  //           xs,
  //           (next,memo) -> {
  //             return apply()
  //           }
  //         )
  //       );
        
        
  //     case PGroup(list)  :
  //     case PArray(array):
  //     case PSet(arr):
  //     case PAssoc(map):
  //   }
  }
}