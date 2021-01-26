library(doSNOW);library(data.table);library(stringr);library(tidyr);library(parallel)

cl = makeSOCKcluster(detectCores()-1)
registerDoSNOW(cl)
stopCluster(cl)


bg = readRDS("sample_bigram_discount.rds")
bg_leftOverProb = readRDS("sample_bigram_lop.rds")
tks = readRDS("sample_tokens_discount.rds")
full_bigrams = readRDS("full_bigrams.rds")


p = c(rep(1, nrow(full_bigrams)))

p = foreach(i=1:length(p), .packages = c("stringr","data.table"), .combine = "c") %dopar% {
  
    calcProbBG(full_bigrams$bigram[i])
  
}

full_bigrams$probability = rep(1, nrow(full_bigrams))
full_bigrams$probability = round(p, 4)

saveRDS(full_bigrams, "complete_bigrams_probability.rds")

tg = readRDS("sample_trigram_discount.rds")
tg_leftOverProb = readRDS("sample_trigram_lop.rds")
full_trigrams = readRDS("full_trigrams.rds")

p = c(rep(1,nrow(full_trigrams)))

p = foreach(i=1:length(p), .packages = c("stringr","data.table"), .combine = "c") %dopar% {
    calcProbTG(full_trigrams$trigram[i])
}

full_trigrams$probability = rep(1, nrow(full_trigrams))
full_trigrams$probability = round(p, 4)

saveRDS(full_trigrams,"complete_bigrams_probability.rds")

fg = readRDS("sample_fourgram_discount.rds")
fg_leftOverProb = readRDS("sample_fourgram_lop.rds")
full_fourgrams = readRDS("full_fourgrams.rds")

# Not opting for parallel processing due to memory 
full_fourgrams = full_fourgrams[,.(probability = calcProbFourgram(fourgram)), by = fourgram]

fiveg = readRDS("sample_fivegram_discount.rds")
fiveg_leftOverProb = readRDS("sample_fivegram_lop.rds")
full_fivegrams = readRDS("full_fivegrams.rds")

full_fivegrams = full_fivegrams[,.(probability = calcProbFivegram(fivegram)), by = fivegram]