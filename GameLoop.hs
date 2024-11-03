module GameLoop where

import Gamestate.GameState
import Control.Monad.State
import Scenes
import Actions
import GameState.EndCheck
import System.Exit (exitSuccess)
import qualified Distribution.Compat.Prelude as System

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
    putStrLn "LOST IN THE SNOW"
    putStrLn "Survival Adventure Game from CESWEG"
    putStrLn "enter the `help` command any time"
    let initialGameState = GameState { scene = 0, flags = ["bunny"], inventory = [] }
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
        "liftIO" ->  do 
            game <- get
            let loc = scene game
            if loc == 7 then do
                liftIO $ putStrLn "you have escaped the Matrix" 
                liftIO exitSuccess
            else liftIO $ putStrLn "try again"
        _      -> liftIO $ putStrLn "try again"

-- Loop that processes actions and checks game state conditions
actionsLoop :: AllScenes -> String -> StateT GameState IO ()
actionsLoop s str = do
    -- Call action and check if user is dead
    game <- get
    let firstPos = scene game
    actions s str
    deadBool <- flagGameOver
    game <- get
    let secondPos = scene game

    if deadBool
        then do
            liftIO $ putStrLn "WASTED."
            liftIO exitSuccess
    else if head (userCut str) /= "go"
        then do
            liftIO $ putStrLn ">>"
            userInput <- liftIO getLine
            actionsLoop s userInput
        else 
            if firstPos == secondPos then do
                liftIO $ putStrLn ">>"
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
    liftIO $ putStrLn ">>"
    userInput <- liftIO getLine
    actionsLoop s userInput

    -- Check if the user is in the end room and if failed end conditions are met
    ending <- isEndRoom
    failedEnd <- failedEndBool
    if ending && failedEnd
        then liftIO $ putStrLn "Reaching civilisation has never felt better. Well, it would feel better if you hadn't just been stabbed in the back. If only you had read the letter, it may have warned you of your friend's paranoia..."
    else if ending
        then liftIO $ putStrLn "Returning to civilisation quickly brings back memories of your friend; his letter a sign he may still be trapped up the mountains. Search and rescue is notified and you are treated to a nice hot meal whilst you remain hopeful of their return."
    else
        narrativeLoop s  -- Continue the narrative loop if not at the end
