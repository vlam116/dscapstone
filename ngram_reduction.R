library(data.table);library(stringr);library(tidyr)

# Removing n-grams observed less than 4 times in the corpus for efficiency purposes.

bg = readRDS("bg_Prob.rds")

bg = bg[frequency > 3]

toRemoveFW = grep("^\\W", bg$firstWord)
toRemoveLW = grep("^\\W", bg$lastWord)

bg = bg[-c(toRemoveFW,toRemoveLW)]

saveRDS(bg, "bg_Prob.rds")

tg = readRDS("tg_Prob.rds")

tg = tg[frequency > 3]

toRemoveFW = grep("^\\W", tg$firstWords)
toRemoveLW = grep("^\\W", tg$lastWord)

tg = tg[-c(toRemoveFW, toRemoveLW)]

saveRDS(tg, "tg_Prob.rds")

fg = readRDS("fg_Prob.rds")

fg = fg[frequency > 3]

toRemoveFW = grep("^\\W", fg$firstWords)
toRemoveLW = grep("^\\W", fg$lastWord)

fg = fg[-c(toRemoveFW, toRemoveLW)]

saveRDS(fg, "fg_Prob.rds")

fivegram = readRDS("fiveg_Prob.rds")

fivegram = fivegram[frequency > 3]

toRemoveFW = grep("^\\W", fivegram$firstWords)
toRemoveLW = grep("^\\W", fivegram$lastWord)

fivegram = fivegram[-c(toRemoveFW, toRemoveLW)]

saveRDS(fivegram, "fiveg_Prob.rds")