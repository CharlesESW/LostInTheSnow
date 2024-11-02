data GameState = GameState 
{ scene :: SceneIndex
, flags :: Flags
, inventory :: Inventory 
}

data Inventory = Inventory [String] deriving (Show, Eq)
type SceneIndex = Int
data Flags = Flags [String] deriving (Show, Eq)