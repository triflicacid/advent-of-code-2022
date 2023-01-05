import Data.List
import System.IO
import Utils

--- BUG: Exploring to a position with new previous vertex?? 

main = do
  h <- openFile "../input.txt" ReadMode
  contents <- hGetContents h
  let heights = (map . map) get_val $ lines contents
      Just start = get_start heights
      Just end = get_end heights
      path = shortest_path heights start end
  print heights
  -- print $ "Path: " ++ (intercalate "," $ map (\(x, y) -> "(" ++ show x ++ "," ++ show y ++ ")") path)
  -- print $ "Path length: " ++ show (length path) -- Print path length; To get the number of steps, subtract one
  hClose h