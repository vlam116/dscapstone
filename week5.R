library(lexRankr);library(quanteda);library(tidyr);library(data.table)

blogs = readLines("en_US.blogs.txt")
sampleLength = length(blogs)*0.5
s = sample(length(blogs),sampleLength)
blogSample = blogs[s]
write(blogSample,"blogSample.txt")


news = readLines("en_US.news.txt")
sampleLength = length(news)*0.5
s = sample(length(news), sampleLength)
newsSample = news[s]
write(newsSample, "newsSample.txt")


twitter = readLines("en_US.twitter.txt")
sampleLength = length(twitter)*0.5
s = sample(length(twitter), sampleLength)
twitterSample = twitter[s]
write(twitterSample, "twitterSample.txt")

blog = readLines("blogSample.txt")
twitter = readLines("twitterSample.txt")
news = readLines("newsSample.txt")

news = iconv(news, "latin1", "ASCII", sub = "") #removing non-ASCII characters
news = tolower(news) #changing all letters to lowercase
news = gsub("[0-9]","",news) #removing numbers
news = gsub("http[^ ]*|www.[^ ]*", "",news) #removing links
news = trimws(news, "both") #removing excess whitespace at the start/end of lines
news = gsub("\\s+"," ",news) #removing excess whitespace between words
news = sentenceParse(news, docId = "create") #creating sentences
news = news[,3] #keeping only the text column 

twitter = iconv(twitter, "latin1", "ASCII", sub = "")
twitter = tolower(twitter)
twitter = gsub("[0-9]","",twitter)
twitter = gsub("http[^ ]*|www.[^ ]*", "",twitter)
twitter = trimws(twitter, "both")
twitter = gsub("\\s+"," ",twitter)
twitter = sentenceParse(twitter, docId = "create")
twitter = twitter[,3]

blog = iconv(blog, "latin1", "ASCII", sub = "")
blog = tolower(blog)
blog = gsub("[0-9]","",blog)
blog = gsub("http[^ ]*|www.[^ ]*", "",blog)
blog = trimws(blog, "both")
blog = gsub("\\s+"," ",blog)
blog = sentenceParse(blog, docId = "create")
blog = blog[,3]

s = readLines("profanity.txt") #using a list of offensive terms filtered by google

#create vector of lines to remove from texts that contain swears
LinesToRemoveBlog = grep(paste(s,collapse = "|"), blog) 
LinesToRemoveTwitter = grep(paste(s,collapse = "|"), twitter) 
LinesToRemoveNews = grep(paste(s,collapse = "|"), news) 

blog = blog[-LinesToRemoveBlog]
twitter = twitter[-LinesToRemoveTwitter]
news = news[-LinesToRemoveNews]

#naming sentences to create corpus object
bc = corpus(blog, docnames = paste0("blog_sentence_",1:length(blog)))
tc = corpus(twitter, docnames = paste0("tweet_sentence",1:length(twitter)))
nc = corpus(news, docnames = paste0("news_sentence_",1:length(news)))

#combining into one corpus
full_corpus = bc + tc + nc 

#tokenizing corpus and creating ngrams 

tks = tokens(full_corpus, what = "word", remove_punct = TRUE)

dfmat_tks = dfm(tks)

dfmat_tks = textstat_frequency(dfmat_tks)

dfmat_tks = as.data.table(dfmat_tks)

dfmat_tks = dfmat_tks[,-(3:5)]

dfmat_tks = setnames(dfmat_tks, old = "feature", new = "token")

bigrams = tokens_ngrams(tks, n = 2L, concatenator = " ")

dfmat_bigrams = dfm(bigrams)

dfmat_bigrams = textstat_frequency(dfmat_bigrams)

dfmat_bigrams = as.data.table(dfmat_bigrams)

dfmat_bigrams = dfmat_bigrams[,-(3:5)]

dfmat_bigrams = setnames(dfmat_bigrams, old = "feature", new = "bigram")

trigrams = tokens_ngrams(tks, n = 3L, concatenator = " ")

dfmat_trigrams = dfm(trigrams)

