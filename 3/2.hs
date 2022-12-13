import System.IO
import Data.List.Split
import Data.Char (ord)

-- Get the intersection between two lists
intersect :: (Eq a) => [a] -> [a] -> [a]
intersect [] = (\_ -> [])
intersect a = filter (`elem` a)

-- Function to remove duplicates
rem_dups :: (Eq a) => [a] -> [a]
rem_dups [] = []
rem_dups (x:xs) = x:(rem_dups $ filter ((/=) x) xs)

-- Get ordinal value of a character item
get_val :: Char -> Int
get_val c = a - (if a <= 90 then 64 - 26 else 96)
  where a = ord c

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