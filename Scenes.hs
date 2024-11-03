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


--Scene flags will only affect the scene whilst in it, will reset upon departure
type Scene = (Description, Inventory)

type AllScenes = [Scene]