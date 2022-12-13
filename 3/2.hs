import System.IO
import Data.List.Split
import Funcs

-- Split a list into groups
split_groups :: Int -> [a] -> [[a]]
split_groups _ [] = []
split_groups n lst = (take n lst):(split_groups n (drop n lst))

main = do
  h <- openFile "input.txt" ReadMode
  contents <- hGetContents h
  let
    dups =
      map (\[a,b,c] -> head $ rem_dups $ intersect c $ intersect a b) $ -- Get letters occuring in both lists. head of string returns char.
      map (\t -> map (\s -> tail $ splitOn "" s) t) $ -- Split text into lists, remove first element ("")
      split_groups 3 $ -- Split into groups of 3
      lines contents -- Get lines (rounds)
    vals = map (get_val.head) dups -- Get value of each duplicate
  print $ sum vals
  hClose h