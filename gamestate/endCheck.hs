module GameState.EndCheck where

import Gamestate.GameState
import Control.Monad.State

-- Check if a specific flag (e.g., "bunny") exists in flags
containsValue :: (Eq v) => v -> [v] -> Bool
containsValue _ [] = False
containsValue x (y:ys)
    | x == y = True
    | otherwise = containsValue x ys

-- Check if "bunny" flag is set to indicate failed end
failedEndBool :: StateT GameState IO Bool
failedEndBool = do
    game <- get
    let flagDeath = flags game
    return $ containsValue "bunny" flagDeath

-- Check if 3 or more flags are triggered to end early
flagGameOver :: StateT GameState IO Bool
flagGameOver = do
    gameState <- get
    let flagDeath = flags gameState
    if "coat" `elem` flagDeath then
        if "bunny" `elem` flagDeath then return $ length flagDeath >= 5
        else return $ length flagDeath >= 4
    else if "bunny" `elem` flagDeath then
        return $ length flagDeath >= 4
    else return $ length flagDeath >= 3

-- Check if the end room has been reached
isEndRoom :: StateT GameState IO Bool
isEndRoom = do
    gameState <- get
    return $ scene gameState == 16
