import System.IO
import FileSystem
import Utils
import FromScript
import Data.Maybe

main = do
  let
    fs0 = create_fs "/"
    f1 = create_file "a.txt" 10
    fs1 = add_child fs0 (head fs0) f1
    d1 = create_dir "usr"
    fs2 = add_child fs1 (head fs1) d1
    Just d2 = find_name "/usr/" fs2
    f2 = create_file "b.txt" 69
    fs3 = add_child fs2 d2 f2
    d3 = create_dir "log"
    fs4 = add_child fs3 d2 d3
    Just d4 = find_name "/usr/log/" fs4
    f3 = create_file "mail" 112
    fs5 = add_child fs4 d4 f3
    Just d = find_name "/usr/" fs5
    c = fs_traverse fs5 d "log/"
    Just c' = c
  putStrLn $ fs_str fs5 (head fs5)
  putStrLn "******"
  putStrLn $ if isNothing c then "Nothing" else fs_str fs5 c'