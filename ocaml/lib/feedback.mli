type t = {
  ncorrect : int;
  nlower : int;
  nequal : int;
  nhigher : int;
  nsuits : int;
}
[@@deriving equal]

val create :
  ncorrect:int -> nlower:int -> nequal:int -> nhigher:int -> nsuits:int -> t

val give_feedback : answer:Hand.t -> guess:Hand.t -> t
