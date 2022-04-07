open! Base

let _random_guess_thresh = 3000

let get_weighted_rem_states ~guess =
  let is_guess hand = List.equal Card.equal hand guess in
  let all_answers =
    !Gamestate.state |> List.filter ~f:(fun hand -> not @@ is_guess hand)
  in
  let all_feedbacks =
    List.map all_answers ~f:(fun answer ->
        Feedback.give_feedback ~answer ~guess)
  in
  let freq =
    all_feedbacks
    |> List.group ~break:(fun a b -> not (Feedback.equal a b))
    |> List.map ~f:List.length
  in
  let weighted_freq = List.map freq ~f:(fun x -> x ** 2) in
  List.fold weighted_freq ~init:0 ~f:Int.( + )

let next_guess ~guess ~feedback =
  Gamestate.update ~guess ~feedback;
  let best_guess =
    let state = !Gamestate.state in
    let nstates = List.length state in
    Stdio.printf "\t[Guesser:] States remaining:%d\n%!" nstates;
    let nstates = List.length state in
    if nstates > _random_guess_thresh then List.nth_exn state (nstates / 2)
    else
      let init = (List.hd_exn state, nstates) in
      let best (current_guess, current_min) guess =
        let rem_states = get_weighted_rem_states ~guess in
        match rem_states < current_min with
        | true -> (guess, rem_states)
        | false -> (current_guess, current_min)
      in
      let guess, _ = state |> List.fold ~init ~f:best in
      guess
  in
  best_guess

(* Avoid generating all possible hands for first guess *)
let initial_guess n =
  Gamestate.n := n;

  (* Try to draw all suits *)
  let draw_suits =
    List.range 0 n
    |> List.map ~f:(fun i -> List.nth_exn Card.all_suits_str (i % 4))
  in

  (* Evenly space out values *)
  let all_vals = Card.all_values_str in
  let vals_step = max 1 (List.length all_vals / (n + 1)) in
  let draw_vals =
    List.range 1 (n + 1)
    |> List.map ~f:(fun i -> List.nth_exn all_vals ((i * vals_step) - 1))
  in
  let create_hand s v = Card.create (s ^ v) in
  let guess = List.map2_exn draw_suits draw_vals ~f:create_hand in
  Hand.create guess
