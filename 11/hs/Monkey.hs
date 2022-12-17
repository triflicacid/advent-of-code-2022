module Monkey where
  import Data.List
  import Data.List.Split
  import Data.Maybe

  to_int = read :: String -> Int

  extract :: Maybe a -> a
  extract x = x'
    where Just x' = x

  -- Set item at a specific index
  list_set :: Int -> a -> [a] -> [a]
  list_set 0 e (_:lst) = e:lst
  list_set i e [] = [e]
  list_set i e (h:lst) = h:(list_set (i-1) e lst)

  -- Operation: a, op, b
  type MOp = (Maybe Int, Char, Maybe Int)
  type Op = (Int, Char, Int)

  -- Evaluate an operation
  eval_op :: Op -> Int
  eval_op (a, '+', b) = a + b
  eval_op (a, '-', b) = a - b
  eval_op (a, '*', b) = a * b
  eval_op (a, '/', b) = a `div` b

  -- Monkey: items, operation, divisor, ifTrue, ifFalse, count
  type Monkey = ([Int], MOp, Int, Int, Int, Int);

  -- Construct a monkey from a build script
  create_monkey :: [String] -> Monkey
  create_monkey todo = (items, (a, op, b), divisor, if1, if0, 0)
    where
      items = map to_int $ splitOn ", " $ last $ splitOn ": " $ todo!!0
      [a_r, op_r, b_r] = words $ last $ splitOn "= " $ todo!!1
      a = if a_r == "old" then Nothing else Just (to_int a_r)
      op = head op_r
      b = if b_r == "old" then Nothing else Just (to_int b_r)
      divisor = to_int $ last $ words $ todo!!2
      if1 = to_int $ last $ words $ todo!!3
      if0 = to_int $ last $ words $ todo!!4

  -- Get monkey's sivisor
  get_divisor :: Monkey -> Int
  get_divisor (_, _, d, _, _, _) = d

  -- Get monkey's work count
  get_count :: Monkey -> Int
  get_count (_, _, _, _, _, cnt) = cnt

  -- Add item to a monkey
  add_item :: Monkey -> Int -> Monkey
  add_item (itms, op, divisor, if1, if0, cnt) itm = (itms ++ [itm], op, divisor, if1, if0, cnt)

  -- Process a monkey, with a transformation function
  process_monkey :: [Monkey] -> Int -> Maybe (Int -> Int) -> [Monkey]
  process_monkey mks mi f = case (mks!!mi) of
    ([], _, _, _, _, _) -> mks
    ((i:i'), (a, op, b), divisor, if1, if0, cnt) -> process_monkey mks' mi f
      where
        mk = mks!!mi
        i0 = eval_op (a', op, b')
        a' = if isNothing a then i else extract a
        b' = if isNothing b then i else extract b
        i1 = if isNothing f then i0 else (extract f) i0
        to = if (i1 `mod` divisor) == 0 then if1 else if0
        to_mk = add_item (mks!!to) i1
        mk' = (i', (a, op, b), divisor, if1, if0, cnt+1)
        mks' = list_set mi mk' $ list_set to to_mk mks

  -- Process every monkey
  process_monkeys :: [Monkey] -> Maybe (Int -> Int) -> [Monkey]
  process_monkeys mks f = pm mks 0
    where
      pm mks i = if i >= length mks then mks else pm (process_monkey mks i f) (i+1)

  -- Process monkeys `n` times
  process_n_monkeys :: Int -> [Monkey] -> Maybe (Int -> Int) -> [Monkey]
  process_n_monkeys 0 mks f = mks
  process_n_monkeys n mks f = process_n_monkeys (n-1) (process_monkeys mks f) f

  -- Monkeys to item strings
  to_str :: [Monkey] -> String
  to_str mks = f mks 0
    where
      f :: [Monkey] -> Int -> String
      f [(itms, _, _, _, _, _)] i = "Monkey " ++ (show i) ++ ": " ++ (intercalate ", " $ map show itms)
      f (mk:mks') i = (f [mk] i) ++ "\n" ++ (f mks' (i+1))