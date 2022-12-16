import System.IO
import CPULib

main = do
  h <- openFile "../input.txt" ReadMode
  contents <- hGetContents h
  let
    ops = map ((\(i:a) -> (i, a)).words) $ lines contents
    cpu = create_cpu 1
    rc = create_record False 0 0
    crt = create_crt True 40 3
    (cpu', _, crt') = cpu_exec_all (cpu, rc, crt) ops
  print $ "x = " ++ (show $ fst cpu') ++ " after " ++ (show $ snd cpu') ++ " cycles."
  putStrLn "===== [ CRT ] ====="
  putStrLn $ crt_get crt'
  hClose h