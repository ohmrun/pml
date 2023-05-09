package eu.ohmrun.pml;

enum PType<T>{
  PTNil;
  PTAny;
  PTVal(v:T);
  PTTag(id:String,apply:Option<Bool>);
  PTGrp(t:PType<T>);
  PTOpt(t:PType<T>);
  PTMap(key:PType<T>,val:PType<T>);
  PTObj(arr:Cluster<Tup2<String,PType<T>>>);
  PTAlt(types:Cluster<PType<T>>);
}
// interface PmlKindApi<P,R>{
//   public function nil():R;
//   public function itm(v:P):R;
//   public function seq(l:R,r:R):R;
// }
// enum PmlKindSum<P>{
//   PKItm(p:P);

//   PKBag(ps:Cluster<PmlKind<P>>);
//   PKSeq(l:PmlKind<P>,r:PmlKind<P>);
//   PKAlt(l:PmlKind<P>,r:PmlKind<P>);
// s
// }
// abstract PmlKind<P>(PmlKindSum<P>) from PmlKindSum<P> to PmlKindSum<P>{
//   public function new(self) this = self;
//   @:noUsing static public function lift<P>(self:PmlKindSum<P>):PmlKind<P> return new PmlKind(self);

//   public function prj():PmlKindSum<P> return this;
//   private var self(get,never):PmlKind<P>;
//   private function get_self():PmlKind<P> return lift(this);

//   public function comply<R>(data:PExpr<P>,with:PmlKindApi<P,R>):Chunk<R,PmlFailure>{
//     return switch([this,data]){
//       case [PKItm(l),PValue(value)] : with.itm(value);
//       case [PKSeq(l,r),PGroup(ls)]   : 
//         switch(__.option(ls.head())){
//           case Some(v) : 
//             final l = l.comply(v,with);
//             final r = r.comply(PGroup(ls.tail()).with);
//             return l.zip(r).map(tp -> tp.decouple(with.seq));
//         }
//       case [PKAlt(l,r),x] : 
//         l.comply(x,with).or(() -> r.comply(x,with));
//     }
//   }
// }