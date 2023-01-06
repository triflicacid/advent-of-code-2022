import Data.List.Split (splitOn)
import System.IO
import Utils (compare, mapIdx)

main = do
  h <- openFile "../input.txt" ReadMode
  contents <- hGetContents h
  let pairs = mapIdx (\x i -> (i + 1, x)) $ map lines $ splitOn "\n\n" contents
      right = filter (\(i, [a, b]) -> Utils.compare a b == 1) pairs
      total = sum (map fst right)
  print ("Sum of indices of correct pairs: " ++ show total)
  hClose h