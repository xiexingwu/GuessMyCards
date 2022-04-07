open! Base

type t = Card.t list [@@deriving equal, sexp_of]

(* let create cards = Set.of_list (module Card) cards *)
let create cards = cards
let length = List.length

let equal hand1 hand2 =
  let is_in_hand2 card = List.mem hand2 card ~equal:Card.equal in
  hand1 |> List.map ~f:is_in_hand2 |> List.fold ~init:true ~f:( && )

let ncorrect ~answer ~guess =
  let is_correct card = List.count guess ~f:(Card.equal card) in
  List.fold answer ~init:0 ~f:(fun accum rest -> accum + is_correct rest)

let nlower ~answer ~guess =
  let lowest = List.min_elt guess ~compare:Card.compare in
  match lowest with
  | None -> failwith "no lowest card"
  | Some value ->
      let lower =
        List.filter answer ~f:(fun card -> Card.compare card value < 0)
      in
      List.length lower

let nhigher ~answer ~guess =
  let highest = List.max_elt guess ~compare:Card.compare in
  match highest with
  | None -> failwith "no lowest card"
  | Some value ->
      let higher =
        List.filter answer ~f:(fun card -> Card.compare card value > 0)
      in
      List.length higher

let nsuits ~answer ~guess =
  let guess_suits =
    List.dedup_and_sort (List.map guess ~f:Card.suit) ~compare:Sexp.compare
  in
  let same_suits =
    List.filter answer ~f:(fun card ->
        List.mem guess_suits (Card.suit card) ~equal:Sexp.equal)
  in
  List.length same_suits

let to_string hand =
  hand |> List.map ~f:Card.to_string
  |> List.fold ~init:"" ~f:(fun s1 s2 -> s1 ^ s2 ^ ", ")
