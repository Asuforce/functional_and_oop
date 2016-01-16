hogeY :: [String] -> [Int] -> [Int] -> String
hogeY _ _ [] = []
hogeY mz x (y:ys) = hoge mz x y ++ hogeY mz x ys

hoge :: [String] -> [Int] -> Int -> String
hoge _ [] _ = []
hoge mz (x:xs) y = getMap mz (x, y) : hoge mz xs y
  where
    getMap :: [String] -> (Int, Int) -> Char
    getMap mz (x, y)
      | x == w = '\n'
      | mz !! y !! x == '*' = '*'
      | mz !! y !! x == 'S' = 'S'
      | mz !! y !! x == 'G' = 'G'
      | (x, y) `elem` p = '@'
      | otherwise = ' '
      where
        w = length $ head mz
        p = [(2,2),(3,2),(3,3),(4,3),(5,3),(5,2),(6,2),(6,1),(7,1),(8,1),(9,1),(9,2),(9,3),(10,3),(10,4),(11,4),(12,4),(13,4),(14,4),(14,5),(14,6),(13,6),(12,6),(11,6),(10,6),(9,6),(8,6),(7,6),(6,6),(5,6),(4,6),(3,6),(2,6),(2,7),(2,8),(3,8),(4,8),(5,8),(6,8),(6,9),(7,9),(8,9),(9,9),(9,8),(10,8),(11,8),(12,8),(13,8),(14,8),(15,8),(16,8),(17,8),(18,8),(19,8),(20,8),(21,8),(22,8)]

main = do
  text <- readFile "maze.txt"
  let maze = lines text
      h = length maze
      w = length $ head maze
      a = hogeY maze [0..w] [0..h-1]
  putStrLn a
