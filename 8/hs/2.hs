import System.IO
import Data.List.Split
import Utils

-- Return a list of every tree upwards that is less than `n`
get_up :: [[Int]] -> Int -> Int -> Int -> [Int]
get_up trs n x y
  | y < 0     = []
  | n <= cur  = [cur]
  | otherwise = cur:(get_up trs n x (y-1))
    where cur = (trs!!y)!!x -- Height of current tree

-- Return a list of every tree downwards that is less than `n`
get_dn :: [[Int]] -> Int -> Int -> Int -> [Int]
get_dn trs n x y
  | y >= length trs = []
  | n <= cur        = [cur]
  | otherwise       = cur:(get_dn trs n x (y+1))
    where cur = (trs!!y)!!x -- Height of current tree

-- Return a list of every tree leftwards that is less than `n`
get_lt :: [[Int]] -> Int -> Int -> Int -> [Int]
get_lt trs n x y
  | x < 0     = []
  | n <= cur  = [cur]
  | otherwise = cur:(get_lt trs n (x-1) y)
    where cur = (trs!!y)!!x -- Height of current tree

-- Return a list of every tree rightwards that is less than `n`
get_rt :: [[Int]] -> Int -> Int -> Int -> [Int]
get_rt trs n x y
  | x >= length (trs!!0) = []
  | n <= cur             = [cur]
  | otherwise            = cur:(get_rt trs n (x+1) y)
    where cur = (trs!!y)!!x -- Height of current tree

-- Calculate scenic score for a tree
scenic_score :: [[Int]] -> Int -> Int -> Int
scenic_score trs x y =
  (length $ get_up trs n x (y-1)) *
  (length $ get_dn trs n x (y+1)) *
  (length $ get_lt trs n (x-1) y) *
  (length $ get_rt trs n (x+1) y)
    where n = (trs!!y)!!x

main = do
  h <- openFile "../input.txt" ReadMode
  contents <- hGetContents h
  let
    trees = (map.map) (to_int.(:[])) $ lines contents
    scores = map_idx (\rw y -> map_idx (\n x -> scenic_score trees x y) rw) trees
    max_score = maximum $ map maximum scores
  print max_score
  hClose h