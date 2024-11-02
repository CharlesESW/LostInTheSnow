module EndCheck where

import Gamestate.GameState
import Control.Monad.State

containsValue :: (Eq v) => v -> [v] -> Bool
containsValue _ [] = False
containsValue x (y:ys)
    | x == y = True
    | otherwise = containsValue x ys

    {-
isEndRoom :: State GameState Bool
isEndRoom = do
    gameState <- get
    let 
-}
--game over if reach end and moralFlag has gone off


moralGameOver :: State GameState Bool
moralGameOver = do
    game <- get
    let flagDeath = flags game
    return $ containsValue "bunny" flagDeath


--game over if flags set off
flagGameOver :: State GameState Bool
flagGameOver = do
    gameState <- get
    let flagDeath = flags gameState
    if length flagDeath >=3 then return True else return False

    