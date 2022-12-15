module FileSystem where
  import Data.List
  import Data.Maybe
  import Utils

  -- Entity: Directory(name,parent,children) | File(name,size,parent)
  data Entity = Dir String (Maybe Int) [Int] | File String Int (Maybe Int)

  -- Create a file
  create_file :: String -> Int -> Entity
  create_file nm sz = File nm sz Nothing

  -- Is entity a file?
  is_file :: Entity -> Bool
  is_file e = case e of
    (File _ _ _) -> True
    _ -> False

  -- Create directory
  create_dir :: String -> Entity
  create_dir nm = Dir nm Nothing []

  -- Is entity a directory?
  is_dir :: Entity -> Bool
  is_dir e = case e of
    (Dir _ _ _) -> True
    _ -> False

  -- Extract name of an entity
  get_name :: Entity -> String
  get_name (Dir nm _ _) = nm
  get_name (File nm _ _) = nm

  -- Get entities' size
  get_size :: [Entity] -> Entity -> Int
  get_size fs (File _ sz _) = sz
  get_size fs (Dir _ _ ch) = sum $ map (\c -> get_size fs (fs!!c)) ch

  -- Create a new filesystem, provided the name of the root
  create_fs :: String -> [Entity]
  create_fs nm = [create_dir nm]

  -- FileSystem: get entity with the given name
  find_name :: String -> [Entity] -> Maybe Entity
  find_name str fs = find (\e -> get_name e == str) fs

  -- Get name's index
  find_name_idx :: String -> [Entity] -> Maybe Int
  find_name_idx str fs = fni 0 fs
    where
      fni i [] = Nothing
      fni i (e:fs') = if str == get_name e then Just i else fni (i+1) fs'

  -- Add child to the FileSystem, registered as a child of <dir>
  add_child :: [Entity] -> Entity -> Entity -> [Entity]
  add_child fs (Dir nm pt chs) ch = fs''
    where
      Just idx = find_name_idx nm fs  -- Get index of parent
      ch' = set_parent fs ch idx -- Set parent of child
      fs' = fs ++ [ch'] -- Add child to file system
      dir' = (Dir nm pt ((length fs):chs)) -- Add child to the directory's child 
      fs'' = list_set idx dir' fs' -- Update filesystem with the modified directory

  -- Set the parent of an entity : child, parent_id
  set_parent :: [Entity] -> Entity -> Int -> Entity
  set_parent fs (File nm b _) pid = File ((get_name (fs!!pid)) ++ nm) b (Just pid)
  set_parent fs (Dir nm _ c) pid = Dir ((get_name (fs!!pid)) ++ nm ++ "/") (Just pid) c

  -- Get child with a given name
  fs_traverse :: [Entity] -> Entity -> String -> Maybe Entity
  fs_traverse fs d pth = cdh d pth
    where
      cdh :: Entity -> String -> Maybe Entity
      cdh (Dir nm pn chs) pth
        | pth == "."    = Just d -- Current directory
        | pth == ".."   = ite pn -- Parent directory
        | pth!!0 == '/' = find_name pth fs -- Search absolute
        | otherwise     = find_name (nm ++ add_slash pth) $ map ((!!) fs) chs -- Search relative
      -- Return entity at the given index
      ite :: Maybe Int -> Maybe Entity
      ite (Nothing) = Nothing
      ite (Just idx) = Just (fs!!idx)


  -- File system to string
  fs_str :: [Entity] -> Entity -> String
  fs_str fs e = tsi e 0 -- "Entities: " ++ (show $ length fs) ++ ".\n" ++ (tsi e 0)
    where
      -- To String utility function (with indentation)
      tsi :: Entity -> Int -> String
      tsi e n = case e of
        (File nm sz p) -> (dup_str " " n) ++ "- " ++ nm ++ " (file,size=" ++ (show sz) ++ ")"
        (Dir nm p chs) -> (dup_str " " n) ++ "- " ++ nm ++ " (dir,size=" ++ (show $ get_size fs e) ++ ")"
          ++ (if length chs == 0 then "" else "\n")
          ++ (pc chs (n+1))
      -- Iterate through and print the children
      pc chs n = intercalate "\n" $ map (\ch -> tsi (fs!!ch) (n+1)) chs
      -- Get string name of parent
      p_str :: Maybe Int -> String
      p_str (Nothing) = "<null>"
      p_str (Just i) = p_str' (fs!!i)
      -- Helper for p_str - get name of entity
      p_str' :: Entity -> String
      p_str' (Dir nm _ _) = nm
      p_str' (File nm _ _) = nm