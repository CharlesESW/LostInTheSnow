module Actions where

import Gamestate.GameState
import Control.Monad.State

-- TODO: Change Filler Text to actual help
actionHelp :: IO ()
actionHelp = putStrLn "Filler Text"

invalidAction :: IO()
invalidAction = putStrLn "Please input a valid command."



{-

actionUse :: String -> GameState GameState ()

actionOpen :: String -> GameState GameState () --needed??

actionLook :: String -> GameState GameState () --unnecessary with Show

actionTake :: String -> GameState GameState ()
-}

containsValue :: (Eq v) => v -> [v] -> Bool
containsValue _ [] = False
containsValue x (y:ys)
    | x == y = True
    | otherwise = containsValue x ys

 --TODO: Get it to actually print the states
actionShow :: String -> StateT GameState IO ()
actionShow input = do
    game <- get
    let i = inventory
    let s = scene

    if input == "inventory" then liftIO $ print (inventory game)
    else if input == "scene" then liftIO $ print (scene game)
    else liftIO invalidAction

--check that String isnt already in Inventory
--add to Inventory
actionTake :: String -> StateT GameState IO ()
actionTake input = do
    game <- get
    let currentInventory = inventory game
    let newInventory = currentInventory ++ [input]
    let duplicateBool = containsValue input currentInventory
    if duplicateBool then liftIO invalidAction
    --else if not in room's inventory then liftIO invalidAction
    else put $ game {inventory = newInventory}