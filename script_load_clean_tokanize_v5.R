##################### CAPSTONE - Load, Clean and Tokanize


## packages
library(quanteda) # https://tutorials.quanteda.io/introduction/r-commands/
library(readr)
library(ggplot2)
library(tidyr)
library(stringr)
library(dplyr)

################# load data
blogs <- read_delim("texts/en_US.blogs.txt",
                    "\t", escape_double = FALSE, col_names = FALSE,
                    trim_ws = TRUE)

news <- read_delim("texts/en_US.news.txt",
                   "\t", escape_double = FALSE, col_names = FALSE,
                   trim_ws = TRUE)

twitter <- read_delim("texts/en_US.twitter.txt",
                      "\t", escape_double = FALSE, col_names = FALSE,
                      trim_ws = TRUE)


# remove emojis to prevent problems down the line https://www.rdocumentation.org/packages/base/versions/3.5.1/topics/iconv
blogs$X1 <- iconv(blogs$X1, 'UTF-8', 'ASCII')
news$X1 <- iconv(news$X1, 'UTF-8', 'ASCII')
twitter$X1 <- iconv(twitter$X1, 'UTF-8', 'ASCII')

# remove blank rows
blogs <- blogs[which(is.na(blogs$X1) == FALSE), ]
news <- news[which(is.na(news$X1) == FALSE), ]
twitter <- twitter[which(is.na(twitter$X1) == FALSE), ]


## sample data, split to train and test set
set.seed(2018) # set seed for reproducibility

blogs <- blogs[sample(nrow(blogs), nrow(blogs) * .1), ] # take 10% of blog texts
index_blogs <- sample(nrow(blogs) * .6) # create index 60/40
train_blogs <- blogs[index_blogs,] # 60% to train set
test_blogs <- blogs[-index_blogs,] # 40% to test set

news <- news[sample(nrow(news), nrow(news) * 1), ] # take 100% of news texts
index_news <- sample(nrow(news) * .6) # create index 60/40
train_news <- news[index_news,] # 60% to train set
test_news <- news[-index_news,] # 40% to test set

twitter <- twitter[sample(nrow(twitter), nrow(twitter) * .05), ] # take 5% of twitter texts
index_twitter <- sample(nrow(twitter) * .6) # create index 60/40
train_twitter <- twitter[index_twitter,] # 60% to train set
test_twitter <- twitter[-index_twitter,] # 40% to test set

train <- rbind(train_blogs, train_news, train_twitter)
test <- rbind(test_blogs, test_news, test_twitter)

## create corpus with quanteda
corpus_train <- corpus(train, text_field = "X1")
corpus_test <- corpus(test, text_field = "X1")

## clean up space
remove(blogs); remove(news); remove(twitter)
remove(index_blogs); remove(index_news); remove(index_twitter)
remove(train_blogs); remove(train_news); remove(train_twitter)
remove(test_blogs); remove(test_news); remove(test_twitter)
remove(train); remove(test)
gc()


## load profanity data
profanity <- read_csv("Profanity/full-list-of-bad-words-banned-by-google.csv", 
                      col_names = FALSE)

## create dfm function
Dfm_ngram <- function(x, y) {
  
  dfm_xgram <- tokens(tolower(x),
                      remove_punct = TRUE, # removes punctuation
                      remove_numbers = TRUE, # removes numbers
                      remove_separators = TRUE, # removes seperators like '-'
                      remove_twitter = TRUE, # removes hashtags and 
                      remove_symbols = TRUE,
                      remove_url = TRUE)
  
# dfm_xgram <- tokens_remove(dfm_xgram, stopwords("english")) # removes prefefined stopwords
  dfm_xgram <- tokens_remove(dfm_xgram, profanity$X1) # and bad words in profanity file
  
  dfm_xgram <- dfm(dfm_xgram, ngrams = y)
  
  return(dfm_xgram)
  
}


## subset to freq (ignore all ngrams with frequency < than x)
freq <- 1

################## Create train set

## extract ngram freq table from dfm and subset to freq (ignore all ngrams with frequency < than x)
df_ngram_train_1 <- textstat_frequency(Dfm_ngram(corpus_train, 1))
df_ngram_train_1 <- select(df_ngram_train_1, feature, frequency)
df_ngram_train_1 <- filter(df_ngram_train_1, frequency >1)
write_csv(df_ngram_train_1, "C:/Users/bstraate/Documents/R/Files/Capstone/df_ngram_train_1_v2")

df_ngram_train_2 <- textstat_frequency(Dfm_ngram(corpus_train, 2))
df_ngram_train_2 <- select(df_ngram_train_2, feature, frequency)
df_ngram_train_2 <- filter(df_ngram_train_2, frequency >1)
write_csv(df_ngram_train_2, "C:/Users/bstraate/Documents/R/Files/Capstone/df_ngram_train_2_v2")

df_ngram_train_3 <- textstat_frequency(Dfm_ngram(corpus_train, 3))
df_ngram_train_3 <- select(df_ngram_train_3, feature, frequency)
df_ngram_train_3 <- filter(df_ngram_train_3, frequency >1)
write_csv(df_ngram_train_3, "C:/Users/bstraate/Documents/R/Files/Capstone/df_ngram_train_3_v2")

df_ngram_train_4 <- textstat_frequency(Dfm_ngram(corpus_train, 4))
df_ngram_train_4 <- select(df_ngram_train_4, feature, frequency)
df_ngram_train_4 <- filter(df_ngram_train_4, frequency >1)
write_csv(df_ngram_train_4, "C:/Users/bstraate/Documents/R/Files/Capstone/df_ngram_train_4_v2")


################## Create test set

df_ngram_test_4 <- textstat_frequency(Dfm_ngram(corpus_test, 4))
df_ngram_test_4 <- select(df_ngram_test_4, feature, frequency)
df_ngram_test_4 <- filter(df_ngram_test_4, frequency >1)
write_csv(df_ngram_test_4, "C:/Users/bstraate/Documents/R/Files/Capstone/df_ngram_test_4")

################## move to script 'predictive model'
