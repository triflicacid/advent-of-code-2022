{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}

{-# HLINT ignore "Use camelCase" #-}
module Utils where

import Data.Char (ord)
import Data.List
import Data.Maybe
import Debug.Trace

-- Set item at a specific index
list_set :: Int -> a -> [a] -> [a]
list_set 0 e (_ : lst) = e : lst
list_set i e [] = [e]
list_set i e (h : lst) = h : (list_set (i - 1) e lst)

-- Get smallest item in a list, according to the transformation predicate
get_min :: (a -> Int) -> [a] -> a
get_min f lst = gm f lst 0 0 h (f h)
  where
    h = head lst
    gm :: (a -> Int) -> [a] -> Int -> Int -> a -> Int -> a
    gm f [] i si s sv = s
    gm f (x : xs) i si s sv = gm f xs (i + 1) si' s' sv'
      where
        fx = f x
        lt = fx < sv -- Is this value better?
        si' = if lt then i else si
        s' = if lt then x else s
        sv' = if lt then fx else sv

type Pos = (Int, Int)

-- Height of starting vertex
cSTART = 0

-- Height of ending vertex
cEND = 27

-- Get position of the starting vertex
get_start :: [[Int]] -> Maybe Pos
get_start hmap = p
  where
    y = elemIndex True $ map (elem cSTART) hmap
    x = if isNothing y then Nothing else elemIndex cSTART $ hmap !! (fromJust y)
    p = if isNothing x then Nothing else Just (fromJust x, fromJust y)

-- Get position of the ending vertex
get_end :: [[Int]] -> Maybe Pos
get_end hmap = p
  where
    y = elemIndex True $ map (elem cEND) hmap
    x = if isNothing y then Nothing else elemIndex cEND $ hmap !! (fromJust y)
    p = if isNothing x then Nothing else Just (fromJust x, fromJust y)

-- Get height value of a character
get_val :: Char -> Int
get_val c
  | c == 'S' = cSTART
  | c == 'E' = cEND
  | otherwise = (ord c) - 96

-- (x, y, height, done, len_to_start, previous)
data Vertex = Vertex Int Int Int Bool (Maybe Int) (Maybe Pos) deriving (Show)

-- Get height of a vertex
get_height :: Vertex -> Int
get_height (Vertex _ _ h _ _ _) = h

-- Get previous length of a vertex
get_len :: Vertex -> Maybe Int
get_len (Vertex _ _ _ _ len _) = len

-- Set length of a vertex
set_len :: Vertex -> Int -> Vertex
set_len (Vertex a b c d _ f) len = Vertex a b c d (Just len) f

-- Get vertex at the given position
get_vertex :: [[Vertex]] -> Pos -> Vertex
get_vertex vs (x, y) = vs !! y !! x

-- Get position of a vertex
get_pos :: Vertex -> Pos
get_pos (Vertex x y _ _ _ _) = (x, y)

-- Vertex: get previous
get_prev :: Vertex -> Maybe Pos
get_prev (Vertex _ _ _ _ _ p) = p

-- Set vertex as `done`
set_done :: Vertex -> Vertex
set_done (Vertex a b c d e f) = Vertex a b c True e f

get_adj :: [[Vertex]] -> Vertex -> [Pos]
get_adj vs (Vertex x y h _ _ _) = pos3
  where
    pos0 = if y > 0 && (get_height $ vs !! (y - 1) !! x) - 1 <= h then [(x, y - 1)] else []
    pos1 = if y < (length vs) - 1 && (get_height $ vs !! (y + 1) !! x) - 1 <= h then (x, y + 1) : pos0 else pos0
    pos2 = if x > 0 && (get_height $ vs !! y !! (x - 1)) - 1 <= h then (x - 1, y) : pos1 else pos1
    pos3 = if x < (length (vs !! y)) - 1 && (get_height $ vs !! y !! (x + 1)) - 1 <= h then (x + 1, y) : pos2 else pos2

-- Prepare a height map for the algorithm
prepare :: [[Int]] -> [[Vertex]]
prepare l = prep l 0
  where
    prep :: [[Int]] -> Int -> [[Vertex]]
    prep [] _ = []
    prep (m : ms) y = (prep_row m 0) : (prep ms (y + 1))
      where
        prep_row :: [Int] -> Int -> [Vertex]
        prep_row [] _ = []
        prep_row (m : ms) x = m' : (prep_row ms (x + 1))
          where
            m' = Vertex x y m False Nothing Nothing

-- Get the shortest path from `start` to `end`
shortest_path :: [[Int]] -> Pos -> Pos -> [Pos]
shortest_path hmap start end = trcbck phmap'' end
  where
    phmap = prepare hmap
    start_v = phmap !! (snd start) !! (fst start)
    phmap' = list_set (snd start) (list_set (fst start) (set_len start_v 0) (phmap !! (fst start))) phmap
    (phmap'', _, _) = alg (phmap', Just start) 0
    -- Iterate until no next vertex is found
    alg :: ([[Vertex]], Maybe Pos) -> Int -> ([[Vertex]], Maybe Pos, Int)
    alg (vs, Nothing) n = (vs, Nothing, n)
    alg (vs, Just p) n = alg (vs', p') n'
      where
        (vs', p', n') = itr (vs, p) n
    -- Iteration: select next vertex from a current vertex
    itr :: ([[Vertex]], Pos) -> Int -> ([[Vertex]], Maybe Pos, Int)
    itr (vs, p) n = (vs'', p', n + 1)
      where
        -- d = if x == 1 && y == 0 then error ("iter with (1,0) found on iteration " ++ show n ++ "\n" ++ (show $ vs!!y!!x)) else 0
        -- d = if isNothing (get_len v'') then error ("get_next chose vertex with length nothing!: " ++ show v'') else 1
        d = error ("get_next: " ++ show v'')
        (x, y) = p
        vs' = list_set (y + d) (list_set x (set_done (vs !! y !! x)) (vs !! y)) vs -- set done=True
        adj = get_adj vs' (vs' !! y !! x) -- Get adjacent vertices
        vs'' = mpv_list vs' p adj
        p' = get_next vs''
        Just p'' = p'
        v'' = vs'' !! (snd p'') !! (fst p'')
    -- Attempt to make the first vertex the previous of the second
    mpv :: [[Vertex]] -> Pos -> Pos -> [[Vertex]]
    mpv vs (x, y) (nx, ny) = vs'
      where
        Vertex _ _ _ cd cl cp = vs !! y !! x -- Get first vertex info
        Vertex a b c pd pl d = vs !! ny !! nx -- Get second vertex info
        ds = if isNothing cl then error ("cl is nothing! At (" ++ show x ++ "," ++ show y ++ "),done=" ++ show cd ++ "\n" ++ show (trcbck vs (x, y))) else 0
        new = if not pd && (isNothing pl || (isJust pl && cl1 < fromJust pl)) then Just (Vertex a b c pd (Just cl1) (Just (x, y))) else Nothing
        cl1 = ds + fromJust cl + 1
        vs' = if isNothing new then vs else list_set ny (list_set nx (fromJust new) (vs !! ny)) vs
    -- Add prevoius vertex from list onto given vertex
    mpv_list :: [[Vertex]] -> Pos -> [Pos] -> [[Vertex]]
    mpv_list vs v [] = vs
    mpv_list vs v (p : p') = mpv_list (mpv vs v p) v p'
    -- Get next suitable vertex to explore
    get_next :: [[Vertex]] -> Maybe Pos
    get_next vs = if null candidates then Nothing else Just (get_pos $ get_min (fromJust . get_len) candidates)
      where
        candidates = foldr (++) [] $ map (filter (\(Vertex _ _ _ d _ p) -> not (d || isNothing p))) vs
    -- Generate a traceback for a completed algorithm run
    trcbck :: [[Vertex]] -> Pos -> [Pos]
    trcbck vmap pos = tbck [] (Just pos)
      where
        tbck :: [Pos] -> Maybe Pos -> [Pos]
        tbck trace Nothing = trace
        tbck trace (Just (x, y)) = tbck ((x, y) : trace) (get_prev (vmap !! y !! x))