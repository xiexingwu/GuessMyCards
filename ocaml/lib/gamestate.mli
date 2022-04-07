type t = Hand.t list
(** Gamestate.t is the type for a Gamestate *)

val create : Hand.t list -> t
val state : t ref
val n : int ref
val update : guess:Hand.t -> feedback:Feedback.t -> unit
val to_string : t -> string
val print : unit -> unit