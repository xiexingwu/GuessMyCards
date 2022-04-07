open! Base

type t = {
  ncorrect : int;
  nlower : int;
  nequal : int;
  nhigher : int;
  nsuits : int;
}
[@@deriving equal]

let create ~ncorrect ~nlower ~nequal ~nhigher ~nsuits =
  { ncorrect; nlower; nequal; nhigher; nsuits }

let give_feedback ~answer ~guess =
  let ncorrect = Hand.ncorrect ~answer ~guess in
  let nlower = Hand.nlower ~answer ~guess in
  let nhigher = Hand.nlower ~answer ~guess in
  let nequal = Hand.length answer - nlower - nhigher in
  let nsuits = Hand.nsuits ~answer ~guess in
  { ncorrect; nlower; nequal; nhigher; nsuits }

module For_testing = struct
  let a1 = Hand.create [ Card.create "C3"; Card.create "H4" ]
  let g1 = Hand.create [ Card.create "H4"; Card.create "C3" ]
  let g2 = Hand.create [ Card.create "H3"; Card.create "C3" ]
  let a3 = Hand.create [ Card.create "D3"; Card.create "S3" ]
  let g4 = Hand.create [ Card.create "H2"; Card.create "H3" ]
  let a5 = Hand.create [ Card.create "CA"; Card.create "C2" ]

  let%test "Testing give_feedback..." =
    let expect = create ~ncorrect:2 ~nlower:0 ~nequal:2 ~nhigher:0 ~nsuits:2 in
    [%equal: t] (give_feedback ~answer:a1 ~guess:g1) expect

  let%test "Testing give_feedback..." =
    let expect = create ~ncorrect:1 ~nlower:0 ~nequal:1 ~nhigher:1 ~nsuits:2 in
    [%equal: t] (give_feedback ~answer:a1 ~guess:g2) expect

  let%test "Testing give_feedback..." =
    let expect = create ~ncorrect:0 ~nlower:0 ~nequal:2 ~nhigher:0 ~nsuits:0 in
    [%equal: t] (give_feedback ~answer:a3 ~guess:g2) expect

  let%test "Testing give_feedback..." =
    let expect = create ~ncorrect:0 ~nlower:0 ~nequal:1 ~nhigher:1 ~nsuits:1 in
    [%equal: t] (give_feedback ~answer:a1 ~guess:g4) expect

  let%test "Testing give_feedback..." =
    let expect = create ~ncorrect:0 ~nlower:1 ~nequal:0 ~nhigher:1 ~nsuits:1 in
    [%equal: t] (give_feedback ~answer:a5 ~guess:a1) expect
end
