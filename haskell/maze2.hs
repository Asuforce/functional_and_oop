import Control.Monad (guard)
import Control.Applicative ((<$>))
import Data.Array (Array, listArray, assocs, (!), elems, (//))

data Direction = E | W | S | N deriving (Show, Eq)
type Pos = (Int,Int) -- (y,x)
type Tile = Char
data MapData = MapData {mapData :: Array Pos Tile, height :: Int, width :: Int}

strToMapData :: Int -> Int -> String -> MapData
strToMapData h w input = MapData (listArray ((0,0), (h,w)) $ filter (/='\n') input) h w

printMapData :: MapData -> IO ()
printMapData (MapData m _ w) = do
  printMapData' w $ elems m
  where
    printMapData' :: Int -> String -> IO ()
    printMapData' _ "" = return ()
    printMapData' w' s = do
      putStrLn $ take w' s
      printMapData' w' $ drop w' s

startPos :: MapData -> Pos
startPos = posOf 'S'
  where
    posOf :: Tile -> MapData -> Pos
    posOf tile (MapData ar _ _) = fst $ head $ filter (\(_,t) -> t == tile) $ assocs ar

-- | 指定した位置から移動した次の位置のリストを返す (壁'*'には移動できない)
nextPoss :: MapData -> Pos -> [Pos]
nextPoss (MapData m h w) p = do
  (y',x') <- (move p) <$> [E,W,S,N]
  guard $ (y' >= 0) && (y' < h) && (x' >= 0) && (x' < w)
  guard $ (m ! (y',x')) /= '*'
  return (y',x')

-- | １マス移動する
move :: Pos -> Direction -> Pos
move (y,x) E = (y,x+1)
move (y,x) W = (y,x-1)
move (y,x) S = (y+1,x)
move (y,x) N = (y-1,x)

-- | ゴールに到達する経路をすべて返す (ただし一度通ったところは通らない)
searchRoute :: MapData -> [Pos] -> Pos -> [[Pos]]
searchRoute m tracks currentP = do
  if ((mapData m) ! currentP) == 'G'
    then return tracks
    else if currentP `elem` tracks
      then []
      else do
        nextP <- nextPoss m currentP
        searchRoute m (currentP:tracks) nextP

-- | ゴールへの最短経路を返す
shortestRoute :: MapData -> Maybe [Pos]
shortestRoute mData =
  let routes = searchRoute mData [] $ startPos mData
      minLen = minimum $ map length routes
      minRoutes = filter (\r -> length r == minLen) routes
  in if length minRoutes == 0 then Nothing else Just $ head minRoutes

-- | マップに経路を重ねる
mergeRoute :: MapData -> [Pos] -> MapData
mergeRoute (MapData m h w) route = MapData (m // init (map (\p -> (p,'$')) $ route)) (h+1) (w+1)

main = do
  c <- readFile "maze.txt"
  let h = length $ lines c
      w = length $ head $ lines c
      mData = strToMapData (h-1) (w-1) c
  case shortestRoute mData of
    Just route -> printMapData $ mergeRoute mData $ route
    Nothing -> error "There is no route."
