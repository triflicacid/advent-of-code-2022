import System.IO
import FileSystem
import FromScript

-- Get size of all directories <= 100000
get_sml :: [Entity] -> Entity -> Int
get_sml fs (Dir _ _ ch) = sum $ filter (<= 100000) $ map (\c -> gs (fs!!c)) ch
  where
    gs :: Entity -> Int
    gs e = case e of
      (Dir _ _ _) -> get_size fs e + get_sml fs e -- Get directory size, and repeat on all children
      _ -> 0

main = do
  h <- openFile "../inputSample.txt" ReadMode
  contents <- hGetContents h
  let
    cmds = map words $ lines contents -- Extract commands from script
    fs = create_fs "/" -- Initialise file system
    cwd = head fs -- Current working directory
    (fs', cwd', s) = exec_all fs cwd cmds cSTATE_NONE
    total = get_sml fs' (head fs')
  -- putStrLn $ "cwd=" ++ (get_name cwd') ++ ",state=" ++ (show s) ++ "\n"
  -- putStrLn $ fs_str fs' (head fs')
  print total
  hClose h