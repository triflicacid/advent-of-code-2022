import System.IO
import Funcs

main = do
  h <- openFile "input.txt" ReadMode
  contents <- hGetContents h
  let
    chars = find_unique contents 4
  print chars
  hClose h