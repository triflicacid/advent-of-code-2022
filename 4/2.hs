import System.IO
import Data.List.Split

to_int = read :: String -> Int

main = do
  h <- openFile "input.txt" ReadMode
  contents <- hGetContents h
  let
    pairs =
      map (\ln ->
        (map.map) to_int $ -- Convert bounds to integers
        map (splitOn "-") $ -- Get lower and upper bound of each pair
        splitOn "," ln) $ -- Get each pair
      lines contents -- Get lines (rounds)
    overlp = filter (\[[a,b],[x,y]] -> (a <= x && b >= y) || (a >= x && b <= y) || (a <= y && x <= b)) pairs
  print (length overlp)
  hClose h