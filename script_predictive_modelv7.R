##################### CAPSTONE - Prediction model

##### packages
library(quanteda) 
library(readr)
library(ggplot2)
library(tidyr)
library(stringr)
library(dplyr)

##### load data
df_1gram <- read_csv("KN_1gram")
df_2gram <- read_csv("KN_2gram")
df_3gram <- read_csv("KN_3gram")
df_4gram <- read_csv("KN_4gram")

profanity <- read_csv("Profanity/full-list-of-bad-words-banned-by-google.csv", 
                      col_names = FALSE)


###### build prediction function
predict_word <- function(text) {
  
  # clean input text
  text <- tolower(text)
  text <- str_replace_all(text, "[[:punct:]]", "")
  
  # count number of words in text input
  numb_of_words <- str_count(text, '\\w+')
  
  # extract words from text input, focus on last 3 words max
  word1 <- strsplit(text, " ")[[1]][numb_of_words-2]
  word2 <- strsplit(text, " ")[[1]][numb_of_words-1]
  word3 <- strsplit(text, " ")[[1]][numb_of_words-0]
  
  # check on bad behavior
  if(any(strsplit(text, " ")[[1]][1:numb_of_words] %in% profanity$X1) == TRUE) {
    results <- "please do not swear in front of the kids"
    numb_of_words <- 0
  }
  
  # run code for 3 or more input words
  if(numb_of_words >= 3) {
    
    # check 4-grams
    test_4gram <- paste0(word1,"_",word2,"_",word3)
    result_4gram <- subset(df_4gram, minuslast == test_4gram)
    
    # check 3-grams
    test_3gram <- paste0(word2,"_",word3)
    result_3gram <- subset(df_3gram, minuslast == test_3gram)
    
    #check 2-grams
    test_2gram <- paste0(word3)
    result_2gram <- subset(df_2gram, minuslast == test_2gram)
    
    # combine and arrange 4,3,2 grams
    results <- rbind(result_4gram, result_3gram, result_2gram)
    results <- arrange(results, desc(KN_P))
    results <- unique(results$lastword)[1:3]
  }
  
  if(numb_of_words >= 2) {
    
    # check 3-grams
    test_3gram <- paste0(word2,"_",word3)
    result_3gram <- subset(df_3gram, minuslast == test_3gram)
    
    #check 2-grams
    test_2gram <- paste0(word3)
    result_2gram <- subset(df_2gram, minuslast == test_2gram)
    
    # combine and arrange 3,2 grams
    results <- rbind(result_3gram, result_2gram)
    results <- arrange(results, desc(KN_P))
    results <- unique(results$lastword)[1:3]
  }
  
  if(numb_of_words >= 1) {
    
    #check 2-grams
    test_2gram <- paste0(word3)
    result_2gram <- subset(df_2gram, minuslast == test_2gram)
    
    # combine and arrange 3,2 grams
    results <- result_2gram
    results <- arrange(results, desc(KN_P))
    results <- unique(results$lastword)[1:3]
  }
  
   # replace NA with highest scoring 1grams
    results[is.na(results)] <- c("the", "to", "and")

  # return top 3
    return(results)
}


###### predict some examples
predict_word("we will do this next")
predict_word("my dear, i")
predict_word("I am going to the united")
predict_word("I like manchester") # here they still top the table ;)
predict_word("let me take")
predict_word("what if")
predict_word("ok")
predict_word("coursera courses are very")
predict_word("ndknd ksfkj lkjdjodw")

##### and some special cases 
predict_word("No i WONT !!!")
predict_word("this project is shit")

#### and unknowns
predict_word("mijn hond is lief")

test[1]

