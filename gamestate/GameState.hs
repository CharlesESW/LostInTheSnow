module Gamestate.GameState where

{-

 State Monad reference

get :: State s s
put :: s -> State s ()
runState :: State s a -> s -> (a, s)


-}

data GameState = GameState 
    { scene :: Int
    , flags :: [String]
    , inventory :: [String]
    }

    --EXTRA: Useless items that fill up limited inventory space - Resource managememt