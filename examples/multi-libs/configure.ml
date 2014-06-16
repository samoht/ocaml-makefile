#directory "../../_build/lib/";;
#directory "../../_build/tools/";;

open Project

let a = Lib.create
    [ Unit.create ~dir:"a" ~deps:[Dep.pkg "ezjsonm"] "a"]
    "lib1"

let b =
  let b = Unit.create ~dir:"b" ~deps:[Dep.lib a] "b" in
  let c = Unit.create ~dir:"b" ~deps:[Dep.unit b] "c" in
  Lib.create [b; c] "lib2"

let () =
  Makefile.of_project (create ~libs:[a; b] ())
