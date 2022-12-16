module Rope(Pos, Instruct, PosSet, create_rope, exec, exec_list) where
  import Data.Set as Set

  type Pos = (Int, Int)
  type Instruct = (Char, Int)
  type PosSet = Set.Set Pos

  -- Create a rope with `n` segments
  create_rope :: Int -> [Pos]
  create_rope 0 = []
  create_rope n = (0,0):(create_rope (n-1))

  -- Get delta given difference
  delta :: Int -> Int -> Pos
  delta x y
    | x == 0 && y == 2    = (0, 1)
    | x == 1 && y == 2    = (1, 1)
    | x == 2 && y == 2    = (1, 1)
    | x == 2 && y == 1    = (1, 1)
    | x == 2 && y == 0    = (1, 0)
    | x == 2 && y == -1   = (1, -1)
    | x == 2 && y == -2   = (1, -1)
    | x == 1 && y == -2   = (1, -1)
    | x == 0 && y == -2   = (0, -1)
    | x == -1 && y == -2  = (-1, -1)
    | x == -2 && y == -2  = (-1, -1)
    | x == -2 && y == -1  = (-1, -1)
    | x == -2 && y == 0   = (-1, 0)
    | x == -2 && y == 1   = (-1, 1)
    | x == -2 && y == 2   = (-1, 1)
    | x == -1 && y == 2   = (-1, 1)
    | otherwise           = (0, 0)

  -- Update position of head, |dx| <= 1, |dy| <= 1
  -- Rope, dx, dy --> Rope
  move :: [Pos] -> Int -> Int -> [Pos]
  move [s] dx dy = [s]
  move (h:r) dx dy = update r'
    where
      h' = (fst h + dx, snd h + dy)
      r' = h':r

  -- Update the rope segment locations
  update :: [Pos] -> [Pos]
  update [h] = [h]
  update (h:t:r) = h:(update $ t':r)
    where
      (hx, hy) = h
      (tx, ty) = t
      (dx, dy) = delta (hx - tx) (hy - ty)
      t' = (tx + dx, ty + dy)

  -- Execute a move instruction
  -- Rope, Instruction, TailPositions --> (Rope, TailPositions)
  exec :: [Pos] -> Instruct -> PosSet -> ([Pos], PosSet)
  exec r (_, 0) tp = (r, tp)
  exec r (d, n) tp = exec r' (d, (n-1)) tp'
    where
      u :: [Pos] -> [Pos]
      u r = case d of
        'L' -> move r (-1) 0
        'R' -> move r 1 0
        'U' -> move r 0 1
        'D' -> move r 0 (-1)
      r' = u r
      tp' = Set.insert (last r') tp

  -- Execute a list of move instructions
  -- Rope, Instructions, TailPositions --> (Rope, TailPositions)
  exec_list :: [Pos] -> [Instruct] -> PosSet -> ([Pos], PosSet)
  exec_list r [] tp = (r, tp)
  exec_list r (i:i') tp = exec_list r' i' tp'
    where
      (r', tp') = exec r i tp