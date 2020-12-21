

Next Word Prediction: Fast Generations. Simple to Use. Endless Applications.  
========================================================
author: Vin Lam
date: 12/18/2020
autosize: true


How Does the App Work?
========================================================

My Next Word Prediction App, which can be found [here](https://vtlam116.shinyapps.io/NextWordPrediction/),
is fast, memory efficient, and incredibly easy to use. Here is how:

- Click on the text box and type in any number of words you want
- The app will generate a table of predictions ordered from most likely to least likely according to the algorithm
- Below, the top candidate will appear in red next to the user's input

The App in Action!
========================================================
![](showcase.png)
![](showcase2.png)


Model Overview
========================================================

This app relies on look-up tables containing n-grams (a sequence of n number of words) split into a "first words" and "last word" component with an associated probability value calculated through Katz back-off with Good Turing smoothing. Without going too deep into the mathematical details, the algorithm works like this:

- Unigrams through 5-grams are extracted from a cleaned training corpus and their frequencies are counted and stored in look-up tables, one for each order n-gram
- The n-gram data collected enables implementation of the algorithm in R; n-gram probabilities are calculated by either using the n-gram's proportional maximum likelihood estimate OR by backing-off through progressively shorter histories of an n-gram 
- Katz's model allows probabilities for certain unseen n-grams in the testing set to be calculated from the training set by redistributing probability mass from observed n-grams
- Using the frequencies of each n-gram, a discount factor is calculated for the least frequently observed n-grams (n-grams with 5 or less frequency count) 
- Left over probability values are calculated from each n-gram table and stored in separate tables containing the first n-1 words of each n-gram and the left over probability associated with those n-1 words. 
- Probabilities are then calculated for every possible n-gram derived from the testing set using the back-off algorithm, which uses the n-gram frequencies, discount factors, and left over probabilities previously obtained

Model Performance and Possible Applications
========================================================

The predictive accuracy of the model was tested on an unseen corpus of tweets and blogs with the following results:

![](benchmarkresults.png)

Among other reported models, the accuracy is among the highest and memory usage is one of the lowest. Runtime was very conservatively estimated by having full CPU usage while running the benchmark. 

Next word prediction is a huge field in the Natural Language Processing field that has several applications with game changing impact.
- Google's predictive search bar that lets you find relevant information instantaneously 
- YouTube's predictive video search that shows old and currently popular searches, which provides data that is used to give a more customized user experience 
- Mobile messaging apps that give next word predictions that can be quickly selected, saving time and effort

This app can be easily built upon to fit your word predictive needs. Predicting multiple words at a time, using more powerful algorithms, improving model accuracy by expanding the training set, there are many possibilities. 


