module Utils where
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

  -- Return play requires to end the game in a certain way: X = lose, Y = draw, Z = win.
  get_play :: String -> String -> String
  get_play a "X"
    | a == "A" = "Z"
    | a == "B" = "X"
    | a == "C" = "Y"
  get_play a "Y"
    | a == "A" = "X"
    | a == "B" = "Y"
    | a == "C" = "Z"
  get_play a "Z"
    | a == "A" = "Y"
    | a == "B" = "Z"
    | a == "C" = "X"