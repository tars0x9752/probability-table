module Main where

import Data.List (find)

type Names = [String]

type Prob = Double

type Probs = [Prob]

data PTable = PTable Names Probs

createPTable :: Names -> Probs -> PTable
createPTable names probs = PTable names normalizedProbs
  where
    totalProb = sum probs
    normalizedProbs = map (/ totalProb) probs -- sum of normalizedProbs must be 1

getPercentage :: (RealFrac a, Integral b) => a -> b
getPercentage prob = round $ prob * 100

getNames :: PTable -> Names
getNames (PTable names _) = names

getProbs :: PTable -> Probs
getProbs (PTable _ probs) = probs

getProbPercentages :: Integral b => PTable -> [b]
getProbPercentages (PTable _ probs) = map getPercentage probs

instance Show PTable where
  show (PTable names probs) = mconcat rows
    where
      showRow name prob = mconcat [name, " | ", show $ getPercentage prob, "%\n"]
      rows = zipWith showRow names probs

combine :: (a -> b -> c) -> [a] -> [b] -> [c]
combine combiner listL listR = zipWith combiner preCombinedL preCombinedR
  where
    repeatLengthOfR = replicate $ length listR
    preCombinedL = mconcat $ map repeatLengthOfR listL
    preCombinedR = cycle listR

combineNames :: Names -> Names -> Names
combineNames = combine combiner
  where
    combiner l r = mconcat [l, "-", r]

combineProbs :: Probs -> Probs -> Probs
combineProbs = combine (*)

instance Semigroup PTable where
  (<>) pTable1 (PTable [] []) = pTable1
  (<>) (PTable [] []) pTable2 = pTable2
  (<>) (PTable n1 p1) (PTable n2 p2) = createPTable names probs
    where
      names = combineNames n1 n2
      probs = combineProbs p1 p2

instance Monoid PTable where
  mempty = PTable [] []
  mappend = (<>)

-- Use the followings

search :: String -> PTable -> String
search targetName (PTable names probs) =
  let zipped = zip names probs
      result = find (\(n, _) -> n == targetName) zipped
   in case result of
        Just (name, prob) -> mconcat [name, " | ", show $ getPercentage prob, "%"]
        Nothing -> "Nothing found"

coin :: PTable
coin = createPTable ["heads", "tails"] [0.5, 0.5]

dice :: PTable
dice = createPTable ["1", "2", "3", "4", "5", "6"] $ replicate 6 (1 / 6)

rps :: PTable
rps = createPTable ["rock", "paper", "scissors"] $ replicate 3 (1 / 3)

main :: IO ()
main = do
  putStrLn "usage: ghci Main.hs"
  putStrLn "example1> dice <> dice -- mappend two tables"
  putStrLn "example2> mconcat [coin, coin, coin] -- mconcat some tables"
  putStrLn "example3> rps -- or just show one tables"
  putStrLn "example4> search \"rock-paper\" $ rps <> rps -- or search element in the table"
