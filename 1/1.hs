import System.IO
import Data.List.Split

main = do
  h <- openFile "input.txt" ReadMode
  contents <- hGetContents h
  let
    cals = -- Array of calories per elf
      map sum $ -- Sum each array of calories
      (map.map) to_int $ -- Convert calorie strings to ints
      map lines $ -- Split strings into arrays of calorie strings
      splitOn "\n\n" contents -- Split into array of strings
      where
        to_int = read :: String -> Int
  print (maximum cals)
  hClose h