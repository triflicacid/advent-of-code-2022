import System.IO
import Utils

main = do
  h <- openFile "../input.txt" ReadMode
  contents <- hGetContents h
  let
    chars = find_unique contents 14
  print chars
  hClose h