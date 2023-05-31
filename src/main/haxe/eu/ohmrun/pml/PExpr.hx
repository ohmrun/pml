package eu.ohmrun.pml;

enum PExprSum<T>{
  PLabel(name:String);
  PApply(name:String);
  PGroup(list:LinkedList<PExpr<T>>);
  PArray(array:Cluster<PExpr<T>>);
  PValue(value:T);
  PEmpty;
  PAssoc(map:Cluster<Tup2<PExpr<T>,PExpr<T>>>);
  PSet(arr:Cluster<PExpr<T>>);
}
@:using(eu.ohmrun.pml.PExpr.PExprLift)
abstract PExpr<T>(PExprSum<T>) from PExprSum<T> to PExprSum<T>{
  static public var _(default,never) = PExprLift;
  public function new(self) this = self;

  //TODO make parse synchronous
  @stability(1)
  @:noUsing static public function parse(str:String):Provide<ParseResult<Token,PExpr<Atom>>>{
    var timer = Timer.unit();
    __.log().debug('lex');
    var p = new stx.parse.pml.Parser();
    var l = stx.parse.pml.Lexer;
    
    var reader  = str.reader();
    return Modulate.pure(l.main.apply(reader)).reclaim(
      (tkns:ParseResult<String,Cluster<Token>>) -> {
        __.log().debug('lex expr: ${timer.since()}');
        timer = timer.start();
        __.log().trace('${tkns}');
        return tkns.is_ok().if_else(
          ()               -> {
            var reader : ParseInput<Token> = tkns.value.defv([]).reader();
            return Produce.pure(p.main().apply(reader)).convert(
              (
                (_) -> {
                  __.log().debug('parse expr: ${timer.since()}');
                }
              ).promote()
            );
          },
          () -> {
            return Produce.pure(ParseResult.make([].reader(),null,tkns.error));
          }
        );
      }
    ).produce(__.accept(reader)).provide();
  }
  @:noUsing static public function lift<T>(self:PExprSum<T>):PExpr<T> return new PExpr(self);
  

  public function prj():PExprSum<T> return this;
  private var self(get,never):PExpr<T>;
  private function get_self():PExpr<T> return lift(this);

  // public function conflate(that:PExpr<T>):PExpr<T>{
  //   return switch(this){
  //     case PEmpty                                    : that;
  //     case PSet(s)                                    :
  //       switch(that){
  //         case P
  //       }  
  //     case PLabel(_) | PValue(_) | PApply(_)         : PGroup(Cons(this,Cons(that,Nil)));
  //     case PGroup(array)                 : switch(that){
  //       case PGroup(list)  : PGroup(array.concat(list));
  //       default           : PGroup(array.snoc(that));
  //     }
  //     case PAssoc(map) : PAssoc(map);
  //    }
  // }  
  public function toString():String{
    return toString_with(Std.string);
  }
  public function toString_with(fn:T->String,?opt : { ?width : Int, ?indent : String }):String{
    if(opt == null){
      opt = { width : 130, indent : " "};
    }
    if(opt.width  == null) opt.width  = 130;
    if(opt.indent == null) opt.indent = " ";
    return (function rec(self:PExpr<T>,?ind=0):String{
      final gap = Iter.range(0,ind).lfold((n,m) -> '$m${opt.indent}', "");
      return switch(self){
        case PLabel(name)     : ':$name';
        case PSet(array)       : 
          var items         = array.map(rec.bind(_,ind+1));
          var length        = items.lfold((n,m) -> m + n.length,ind);
          var horizontal    = length < opt.width ? true : false;
          return horizontal.if_else(
            () -> '#{' + items.join(" ") + '}',
            () -> '{\n ${gap}' + items.join(' \n ${gap}') + '\n${gap}}'
          );
        case PArray(array)       : 
          var items         = array.map(rec.bind(_,ind+1));
          var length        = items.lfold((n,m) -> m + n.length,ind);
          var horizontal    = length < opt.width ? true : false;
          return horizontal.if_else(
            () -> '[' + items.join(" ") + ']',
            () -> '[\n ${gap}' + items.join(' \n ${gap}') + '\n${gap}]'
          );
        case PApply(name)     : '#$name';
        case PGroup(array)    : 
          var items         = array.map(rec.bind(_,ind+1));
          var length        = items.lfold((n,m) -> m + n.length,ind);
          var horizontal    = length < opt.width ? true : false;
          return horizontal.if_else(
            () -> '(' + items.join(" ") + ')',
            () -> '(\n ${gap}' + items.join(' \n ${gap}') + '\n${gap})'
          );
        case PValue(value)    : fn(value);
        case PEmpty           : "()";
        case PAssoc(map)      : 
          final items           = map.map(
            __.detuple((k,v) -> {
             return __.couple(rec(k,ind + 1),rec(v,ind + 1));
            })
          );
          final horizontal_test = items.map(
            __.decouple((l,r) -> {
              return '$l $r';
            })
          );
          final length  = horizontal_test.lfold((n,m) -> m + n.length + 2,ind);
          final showing = if(length > opt.width){
            final widest = horizontal_test.lfold(
              (n,m) -> {
                final l = n.length;
                return l > m ? l : m;
              },
              0
            );
            if(widest > opt.width){
              final next = items.map(
                __.decouple(
                  (l:String,r:String) -> '${gap}$l\n${gap}$r'
                )
              ).lfold(
                (n,m) -> '$m\n$n',
                ""
              );
              '${gap}\n{\n${next}\n';
            }else{
              final next = items.map(
                __.decouple(
                  (l,r) -> '${gap}$l $r'
                )
              ).lfold(
                (n,m) -> '$m\n$n',
                ""
              );
              '${gap}\n{\n${next}\n';
            }
          }else{
            var data = horizontal_test.lfold(
              (n,m) -> m == "" ? n :'$m $n',
              ""
            );
            '{$data}';
          }
          showing;
          // var len           = items.lfold((n,m) -> m + n.length,0);
        case null             : "";
      }
    })(this);
  }
  public function data_only():Option<Cluster<T>>{
    return switch(this){
      case PGroup(xs) : 
        xs.lfold(
          (n,m:Option<Cluster<T>>) -> switch(m){
            case Some(arr) : switch(n){
              case PValue(value) : Some(arr.snoc(value));
              default            : None;
            }
            default : None;
          },
          Some([])
        );
      default : None;
    }
  }
}
class PExprLift{
  //TODO any rescueing map given the typing?
  // static public function map<T,TT>(expr:PExpr<T>,fn:T->TT):PExpr<TT>{
  //   return switch expr {
  //     case PLabel(name)      : PLabel(name);
  //     case PGroup(list)      : PGroup(list.map(e -> e.map(fn)));
  //     case PValue(value)     : PValue(fn(value));
  //     case PAssoc(map)       : 
  //     final next = RedBlackMap.make(map.with);
  //     for(key => val in map){
  //       next.set(map())
  //     }  
  //     PAssoc(

        
  //     );
  //     case PEmpty            : PEmpty;
  //   }
  // }
  static public function eq<T>(inner:Eq<T>):Eq<PExpr<T>>{
    return new stx.assert.pml.eq.PExpr(inner);
  }
  static public function lt<T>(inner:Ord<T>):Ord<PExpr<T>>{
    return new stx.assert.pml.ord.PExpr(inner);
  }
  static public function comparable<T>(inner:Comparable<T>):Comparable<PExpr<T>>{
    return new stx.assert.pml.comparable.PExpr(inner);
  }
  // static public function denote<T>(self:PExpr<T>,fn:T->GExpr){
  //   return new stx.g.denote.PExpr(fn).apply(self);
  // }
  //static public function fold<T>(self:PExpr<T>)
  // static public function is_stringy(self:PExpr<Atom>){
  //   return 
  // }
  static public function get_string(self:PExpr<Atom>){
    return switch(self){
      case PLabel(name) | PApply(name) | PValue(AnSym(name)) | PValue(Str(name)) : 
        Some(name);
      default       : 
        None;
    }
  }
  static public function tokenize<T>(self:PExpr<T>):Cluster<PToken<Either<String,T>>>{
    function rec(self:PExpr<T>):Cluster<PToken<Either<String,T>>>{
      return switch(self){
        case PLabel(name)   : [PTData(Left(':$name'))].imm();
        case PApply(name)   : [PTData(Left('#$name'))].imm();
        case PGroup(list)   : [PTLParen].imm().concat(list.lfold(
          (next:PExpr<T>,memo:Cluster<PToken<Either<String,T>>>) -> {
            return memo.concat(rec(next));
          },
          [].imm()
        )).snoc(PTRParen);
        case PArray(array)  :
          [PTLSquareBracket].imm().concat(array.lfold(
            (next:PExpr<T>,memo:Cluster<PToken<Either<String,T>>>) -> {
              return memo.concat(rec(next));
            },
            [].imm()
          )).snoc(PTRSquareBracket);
        case PValue(value)  : [PTData(Right(value))];
        case PEmpty         : [PTLParen,PTRParen];
        case PAssoc(map)    : [PTLBracket].imm().concat(
          map.lfold(
            (next:Tup2<PExpr<T>,PExpr<T>>,memo:Cluster<PToken<Either<String,T>>>) -> {
              return switch(next){
                case tuple2(l,r) : memo.concat(rec(l).concat(rec(r)));
              }
            },
            [].imm()
          )
        ).snoc(PTRBracket);
        case PSet(arr)      : [PTHashLBracket].imm().concat(
          arr.lfold(
            (next:PExpr<T>,memo:Cluster<PToken<Either<String,T>>>) -> {
              return memo.concat(rec(next));
            },
            [].imm()
          )
        ).snoc(PTRBracket);
      }
    }
    return rec(self);
  }
  static public function index<T>(self:PExpr<T>){
    return switch(self){
      case PLabel(name)   : [CoIndex(0)];
      case PApply(name)   : [CoIndex(0)];
      case PGroup(list)   : list.toCluster().imap(
        (idx,val) -> {
          return CoIndex(idx);
        }
      );
      case PArray(array)  : array.imap(
        (idx,val) -> CoIndex(idx)
      );
      case PValue(value)  : [CoIndex(0)];
      case PEmpty         : [];
      case PAssoc(map)    : is_label_map(self).if_else(
        () -> map.imap(
          (i,x) -> CoField(x.fst().get_label().fudge(),i)
        ),
        () -> map.imap(
          (i,x) -> CoIndex(i)
        )
      );
      case PSet(arr)      : arr.imap(
        (i,_) -> CoIndex(i)
      );
    }
  }
  static public function access<T>(self:PExpr<T>,key:Coord):Option<PExpr<T>>{
    return switch([self,key]){
      case [PLabel(name),CoIndex(0)]    : __.option(self);
      case [PApply(name),CoIndex(0)]    : __.option(self);
      case [PGroup(list),CoIndex(i)]    : __.option(list.toCluster()[i]);
      case [PArray(array),CoIndex(i)]   : __.option(array[i]);
      case [PValue(name),CoIndex(0)]    : __.option(self);
      case [PEmpty,CoIndex(0)]          : __.option(self);
      case [PAssoc(map),CoIndex(i)]     : __.option(map[i]).map(x -> x.snd());
      case [PAssoc(map),CoField(s,null)]: 
        map.search(
          x -> x.fst().get_label().map(
            sI -> sI == s
          ).defv(false)
        ).map(x -> x.snd());
      case [PAssoc(map),CoField(s,i)]   : __.option(map[i]).flat_map(
        x -> (x.fst().get_label().map(x -> x == s).defv(false)).if_else(
          () -> __.option(x.snd()),
          () -> __.option()
        )
      );
      case [PSet(arr),CoIndex(i)]       : __.option(arr[i]);
      default                           : __.option();
    }
  }
  static public function members<T>(self:PExpr<T>):Cluster<Tup2<Coord,PExpr<T>>>{
    return switch(self){
      case PLabel(name)   : [tuple2(CoIndex(0),self)];
      case PApply(name)   : [tuple2(CoIndex(0),self)];
      case PGroup(list)   : list.toCluster().imap(
        (idx,val) -> {
          return tuple2(CoIndex(idx),val);
        }
      );
      case PArray(array)  : array.imap(
        (idx,val) -> tuple2(CoIndex(idx),val)
      );
      case PValue(value)  : [tuple2(CoIndex(0),self)];
      case PEmpty         : [];
      case PAssoc(map)    : is_label_map(self).if_else(
        () -> map.imap(
          (i,x) -> tuple2(CoField(x.fst().get_label().fudge(),i),x.snd())
        ),
        () -> map.imap(
          (i,x) -> tuple2(CoIndex(i),x.snd())
        )
      );
      case PSet(arr)      : arr.imap(
        (i,x) -> tuple2(CoIndex(i),x)
      );
    }
  }
  static public function is_label_map<T>(self:PExpr<T>){
    return switch(self){
      case PAssoc(map) : map.all(
        (tup) -> switch(tup.fst()){
          case PLabel(_) : true;
          default        : false;
        }
      );
      default : false;
    }
  }
  static public function get_label<T>(self:PExpr<T>){
    return switch(self){
      case PLabel(str) : __.option(str);
      default          : __.option();
    }
  }
  static public function mod<T,U>(self:PExpr<T>,fn:PExpr<T> -> PExpr<U>):PExpr<U>{
    return switch(self){
      case PLabel(name)     : fn(self);
      case PApply(name)     : fn(self);
      case PGroup(list)     : PGroup(list.map(fn));
      case PArray(array)    : PArray(array.map(fn));
      case PValue(value)    : fn(self);
      case PEmpty           : fn(self);
      case PAssoc(map)      : PAssoc(map.map(
        (tup) -> tup.detuple(
          (l,r) -> tuple2(fn(l),fn(r))
        )
      ));
      case PSet(arr)        : PSet(arr.map(fn));
    }
  }
  static public function is_array<T>(self:PExpr<T>){
    return switch (self){
      case PArray(_) : true;
      default : false;
    }
  }
  static public function is_set<T>(self:PExpr<T>){
    return switch (self){
      case PSet(_) : true;
      default : false;
    }
  }
  static public function is_group<T>(self:PExpr<T>){
    return switch (self){
      case PGroup(_) : true;
      default : false;
    }
  }
  static public function is_assoc<T>(self:PExpr<T>){
    return switch (self){
      case PAssoc(_) : true;
      default : false;
    }
  }
  static public function is_leaf<T>(self:PExpr<T>){
    return switch(self){
      case PLabel(name)     : true;
      case PApply(name)     : true;
      case PGroup(list)     : false;
      case PArray(array)    : false;
      case PValue(value)    : true;
      case PEmpty           : true;
      case PAssoc(map)      : false;
      case PSet(arr)        : false;    
    }
  }
}
/**
```
return switch(self){
  case PLabel(name):
  case PApply(name):
  case PGroup(list):
  case PArray(array):
  case PValue(value):
  case PEmpty:
  case PAssoc(map):
  case PSet(arr):
}```
*/