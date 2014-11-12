(*
 * Copyright (c) 2014 Thomas Gazagnaire <thomas@gazagnaire.org>
 * Copyright (c) 2014 Daniel C. Bünzli
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *)

let str = Printf.sprintf

(* Project *)

type t =
  { name : string;
    cond : bool As_conf.value;
    args : As_args.t;
    schemes : As_conf.scheme list;
    parts : As_part.kind As_part.t list;
    (**)
    deps : As_conf.Key.Set.t Lazy.t;
    conf : As_conf.t option; }

let deps p =
  let add_key k acc = As_conf.Key.(Set.add (V k) acc) in
  let add_part acc p = As_conf.Key.Set.union acc (As_part.deps p) in
  (* FIXME test_keys should be As_conf.Key.Set.empty *)
  List.fold_left add_part As_conf.Key.Set.empty p.parts
  |> add_key As_conf.project_version
  |> add_key As_conf.root_dir

let v ?(cond = As_conf.true_) ?(args = As_args.empty) ?(schemes = []) name
    ~parts =
  let rec p =
    { name; cond; args; schemes;
      parts = As_part.list_uniq (parts :> As_part.kind As_part.t list);
      deps = lazy (deps p);
      conf = None; }
  in
  p

let name p = p.name
let cond p = p.cond
let args p = p.args
let schemes p = p.schemes
let parts p = p.parts

let deps p = Lazy.force p.deps

(* Configuration *)

let conf p = match p.conf with
| Some c -> c
| None ->
    As_log.msg_driver_fault As_log.Warning
      "No@ configuration@ set@ for@ project,@ using@ base@ configuration.";
    (As_conf.of_keys (deps p))

let with_conf p c = { p with conf = Some c }
let eval p v = As_conf.eval (conf p) v
let eval_key p k = eval p (As_conf.value k)

(* Configuration dependent values *)

let version p = eval_key p As_conf.project_version
let products ?(root = true) p = As_path.Set.empty
let watermark_string ?suffix p =
  let suffix = match suffix with
  | None -> "-- generated by assemblage %%VERSION%%"
  | Some s -> s
  in
  str "%s %s %s" (name p) (version p) suffix

let pp_signature ppf p =
  let pp_icon = (* UTF-8 <U+0020, U+1F377> *)
    let pp_icon ppf () = As_fmt.pp ppf " \xF0\x9F\x8D\xB7" in
    As_fmt.(pp_if_utf8 pp_icon nop)
  in
  As_fmt.(pp ppf "%a %s%a"
            (pp_styled_str `Bold) (name p) (version p) pp_icon ())

(* Assembled projects *)

let projects = ref []
let assemble p = projects := p :: !projects
let list () = List.rev !projects
