import System.IO
import Data.List.Split
import Utils

-- Check that every tree at this position and above is smaller than `n`
all_up :: [[Int]] -> Int -> Int -> Int -> Bool
all_up trs n x y = (y < 0) || ((n > (trs!!y)!!x) && (all_up trs n x (y - 1)));

-- Check that every tree at this position and below is smaller than `n`
all_dn :: [[Int]] -> Int -> Int -> Int -> Bool
all_dn trs n x y = (y >= length trs) || ((n > (trs!!y)!!x) && (all_dn trs n x (y + 1)));

-- Check that every tree at and left of this position is smaller than `n`
all_lt :: [[Int]] -> Int -> Int -> Int -> Bool
all_lt trs n x y = (x < 0) || ((n > (trs!!y)!!x) && (all_lt trs n (x - 1) y));

-- Check that every tree at and right of this position is smaller than `n`
all_rt :: [[Int]] -> Int -> Int -> Int -> Bool
all_rt trs n x y = (x >= length (trs!!y)) || ((n > (trs!!y)!!x) && (all_rt trs n (x + 1) y));

main = do
  h <- openFile "../input.txt" ReadMode
  contents <- hGetContents h
  let
    trees = (map.map) (to_int.(:[])) $ lines contents
    visible = map_idx (\rw y -> map_idx (\n x ->
        (all_up trees n x (y - 1)) || (all_dn trees n x (y + 1)) || (all_lt trees n (x - 1) y) || (all_rt trees n (x + 1) y)
      ) rw) trees
    count = sum $ map (length.(filter id)) visible -- Count how many visible trees there are
  print count
  hClose h