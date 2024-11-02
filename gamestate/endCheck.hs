--module??
--import??

containsValue :: (Eq v) => v -> [v] -> Bool
containsValue _ [] = False
containsValue x (y:ys)
| x == y = True
| otherwise = containsValue x ys

isEndRoom :: State GameState Bool
isEndRoom = do
    gameState <- get
    let 

--game over if reach end and moralFlag has gone off
    moralGameOver :: State GameState Bool
    moralGameOver = do
        gameState <- get
        let flagDeath = flags gameState
        return $ containsValue "bunny" flagDeath


--game over if flags set off
flagGameOver :: State GameState Bool
gameOver = do
    gameState <- get
    let flagDeath = flags gameState
    return $ length flagDeath >=3
    