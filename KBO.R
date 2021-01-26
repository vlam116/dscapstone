library(data.table);library(stringr)

sepWords = function(input){
  # Initialize empty vectors
  firstWords = c()
  lastWord = c()
  
  # Fetching position of spaces in the input string
  spaces = gregexpr(" ", input)[[1]]
  lastSpace = spaces[length(spaces)]
  
  for(i in 1:length(input)){
    firstWords[i] = substr(input[i], 1, lastSpace-1)
    lastWord[i] = substr(input[i], lastSpace+1, nchar(input[i]))
  }
  
  list(firstWords=firstWords, lastWord=lastWord)
  
}

getLastWords = function(input, n = 1){
  # Removing extra spaces and uppercases inputted by user
  input = gsub("[[:space:]]+", " ", str_trim(tolower(input)))
  
  # Separate into individual words
  words = unlist(strsplit(input, " "))
  
  if (length(words) < n){
    stop("Not enough terms!")
  }
  
  start = length(words)-n+1
  end = length(words)
  tempWords = words[start:end]
  
  paste(tempWords, collapse=" ")
}

calcProbFivegram = function(inputString){
  wordList = sepWords(getLastWords(inputString, n = 5))
  FW = wordList$firstWords
  LW = wordList$lastWord
  
  finalProb = -1
  
  FWMatches = fiveg[firstWords == FW]
  
  if(nrow(FWMatches) > 0){
    FullMatch = fiveg[firstWords == FW & lastWord == LW]
    if(nrow(FullMatch) > 0){
      allFreq = sum(FWMatches$frequency)
      finalProb = ((FullMatch$discount * FullMatch$frequency) / allFreq)
    } else {
      wordList = sepWords(getLastWords(inputString, n = 4))
      fgFW = wordList$firstWords
      fgLW = wordList$lastWord
      
      beta_leftoverprob = fiveg_leftOverProb[firstWords == FW]$leftoverprob
      
      fgFWMatches = fg[firstWords == fgFW]
      fgFullMatch = fg[firstWords == fgFW & lastWord == fgLW]
      
      if(nrow(fgFullMatch) > 0){
        fgFWMatches_Remain = fgFWMatches[!(fgFWMatches$lastWord %in% FWMatches$lastWord)]
        allFreq = sum(fgFWMatches$frequency)
        
        alpha = beta_leftoverprob / sum((fgFWMatches_Remain$frequency * fgFWMatches_Remain$discount) / allFreq)
        
        finalProb = alpha * ((fgFullMatch$frequency * fgFullMatch$discount) / allFreq)
      } else {
        wordList = sepWords(getLastWords(inputString, n = 3))
        tgFW = wordList$firstWords
        tgLW = wordList$lastWord
        
        tgFWMatches = tg[firstWords == tgFW]
        tgFullMatch = tg[firstWords == tgFW & lastWord == tgLW]
        
        if(nrow(tgFullMatch) > 0){
          tgFWMatches_Remain = tgFWMatches[!(tgFWMatches$lastWord %in% fgFWMatches$lastWord)]
          allFreq = sum(fgFWMatches$frequency)
          
          alpha = beta_leftoverprob / sum((tgFWMatches_Remain$frequency * tgFWMatches_Remain$discount) / allFreq)
          
          finalProb = alpha * ((tgFullMatch$frequency * tgFullMatch$discount) / allFreq)
        } else {
          wordList = sepWords(getLastWords(inputString, n = 2))
          bgFW = wordList$firstWords
          bgLW = wordList$lastWord
          
          bgFWMatches = bg[firstWord == bgFW]
          bgFullMatch = bg[firstWord == bgFW & lastWord == bgLW]
          
          if(nrow(bgFullMatch)> 0){
            bgFWMatches_Remain = bgFWMatches[!(bgFWMatches$lastWord %in% tgFWMatches$lastWord)]
            allFreq = sum(bgFWMatches$frequency)
            
            alpha = beta_leftoverprob / sum((bgFWMatches_Remain$frequency * bgFWMatches_Remain$discount) / allFreq)
            
            finalProb = alpha * ((bgFullMatch$frequency * bgFullMatch$discount) / allFreq)
          } else {
            ug = tks
            ugFullMatch = tks[token == bgLW]
            
            ug_Remain = ug[!(ug$token %in% bgFWMatches$lastWord)]
            allFreq = sum(ug$frequency)
            
            alpha = beta_leftoverprob / sum((ug_Remain$frequency * ug_Remain$discount) / allFreq)
            
            finalProb = alpha * ((ugFullMatch$frequency * ugFullMatch$discount) / allFreq)
            
            finalProb = sum(finalProb)
          }
        } 
      }
    }
  } 
  
  finalProb
  
}

