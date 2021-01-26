library(quanteda);library(readtext);library(tidyverse);library(RColorBrewer)

blog1 = readLines("en_US.blogs1.txt")
cor1 = corpus(blog1)

swears = readLines("profanity.txt")

dfm1 = dfm(cor1,
           remove = swears,
           stem = TRUE,
           tolower = TRUE)

topfeatures(dfm1, 20)

set.seed(11)

textplot_wordcloud(dfm1, min_count = 1000, random_order = FALSE,
                   rotation = .25,
                   color = brewer.pal(8,"Dark2"))

blog = readtext("en_US.blogs1.txt")
blog_corpus = corpus(blog)

twitter = readtext("en_US.twitter1.txt")
twitter_corpus = corpus(twitter)

news = readtext("en_US.news1.txt")
news_corpus = corpus(news)

corpus = blog_corpus + twitter_corpus + news_corpus

txtDF = dfm(corpus,
            remove = swears,
            stem = TRUE,
            tolower = TRUE)

###

txtDF

rmStop = dfm(txtDF, 
             remove = stopwords("english"))

textstat_lexdiv(rmStop, measure = "TTR", remove_punct = TRUE)

textstat_lexdiv(txtDF, measure = "TTR", remove_punct = TRUE)

tks = tokens(corpus, remove_punct = TRUE)

length(unique(tks[[1]]))
length(unique(tks[[2]]))
length(unique(tks[[3]]))

textstat_frequency(rmStop, n = 20)

tks_ngrams = tokens_ngrams(tks, n=2:4)

tks_ngrams = dfm(tks_ngrams)

topfeatures(tks_ngrams, 20)

tks_2grams = tokens_ngrams(tks, n = 2)
tks_3grams = tokens_ngrams(tks, n = 3)

dfm_1gram = dfm(tks)
dfm_2grams = dfm(tks_2grams)
dfm_3grams = dfm(tks_3grams)

textplot_wordcloud(dfm_1gram, 
                   min_count = 1000, 
                   min_size = 2,
                   max_size = 8,
                   max_words = 100,
                   random_order = FALSE,
                   rotation = .25,
                   color = brewer.pal(8,"Dark2"))