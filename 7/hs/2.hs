import System.IO
import Utils
import FileSystem
import FromScript
import Data.Maybe

cTOTAL_SIZE = 70000000
cNEEDED_SIZE = 30000000
cTARGET = cTOTAL_SIZE - cNEEDED_SIZE

main = do
  h <- openFile "../input.txt" ReadMode
  contents <- hGetContents h
  let
    cmds = map words $ lines contents -- Extract commands from script
    fs = create_fs "/" -- Initialise file system
    cwd = head fs -- Current working directory
    (fs', cwd', s) = exec_all fs cwd cmds cSTATE_NONE
    excess = (get_size fs' $ head fs') - cTARGET
    (me, ms) =
      get_min snd -- Get minimum, based off of size
      $ filter ((>= excess).snd) -- Remove all directories below 'excess' size
      $ filter (is_dir.fst) -- Only keep directories
      $ map (\e -> (e, get_size fs' e)) fs' -- Get pairs (entity, size)
  print $ (get_name me) ++ ": " ++ (show ms)
  hClose h