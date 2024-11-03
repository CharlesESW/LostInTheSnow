{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Redundant if" #-}
module Actions where

import Gamestate.GameState
import Scenes
import Control.Monad.State
import Data.List

-- TODO: Change Filler Text to actual help
actionHelp :: IO ()
actionHelp = putStrLn "Filler Text"

invalidAction :: IO()
invalidAction = putStrLn "Please input a valid command."

goingNorth :: Int -> AllScenes -> Int
goingNorth loc scenes = do
    if loc < 4 then loc
    else if fst (scenes!!(loc - 4)) == "NULL" then loc
    else loc - 4

goingSouth :: Int -> AllScenes -> Int
goingSouth loc scenes = do
    if loc > 11 then loc
    else if fst (scenes!!(loc + 4)) == "NULL" then loc
    else loc + 4

goingEast :: Int -> AllScenes -> Int
goingEast loc scenes = do
    if loc == 11 then 16
    else if loc `mod` 4 == 3 then loc
    else if fst (scenes!!(loc + 1)) == "NULL" then loc
    else loc + 1

goingWest :: Int -> AllScenes -> Int
goingWest loc scenes = do
    if loc `mod` 4 == 0 then loc
    else if fst (scenes!!(loc - 1)) == "NULL" then loc
    else loc - 1

actionGo :: String -> AllScenes -> StateT GameState IO ()
actionGo "north" scenes = do
    game <- get
    let place = scene game
    let newPlace = goingNorth place scenes
    let f = flags game
    if place == newPlace then do
        liftIO $ putStrLn "You are not able to travel north"
        put $ game {scene = newPlace}
    else if place == 5 then do
        liftIO $ putStrLn "You were killed by a Yeti"
        put $ game {scene = newPlace, flags = ["1", "2", "3"]}
    else if place == 8 then do
        liftIO $ putStrLn "You were struck by lightning"
        put $ game {scene = newPlace, flags = ["1", "2", "3"]}
    else if place == 11 then do
        liftIO $ putStrLn "There was a rockfall that caused you to get stranded, you slowly starve to death"
        put $ game {scene = newPlace, flags = ["1", "2", "3"]}
    else if place == 10 then do
        liftIO $ putStrLn "You fell into a pit, but managed to get back out only taking a little damage"
        put $ game {scene = place, flags = f ++ ["fellinpit"]}
    else if place == 13 && notElem "coat" f then do
        liftIO $ putStrLn "it is very cold and you get hypothermia"
        put $ game {scene = newPlace, flags = f ++["cold"]}
    else do
        liftIO $ putStrLn "You have travelled north"
        put $ game { scene = newPlace }
actionGo "south" scenes = do
    game <- get
    let place = scene game
    let f = flags game
    let newPlace = goingSouth place scenes
    if place == newPlace then do
        liftIO $ putStrLn "You are not able to travel south"
        put $ game { scene = newPlace }
    else if place == 1 then do
        liftIO $ putStrLn "You were killed by a Yeti"
        put $ game {scene = newPlace, flags = ["1", "2", "3"]}
    else if place == 4 then do
        liftIO $ putStrLn "You were struck by lightning"
        put $ game {scene = newPlace, flags = ["1", "2", "3"]}
    else if place == 7 then do
        liftIO $ putStrLn "There was a rockfall that caused you to get stranded, you slowly starve to death"
        put $ game {scene = newPlace, flags = ["1", "2", "3"]}
    else if place == 2 then do
        liftIO $ putStrLn "You fell into a pit, but managed to get back out only taking a little damage"
        put $ game {scene = place, flags = f ++ ["fellinpit"]}
    else if place == 8 then do
        liftIO $ putStrLn "There was an avalanche which you narrowly escaped"
        put $ game {scene = place, flags = f ++ ["avalanche"]}
    else if place == 5 && notElem "coat" f then do
        liftIO $ putStrLn "it is very cold and you get hypothermia"
        put $ game {scene = newPlace, flags = f ++["cold"]}
    else if place == 11 then do
        liftIO $ putStrLn "You have fallen in, you don't know how long you will last"
        put $ game {scene = newPlace, flags = f ++ ["illness"]}
    else do
        liftIO $ putStrLn "You have travelled south"
        put $ game { scene = newPlace }
actionGo "east" scenes = do
    game <- get
    let place = scene game
    let newPlace = goingEast place scenes
    let f = flags game
    if place == newPlace then do
        liftIO $ putStrLn "You are not able to travel east"
        put $ game { scene = newPlace }
    else if place == 10 then do
        liftIO $ putStrLn "There was a rockfall that caused you to get stranded, you slowly starve to death"
        put $ game {scene = newPlace, flags = ["1", "2", "3"]}
    else if place == 5 then do
        liftIO $ putStrLn "You fell into a pit, but managed to get back out only taking a little damage"
        put $ game {scene = place, flags = f ++ ["fellinpit"]}
    else if place == 14 then do
        liftIO $ putStrLn "You have fallen ill, you don't know how long you will last"
        put $ game {scene = newPlace, flags = f ++ ["sickness"]}
    else if place == 8 && notElem "coat" f then do
        liftIO $ putStrLn "it is very cold and you get hypothermia"
        put $ game {scene = newPlace, flags = f ++["cold"]}
    else do
        liftIO $ putStrLn "You have travelled east"
        put $ game { scene = newPlace }
actionGo "west" scenes = do
    game <- get
    let place = scene game
    let newPlace = goingWest place scenes
    let f = flags game
    if place == newPlace then do
        liftIO $ putStrLn "you are not able to travel wast"
        put $ game { scene = newPlace }
    else if place == 11 then do
        liftIO $ putStrLn "There was a rockfall that caused you to get stranded, you slowly starve to death"
        put $ game {scene = newPlace, flags = ["1", "2", "3"]}
    else if place == 7 then do
        liftIO $ putStrLn "You fell into a pit, but managed to get back out only taking a little damage"
        put $ game {scene = place, flags = f ++ ["fellinpit"]}
    else if place == 13 then do
        liftIO $ putStrLn "There was an avalanche which you narrowly escaped"
        put $ game {scene = place, flags = f ++ ["avalanche"]}
    else if place == 10 && notElem "coat" f then do
        liftIO $ putStrLn "it is very cold and you get hypothermia"
        put $ game {scene = newPlace, flags = f ++["cold"]}
    else do
        liftIO $ putStrLn "You have travelled west"
        put $ game { scene = newPlace }
actionGo _ _ = do
    game <- get
    liftIO invalidAction
    put game



{-

actionUse :: String -> GameState GameState ()

actionOpen :: String -> GameState GameState () --extra for later
-}

containsValue :: (Eq v) => v -> [v] -> Bool
containsValue _ [] = False
containsValue x (y:ys)
    | x == y = True
    | otherwise = containsValue x ys

--print scene description or inventory
actionShow :: String -> AllScenes -> StateT GameState IO ()
actionShow input as = do
    game <- get
    if input == "inventory" then liftIO $ print (inventory game)
    else if input == "scene" then liftIO $ print (fst (as!!scene game))
    else liftIO invalidAction

--add to Inventory
actionTake :: String -> AllScenes -> StateT GameState IO ()
actionTake input s = do
    game <- get
    let currentInventory = inventory game
    let newInventory = currentInventory ++ [input]
    let duplicateBool = containsValue input currentInventory
    let roomInventory = snd (s!!scene game)
    let validTake = containsValue input roomInventory
    if duplicateBool then liftIO invalidAction
    else if not validTake then liftIO invalidAction
    --else if not in room's inventory then liftIO invalidAction
    else put $ game {inventory = newInventory}

checkUse :: String -> [String] -> [String]
checkUse item inv = do
    if containsValue item inv then delete item inv
    else inv

flagUse :: String -> [String] -> [String]
flagUse item flags = do
    if item == "knife" then flags ++ ["Oh no they did the thing they shouldn't have"]
    else flags

actionUse :: String -> StateT GameState IO ()
actionUse input = do
    game <- get
    let initialInv = inventory game
    let initialFlags = flags game
    let newInv = checkUse input initialInv
    let newFlags = flagUse input initialFlags
    if initialInv == newInv then do
        liftIO $ putStrLn "You do not have that item in your inventory"
    else do
        liftIO $ putStrLn ("you have successfully used " ++ input)
        put $ game {inventory = newInv, flags = newFlags}