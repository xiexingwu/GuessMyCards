open! Base

type t [@@deriving compare, equal, sexp_of]
(** Card.t is the type for a card *)

(* val all_cards : t set *)
val create : string -> t
val compare : t -> t -> int
val suit : t -> Sexp.t
val value : t -> int
val to_string : t -> string

(* type comparator_witness *)

(* val comparator : (t, comparator_witness) Comparator.t *)
val all_cards_str : string list
val all_cards : t list
val all_values_str : string list
val all_suits_str : string list