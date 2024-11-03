module GameLoop where

import Gamestate.GameState
import Control.Monad.State
import Scenes
import Actions
import GameState.EndCheck


{-
0. Welcome Message, in first room
LOOP
1. Enter Room, Scene Description displays
2.Loop
    a) User Takes Action (Set flags)
    b) Is User Dead (Set flags)
3. Is User in End Room 
-}

main :: IO ()
main = do
    --welcome stuff
    --go to recursive function
    --do ending out of loop
    print "placeholder"

{-
wordsWhen     :: (Char -> Bool) -> String -> [String]
wordsWhen p s =  case dropWhile p s of
                    "" -> []
                    s' -> w : wordsWhen p s''
                    where (w, s'') = break p s

--cuts the user input into verb + subject for use in multiple functions
userCut :: String -> [String]
userCut str = do
    let strlst = wordsWhen (==' ') str
    return strlst
-}

userCut :: String -> [String]
userCut [] = []
userCut s = x : userCut (drop 1 y) where (x,y) = span (/= ' ') s

--getting verb from userInput, checking if verb is accepted, move to the right action
actions :: AllScenes -> String -> StateT GameState IO ()
actions s str = do
    let v = userCut str
    let verb = v!!0
    if verb == "help" then liftIO actionHelp
    else if verb == "go" then actionGo (v!!1) s
    else if verb == "show" then actionShow  (v!!1) s
    else if verb == "take" then actionTake  (v!!1) s
    else if verb == "use" then actionUse  (v!!1)
    else liftIO $ putStrLn "Try again"

getUserInput :: String
getUserInput = do
    liftIO readLn

actionsLoop :: AllScenes -> String -> StateT GameState IO ()
actionsLoop s str = do
    --call action
    actions s str
    --death check
    let deadBool = GameState.EndCheck.flagGameOver
    if deadBool then do
        ptrStrLn "You have died"
        System.Exit
    --if moving then leave function, else recursion time baybee
    else if do
        (userCut str!!0) /= "go" then actionsLoop s getUserInput
    else
        liftIO $ putStr ""

narrativeLoop :: AllScenes -> StateT GameState IO ()
narrativeLoop s = do
    game <- get
    --scene description
    let sceneInt = scene game
    liftIO $ putStrLn (fst (s!!sceneInt))
    --read user action
    n <- liftIO readLn
    actionsLoop s n
    --is user in end room
    let ending = GameState.EndCheck.isEndRoom
    if ending && GameState.EndCheck.failedEndBool
        then liftIO $ putStrLn "Unfortunately you have been murdered by the bunny's mother, she has been hunting you for your entire journey."
    else if ending
        then liftIO $ putStrLn "Congratulations, you have escaped the Snowy Hellscape"
    else
        liftIO $ putStrLn "hello"