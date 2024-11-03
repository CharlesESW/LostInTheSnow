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


--Scene flags will only affect the scene whilst in it, will reset upon departure
type Scene = (Description, Inventory)

type AllScenes = [Scene]
--TODO add narrative clues to MCs amnesia
getMap :: [(String, [String])]
getMap = [("You open your eyes to a cold white landscape, lying down with a small knife beside you. All around you there are snowy mountains, and in your small clearing you find a mysteriously desolate campsite. Beside you lies an envelope addressed to a 'Steven'. There is also a hat and gloves set, but unfortunately you may only pick one.", ["letter", "set"]), 
    ("The climb up the least harrowing slope is still quite treacherous, but you make it over the hill. Winds are picking up and all you can see is white. All white except from a slight glimmer on the ground - it's a coin!",["coin"]), 
    ("Winding carefully through a rocky path gets you to an alcove. It looks like you're not the first person here, perhaps there will be some clues on why you're here. There is a single ski. There is a fraying rope.",["ski", "rope"]), 
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
    --- TODO: if you take the letter then secrets are revealed, else your friend has gone mad and is hunting you down to kill you.