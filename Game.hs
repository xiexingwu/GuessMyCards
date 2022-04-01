module Game (feedback, initialGuess, nextGuess, GameState) where

import Card
import Data.List

-- | Hand is a list of Cards. A personally helpful but not necessary abstraction
-- | GameState is a list of all possible Hands.
type Hand = [Card]
type GameState = [Hand]

-- | feedback takes the target and guess as inputs and computes the feedback 
--   introduced in the problem spec
feedback :: Hand -> Hand -> (Int, Int, Int, Int, Int)
feedback target guess  = (nCorrect, nLowerR, nSameR, nHigherR, nSameS)
    where nCards   = length target
          nCorrect = length (intersect guess target)
          nLowerR  = getNumberLowerRank guess target
          nSameR   = nCards - length (deleteFirstsBy (eqProp rank) guess target)
          nHigherR = getNumberHigherRank guess target
          nSameS   = nCards - length (deleteFirstsBy (eqProp suit) guess target)

-- | eqProp compares the property (suit or rank) of two Cards and returns 
--   True/False
eqProp :: Eq a => (Card -> a) -> Card -> Card -> Bool
eqProp prop card1 card2 = (prop card1) == (prop card2)

-- | getNumberLowerRank finds the number of target Cards with Rank less than the
--   lowest rank guess Card
getNumberLowerRank :: Hand -> Hand -> Int
getNumberLowerRank guess target = sum [fromEnum (rank targetR < guess_min) | targetR <- target]
    where guess_min = minimum (map rank guess)

-- | getNumberHigherRank finds the number of target Cards with Rank greater than
--   the highest rank guess Card
getNumberHigherRank :: Hand -> Hand -> Int
getNumberHigherRank guess target = sum [fromEnum (rank targetR > guess_max) | targetR <- target]
    where guess_max = maximum (map rank guess)

-- | initialGuess makes the initial guess of the Cards and initialises the 
--   GameState.
--   The initial guess is made so that the numCards Cards taken partition the 
--   deck into n+1 approximately even-sized partitions.
initialGuess :: Int -> (Hand,GameState)
initialGuess numCards = (guess, feasibleGuesses)
    where 
        allCards = [minBound..maxBound]::[Card]
        guess 
          | numCards == 1 = [allCards !! (deckSize `div` 2)]
          | otherwise     = [allCards !! i 
                             | i <- getDrawIndices step deckSize []]
        deckSize = length allCards - 1
        step = (deckSize `div` (numCards+1))
        feasibleGuesses = [hand | hand <- ndtake numCards allCards] \\ [guess]

--- | getDrawIndices generates a grid from 0 to end with stepsize step, and 
--    finally returns all values excluding the endpoints
getDrawIndices :: Int -> Int -> [Int] -> [Int]
getDrawIndices step end [] = getDrawIndices step end [0]
getDrawIndices step end list
    | next <= end = getDrawIndices step end (next:list)
    | otherwise = (init . tail) list
    where
      next = head list + step

-- | ndtake is a non-deterministic take
ndtake :: Int -> [a] -> [[a]]
ndtake 0 _      = [[]]
ndtake n []     = []
ndtake n (x:xs) = map (x:) (ndtake (n-1) xs) ++ ndtake n xs

-- | nextGuess generates a new guess using the method bestGuess. The gamestate
--   is updated to only consider Hands with the same feedback
nextGuess :: (Hand,GameState) -> (Int,Int,Int,Int,Int) -> ([Card],GameState)
nextGuess (oldGuess, state) currFeedback = (newGuess', state')
    where
        state' = delete oldGuess [hand | hand <- state
                                  , feedback hand oldGuess == currFeedback]
        newGuess' = bestGuess state'

-- | bestGuess finds a good next guess. This is done by minimizing the remaining
--   feasible solutions from a chosen guess
bestGuess :: GameState -> Hand
bestGuess state = fst bestGuesses
    where
        targetFeasibleGuesses = [(target, feasibleGuesses) | target <- state, 
                        let state' = state \\ [target],
                        let feasibleGuesses = getAvgRemHands target state']
        bestGuesses = foldl1 keepMinFeasibleGuess targetFeasibleGuesses

-- | keepMinFeasibleGuess is used to compare and keep guesses with the smaller
--   number of remaining feasible solutions
keepMinFeasibleGuess :: Ord a=> (Hand,a) -> (Hand,a) -> (Hand,a)
keepMinFeasibleGuess x y
    | snd x <= snd y = x
    | otherwise = y

-- | getAvgRemHands computes the average number of feasible hands that remain
--   once a guess is found to be incorrect
getAvgRemHands :: Hand -> GameState -> Double
getAvgRemHands target state
    = sum [(nOutcomes / totalOutcomes) * nOutcomes
          | aFeedback <- groupedFeedback
          , let nOutcomes = (fromIntegral . length) aFeedback]
    where
        allFeedback  = [aFeedback | feasibleGuess <- state, let aFeedback = feedback target feasibleGuess]
        groupedFeedback = (group . sort) allFeedback
        totalOutcomes = (fromIntegral . length) allFeedback