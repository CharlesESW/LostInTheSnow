module Scenes where
import Gamestate.GameState
import Control.Monad.State

--ToDo individual Scenes with items to pick up or use
{-
NEED

Scene Description
Inventory for the room to compare against user input
List of Scenes

-}
type Description = String
type Inventory = [String]

type Scene = (Description, Inventory)

type AllScenes = [Scene]