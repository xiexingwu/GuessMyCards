type t = Card.t list [@@deriving equal]

val create : Card.t list -> t
val length : t -> int
val ncorrect : answer:t -> guess:t -> int
val nlower : answer:t -> guess:t -> int
val nhigher : answer:t -> guess:t -> int
val nsuits : answer:t -> guess:t -> int
val to_string : t -> string