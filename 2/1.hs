import System.IO
import Utils

main = do
  h <- openFile "input.txt" ReadMode
  contents <- hGetContents h
  let
    scores = map (\[a,b] -> total_score a b) $ -- Convert into game scores
      map words $ -- Split into who played who
      lines contents -- Get lines (rounds)
  print (sum scores)
  hClose h