# probability-table

## examples

```sh
ghci Main.hs

> dice
1 | 17%
2 | 17%
3 | 17%
4 | 17%
5 | 17%
6 | 17%

ghci> mconcat [coin, coin, coin]
heads-heads-heads | 12%
heads-heads-tails | 12%
heads-tails-heads | 12%
heads-tails-tails | 12%
tails-heads-heads | 12%
tails-heads-tails | 12%
tails-tails-heads | 12%
tails-tails-tails | 12%

ghci> dice <> coin
1-heads | 8%
1-tails | 8%
2-heads | 8%
2-tails | 8%
3-heads | 8%
3-tails | 8%
4-heads | 8%
4-tails | 8%
5-heads | 8%
5-tails | 8%
6-heads | 8%
6-tails | 8%

ghci> search "rock-paper" $ rps <> rps
"rock-paper | 11%"
```