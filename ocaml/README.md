# Libraries
Written using Jane Street's packages:
* base `0.14.0`
* stdio `0.14.0`
* core `0.14.0`
* ppx_jane `0.14.0`

# Strategy overview
Let a `hand` be a collection of cards.

The first guess is pretty much random.
Given the feedback of the guess, we can compute the `gamestate`, i.e. all possible `hand`s that would result in such a feedback, so the true answer must be within the `gamestate`.

Suppose we choose a random `hand`s in the `gamestate` as our next guess. Each of the remaining `hand`s is a candidate for the answer and will give a possible feedback (not necessarily all distinct). Consider a possible feedback that appears $n$ times, then in the scenario where the feedback actually occurs, the `gamestate` is reduced to exactly the $n$ corresponding answers. While a possible feedback with smaller $n$ means a lower probability of from actually realizing, in the case it does appear, it reduces the `gamestate` to a much smaller space. We can thus compute a weighted number of remaining states:
$$
\sum_{i=1}^{N_f} n_i \frac{n_i}{N_g},
$$
where $N_f$ is the number of distinct feedbacks for our random guess, and $N_g$ is the size of `gamestate` (i.e. number of feasible `hand`s that could be the answer).

The strategy is to find the guess that minimises this weighted sum. Since the denominator is all $N_g$, the strategy just tries to find the guess that minimises $\sum_i n_i^2$. 

**Caveat**: This strategy scales $O(N_g^2)$, so for large $N_g$ the computation is quite slow. Instead, for large $N_g$, we just make a random guess that will hopefully prune the `gamestate` to a more manageable size. The threshold for large $N_g$ is currently set as `_random_guess_thresh = 3000` in `guesser.ml`.

# To run

```
$ dune build
$ dune exec bin/main.exe
```

By inputting `C5,DJ` as your choice of cards, the program will try to guess your cards:

* 5 of clubs;
* Jack of Diamonds.

Note that the order of your cards do not matter.

* **WARNING**

    The problem size becomes very large for 6 or more cards. ${52}\choose{6}$ $\approx 20$ million.
    
    A 5 card problem can usually be solved in under a minute. ${52}\choose{5}$ $\approx 2.6$ million.

## Example execution
```
$ dune exec bin/main.exe
A card is denoted by 'SV' where 'S' is its suit and 'V' is its value.
Valid suits: DCHS
Valid values: 23456789TJQKA
Example, to input '3 of hearts' and 'ten of clubs', type in "H3,CT".
Enter your cards in a comma-separated list:
C5,DJ   
-----Round 1-----
Guess: D5, C9,  
        is wrong...
        [Guesser:] States remaining:153
        Time taken: 19.7319984436 ms
-----Round 2-----
Guess: CK, CA,  
        is wrong...
        [Guesser:] States remaining:56
        Time taken: 1.27911567688 ms
-----Round 3-----
Guess: DK, CQ,  
        is wrong...
        [Guesser:] States remaining:42
        Time taken: 0.419616699219 ms
-----Round 4-----
Guess: DQ, CJ,  
        is wrong...
        [Guesser:] States remaining:30
        Time taken: 0.226020812988 ms
-----Round 5-----
Guess: DJ, C10,  
        is wrong...
        [Guesser:] States remaining:9
        Time taken: 0.0288486480713 ms
-----Round 6-----
Guess: DJ, C8,  
        is wrong...
        [Guesser:] States remaining:3
        Time taken: 0.00500679016113 ms
-----Round 7-----
Guess: DJ, C6,  
        is wrong...
        [Guesser:] States remaining:1
        Time taken: 0.00214576721191 ms
-----Round 8-----
Guess: DJ, C5,  
        IS CORRECT!
```