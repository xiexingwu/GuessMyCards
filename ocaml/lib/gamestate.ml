open! Base
open! Stdio
open! Core

type t = Hand.t list

let create hands : t = hands
let state : t ref = ref (create [])
let n = ref 0

let rec cards_choose_n ?(cards = Card.all_cards) n : Card.t list list =
  match (n, cards) with
  | 0, _ -> [ [] ]
  | _, [] -> []
  | _, next :: remaining ->
      let take_next =
        List.map (cards_choose_n ~cards:remaining (n - 1)) ~f:(List.cons next)
      in
      let dont_take = cards_choose_n ~cards:remaining n in
      take_next @ dont_take

let to_string state =
  state
  |> List.map ~f:(fun hand -> "[" ^ Hand.to_string hand ^ "]")
  |> List.fold ~init:"" ~f:(fun s1 s2 -> s1 ^ s2 ^ "; ")

let print () =
  print_string (to_string !state);
  printf "\n%!"

let update ~guess ~feedback =
  let feasible_hand hand =
    Feedback.equal feedback (Feedback.give_feedback ~answer:hand ~guess)
  in
  if List.length !state > 0 then
    let new_state = List.filter !state ~f:feasible_hand in
    state := new_state
  else
    (* called for the first time *)
    let all_cards_choose_n = cards_choose_n !n in
    let add_cards_if_valid cards =
      if feasible_hand (Hand.create cards) then state := cards :: !state
    in
    List.iter all_cards_choose_n ~f:add_cards_if_valid
