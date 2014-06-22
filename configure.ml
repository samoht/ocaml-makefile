open Project

(* OCamlfind packages *)

let cmdliner = Dep.pkg "cmdliner"
let opam     = Dep.pkg "opam"

(* Compilation units *)

let dir = "lib"
let e = Unit.create ~dir ~deps:[cmdliner]            "env"
let p = Unit.create ~dir ~deps:[cmdliner]            "project"
let f = Unit.create ~dir ~deps:[Dep.unit p]          "ocamlfind"
let o = Unit.create ~dir ~deps:[opam; Dep.unit p]    "opam"
let m = Unit.create ~dir ~deps:(Dep.units [p; f])    "makefile"
let t = Unit.create ~dir ~deps:(Dep.units [m; f; o]) "tools"

(* Build artifacts *)

let lib = Lib.create [e; p; f; o; m; t] "tools"

let bin = Bin.create ~deps:[Dep.lib lib] "configure.ml"

(* The project *)

let version = "0.1"

let t =
  let version = version ^ match Git.version () with
    | None   -> ""
    | Some v -> "~" ^ v in
  create ~libs:[lib] ~bins:[bin] ~version "tools"

let () =
  Tools.generate t `Makefile
