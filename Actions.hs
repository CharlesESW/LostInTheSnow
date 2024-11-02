{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Redundant if" #-}
module Actions where

import Gamestate.GameState
import Scenes
import Control.Monad.State

-- TODO: Change Filler Text to actual help
actionHelp :: IO ()
actionHelp = putStrLn "Filler Text"

invalidAction :: IO()
invalidAction = putStrLn "Please input a valid command."

goingNorth :: Int -> AllScenes -> Int
goingNorth loc scenes = do
    if loc < 4 then loc
    else if fst(scenes!!(loc - 4)) == "NULL" then loc
    else loc - 4 

goingSouth :: Int -> AllScenes -> Int
goingSouth loc scenes = do
    if loc > 11 then loc
    else if fst(scenes!!(loc + 4)) == "NULL" then loc
    else loc + 4 

goingEast :: Int -> AllScenes -> Int
goingEast loc scenes = do
    if loc `mod` 4 == 3 then loc
    else if fst(scenes!!(loc + 1)) == "NULL" then loc
    else loc + 1

goingWest :: Int -> AllScenes -> Int
goingWest loc scenes = do
    if loc `mod` 4 == 0 then loc
    else if fst(scenes!!(loc - 1)) == "NULL" then loc
    else loc - 1 

actionGo :: String -> AllScenes -> StateT GameState IO ()
actionGo "north" scenes = do
    game <- get
    let place = scene game
    let newPlace = goingNorth place scenes
    if place == newPlace then liftIO $ putStrLn "You are not able to travel north"
    else liftIO $ putStrLn "You have travelled north"
    put $ game { scene = newPlace }
actionGo "south" scenes = do
    game <- get
    let place = scene game
    let newPlace = goingSouth place scenes
    if place == newPlace then liftIO $ putStrLn "You are not able to travel south"
    else liftIO $ putStrLn "You have travelled south"
    put $ game { scene = newPlace }
actionGo "east" scenes = do
    game <- get
    let place = scene game
    let newPlace = goingEast place scenes
    if place == newPlace then liftIO $ putStrLn "You are not able to travel east"
    else liftIO $ putStrLn "You have travelled east"
    put $ game { scene = newPlace }
actionGo "west" scenes = do
    game <- get
    let place = scene game
    let newPlace = goingWest place scenes
    if place == newPlace then liftIO $ putStrLn "you are not able to travel wast"
    else liftIO $ putStrLn "You have travelled west"
    put $ game { scene = place }
actionGo _ _ = do
    game <- get
    liftIO invalidAction
    put game



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