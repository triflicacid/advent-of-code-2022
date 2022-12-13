import System.IO

-- Rock = A/X; Paper = B/Y; Scissors = C/Z.
-- Return whether we (b) win the round
win :: String -> String -> Bool
win a b = (b == "X" && a == "C") || (b == "Y" && a == "A") || (b == "Z" && a == "B")

-- Check if game is a draw
draw :: String -> String -> Bool
draw a b = (a == "A" && b == "X") || (a == "B" && b == "Y") || (a == "C" && b == "Z")

-- Get score for playing an item
item_score :: String -> Int
item_score a
  | a == "A" || a == "X" = 1
  | a == "B" || a == "Y" = 2
  | a == "C" || a == "Z" = 3

-- Get score of a game outcome
game_score :: String -> String -> Int
game_score a b
  | draw a b    = 3 -- Draw
  | win a b  = 6 -- We won
  | otherwise = 0 -- We lost

-- Get total score
total_score :: String -> String -> Int
total_score a b = (item_score b) + (game_score a b)

main = do
  h <- openFile "input.txt" ReadMode
  contents <- hGetContents h
  let
    scores = map (\[a,b] -> total_score a b) $ -- Convert into game scores
      map words $ -- Split into who played who
      lines contents -- Get lines (rounds)
  print (sum scores)
  hClose h