module Actions where

import Gamestate.GameState (GameState)
import Control.Monad.State

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
actionShow :: String -> IO ()
actionShow input | "inventory" = actionInventory
                 | "scene" = actionScene


actionInventory :: State GameState inventory -> IO ()
actionInventory = print




actionScene :: State GameState scene -> IO()
actionScene = print