module NNQsPartTwo where

import System.IO

import System.Random
import Control.Monad (when)

import Data.List (sort)

import NNQs




-- 24
  {--
    Lotto: Draw N different random numbers from the set 1..M.
      Prelude System.Random>diff_select 6 49
        ~> Prelude System.Random>[23,1,17,33,21,37]
  --}

diff_select :: Int -> Int -> IO [Int]
diff_select n m = rnd_select (range 1 m) n


-- 25
  {--
    Generate a random permutation of the elements of a list.
      Prelude System.Random>rnd_permu "abcdef"
      ~> Prelude System.Random>"badcef"
  --}
rnd_permu :: [a] -> IO [a]
rnd_permu xs = rnd_select xs (length xs)



-- 26
    {--
        > combinations 3 "abcdef"
        ["abc","abd","abe",...]
    --}


-- 0-based, a <= i < b (python-style) indexing
slice' :: [a] -> Int -> Int -> [a]
slice' xs a = slice xs (a + 1)


powerset :: [a] -> [[a]]
powerset []         = [[]]
--powerset (x:[])     = [ [], [x] ]
powerset (x:xs)     = [ x:ys | ys <- yys ] ++ yys where yys = powerset xs


-- CLAIM: this is not the most efficient way to do this.
combinations :: [a] -> Int -> [[a]]
combinations xs n = [ ys | ys <- powerset xs, length ys == n ]


combo :: [a] -> Int -> [[a]]
combo [] _ = []
combo xs 0 = [[]]
combo xs 1 = fmap (\x -> [x]) xs
combo (x:xs) n = [ x : ys | ys <- combo xs (n - 1) ] ++ combo xs n


fact :: Int -> Int
fact 0 = 1
fact n = n * fact(n - 1)

binCoeff :: Int -> Int -> Int
binCoeff n k
    | k > n = 0
    | otherwise = (fact n) `div` ((fact (n-k)) * fact k)




isAllUniq :: Eq a => [a] -> Bool
isAllUniq [] = True
isAllUniq (x:xs) = and $ [isAllUniq xs] ++ [ y /= x | y <- xs ]




testCombo :: Int -> Int -> Bool
testCombo m n
        | (binCoeff m n) /= (length cc :: Int) = False
        | or $ fmap (\xx -> length xx /= n) cc = False
        | not (isAllUniq cc) = False
        | otherwise = True
    where
        cc = combo (range 1 m) n
        
        
           









-- 27
    {--
        Group the elements of a set into disjoint subsets.
            a) In how many ways can a group of 9 people work in 3 disjoint subgroups of 2, 3 and 4 persons? Write a function that generates all the possibilities and returns them in a list.
            b) Generalize the above predicate in a way that we can specify a list of group sizes and the predicate will return a list of groups.
        Note that we do not want permutations of the group members; i.e. ((ALDO BEAT) ...) is the same solution as ((BEAT ALDO) ...). However, we make a difference between ((ALDO BEAT) (CARLA DAVID) ...) and ((CARLA DAVID) (ALDO BEAT) ...).
        You may find more about this combinatorial problem in a good book on discrete mathematics under the term "multinomial coefficients".

        P27> group [2,3,4] ["aldo","beat","carla","david","evi","flip","gary","hugo","ida"]
            [[["aldo","beat"],["carla","david","evi"],["flip","gary","hugo","ida"]],...]
                (altogether 1260 solutions)
 
        27> group [2,2,5] ["aldo","beat","carla","david","evi","flip","gary","hugo","ida"]
            [[["aldo","beat"],["carla","david"],["evi","flip","gary","hugo","ida"]],...]
                (altogether 756 solutions)
    --}




skip :: Int -> [a] -> [a]
skip 0 xs       = xs
skip _ []       = []
skip n (_:xs)   = skip (n - 1) xs


{--
    e.g.,
        >partByIndex "abcdefghi" [7,1,2]
            ~> ["bch", "adefgi"]
            

partByIndex :: [a] -> [Int] -> [[a]]
partByIndex xs js = loop xs (sort js) []
    where
        loop xs []      acc = [acc,xs] --fmap sort [acc, xs]
        loop xs (j:js)  acc = loop ys (fmap (subtract 1) js) (xs !! j : acc)
            where
                ys = take j xs ++ skip (j+1) xs

partByIndexOrd :: (Ord a) => [a] -> [Int] -> [[a]]
--partByIndexOrd xs js = fmap sort $ partByIndex xs js
partByIndexOrd = fmap (fmap sort) . partByIndex

--}






{--
group :: [Int] -> [a] -> [[a]]
group [] _ = []
group _ [] = []
group (size:sizes) xs = fmap (++) [] $ fmap f [] $ combinations (range 0 $ length xs -1) size
    where
        f [] = []
        f jndexes = kept ++ group sizes remaining
            where [kept, remaining] = partByIndex xs jndexes
            
--}



-- 31
{-- isPrime --}
isPrime :: Int -> Bool
isPrime 1 = False
isPrime 2 = True
isPrime n = not $ or [ n `mod` x == 0 | x <- [ 2 .. n ], x * x < n ]


-- 32
{-- gcd' --}

-- might not work right all/most of time either,
-- at least it's shorter...
gcd' :: Int -> Int -> Int
gcd' a b    | a < 0         = gcd' (abs a) b
            | b < 0         = gcd' a (abs b)
            | b == 0        = a
            | a < b         = gcd' b a
            | otherwise     = gcd' (a `div` b) (a `rem` b)





-- 33
{-- coprime --}
coprime :: Int -> Int -> Bool
coprime n m = gcd' n m == 1

