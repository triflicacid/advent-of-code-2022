module Utils where

import Data.Char (isDigit)

-- Map, but pass an index
mapIdx :: (a -> Int -> b) -> [a] -> [b]
mapIdx f lst = mp lst 0
  where
    mp [] _ = []
    mp (x : xs) n = f x n : mp xs (n + 1)

-- Parse to an integer
toInt :: String -> Int
toInt = read

-- Extract sub-array of an array, where <a> is the starting index, <b> is the ending index (exclusive)
substr :: [a] -> Int -> Int -> [a]
substr str a b = take (b - a) $ drop a str

-- Match brackets.
matchBrackets :: String -> Int
matchBrackets str = fst (f str 0 0)
  where
    f :: String -> Int -> Int -> (Int, Int)
    f [] i o = (-1, o)
    f (c : cs) i open = if open' <= 0 then (i, 0) else f cs (i + 1) open'
      where
        open'
          | c == '[' = open + 1
          | c == ']' = open - 1
          | otherwise = open

-- Match a number (integer). Return index after last number.
matchNum :: String -> Int
matchNum str = f str 0
  where
    f :: String -> Int -> Int
    f [] i = i
    f (c : cs) i = if isDigit c then f cs (i + 1) else i

-- Split a string ofa list into an actual list
split :: String -> [String]
split str = f (tail str) []
  where
    f :: String -> [String] -> [String]
    f [']'] l = l
    f str list = f str' list'
      where
        numEnd = matchNum str
        listEnd = matchBrackets str
        str'
          | head str == ',' = tail str
          | isDigit (head str) = drop numEnd str
          | head str == '[' = drop (listEnd + 1) str
          | otherwise = str

        list'
          | isDigit (head str) = list ++ [substr str 0 numEnd]
          | head str == '[' = list ++ [substr str 0 (listEnd + 1)]
          | otherwise = list

-- Given two strings, return if they are in the correct order. -1 -> no, 0 -> equal, 1 -> yes
compare :: String -> String -> Int
compare lhs rhs = if iln && irn then (if ln == rn then 0 else if ln < rn then 1 else -1) else cmpList (split lhs') (split rhs')
  where
    iln = isDigit (head lhs)
    ln = toInt lhs
    irn = isDigit (head rhs)
    rn = toInt rhs
    rhs' = if irn && head lhs == '[' then "[" ++ rhs ++ "]" else rhs
    lhs' = if iln && head rhs == '[' then "[" ++ lhs ++ "]" else lhs

cmpList :: [String] -> [String] -> Int
cmpList [] [] = 0
cmpList [] _ = 1
cmpList _ [] = -1
cmpList (l : ls) (r : rs) = if cmp == 0 then cmpList ls rs else cmp
  where
    cmp = Utils.compare l r

-- Given an array, sort it using a comparator function, returning if a > b (if a should be sorted after b).
sort :: (a -> a -> Bool) -> [a] -> [a]
sort cmp list = srt cmp list []
  where
    srt cmp [] done = done
    srt cmp (x : xs) done = srt cmp xs (iter done 0)
      where
        -- Loop and insert `x` into `lst` in the correct position
        iter lst i
          | i < length lst = if lst !! i `cmp` x then take i lst ++ [x] ++ drop i lst else iter lst (i + 1)
          | otherwise = lst ++ [x]
