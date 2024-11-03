module GameLoop where

import Gamestate.GameState
import Control.Monad.State
import Scenes
import Actions
import GameState.EndCheck
import System.Exit (exitSuccess)

{- Main Game Loop Steps:
    1. Welcome Message
    2. Scene Description (Enter Room)
    3. User Action Loop
        a) User Takes Action
        b) Check if User is Dead
        c) Check if User is in End Room
-}

main :: IO ()
main = do
    putStrLn "Start stuff"
    let initialGameState = GameState { scene = 0, flags = [], inventory = [] }
    evalStateT (narrativeLoop Scenes.getMap) initialGameState

-- Utility to split user input into words
userCut :: String -> [String]
userCut [] = []
userCut s = x : userCut (drop 1 y) where (x, y) = span (/= ' ') s

-- Processing user actions
actions :: AllScenes -> String -> StateT GameState IO ()
actions s str = do
    let v = userCut str
    let verb = head v
    case verb of
        "help" -> liftIO actionHelp
        "go"   -> actionGo (v !! 1) s
        "show" -> actionShow (v !! 1) s
        "take" -> actionTake (v !! 1) s
        "use"  -> actionUse (v !! 1)
        _      -> liftIO $ putStrLn "Try again"

-- Loop that processes actions and checks game state conditions
actionsLoop :: AllScenes -> String -> StateT GameState IO ()
actionsLoop s str = do
    -- Call action and check if user is dead
    actions s str
    deadBool <- flagGameOver
    if deadBool
        then do
            liftIO $ putStrLn "You have died."
            liftIO exitSuccess
        else if head (userCut str) /= "go"
            then do
                liftIO $ putStrLn "Enter your next action:"
                userInput <- liftIO getLine
                actionsLoop s userInput
            else return ()

-- Main narrative loop that checks game state and manages the game flow
narrativeLoop :: AllScenes -> StateT GameState IO ()
narrativeLoop s = do
    game <- get
    -- Display scene description
    let sceneInt = scene game
    liftIO $ putStrLn (fst (s !! sceneInt))
    
    -- Read user action
    liftIO $ putStrLn "Enter your action:"
    userInput <- liftIO getLine
    actionsLoop s userInput

    -- Check if the user is in the end room and if failed end conditions are met
    ending <- isEndRoom
    failedEnd <- failedEndBool
    if ending && failedEnd
        then liftIO $ putStrLn "Unfortunately, you have been murdered by the bunny's mother. She has been hunting you for your entire journey."
    else if ending
        then liftIO $ putStrLn "Congratulations, you have escaped the Snowy Hellscape!"
    else
        narrativeLoop s  -- Continue the narrative loop if not at the end
