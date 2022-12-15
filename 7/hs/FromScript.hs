module FromScript(exec_all, cSTATE_NONE) where
  import Utils
  import FileSystem

  cSTATE_NONE = 0 -- Waiting for command
  cSTATE_LS = 1 -- In ls command

  -- Execute the given commands: fs, cwd, commands, state
  exec_all :: [Entity] -> Entity -> [[String]] -> Int -> ([Entity], Entity, Int)
  exec_all fs cwd [] s = (fs, cwd, s)
  exec_all fs cwd ((d:args):cmds') s
    | d == "$"       = exec_all fs'  cwd'   cmds' s'  -- Command!
    | s == cSTATE_LS = exec_all fs'' cwd''  cmds' sp  -- ls entry
    | otherwise      = exec_all fs   cwd    cmds' s   -- Ignore...
      where
        (fs', cwd', s') = exec fs cwd (head args) (tail args) s -- CMD: Execute command
        fs'' = scan_ls fs cwd (d:args) -- LS: Scan ls line
        Just cwd'' = find_name (get_name cwd) fs'' -- LS: get new cwd
        sp = if (not $ null cmds') && ((head $ head cmds') == "$") then cSTATE_NONE else s -- Propagate the current state?

  -- Execute a given command on a file system : FileSystem, CWD, Command, *Args, State; returns (FileSystem, CWD, State)
  exec :: [Entity] -> Entity -> String -> [String] -> Int -> ([Entity], Entity, Int)
  exec fs cwd "cd" [pth] s = (fs', cwd', cSTATE_NONE)
    where
      (fs', cwd') = exec_cd fs cwd pth
  exec fs cwd "ls" [] s = (fs, cwd, cSTATE_LS)

  -- Evaluate the `cd` command: FileSystem, CWD, Path
  exec_cd :: [Entity] -> Entity -> String -> ([Entity], Entity)
  exec_cd fs cwd pth = (fs, cwd')
    where
      Just cwd' = fs_traverse fs cwd pth

  -- Scan ls output line. Add file/dir? FileSystem, CWD, *Args, return FileSystem'
  scan_ls :: [Entity] -> Entity -> [String] -> [Entity]
  scan_ls fs cwd ("dir":dir:_) = add_child fs cwd $ create_dir dir
  scan_ls fs cwd (sz:nm:_) = add_child fs cwd $ create_file nm $ to_int sz