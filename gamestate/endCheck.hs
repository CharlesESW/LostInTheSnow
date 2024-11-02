

containsValue :: (Eq v) => v -> [v] -> Bool
containsValue _ [] = False
containsValue x (y:ys)
| x == y = True
| otherwise = containsValue x ys

isEndRoom :: State GameState Bool
isEndRoom = do
    gameState <- get
    let 


gameOver :: State GameState Bool
gameOver = do
    gameState <- get
    let flagDeath = flags gameState
    let moralFlag = containsValue "bunny" flagDeath
    let endRoom = 