# JHU Data Science Specialization Capstone
This repository contains the R scripts used to perform various text data mining operations required to create the data files utilized in my Next Word Prediction [App](https://vtlam116.shinyapps.io/NextWordPrediction/). 

The original text files are part of the course, which can be found [here](https://www.coursera.org/specializations/data-science-statistics-machine-learning). Each of the three files contains texts taken from a variety of web blogs, news articles, and tweets.


A short summary of each file:
* Week1: 
    * Reading in and looking at the data and getting familiar with textual data structures
    * Taking note of the number of lines and characters in each text file
    * Wrote a function for splitting each text file into smaller chunks to test data mining functions in the future to avoid long runtimes
    * New packages used: quanteda, readtext
* Week2:
    * Exploratory data analysis with 10% of the dataset.      
    * Tokenizing text then visualizing most common words/tokens with a word cloud and analyzing token counts
    * Calculating type/token ratio (TTR), generating n-grams and plotting n-gram frequencies from a corpus containing text samples from each source (from Week1) 
* Week 3:
    * Testing the majority of text data mining and preprocessing operations, primarily text cleaning on a small subset of the data before preparing the actual training set
    * Creating sentences from cleaned text, tokenizing, and forming n-gram data tables
* Week5: 
    * Performing text preprocessing operations on a randomly sampled training set comprised of 50% of the original data and creating sentences from cleaned text
    * Combining sentences into a single corpus, tokenizing, and extracting n-grams 1:5 
    * Summing up frequencies of all n-grams and separating n-grams into "first word(s)" and "last word" elements
    * Finalizing base n-gram tables to contain the full n-gram, the first n words of the n-gram, the last word of the n-gram, and the n-gram's observed frequency
    * New packages used: lexRankr, data.table
* Week5pt2: 
    * Preparing to implement Katz's back-off model with Good-Turing smoothing, which requires calculating discount factors for n-grams and left over probability mass for the n-1-grams 
    * Calculating discount coefficients for n-grams with frequency counts below six and left over probability mass for reliably observed n-grams
    * Appending discount coefficient column to existing n-gram tables 
    * New tables created for storing n-grams and their respective left over probability
* Backoff_algorithm: 
    * Implementation of Katz's back-off model for calculating the probabilities of n-grams 2:5
    * Created two support functions for separating a string into a list containing a "first words" and "last word" element (used to identify what order n-gram) and getting the last words of a string (used to iteratively back-off through shorter histories and ) 
    * Wrote functions implementing Katz's language model for calculating n-gram probabilities for n-gram orders 2:5 
* Completed_ngram_tables:
    * Formatting and finalizing data tables for usage in the R Shiny app
* predNextWord: 
    * Writing a function for matching user input to observed n-grams stored in finialized n-gram tables and returning the top five highest probability candidates
    * Function checks the highest order n-gram input by the user and searches each n-gram table as necessary (back-off) until at least five matches are found, otherwise if no matches are found it will always return the top five most common tokens


