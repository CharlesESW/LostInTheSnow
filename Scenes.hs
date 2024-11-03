module Scenes where
import Gamestate.GameState
import Control.Monad.State


{-
NEED

Scene Description
Inventory for the room to compare against user input
List of Scenes

-}
type Description = String
type Inventory = [String]


--EXTRA Scene flags will only affect the scene whilst in it, will reset upon departure
type Scene = (Description, Inventory)

type AllScenes = [Scene]

getMap :: [(String, [String])]
getMap = [("you open your eyes to a cold white landscape, lying down with a hat and gloves set [set] beside you. all around there are snowy mountains, and in your small clearing is a mysteriously desolate campsite. looking around, you spot an envelope addressed to 'My Son'. strangely you can only pick up one thing.", ["letter", "set"]), 
    ("the climb up the least harrowing slope is still quite treacherous, but you make it over the hill. winds are picking up and all you can see is white. all white except from a slight glimmer on the ground - it's a coin!",["coin"]), 
    ("winding carefully through a rocky path gets you to an alcove. it looks like you're not the first person here, perhaps there will be some clues on why you're here. there is a single ski. there is a fraying rope.",["ski", "rope"]), 
    ("",["Coat"]), 
    ("fifth",[]), 
    ("sixth",[]), 
    ("NULL",[]), 
    ("eigth",[]), 
    ("ninth",["Matches"]), 
    ("tenth",[]), 
    ("eleventh",["Jerky"]), 
    ("twelve",[]), 
    ("NULL",[]), 
    ("fourteenth",[]), 
    ("fifteenth",[]), 
    ("sixteenth",[]), 
    ("Leaving the mountain must be such a relief, congratulations on your survival thusfar. Unfortunately it is still unknown how you even ended up here; and just what did happen to your friend...",[])]