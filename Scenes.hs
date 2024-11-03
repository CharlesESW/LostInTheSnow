module Scenes where
import Gamestate.GameState
import Control.Monad.State

--ToDo individual Scenes with items to pick up or use
{-
NEED

Scene Description
Inventory for the room to compare against user input
List of Scenes

--if you fall into a 'hole' you add a flag to the list and have to go back up the way you came (Scene will trigger the flag not the moving)
-}
type Description = String
type Inventory = [String]

type Scene = (Description, Inventory)

type AllScenes = [Scene]

getMap :: [(String, [String])]
getMap = [("first", ["things"]), 
    ("second",[]), 
    ("third",[]), 
    ("fourth",[]), 
    ("fifth",[]), 
    ("sixth",[]), 
    ("seventh",[]), 
    ("eigth",[]), 
    ("ninth",[]), 
    ("tenth",[]), 
    ("eleventh",[]), 
    ("twelve",[]), 
    ("thirteenth",[]), 
    ("fourteenth",[]), 
    ("fifteenth",[]), 
    ("sixteenth",[]), 
    ("winner",[])]