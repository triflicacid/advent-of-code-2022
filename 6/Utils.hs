module Utils where
  -- Extract substring of a string
  substr :: String -> Int -> Int -> String
  substr str a b = take (b-a) $ drop a str

  -- Remove duplicates
  rem_dups :: (Eq a) => [a] -> [a]
  rem_dups [] = []
  rem_dups (x:xs) = if elem x xs then rem_dups xs else x:(rem_dups xs)

  find_unique :: String -> Int -> Int
  find_unique str n = f str n 0
    where
      f str 0 i = 0
      f [] n i = 0
      f str n i = if (length $ rem_dups $ substr str i (i+n)) == n then n+i else f str n (i+1)