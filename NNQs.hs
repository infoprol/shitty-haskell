module NNQs where

import System.IO

{-- https://wiki.haskell.org/99_questions/1_to_10 --}
{--
    NOTE: i'm leaving the functions with incomplete defs
    for now.  if nothing else, they could be wrapped in Maybe's
--}

--1
myLast :: [a] -> a  
myLast [x]  = x
myLast (x:xs) = myLast xs

--2
myButLast :: [a] -> a
myButLast (x:y:[])  = x
myButLast (x:xs)    = myButLast xs

--3
elementAt :: [a] -> Int -> a
elementAt (x:xs) 0 = x
elementAt (x:xs) k = elementAt xs (k - 1)

--4
myLength :: [a] -> Int
myLength = foldl ((\x y -> x) . (+1)) 0
--myLength (x:xs) = myLength

--5
myReverse :: [a] -> [a]
myReverse = foldl (\acc x -> x:acc) []

--6
isPalindrome :: (Eq a) => [a] -> Bool
isPalindrome xs = xs == (myReverse xs)

-- 7
data NestedList a = Elem a | List [NestedList a] deriving Show

simpleFlatten :: [[a]] -> [a]
simpleFlatten []              = []
simpleFlatten ([]:xxs)        = simpleFlatten xxs
simpleFlatten ((y:ys):xxs)    = y : simpleFlatten (ys:xxs)

flatten :: NestedList a -> [a]
flatten (Elem x)        = [x]
flatten (List [])       = []
flatten (List (x:xs))   = flatten x ++ flatten (List xs)

-- 8
f :: (Eq a) => [a] -> [a]
f []        = []
f (x:xs)    = foldl (\(a:acc) z -> if z == a then acc else (z:a:acc)) [x] xs

compress :: (Eq a) => [a] -> [a]
compress [] = []
compress xs = myReverse $ loop xs []
    where
        loop []         acc     = acc
        loop (x:xs)     []      = loop xs [x]
        loop (x:xs)     (y:ys)  = loop xs (if x == y then (y:ys) else (x:y:ys))

-- 9
pack :: Eq a => [a] -> [[a]]
pack [] = []
pack xs = myReverse $ loop xs [] []
    where
        loop []         innAcc      outAcc  = innAcc : outAcc
        loop (x:xs)     []          outAcc  = loop xs [x] outAcc
        
        loop (x:xs) (y:ys) outAcc   | x == y    = loop  xs  (x:y:ys)    outAcc
                                    | otherwise = loop  xs  [x]         ((y:ys) : outAcc)

-- 10
encode :: Eq a => [a] -> [ (Int, a) ]
encode = g . pack
    where
        g = fmap $ \(x:xs) -> ((myLength (x:xs)), x)


{--
    https://wiki.haskell.org/99_questions/11_to_20
--}

len :: [a] -> Int
len = myLength


-- 11

data SymbolRun a = Single a | Multiple Int a deriving Show


encodeModified :: Eq a => [a] -> [SymbolRun a]
encodeModified = (fmap h) . pack
    where
        h (x:[]) = Single x
        h (x:xs) = Multiple (len (x:xs)) x


-- 12
decodeModified :: Eq a => [SymbolRun a] -> [a]
decodeModified [] = []
decodeModified (x:xs) =
  case x of
    (Single c)      ->  c : decodeModified xs
    (Multiple n c)  ->  fmap (const c) [ 1 .. n ] ++ decodeModified xs


-- 13
encodeDirect :: Eq a => [a] -> [SymbolRun a]
encodeDirect [] = []
encodeDirect zs = recurse zs []
  where
    recurse [] acc = myReverse acc
    recurse (x:xs) [] = recurse xs [Single x]
    recurse (x:xs)  (y:ys)  =
      case y of
        (Single c)      -> recurse xs (if c == x then Multiple 2 c :ys else (Single x):y:ys)
        (Multiple n c)  -> recurse xs (if c == x then Multiple (n+1) c :ys else (Single x):y:ys)
      
-- 14
xdupli :: [a] -> [a]
xdupli [] = []
xdupli xs = recurse xs []
  where
    recurse []      acc = foldl (\xs x -> x:xs) [] acc
    recurse (x:xs)  acc = recurse xs (x:x:acc)
    
xxdupli :: [a] -> [a]
xxdupli = dupl . rev
  where
    rev = foldl (flip (:)) []
    dupl = foldl (\xs x -> x:x:xs) []

-- oh, yeah - right...
dupli :: [a] -> [a]
dupli = foldr (\x xs -> x:x:xs) []




-- 15
rev :: [a] -> [a]
rev = foldl (flip (:)) []

repli :: [a] -> Int -> [a]
repli xxs n = foldr (++) [] zzs
  where
    zzs     = fmap repl xxs
    repl x  = take n (repeat x)

--repli xxs n = foldr (\x xs -> (take n $ repeat x) ++ xs) xxs []
--repli xs n = repli (dupli xs) (n - 1)
--repli xxs n = foldr (\x xs -> [ x | x <- 1 ... n ])


-- 16
{-- --}
-- deviating from prob signature of `:: [a] -> Int -> [a]`
--dropEvery :: Int -> [a] -> [a]

dropEvery :: [a] -> Int -> [a]
dropEvery xxs n = rev (recurse xxs [] [])
  where
    recurse []      innAcc  outAcc  = foldr (:) innAcc outAcc
--    recurse (x:xs)  []      []      = recurse xs [x] []
    recurse (x:xs)  innAcc  outAcc
      | (len innAcc) < n - 1    = recurse xs (x:innAcc) outAcc
      | otherwise               = recurse xs [] (foldr (:) innAcc outAcc)
        
    










