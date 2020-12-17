library(data.table);library(stringr)

bg = readRDS("complete_bigram_probabilities_rounded.rds")

bg$firstWord = rep(1, nrow(bg))
bg$lastWord = rep(1, nrow(bg))

firstWords = c()
lastWord = c()

for(i in 1:nrow(bg)){
  firstWords[i] = sepWords(bg$bigram[i])$firstWords
  lastWord[i] = sepWords(bg$bigram[i])$lastWord
}

bg$firstWord = firstWords
bg$lastWord = lastWord

tg = readRDS("complete_trigram_probabilities_rounded.rds")

tg$firstWords = rep(1, nrow(tg))
tg$lastWord = rep(1, nrow(tg))

firstWords = c()
lastWord =  c()

for(i in 1:nrow(tg)){
  firstWords[i] = sepWords(tg$trigram[i])$firstWords
  lastWord[i] = sepWords(tg$trigram[i])$lastWord
}

tg$firstWords = firstWords
tg$lastWord = lastWord

fg = readRDS("complete_fourgram_probabilties_rounded.rds")

fg$firstWords = rep(1,nrow(fg))
fg$lastWord = rep(1, nrow(fg))

firstWords = c()
lastWord = c()

for(i in 1:nrow(fg)){
  firstWords[i] = sepWords(fg$fourgram[i])$firstWords
  lastWord[i] = sepWords(fg$fourgram[i])$lastWord
}

fg$firstWords = firstWords
fg$lastWord = lastWord

fiveg = readRDS("complete_fivegram_probabilties_rounded.rds")

fiveg$firstWords = rep(1,nrow(fiveg))
fiveg$lastWord = rep(1,nrow(fiveg))

firstWords = c()
lastWord = c()

for(i in 1:nrow(fiveg)){
  firstWords[i] = sepWords(fiveg$fivegram[i])$firstWords
  lastWord[i] = sepWords(fiveg$fivegram[i])$lastWord
}

fiveg$firstWords = firstWords
fiveg$lastWord = lastWord