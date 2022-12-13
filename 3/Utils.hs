module Utils where
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