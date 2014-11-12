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

(* Silo

   FIXME I wonder if we really still want that. *)

(* Check *)

let check p =
  let silo = As_part.coerce `Silo p in
  As_log.warn "%a part check is TODO" As_part.pp_kind (As_part.kind silo);
  true

(* Actions *)

let actions p =
  let silo = As_part.coerce `Silo p in
  As_log.warn "%a part actions are TODO" As_part.pp_kind (As_part.kind silo);
  []

(* Silos *)

let v ?usage ?cond ?args name needs =
  As_part.v_kind ?usage ?cond ?args name `Silo

let of_base p =
  let meta = As_part.meta_nil in
  As_part.with_kind_meta `Silo meta p
