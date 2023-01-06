import Data.List (elemIndex)
import Data.Maybe (fromJust)
import System.IO
import Utils (compare, sort)

main = do
  h <- openFile "../input.txt" ReadMode
  contents <- hGetContents h
  let all = filter (not . null) $ lines contents
      markers = ["[[2]]", "[[6]]"]
      all' = all ++ markers
      ordered = sort (\a b -> Utils.compare a b == -1) all' -- Order - smallest first, largest last
      indices = map ((+ 1) . fromJust . (`elemIndex` ordered)) markers -- Get index of markers in sorted list (1-index based)
      key = product indices
  print ("Decoder Key: " ++ show key)
  hClose h