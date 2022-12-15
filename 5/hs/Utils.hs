module Utils where
  -- Convert String to Int
  to_int = read :: String -> Int

  -- Return list of all itrms which satidfy the indexed predicate
  filter_idx :: (Int -> Bool) -> [a] -> [a]
  filter_idx p lst = func p lst 0
    where
      func _ [] _ = []
      func p (x:xs) i = if p i then x:rest else rest
        where rest = func p xs (i+1)