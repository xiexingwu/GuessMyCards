open! Base

module Suit = struct
  module T = struct
    type t = Club | Diamond | Heart | Spade
    [@@deriving compare, equal, sexp_of]

    let to_string s =
      match s with Club -> "C" | Diamond -> "D" | Heart -> "H" | Spade -> "S"
  end

  include T

  (* exception Invalid_Suit_Char of string *)
  let create ch =
    match ch with
    | 'C' -> Club
    | 'D' -> Diamond
    | 'H' -> Heart
    | 'S' -> Spade
    | _ -> failwith "Invalid suit character"
  (* | _   -> raise (Invalid_Suit_Char "Invalid suit character") *)

  let int_of suit =
    match suit with Diamond -> 1 | Club -> 2 | Heart -> 3 | Spade -> 4

  let compare s1 s2 = Int.compare (int_of s1) (int_of s2)
end

module Value = struct
  module T = struct
    type t = Number of int | Jack | Queen | King | Ace
    [@@deriving equal, sexp_of]

    let int_of value =
      match value with
      | Ace -> 14
      | King -> 13
      | Queen -> 12
      | Jack -> 11
      | Number i -> i

    let compare v1 v2 = Int.compare (int_of v1) (int_of v2)

    let to_string v =
      match v with
      | Ace -> "A"
      | King -> "K"
      | Queen -> "Q"
      | Jack -> "J"
      | _ -> Int.to_string (int_of v)
  end

  (* exception Invalid_Value_Char of string   *)
  include T

  let create ch =
    match ch with
    | 'A' -> Ace
    | 'K' -> King
    | 'Q' -> Queen
    | 'J' -> Jack
    | 'T' -> Number 10
    | '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9' ->
        let asc_0 = Char.to_int '0' in
        Number (Char.to_int ch - asc_0)
    | _ -> failwith "Invalid value character"
  (* | _   -> raise (Invalid_Value_Char "Invalid value character") *)
end

module T = struct
  type t = Suit.t * Value.t [@@deriving compare, equal, sexp_of]

  let compare ((s1, v1) : t) ((s2, v2) : t) =
    let val_comp = Value.compare v1 v2 in
    let suit_comp = Suit.compare s1 s2 in
    if val_comp = 0 then suit_comp else val_comp

  let create str =
    let str_l = String.to_list str in
    match str_l with
    | [ suit_ch; value_ch ] -> (Suit.create suit_ch, Value.create value_ch)
    | _ -> failwith ("Invalid card string: " ^ String.of_char_list str_l)

  let suit card = Suit.sexp_of_t (fst card)
  let value card = Value.int_of (snd card)

  let to_string card =
    let s, v = card in
    Suit.to_string s ^ Value.to_string v
end

include T
(* include Comparator.Make (T) *)

let all_values_str =
  [ "2"; "3"; "4"; "5"; "6"; "7"; "8"; "9"; "T"; "J"; "Q"; "K"; "A" ]

let all_suits_str = [ "D"; "C"; "H"; "S" ]

let all_cards_str =
  let suits = String.to_list "DCHS" in
  let values = String.to_list "23456789TJQKA" in
  let allpairs = List.cartesian_product suits values in
  let f (suit, value) = String.of_char suit ^ String.of_char value in
  List.map allpairs ~f

let all_cards = List.map all_cards_str ~f:create
