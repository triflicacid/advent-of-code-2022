module Utils where
  import Data.List

  -- Convert String to Int
  to_int = read :: String -> Int

  -- Duplicate a string n times
  dup_str :: String -> Int -> String
  dup_str str n
    | n == 0    = ""
    | n == 1    = str
    | otherwise = str ++ (dup_str str (n-1))

  -- Set item at a specific index
  list_set :: Int -> a -> [a] -> [a]
  list_set 0 e (_:lst) = e:lst
  list_set i e [] = [e]
  list_set i e (h:lst) = h:(list_set (i-1) e lst)

  -- Get smallest item in a list, according to the transformation predicate
  get_min :: (a -> Int) -> [a] -> a
  get_min f lst = gm f lst 0 0 h (f h)
    where
      h = head lst
      gm :: (a -> Int) -> [a] -> Int -> Int -> a -> Int -> a
      gm f [] i si s sv = s
      gm f (x:xs) i si s sv = gm f xs (i+1) si' s' sv'
        where
          fx = f x
          lt = fx < sv -- Is this value better?
          si' = if lt then i else si
          s'  = if lt then x else s
          sv' = if lt then fx else sv

  -- Add slash to end of string
  add_slash :: String -> String
  add_slash str = if last str == '/' then str else str ++ "/"