dfmat_trigrams = textstat_frequency(dfmat_trigrams)

dfmat_trigrams = as.data.table(dfmat_trigrams)

dfmat_trigrams = dfmat_trigrams[,-(3:5)]

dfmat_trigrams = setnames(dfmat_trigrams, old = "feature", new = "trigram")

fourgrams = tokens_ngrams(tks, n = 4L, concatenator = " ")

dfmat_fourgrams = dfm(fourgrams)

dfmat_fourgrams = textstat_frequency(dfmat_fourgrams)

dfmat_fourgrams = as.data.table(dfmat_fourgrams)

dfmat_fourgrams = dfmat_fourgrams[,1:2]

dfmat_fourgrams = setnames(dfmat_fourgrams, old = "feature", new = "fourgram")

fivegrams = tokens_ngrams(tks, n = 5L, concatenator = " ")

dfmat_fivegrams = dfm(fivegrams)

dfmat_fivegrams = textstat_frequency(dfmat_fivegrams)

dfmat_fivegrams = as.data.table(dfmat_fivegrams)

dfmat_fivegrams = dfmat_fivegrams[,1:2]

dfmat_fivegrams = setnames(dfmat_fivegrams, old = "feature", new = "fivegram")

### Creating columns for first/last words

dfmat_bigrams$firstWord = rep(1, nrow(dfmat_bigrams))
dfmat_bigrams$lastWord = rep(1, nrow(dfmat_bigrams))

bg = dfmat_bigrams$bigram

rp = c()
rp$firstWord = rep(1, length(bg))
rp$lastWord = rep(1, length(bg))
for(i in 1:length(rp$firstWord)){
  rep = sepWords(bg[i])
  rp$firstWord[i] = rep$firstWords
  rp$lastWord[i] = rep$lastWord
}

dfmat_bigrams$firstWord = rp$firstWord
dfmat_bigrams$lastWord = rp$lastWord

saveRDS(dfmat_bigrams, "sample_bigrams.rds")

dfmat_trigrams$firstWords = rep(1, nrow(dfmat_trigrams))
dfmat_trigrams$lastWord = rep(1, nrow(dfmat_trigrams))

tg = dfmat_trigrams$trigram

rp = c()
rp$firstWords = rep(1, length(tg))
rp$lastWord = rep(1, length(tg))
for(i in 1:length(rp$firstWords)){
  rep = sepWords(tg[i])
  rp$firstWords[i] =  rep$firstWords
  rp$lastWord[i] = rep$lastWord
}

dfmat_trigrams$firstWords = rp$firstWords
dfmat_trigrams$lastWord = rp$lastWord

saveRDS(dfmat_trigrams, "sample_trigrams.rds")

dfmat_fourgrams$firstWords = rep(1, nrow(dfmat_fourgrams))
dfmat_fourgrams$lastWord = rep(1, nrow(dfmat_fourgrams))

firstWords = c()
lastWord =  c()

for(i in 1:nrow(dfmat_fourgrams)){
  firstWords[i] = sepWords(dfmat_fourgrams$fourgram[i])$firstWords
  lastWord[i] = sepWords(dfmat_fourgrams$fourgram[i])$lastWord
}

dfmat_fourgrams$firstWords = firstWords
dfmat_fourgrams$lastWord = lastWord

saveRDS(dfmat_fourgrams, "sample_fourgrams.rds")

dfmat_fivegrams$firstWords = rep(1, nrow(dfmat_fivegrams))
dfmat_fivegrams$lastWord = rep(1, nrow(dfmat_fivegrams))

firstWords = c()
lastWord = c()

for(i in 1:nrow(dfmat_fivegrams)){
  firstWords[i] = sepWords(dfmat_fivegrams$fivegram[i])$firstWords
  lastWord[i] = sepWords(dfmat_fivegrams$fivegram[i])$lastWord
}

dfmat_fivegrams$firstWords = firstWords
dfmat_fivegrams$lastWord = lastWord

saveRDS(dfmat_fivegrams, "sample_fivegrams.rds")