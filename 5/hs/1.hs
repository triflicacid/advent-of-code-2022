import System.IO
import Data.List
import Data.List.Split
import Data.Char
import Utils

exec_moves :: [[Int]] -> [[String]] -> [[String]]
exec_moves [] cs = cs
exec_moves ([0,a,b]:mvs) cs = exec_moves mvs cs
exec_moves ([n,a,b]:mvs) cs = exec_moves ([(n-1),a,b]:mvs) $ mv_a_b a b cs

-- Move top value from pile <a> onto pile <b> in the given piles
mv_a_b :: Int -> Int -> [[String]] -> [[String]]
mv_a_b a b cs = put_b b itm (h' ++ t)
  where
    (h,t) = splitAt a cs
    itm = head $ last h
    h' = (init h) ++ [tail $ last h]

-- Place item <itm> onto pile <b> in the given piles
put_b :: Int -> String -> [[String]] -> [[String]]
put_b b itm cs = (h' ++ t)
  where
    (h, t) = splitAt b cs
    h' = (init h) ++ [itm : (last h)]

main = do
  h <- openFile "../input.txt" ReadMode
  contents <- hGetContents h
  let
    sects =
      map (\a -> splitOn "\n" a) $ -- Split by each line
      splitOn "\n\n" contents -- [crates,moves]
    moves =
      filter (\ls -> length ls == 3) $ -- Remove empty moves
      map (\w -> map to_int $ filter (isDigit.head) w) $ -- Extract numeric words as integers
      map words (sects!!1) -- Split each word
    crates = -- Crate syntax: [top, top-1, ..., bottom]
      map (filter (\x -> x /= " ")) $ -- Remove empty elements
      transpose $ -- Rows -> Cols
      map (filter_idx (\i -> (i - 1) `mod` 4 == 0)) $ -- Extract indexes 1, 5, 9, ...
      map (tail.(splitOn "")) $ -- Split each character, remove first blank space
      init (sects!!0) -- Remove last row
    n_crates = exec_moves moves crates -- Apply moves to crates
    tops = intercalate "" $ map head n_crates -- Get top crate on each stack
  print tops
  hClose h