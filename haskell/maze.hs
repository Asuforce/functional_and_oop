import Data.Time

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
canMove mz (x, y)
  | mz !! y !! x == '*' = False
  | otherwise           = True

nextSteps :: [String] -> Pos -> [Pos]
nextSteps mz (x, y) = filter (canMove mz) [(x-1, y), (x+1, y), (x, y-1), (x, y+1)]

getPath :: [String] -> Pos -> [Path] -> Path
getPath _ _ [] = fail "no Path"
getPath mz p1 ap@(path:queue)
  | p0 == p1 = reverse path
  | otherwise = getPath mz p1 $ queue ++ [ x : path | x <- nextSteps mz p0, not $ or $ map (x `elem`) ap]
  where
    p0 = head path

buildY :: [String] -> [Int] -> [Int] -> String
buildY _ _ [] = []
buildY mz x (y:ys) = buildX mz x y ++ buildY mz x ys

buildX :: [String] -> [Int] -> Int -> String
buildX _ [] _ = []
buildX mz (x:xs) y = getMap mz (x, y) : buildX mz xs y
  where
    getMap :: [String] -> Pos -> Char
    getMap mz (x, y)
      | x == w = '\n'
      | mz !! y !! x == '*' = '*'
      | mz !! y !! x == 'S' = 'S'
      | mz !! y !! x == 'G' = 'G'
      | (x, y) `elem` path = '@'
      | otherwise = ' '
      where
        w = length $ head mz
        start = findPos mz 'S'
        goal  = findPos mz 'G'
        path  = getPath mz goal [ x : [start] | x <- nextSteps mz start]

main = do
  x <- getCurrentTime
  mazeTxt <- readFile "maze.txt"
  let maze = lines mazeTxt
      h = length maze
      w = length $ head maze
      result = buildY maze [0..w] [0..h-1]
  putStrLn result
  y <- getCurrentTime
  print $ diffUTCTime y x
