module GameState where

import           Control.Monad.State

{- State Monad reference

get :: State s s
put :: s -> State s ()
runState :: State s a -> s -> (a, s)

-}
data GameState = GameState 
    { scene :: SceneIndex
    , flags :: Flags
    , inventory :: Inventory 
    }

data Inventory = Inventory [String] deriving (Show, Eq)
type SceneIndex = Int
data Flags = Flags [String] deriving (Show, Eq)