open! Base
open! Stdio
open! Game

let time f =
  let open Core in
  let start = Time.now () in
  let x = f () in
  let stop = Time.now () in
  printf "\tTime taken: %F ms\n%!" (Time.diff stop start |> Time.Span.to_ms);
  x

let ask_for_answer () =
  printf
    "A card is denoted by 'SV' where 'S' is its suit and 'V' is its value.\n";
  printf "Valid suits: %s\n" (String.concat Card.all_suits_str);
  printf "Valid values: %s\n" (String.concat Card.all_values_str);
  printf
    "Example, to input '3 of hearts' and 'ten of clubs', type in \"H3,CT\".\n";
  printf "Enter your cards in a comma-separated list:\n%!";
  match In_channel.(input_line stdin) with
  | None -> failwith "No cards entered."
  | Some hand_str ->
      let card_list_str = String.split hand_str ~on:',' in
      let card_list = List.map card_list_str ~f:Card.create in
      Hand.create card_list

let answer = ask_for_answer ()
let guess = ref (Guesser.initial_guess (List.length answer))
let guesses = ref 1
let won = ref false

let () =
  let play_round () =
    let state = !Gamestate.state in
    printf "-----Round %d-----\n" !guesses;
    (* printf "Guesser game state is "; *)
    (* Gamestate.print (); *)
    if not (List.is_empty state || List.mem state answer ~equal:Hand.equal) then
      failwith "guesser pruned away correct answer";
    printf "Guess: %s \n" (Hand.to_string !guess);

    match Hand.equal !guess answer with
    | true ->
        printf "\tIS CORRECT! \n%!";
        won := true
    | false ->
        printf "\tis wrong...\n%!";
        let feedback = Feedback.give_feedback ~answer ~guess:!guess in
        guess := time (fun () -> Guesser.next_guess ~guess:!guess ~feedback);
        Int.incr guesses
  in
  while not !won do
    play_round ()
  done
