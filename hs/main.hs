import Card
import Game


feedback :: Hand -> Hand -> (Int, Int, Int, Int, Int)
initialGuess :: Int -> (Hand,GameState)
nextGuess :: (Hand,GameState) -> (Int,Int,Int,Int,Int) -> ([Card],GameState)

driver :: [Card] -> ([Card], GameState) -> Int
driver (answer, _) ([], _) = driver (answer, 1) (initialGuess (length answer))
driver answer guess 
    | ncorrect == length answer = 1
    where
        ncorrect = head feedback answer guess
        