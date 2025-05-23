{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Redundant if" #-}
module Actions where

import GameState.GameState
import Scenes
import Control.Monad.State
import Data.List
import System.Process

actionHelp :: IO ()
actionHelp = putStrLn "--help \n\nthe aim of the game is to escape from the mountain you have found yourself upon\nthis game operates entirely in lapslock, using uppercase will not work \nthe commands are `go [nesw]`, `show [inventory/scene]`, `take [item]` and `use [item]`\n\nplease use your best survival skills to avoid flags and save yourself - remember actions do have consequences!"

invalidAction :: IO()
invalidAction = putStrLn "please input a valid command."

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

almostDead :: [String] -> Bool
almostDead f = do
    if "coat" `elem` f then
        if "bunny" `elem` f then length f >= 4
        else length f >= 3
    else if "bunny" `elem` f then length f >= 3
    else length f >=2


actionGo :: String -> AllScenes -> StateT GameState IO ()
actionGo "north" scenes = do
    game <- get
    let place = scene game
    let newPlace = goingNorth place scenes
    let f = flags game
    if place == 5 then do
        liftIO $ putStrLn "a yeti has killed you; oh dear, didn't you know that you're a guest in their house? watch where you step!"
        put $ game {scene = newPlace, flags = ["1", "2", "3"]}
    else if place == 8 then do
        liftIO $ putStrLn "a freak weather system passed over and you have been struck by lightning; what a way to go!"
        put $ game {scene = newPlace, flags = ["1", "2", "3"]}
    else if place == 11 then do
        liftIO $ putStrLn "awareness is key! rockfall has now stranded you, slowly starving you to death."
        put $ game {scene = newPlace, flags = ["1", "2", "3"]}
    else if place == 10 then do
        if almostDead f then do
            liftIO $ putStrLn "you fell into a pit, however the combination of previous mistakes meant you couldn't survive this one."
            put $ game {scene = place, flags = f ++ ["fellinpit"]}
        else do
            liftIO $ putStrLn "you fell into a pit, but managed to get back out to where you were before and only took a little damage."
            put $ game {scene = place, flags = f ++ ["fellinpit"]}
    else if place == 13 then
        if "coat" `elem` f then do
            liftIO $ system "cls"
            liftIO $ putStrLn "it is very cold but luckily you wore your trusty coat and were ok"
            put $ game {scene = newPlace}
        else do
            if almostDead f then do
                liftIO $ putStrLn "it is very cold so you get hypothermia, combined with your previous blunders, you can't survive any longer."
                put $ game {scene = place, flags = f ++ ["cold"]}
            else do
                liftIO $ system "cls"
                liftIO $ putStrLn "it is very cold so you get hypothermia, were you not warned?"
                put $ game {scene = newPlace, flags = f ++["cold"]}
    else if place == newPlace then do
        liftIO $ putStrLn "you cannot follow this path."
        put $ game {scene = newPlace}
    else do
        liftIO $ system "cls"
        liftIO $ putStrLn "traversed north..."
        put $ game { scene = newPlace }
actionGo "south" scenes = do
    game <- get
    let place = scene game
    let f = flags game
    let newPlace = goingSouth place scenes
    if place == 1 then do
        liftIO $ putStrLn "a yeti has killed you; oh dear, didn't you know that you're a guest in their house? watch where you step!"
        put $ game {scene = newPlace, flags = ["1", "2", "3"]}
    else if place == 4 then do
        liftIO $ putStrLn "a freak weather system passed over and you have been struck by lightning; what a way to go!"
        put $ game {scene = newPlace, flags = ["1", "2", "3"]}
    else if place == 7 then do
        liftIO $ putStrLn "awareness is key! rockfall has now stranded you, slowly starving you to death."
        put $ game {scene = newPlace, flags = ["1", "2", "3"]}
    else if place == 2 then
        if almostDead f then do
            liftIO $ putStrLn "you fell into a pit, however the combination of previous mistakes meant you couldn't survive this one."
            put $ game {scene = place, flags = f ++ ["fellinpit"]}
        else do
            liftIO $ putStrLn "you fell into a pit, but managed to get back out to where you were before and only took a little damage."
            put $ game {scene = place, flags = f ++ ["fellinpit"]}
    else if place == 8 then do
        if almostDead f then do
            liftIO $ putStrLn "An avalanche came but all your previous mistakes meant you didn't have the energy to escape it."
            put $ game {scene = place, flags = f ++ ["avalanche"]}
        else do
            liftIO $ putStrLn "near miss! you almost got caught in an avalanche, winding you. you managed to get back to where you were before but the dangers of the mountains must be making you anxious."
            put $ game {scene = place, flags = f ++ ["avalanche"]}
    else if place == 5 then
        if "coat" `elem` f then do
            liftIO $ system "cls"
            liftIO $ putStrLn "it is very cold but luckily you wore your trusty coat and were ok"
            put $ game {scene = newPlace}
        else do
            if almostDead f then do
                liftIO $ putStrLn "it is very cold so you get hypothermia, combined with your previous blunders, you can't survive any longer."
                put $ game {scene = place, flags = f ++ ["cold"]}
            else do
                liftIO $ system "cls"
                liftIO $ putStrLn "it is very cold so you get hypothermia, were you not warned?"
                put $ game {scene = newPlace, flags = f ++["cold"]}
    else if place == 11 then do
        liftIO $ system "cls"
        liftIO $ putStrLn "illness has befallen you; you may not last very long.."
        put $ game {scene = newPlace, flags = f ++ ["illness"]}
    else if place == newPlace then do
        liftIO $ putStrLn "you cannot follow this path."
        put $ game {scene = newPlace}
    else do
        liftIO $ system "cls"
        liftIO $ putStrLn "traversed south..."
        put $ game { scene = newPlace }
actionGo "east" scenes = do
    game <- get
    let place = scene game
    let newPlace = goingEast place scenes
    let f = flags game
    if place == 10 then do
        liftIO $ putStrLn "awareness is key! rockfall has now stranded you, slowly starving you to death."
        put $ game {scene = newPlace, flags = ["1", "2", "3"]}
    else if place == 5 then do
        if almostDead f then do
            liftIO $ putStrLn "you fell into a pit, however the combination of previous mistakes meant you couldn't survive this one."
            put $ game {scene = place, flags = f ++ ["fellinpit"]}
        else do
            liftIO $ putStrLn "you fell into a pit, but managed to get back out to where you were before and only took a little damage."
            put $ game {scene = place, flags = f ++ ["fellinpit"]}
    else if place == 14 then do
        liftIO $ system "cls"
        liftIO $ putStrLn "illness has befallen you; you may not last very long.."
        put $ game {scene = newPlace, flags = f ++ ["sickness"]}
    else if place == 8 then
        if "coat" `elem` f then do
            liftIO $ system "cls"
            liftIO $ putStrLn "it is very cold but luckily you wore your trusty coat and were ok"
            put $ game {scene = newPlace}
        else do
            if almostDead f then do
                liftIO $ putStrLn "it is very cold so you get hypothermia, combined with your previous blunders, you can't survive any longer."
                put $ game {scene = place, flags = f ++ ["cold"]}
            else do
                liftIO $ system "cls"
                liftIO $ putStrLn "it is very cold so you get hypothermia, were you not warned?"
                put $ game {scene = newPlace, flags = f ++["cold"]}
    else if place == newPlace then do
        liftIO $ putStrLn "you cannot follow this path."
        put $ game {scene = newPlace}
    else do
        liftIO $ system "cls"
        liftIO $ putStrLn "traversed east..."
        put $ game { scene = newPlace }
actionGo "west" scenes = do
    game <- get
    let place = scene game
    let newPlace = goingWest place scenes
    let f = flags game
    if place == 11 then do
        liftIO $ putStrLn "awareness is key! rockfall has now stranded you, slowly starving you to death."
        put $ game {scene = newPlace, flags = ["1", "2", "3"]}
    else if place == 7 then do
        if almostDead f then do
            liftIO $ putStrLn "you fell into a pit, however the combination of previous mistakes meant you couldn't survive this one."
            put $ game {scene = place, flags = f ++ ["fellinpit"]}
        else do
            liftIO $ putStrLn "you fell into a pit, but managed to get back out to where you were before and only took a little damage."
            put $ game {scene = place, flags = f ++ ["fellinpit"]}
    else if place == 13 then do
        if almostDead f then do
            liftIO $ putStrLn "An avalanche came but all your previous mistakes meant you didn't have the energy to escape it."
            put $ game {scene = place, flags = f ++ ["avalanche"]}
        else do
            liftIO $ putStrLn "near miss! you almost got caught in an avalanche, winding you. you managed to get back to where you were before but the dangers of the mountains must be making you anxious."
            put $ game {scene = place, flags = f ++ ["avalanche"]}
    else if place == 10 then
        if "coat" `elem` f then do
            liftIO $ system "cls"
            liftIO $ putStrLn "it is very cold but luckily you wore your trusty coat and were ok"
            put $ game {scene = newPlace}
        else do
            if almostDead f then do
                liftIO $ putStrLn "it is very cold so you get hypothermia, combined with your previous blunders, you can't survive any longer."
                put $ game {scene = place, flags = f ++ ["cold"]}
            else do
                liftIO $ system "cls"
                liftIO $ putStrLn "it is very cold so you get hypothermia, were you not warned?"
                put $ game {scene = newPlace, flags = f ++["cold"]}
    else if place == newPlace then do
        liftIO $ putStrLn "you cannot follow this path."
        put $ game {scene = newPlace}
    else do
        liftIO $ system "cls"
        liftIO $ putStrLn "traversed west..."
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
    else if input == "scene" then liftIO $ putStrLn (fst (as!!scene game))
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
    else if length currentInventory ==2 then liftIO $ putStrLn "inventory is full" --inventory is full
    else if input == "letter" && elem "set" currentInventory then liftIO invalidAction
    else if input == "set" && elem "letter" currentInventory then liftIO invalidAction
    else do
        liftIO $ putStrLn ("you have successfully taken " ++ input)
        put $ game {inventory = newInventory}

checkUse :: String -> [String] -> [String]
checkUse item inv = do
    if containsValue item inv then delete item inv
    else inv

putUse :: String -> [String] -> [String]
putUse item flags = flags ++ [item]

flagUse :: String -> [String] -> [String]
flagUse item flags = do
    --if user is 'cold' and uses 'matches' then remove 'cold' flag
    if item == "matches" then checkUse "cold" flags
    else if item == "jerky" then checkUse "sickness" flags
    else if item == "letter" then checkUse "bunny" flags
    else if item == "coat" then putUse "coat" flags
    else flags

actionUse :: String -> StateT GameState IO ()
actionUse input = do
    game <- get
    let initialInv = inventory game
    let initialFlags = flags game
    let newInv = checkUse input initialInv
    let newFlags = flagUse input initialFlags
    if initialInv == newInv then do
        liftIO $ putStrLn "you do not have that item in your inventory"
    else if input == "letter" then do
        liftIO $ putStrLn "you open a heartfelt letter addressed to who you now remember is your best friends' son. he expresses his love and sorrow that he may not return home, he fears that a member of his team is after his life. you are glad to have retrieved the letter."
        put $ game {inventory = newInv, flags = newFlags}    else if input == "camera" then do
        liftIO $ putStrLn "the camera shows you pictures of you and another in the mountains. you both look happy. looking at these is making your head hurt, it's time to put it down."
        put $ game {inventory = newInv, flags = newFlags}
    else if input == "matches" && "cold" `elem` initialFlags then do
        liftIO $ putStrLn "you have used the matches to warm yourself up, hypothermia has receeded."
        put $ game {inventory = newInv, flags = newFlags}
    else if input == "jerky" && "sickness" `elem` initialFlags then do
        liftIO $ putStrLn "you have used the jerky to cure your sickness, you feel much better"
        put $ game {inventory = newInv, flags = newFlags}
    else if input == "coin" || input == "ski" || input == "rope" || input == "ring" || input == "torch" || input == "flare" then do
        liftIO $ putStrLn "this item is unusable"
        put game
    else do
        liftIO $ putStrLn ("you have used " ++ input)
        put $ game {inventory = newInv, flags = newFlags}
