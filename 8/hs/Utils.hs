module Utils where
  -- Cast String to Int
  to_int = read :: String -> Int

  -- Same as the `map` function, but provides the index
  map_idx :: (a -> Int -> b) -> [a] -> [b]
  map_idx f a = mi a 0
    where
      mi [] i = []
      mi (a:a') i = (f a i):(mi a' (i+1))