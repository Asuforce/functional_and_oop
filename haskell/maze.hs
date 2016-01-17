type Pos = (Int,Int)
type Path = [Pos]

findPos :: [String] -> Char -> Pos
findPos mz c =
  let y = findY mz c 0
      x = findX (mz!!y) c 0
  in (x,y)
  where
    findY :: [String] -> Char -> Int -> Int
    findY [] _ _ = error $ c : " not found\n"
    findY (x:xs) c n
      | c `elem` x = n
      | otherwise  = findY xs c (n+1)
    findX :: String -> Char -> Int -> Int
    findX (x:xs) c n
      | x == c     = n
      | otherwise  = findX xs c (n+1)

canMove :: [String] -> Pos -> Bool
canMove mz (x,y)
  | mz !! y !! x == '*' = False
  | otherwise           = True

nextSteps :: [String] -> Pos -> [Pos]
nextSteps mz (x,y) = filter (canMove mz) [(x-1,y), (x+1,y), (x,y-1), (x,y+1)]

getPath :: [String] -> Pos -> [Path] -> Path
getPath _ _ [] = fail "no Path"
getPath mz p1 ap@(path:queue)
  | p0 == p1 = reverse path
  | otherwise = getPath mz p1 $ queue ++ [ x : path | x <- nextSteps mz p0, not $ or $ map (x `elem`) ap]
  where
    p0 = head path

buildY :: [String] -> Path -> [Int] -> [Int] -> String
buildY _ _ _ [] = []
buildY mz pt x (y:ys) = buildX mz pt x y ++ buildY mz pt x ys

buildX :: [String] -> Path -> [Int] -> Int -> String
buildX _ _ [] _ = []
buildX mz pt (x:xs) y = getMap mz pt (x, y) : buildX mz pt xs y
  where
    getMap :: [String] -> Path -> Pos -> Char
    getMap mz pt (x, y)
      | x == w = '\n'
      | mz !! y !! x == '*' = '*'
      | mz !! y !! x == 'S' = 'S'
      | mz !! y !! x == 'G' = 'G'
      | (x, y) `elem` pt = '@'
      | otherwise = ' '
      where
        w = length $ head mz

main = do
  mazeTxt <- readFile "maze.txt"
  let maze = lines mazeTxt
      h = length maze
      w = length $ head maze
      start = findPos maze 'S'
      goal  = findPos maze 'G'
      path  = getPath maze goal [ x : [start] | x <- nextSteps maze start]
      result = buildY maze path [0..w] [0..h-1]
  putStrLn result
