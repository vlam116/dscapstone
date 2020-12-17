library(data.table)

# Using GT discounting and assuming k = 5 such that n-grams with count > k are not discounted (d = 1)
# According to Katz, n-grams observed frequently are reliable counts. 


fiveg = readRDS("sample_fivegrams.rds")

fiveg = setcolorder(fiveg, c("firstWords", "lastWord", "frequency", "fivegram"))

fiveg$discount = rep(1, nrow(fiveg))

# The discount factor is calculated as follows: d = (rStar/r) * (nP1/n)
# where r is the count of an event occurring 
# r star is r+1
# nP1 is the total number of times an event was observed r+1 times
# n is the total number of times an event was observed r times
for(i in 1:5){
  
  # Only discounting n-grams where the frequencies 1:5 
  r = i 
  rStar = r + 1
  
  # The number of rows in our fivegram table where the frequency is equal to r gives us our numerator
  n = nrow(fiveg[frequency == r])
  # The number of rows in our fivegram table where the frequency is equal to r+1 gives us the denominator
  nPlusOne = nrow(fiveg[frequency == rStar])
  
  # The discount coefficient is calculated 
  d = (rStar/r)*(nPlusOne/n)
  
  # For n-grams having the same frequency, the discount coefficient will be the same, so we can construct
  # the discount column in the fivegram table like this
  fiveg[frequency == r, discount := d]
  
}

# Creating function to calculate left over probability to be distributed to lower order n-grams as part of
# katz's back-off model
# With the discount factor calculated, the left over probability is calculated as follows:
# 1 - sum(d * count observed first word / total count of ngrams with same frequency as observed ngram)

calcLOP = function(lastWord, frequency, discount){
  countOfCounts = sum(frequency)
  
  return(1-sum((discount*frequency)/countOfCounts))
}

fiveg_leftOverProb = fiveg[, .(leftoverprob = calcLOP(lastWord, frequency, discount)), by = firstWords]

fg = readRDS("sample_fourgrams.rds")

fg = setcolorder(fg, c("firstWords", "lastWord", "frequency", "fourgram"))

fg$discount = rep(1, nrow(fg))

for(i in 1:5){
  
  r = i
  rStar = r + 1
  
  n = nrow(fg[frequency == r])
  nPlusOne = nrow(fg[frequency == rStar])
  
  d = (rStar/r)*(nPlusOne/n)
  
  fg[frequency == r, discount := d]
  
}

fg_leftOverProb = fg[, .(leftoverprob = calcLOP(lastWord, frequency, discount)), by = firstWords]

tg = readRDS("sample_trigrams.rds")

tg = setcolorder(tg, c("firstWords","lastWord","frequency","trigram"))
  
tg$discount = rep(1, nrow(tg))
  
for(i in 1:5){
    
    r = i
    rStar = r + 1
    
    n = nrow(tg[frequency == r])
    nPlusOne = nrow(tg[frequency == rStar])
    
    d = (rStar/r)*(nPlusOne/n)
    
    tg[frequency == r, discount := d]
    
}

tg_leftOverProb = tg[, .(leftoverprob = calcLOP(lastWord, frequency, discount)), by = firstWords]

bg = readRDS("sample_bigrams.rds")

bg = setcolorder(bg, c("firstWord","lastWord","frequency","bigram"))

bg$discount = rep(1, nrow(bg))

for(i in 1:5){
  
    r = i
    rStar = r + 1
    
    n = nrow(bg[frequency == r])
    nPlusOne = nrow(bg[frequency == rStar])
    
    d = (rStar/r)*(nPlusOne/n)
    
    bg[frequency == r, discount := d]
    
}

bg_leftOverProb = bg[, .(leftoverprob = calcLOP(lastWord, frequency, discount)), by = firstWord]

tks = readRDS("sample_tokens.rds")

tks$discount = rep(1, nrow(tks))

for(i in 1:5){
  
  r = i
  rStar = r + 1
  
  n = nrow(tks[frequency == r])
  nPlusOne = nrow(tks[frequency == rStar])
  
  d = (rStar/r)*(nPlusOne/n)
  
  tks[frequency == r, discount := d]
  
}