calcProbFourgram = function(inputString){
  # Fetching words and preprocessing 
  wordList = sepWords(getLastWords(inputString, n = 4))
  fgFW = wordList$firstWords
  fgLW = wordList$lastWord
  
  finalProb = -1
  
  fgFirstMatch = fg[firstWords == fgFW]
  
  if (nrow(fgFirstMatch) > 0){
    # Check fourgrams for a match
    fgFullMatch = fg[firstWords == fgFW & lastWord == fgLW]
    if (nrow(fgFullMatch) > 0){
      allFreq = sum(fgFirstMatch$frequency)
      finalProb = ((fgFullMatch$discount * fgFullMatch$frequency) / allFreq)
    } else {
      # If no matches are found in fourgrams, check trigrams, bigrams and unigrams
      wordList = sepWords(getLastWords(inputString, n = 3))
      tgFW = wordList$firstWords
      tgLW = wordList$lastWord
      
      # Use left over probability calculated earlier to distribute to unseen words
      beta_leftoverprob = fg_leftOverProb[firstWords == fgFW]$leftoverprob
      
      tgFirstMatch = tg[firstWords == tgFW]
      tgFullMatch = tg[firstWords == tgFW & lastWord == tgLW]
      
      if (nrow(tgFullMatch) > 0){
        # Only check trigrams that did not previously appear in the fourgrams
        tgFirstMatch_Remain = tgFirstMatch[!(tgFirstMatch$lastWord %in% fgFirstMatch$lastWord)]
        allFreq = sum(tgFirstMatch$frequency)
        
        alpha = beta_leftoverprob / sum((tgFirstMatch_Remain$frequency * tgFirstMatch_Remain$discount) / allFreq)
        
        finalProb = alpha * ((tgFullMatch$frequency * tgFullMatch$discount ) / allFreq)
      } else {
        wordList = sepWords(getLastWords(inputString, n = 2))
        bgFW = wordList$firstWords
        bgLW = wordList$lastWord
        
        bgFirstMatch = bg[firstWord == bgFW]
        bgFullMatch = bg[firstWord == bgFW & lastWord == bgLW]
        
        if (nrow(bgFullMatch) > 0){
          # Only check bigrams that did not previously appear in the trigrams
          bgFirstMatch_Remain = bgFirstMatch[!(bgFirstMatch$lastWord) %in% tgFirstMatch$lastWord]
          allFreq = sum(bgFirstMatch$frequency)
          
          alpha = beta_leftoverprob / sum((bgFirstMatch_Remain$frequency * bgFirstMatch_Remain$discount) / allFreq)
          
          finalProb = alpha * ((bgFullMatch$frequency * bgFullMatch$discount) / allFreq)
        } else {
          # Last resort is to check unigrams
          ugFirstMatch = tks 
          ugFullMatch = tks[token == bgLW] 
          
          ugFirstMatch_Remain = ugFirstMatch[!(ugFirstMatch$token %in% bgFirstMatch$lastWord)]
          allFreq = sum(ugFirstMatch$frequency)
          
          alpha = beta_leftoverprob / sum((ugFirstMatch_Remain$frequency * ugFirstMatch_Remain$discount) / allFreq)
          
          finalProb = alpha * ((ugFullMatch$frequency * ugFullMatch$discount) / allFreq)
          
          finalProb = sum(finalProb)
        }
      }
    }
  } 
  
  finalProb
  
}

