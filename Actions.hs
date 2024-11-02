module Actions where

import GameState

-- TODO: Change Filler Text to actual help
actionHelp :: () -> IO ()
actionHelp = putStrLn "Filler Text"

{-
actionGo :: String -> GameState GameState ()

actionUse :: String -> GameState GameState ()

actionOpen :: String -> GameState GameState ()

actionLook :: String -> GameState GameState ()

actionTake :: String -> GameState GameState ()
-}


-- TODO: Get it to actually print the states
actionShow :: String -> GameState GameState ()
actionShow input = do
    game <- get
    if input == "inventory" then putStrLn "this will output the inventory"
    else if input == "state" then putStrLn "this will output the state"
    else putStrLn "I'm sorry that is not something that can be shown"

