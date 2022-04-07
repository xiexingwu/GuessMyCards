# The Code
There are two versions of the code, one in OCaml and one in Haskell.

The Haskell code implements the logic, but is missing a driver for the functions to be executed in a meaningful manner (i.e. accept an input answer).

The OCaml code is more fully featured. Instructions on how to run in the README of the OCaml folder.

# The Game
## Rules
The game consists of two players with a standard 52 card deck of playing cards.
One player is the guesser, the other the answerer.
The game begins when the answerer secretly selects a number of cards from the deck. The aim of the game is for the guesser to guess the selected cards, knowing the number of cards selected.
The order of the cards is irrelevant, and the cards are chosen without replacement.

The guesser makes a guess by choosing the same number of cards from the deck and showing them to the answerer. The answerer's response is 5 numbers:
1. The number of correctly guessed cards.
2. The number of answer cards with rank lower than the lowest rank in the guess. 2 is lowest, A is highest.
3. The number of cards in the guess with rank equal to some answer card. Note that duplicates in the guess do not affect this number (i.e. dupes ignored).
4. The number of answer cards with rank higher than the highest rank in the guess.  
5. The number of cards in the answer with the same suit as a card in the guess. As before, duplicates in the guess do not affect this number.
The guesser continues to make guesses, receiving feedback each time until all answer cards are determined. 

## Example rounds:
### Example 1
Answer: 3♣,4♥

Guess: 4♥,3♣

Feedback: 2,0,2,0,2 
* 2 answer cards match guess,
* no answer rank less than 3,
* 2 answer ranks match guess,
* no answer rank greater than 4,
* 2 answer suits match guess.

### Example 2
Answer: 3♣,4♥

Guess: 3♣,3♥

Feedback: 1,0,1,1,2 
* 1 exact match (3♣),
* no answer rank less than 3,
* 1 answer rank matches guess,
* 1 answer rank greater than 3,
* 2 answer suits match guess.

### Example 3
Answer: 3♦,3♠

Guess: 3♣,3♥

Feedback: 0,0,2,0,0 
* No exact matches,
* no answer rank less than 3,
* 2 answer ranks match guess,
* no answer ranks greater than 3,
* no answer suits match guess.

### Example 4
Answer: 3♣,4♥

Guess: 2♥,3♥ 

Feedback: 0,0,1,1,1 
* No exact matches,
* no answer rank less than a 2,
* 1 answer rank matches guess,
* 1 answer rank greater than 3,
* 1 answer suit matches guess.

### Example 5
Answer: A♣,2♣ 

Guess: 3♣,4♥ 

Feedback: 0,1,0,1,1 
* No exact matches,
* 1 answer rank less than 3 (Ace is high),
* no answer rank matches guess,
* 1 answer rank greater than 4,
* 1 answer suit matches guess (either ♣; you can only count 1 because there’s only 1 in the guess).

