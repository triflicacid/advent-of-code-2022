import System.IO
import qualified Data.Set as Set
import Rope

to_int = read :: String -> Int

main = do
  h <- openFile "../input.txt" ReadMode
  contents <- hGetContents h
  let
    steps = map ((\[d,n] -> (head d, to_int n)).words) $ lines contents
    rope = create_rope 2
    pos = Set.singleton (0,0) :: PosSet
    (rope', pos') = exec_list rope steps pos
  -- print rope'
  -- print pos'
  print $ "Tail visited " ++ (show $ Set.size pos') ++ " locations."
  hClose h