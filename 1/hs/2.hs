import System.IO
import Data.List
import Data.List.Split

main = do
  h <- openFile "../input.txt" ReadMode
  contents <- hGetContents h
  let
    cals = -- Array of calories per elf
      map sum $ -- Sum each array of calories
      (map.map) to_int $ -- Convert calorie strings to ints
      map lines $ -- Split strings into arrays of calorie strings
      splitOn "\n\n" contents -- Split into array of strings
      where
        to_int = read :: String -> Int
    max1 = maximum cals
    max2 = maximum $ delete max1 cals
    max3 = maximum $ delete max2 $ delete max1 cals
  print (max1 + max2 + max3)
  hClose h