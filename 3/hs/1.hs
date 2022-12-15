import System.IO
import qualified Data.Text as Tx
import qualified Data.Text.Conversions as TxCv
import Data.List.Split
import Utils

main = do
  h <- openFile "../input.txt" ReadMode
  contents <- hGetContents h
  let
    dups =
      map (\[a,b] -> head $ head $ intersect a b) $ -- Get letters occuring in both lists. head of string returns char.
      map (\t -> map (\s -> tail $ splitOn "" $ Tx.unpack s) t) $ -- Split text into lists, remove first element ("")
      map (\ln -> let hlen = div (Tx.length ln) 2
        in [Tx.take hlen ln, Tx.drop hlen ln]) $ -- Split in half
      map (\ln -> TxCv.toText ln) $ -- Convert string to text
      lines contents -- Get lines (rounds)
    vals = map get_val dups
  print (sum vals)
  hClose h