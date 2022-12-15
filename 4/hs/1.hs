import System.IO
import Data.List.Split

to_int = read :: String -> Int

main = do
  h <- openFile "../input.txt" ReadMode
  contents <- hGetContents h
  let
    pairs =
      map (\ln -> (map.map) to_int $ map (splitOn "-") $ splitOn "," ln) $ -- Split each line into groups, then split each group bound
      lines contents -- Get lines (rounds)
    overlp = filter (\[[a,b],[x,y]] -> (a >= x && b <= y) || (x >= a && y <= b)) pairs
  print (length overlp)
  hClose h