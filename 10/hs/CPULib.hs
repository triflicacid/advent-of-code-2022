module CPULib where
  type CPU = (Int, Int) -- (x, cycle)
  type Rec = (Bool, Int, Int, [CPU]) -- Enable, Start, Every, [CPU State]
  type CRT = (Bool, Int, Int, Int, Int, String) -- Enable, Width, SpriteWidth, Pos, Calls, Output
  type Bundle = (CPU, Rec, CRT)

  to_int = read :: String -> Int

  --------------------- RECORD
  -- Create a record
  create_record :: Bool -> Int -> Int -> Rec
  create_record en s e = (en, s, e, [])

  -- Add a record?
  record :: Rec -> CPU -> Rec
  record rc cpu = case rc of
    (False, _, _, _) -> rc
    (True, s, e, l) -> if ((cy - s) `mod` e) == 0 then (True, s, e, l') else rc
      where
        (x, cy) = cpu
        l' = l ++ [cpu]

  -- Record: get data
  record_get :: Rec -> [CPU]
  record_get (_, _, _, lst) = lst

  -- Is record enabled?
  record_enabled :: Rec -> Bool
  record_enabled (e, _, _, _) = e

  --------------------- CRT
  -- Create a CRT (Cathode Ray Tube)
  create_crt :: Bool -> Int -> Int -> CRT
  create_crt en w sw = (en, w, sw, 0, 0, "")

  -- Is CRT disabled?
  crt_enabled :: CRT -> Bool
  crt_enabled (en, _, _, _, _, _) = en

  -- CRT: get output
  crt_get :: CRT -> String
  crt_get (_, _, _, _, _, out) = out

  -- Draw to the CRT
  -- hpos, CRT, CPU
  draw :: Int -> CRT -> CPU -> CRT
  draw hpos crt cpu = case crt of
    (False, _, _, _, _, _) -> crt
    (True, w, sw, pos, cs, out) -> (True, w, sw, pos', cs', out')
      where
        cs' = cs + 1 -- Increment call number
        nl = mod cs' w == 0 -- Are we going on to a new line
        out' = out ++ (if pos >= hpos - sp && pos <= hpos + sp then "#" else ".") ++ (if nl then "\n" else "");
        sp = (sw - 1) `div` 2 -- Padding either side of sprite
        pos' = if nl then 0 else pos + 1

  --------------------- CPU
  -- Create a cpu
  create_cpu :: Int -> CPU
  create_cpu x = (x, 0)

  -- Execute an instruction on a cpu.
  cpu_exec :: Bundle -> String -> [String] -> Bundle
  cpu_exec (cpu, rc, crt) "noop" [] = (cpu', rc', crt')
    where
      (x, cy) = cpu
      cpu' = (x, cy+1)    -- +1 cycles
      rc' = record rc cpu' -- Record?
      crt' = draw x crt cpu' -- Draw to CRT
  cpu_exec (cpu, rc, crt) "addx" [n] = (cpu''', rc'', crt'')
    where
      (x, cy) = cpu
      cpu' = (x, cy+1)                   -- +1 cycles
      rc' = record rc cpu'               -- Record?
      crt' = draw x crt cpu'             -- Draw to CRT
      cpu'' = (x, (snd cpu') + 1)        -- +1 cycles
      rc'' = record rc' cpu''            -- Record?
      crt'' = draw x crt' cpu''          -- Draw to CRT
      cpu''' = (x+(to_int n), snd cpu'') -- Execute the addition

  -- CPU: Execute a list of instructons
  cpu_exec_all :: Bundle -> [(String, [String])] -> Bundle
  cpu_exec_all bdl [] = bdl
  cpu_exec_all bdl ((i, a):i') = cpu_exec_all bdl' i'
    where
      bdl' = cpu_exec bdl i a