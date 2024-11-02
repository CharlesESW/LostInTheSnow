module Gamestate.GameState where

{-

 State Monad reference

get :: State s s
put :: s -> State s ()
runState :: State s a -> s -> (a, s)


-}

data GameState = GameState 
    { scene :: SceneIndex
    , flags :: Flags
    , inventory :: Inventory
    }

newtype Inventory = Inventory [String] deriving (Show, Eq)
type SceneIndex = Int
newtype Flags = Flags [String] deriving (Show, Eq)