calcProbTG = function(inputString){
  # Fetching words and preprocessing 
  wordList = sepWords(getLastWords(inputString, n = 3))
  tgFW = wordList$firstWords
  tgLW = wordList$lastWord
  
  finalProb = -1
  
  tgFirstMatch = tg[firstWords == tgFW]
  
  if (nrow(tgFirstMatch) > 0){
    # Check trigrams for a match
    tgFullMatch = tg[firstWords == tgFW & lastWord == tgLW]
    if (nrow(tgFullMatch) > 0){
      allFreq = sum(tgFirstMatch$frequency)
      finalProb = ((tgFullMatch$discount * tgFullMatch$frequency) / allFreq)
    } else {
      # If no matches are found in trigrams, check bigrams and unigrams
      wordList = sepWords(getLastWords(inputString, n = 2))
      bgFW = wordList$firstWords
      bgLW = wordList$lastWord
      
      # Use left over probability calculated earlier to distribute to unseen words
      beta_leftoverprob = tg_leftOverProb[firstWords == tgFW]$leftoverprob
      
      bgFirstMatch = bg[firstWord == bgFW]
      bgFullMatch = bg[firstWord == bgFW & lastWord == bgLW]
      
      if (nrow(bgFullMatch) > 0){
        # Only check bigrams that did not previously appear in the trigrams
        bgFirstMatch_Remain = bgFirstMatch[!(bgFirstMatch$lastWord %in% tgFirstMatch$lastWord)]
        allFreq = sum(bgFirstMatch$frequency)
        
        alpha = beta_leftoverprob / sum((bgFirstMatch_Remain$frequency * bgFirstMatch_Remain$discount) / allFreq)
        
        finalProb = alpha * ((bgFullMatch$frequency * bgFullMatch$discount ) / allFreq)
      } else {
        
        # Last resort is to check unigrams
        ugFirstMatch = tks 
        ugFullMatch = tks[token == bgLW] 
        
        ugFirstMatch_Remain = ugFirstMatch[!(ugFirstMatch$token %in% tgFirstMatch$lastWord)]
        allFreq = sum(ugFirstMatch$frequency)
        
        alpha = beta_leftoverprob / sum((ugFirstMatch_Remain$frequency * ugFirstMatch_Remain$discount) / allFreq)
        
        finalProb = alpha * ((ugFullMatch$frequency * ugFullMatch$discount) / allFreq)
        
        finalProb = sum(finalProb)
        
      }
    }
  } 
  
  finalProb
  
}

calcProbBG = function(inputString){
  # Fetching words and preprocessing 
  wordList = sepWords(getLastWords(inputString, n = 2))
  bgFW = wordList$firstWords
  bgLW = wordList$lastWord
  
  finalProb = -1
  
  bgFirstMatch = bg[firstWord == bgFW]
  
  if (nrow(bgFirstMatch) > 0){
    # Check bigrams for a complete match
    bgFullMatch = bg[firstWord == bgFW & lastWord == bgLW]
    if (nrow(bgFullMatch) > 0){
      allFreq = sum(bgFirstMatch$frequency)
      finalProb = ((bgFullMatch$discount * bgFullMatch$frequency) / allFreq)
    } else {
      # If no matches are found in bigrams, check unigrams
      # Use left over probability calculated earlier to distribute to unseen words
      beta_leftoverprob = bg_leftOverProb[firstWord == bgFW]$leftoverprob
      ugFirstMatch = tks 
      ugFullMatch = tks[token == bgLW] 
        
      ugFirstMatch_Remain = ugFirstMatch[!(ugFirstMatch$token %in% bgFirstMatch$lastWord)]
      allFreq = sum(ugFirstMatch$frequency)
        
      alpha = beta_leftoverprob / sum((ugFirstMatch_Remain$frequency * ugFirstMatch_Remain$discount) / allFreq)
        
      finalProb = alpha * ((ugFullMatch$frequency * ugFullMatch$discount) / allFreq)
      
      finalProb = sum(finalProb)
      
    }
  }
  
  finalProb
  
}

# For single word probabilities we will just use the MLE.




