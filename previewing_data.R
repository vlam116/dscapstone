library(quanteda);library(readtext)

blog1 = readLines("en_US.blogs1.txt")
blog1 = tolower(blog1)
cor1 = corpus(blog1)

swears = readLines("profanity.txt")

dfm1 = dfm(cor1,
           remove = swears,
           stem = TRUE)

sort(colSums(dfm1), decreasing = T)

blog = readLines("en_US.blogs.txt")
length(blog)

twitter = readLines("en_US.twitter.txt")
length(twitter)

news = readLines("en_US.news.txt")
length(news)

max(nchar(news))
max(nchar(blog))
max(nchar(twitter))

length(grep("love",twitter))/length(grep("hate",twitter))

grep("biostats",twitter)
twitter[556872]

grep("A computer once beat me at chess, but it was no match for me at kickboxing",twitter)
twitter[519059]

length(news)
length(twitter)

createSamples = function(x){
  y = readLines(x)
  l = length(y)/10
  for(i in 1:10){
    s = sample(length(y),l)
    y1 = y[s]
    y = y[-s]
    write(y1,paste0("test",i,".txt",sep=""))
  }
}
