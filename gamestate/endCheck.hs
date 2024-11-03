module GameState.EndCheck where

import Gamestate.GameState
import Control.Monad.State

{-

Immediate Death ends the game
--immediate death means to add 3 flags to flaglist then trigger flagGameOver but has different end message
3 Flags ends the game
Reaching the end ends the game

Alive end means not triggering moralGameOver

--need add flag function when a flag is triggered
EXTRA--could remove flags if find and use healing supplies
-}

containsValue :: (Eq v) => v -> [v] -> Bool
containsValue _ [] = False
containsValue x (y:ys)
    | x == y = True
    | otherwise = containsValue x ys

--if bunny is killed, then reaching the end will kill player
--True==Failed
failedEndBool :: State GameState Bool
failedEndBool = do
    game <- get
    let flagDeath = flags game
    return $ containsValue "bunny" flagDeath

--if 3 flags are triggered then failed and end early
flagGameOver :: State GameState Bool
flagGameOver = do
    gameState <- get
    let flagDeath = flags gameState
    if length flagDeath >=3 then return True else return False

--find out if end room has been reached
isEndRoom :: State GameState Bool
isEndRoom = do
    gameState <- get
    let lastScene = scene gameState
    if lastScene == 16 then return True else return False