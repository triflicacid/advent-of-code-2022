import System.IO
import Data.List
import Data.List.Split
import Monkey

main = do
  h <- openFile "../input.txt" ReadMode
  contents <- hGetContents h
  let
    notes = map (tail.lines) $ splitOn "\n\n" contents
    mks = map create_monkey notes
    mks' = process_n_monkeys 20 mks (Just (`div` 3))
    work = map get_count mks'
    max1 = maximum work
    max2 = maximum $ delete max1 work
  putStrLn $ to_str mks'
  putStr "\n"
  print work
  print $ "Most: " ++ (show max1) ++ " and " ++ (show max2)
  print $ "Monkey Business: " ++ (show $ max1 * max2)
  hClose h