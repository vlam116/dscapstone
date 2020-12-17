library(parallel);library(doParallel);library(tidytext);library(dplyr);library(ggplot2);library(lexRankr)
library(quanteda);library(tidyr)

cluster = makeCluster(detectCores()-1)
registerDoParallel(cluster)
stopCluster(cluster)
registerDoSEQ()

### TEXT CLEANING *** CREATING CORPUS *** TOKENIZING TEXT *** GENERATING NGRAMS ###

blog = readLines("en_US.blogs1.txt")
twitter = readLines("en_US.twitter1.txt")
news = readLines("en_US.news1.txt")

sum(nchar(blog)) #no.words
length(blog) #no.lines
max(nchar(blog)) #length of longest line
mean(nchar(blog)) # mean line length
min(nchar(blog)) #length of shortest line

news = iconv(news, "latin1", "ASCII", sub = "") #removing non-ASCII characters
news = tolower(news) #changing all letters to lowercase
news = gsub("[0-9]","",news) #removing numbers
news = gsub("http[^ ]*|www.[^ ]*", "",news) #removing links
news = trimws(news, "both") #removing excess whitespace at the start/end of lines
news = gsub("\\s+"," ",news) #removing excess whitespace between words
news = gsub("'","",news) #removing apostrophes 
news = sentenceParse(news, docId = "create") #creating sentences
news = news[,3] #keeping only the text column 

twitter = iconv(twitter, "latin1", "ASCII", sub = "")
twitter = tolower(twitter)
twitter = gsub("[0-9]","",twitter)
twitter = gsub("http[^ ]*|www.[^ ]*", "",twitter)
twitter = trimws(twitter, "both")
twitter = gsub("\\s+"," ",twitter)
twitter = gsub("'","",twitter)
twitter = sentenceParse(twitter, docId = "create")
twitter = twitter[,3]

blog = iconv(blog, "latin1", "ASCII", sub = "")
blog = tolower(blog)
blog = gsub("[0-9]","",blog)
blog = gsub("http[^ ]*|www.[^ ]*", "",blog)
blog = trimws(blog, "both")
blog = gsub("\\s+"," ",blog)
blog = gsub("'","",blog)
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

#converting to tidy format
fc_tidy = tidy(full_corpus)

#tokenizing corpus and creating ngrams 2:5

tokens = fc_tidy %>% 
    unnest_tokens(word, text) %>%
    count(word, sort = TRUE)

#plotting 15 most common words
g = ggplot(head(tokens,15), aes(x = reorder(word,n), y = n)) 
g + geom_bar(stat = "identity", fill = "red") +
    geom_text(aes(label=n), vjust = -0.3, size = 3) +
    xlab("Unigram") +
    ylab("Frequency") +
    ggtitle("Top 15 Unigram Frequencies") + 
    theme(plot.title = element_text(hjust = 0.5))

bigrams = fc_tidy %>%
    unnest_tokens(bigram, text, token = "ngrams", n = 2) 

bigrams_sep = bigrams %>%
    separate(bigram, c("w1","w2"), sep = " ") %>%
    count(w1, w2, sort = TRUE)

trigrams = fc_tidy %>%
    unnest_tokens(trigram, text, token = "ngrams", n = 3) 

trigrams_sep = trigrams %>%
    separate(trigram, c("w1","w2","w3"), sep = " ") %>%
    count(w1, w2, w3, sort = TRUE)

fourgrams = fc_tidy %>%
    unnest_tokens(fourgram, text, token = "ngrams", n = 4) 

fivegrams = fc_tidy %>%
    unnest_tokens(fivegram, text, token = "ngrams", n = 5) 
