package eu.ohmrun.pml.test;

import eu.ohmrun.pml.Extract.*;

class ExtractTest extends TestCase{
  public function _test_order(){
    final v = __.resource('haxe_cpl_order').string();
    final p = __.pml().parse(v);
    final q = p.errate((_) -> E_Pml_Noise).adjust(
      pr -> pr.toUpshot().errate(E_Pml_Parse)
    ).adjust(
      x -> x.fold(
        ok -> __.accept(ok),
        () -> __.reject(f -> f.of(E_Pml_Empty))
      )
    ).map(
      x -> {
          return imbibe(order(),'order_outer').apply([x].reader());
      }
    ).environment(
      x -> {
        trace(x);
      },
      __.raise
    );
    q.crunch();
  }
  public function _test_lib2(){
    final v = 'lib "stx_pico" "2.2"'.reader();
    final x = __.pml().parseI()(v);
    final a = lib2().apply(x.value.map(x-> [x].imm()).defv([]).reader());
    for(opt in a){
      for(x in opt){
        same(HxLib(new Lib('stx_pico',"2.2")),x);
      }
    }
  }
  public function test(){
    final v = __.resource('haxe_cpl').string();
    final p = __.pml().parse(v);
    final q = p.errate((_) -> E_Pml_Noise).adjust(
      pr -> pr.toUpshot().errate(E_Pml_Parse)
    ).adjust(
      x -> x.fold(
        ok -> __.accept(ok),
        () -> __.reject(f -> f.of(E_Pml_Empty))
      )
    ).map(
      x -> {
          return imbibe(hx_compile(),'hx_compile_outer').apply([x].reader());
      }
    ).environment(
      x -> {
        trace(x);
      },
      __.raise
    );
    q.crunch();
  }
  public function e(){
    return Extract;
  }
  public function hx_compile(){
    return imbibe(
      Extract.symbol('hx.Compiler')._and(
        context().or(order()).one_many()
      ),
      "hx_compile"
    );
  }
  public function lib1(){
    return symbol('lib')._and(wordish()).then(x -> Lib.make(x)).then(HxLib);
  }
  public function lib2(){
    return symbol('lib')._and(wordish()).and(wordish())
    .then(x -> Lib.make(x.fst(),x.snd())).then(HxLib);
  }
  public function lib(){
    return lib2().or(lib1());
  }

  public function cp(){
    return symbol('cp')._and(wordish()).then(HxCp);
  }
  public function define2(){
    return symbol('define')._and(wordish()).and(wordish()).then(__.decouple((x,y) -> HxDefine(x,y)));
  }
  public function define1(){
    return symbol('define')._and(wordish()).then(x -> HxDefine(x,""));
  }
  public function define(){
    return define2().or(define1());
  }
  public function makro(){
    return symbol('macro')._and(wordish()).then(HxMacro);
  }
  public function context(){
    return imbibe(define(),'define').or(
      imbibe(makro(),'makro')
    ).or(
      imbibe(cp(),'cp')
    ).or(
      imbibe(lib(),'lib')
    );
  }
  public function main(){
    return symbol('main')._and(wordish()).then(HxMain);
  }
  public function target(){
    return symbol('target')._and(wordish()).then(HxTarget);
  }
  public function order_item(){
    return imbibe(
      main().or(target()),'main_or_target'
    ).or(context());
  }
  public function order(){
    return imbibe(
        symbol('order')._and(
          imbibe(
            order_item().one_many(),
            "order item"
          ).one_many()
      ),'order').then(
        x -> HxOrder(x)
      );
  }
}
enum HxParseToken{
  HxLib(lib:Lib);
  HxCp(str:String);
  HxDefine(key:String,val:String);
  HxMacro(str:String);
  HxMain(main:String);
  HxTarget(tgt:String);
  HxOrder(builds:Cluster<Cluster<HxParseToken>>);
}
class Lib{
  final name : String;
  final version : String;
  public function new(name,version){
    this.name     = name;
    this.version  = version;
  }
  static public function make(name,version=""){
    return new Lib(name,version);
  }
  public function toString(){
    return '($name $version)';
  }
}