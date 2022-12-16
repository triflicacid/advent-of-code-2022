import System.IO
import CPULib

main = do
  h <- openFile "../inputSample2.txt" ReadMode
  contents <- hGetContents h
  let
    ops = map ((\(i:a) -> (i, a)).words) $ lines contents
    cpu = create_cpu 1
    rc = create_record True 20 40
    crt = create_crt False 0 0
    (cpu', rc', _) = cpu_exec_all (cpu, rc, crt) ops
    signals = map (\(x,c) -> x*c) $ record_get rc'
  print $ "x = " ++ (show $ fst cpu') ++ " after " ++ (show $ snd cpu') ++ " cycles."
  print $ "Sum of recorded signals: " ++ (show $ sum signals)
  hClose h