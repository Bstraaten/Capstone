##################### CAPSTONE - Smoothing N-grams

# http://smithamilli.com/blog/kneser-ney/
# https://nlp.stanford.edu/~wcmac/papers/20050421-smoothing-tutorial.pdf
# https://stringr.tidyverse.org/reference/word.html
# http://www.foldl.me/2014/kneser-ney-smoothing/
# https://stats.stackexchange.com/questions/246011/a-simple-numerical-example-for-kneser-ney-smoothing
# https://www.youtube.com/watch?v=ody1ysUTD7o
# https://tutorials.quanteda.io/


## packages
library(quanteda) 
library(readr)
library(ggplot2)
library(tidyr)
library(stringr)
library(dplyr)

################# load data and filter freq > 1
df_1gram <- read_csv("df_ngram_train_1_v2")
df_1gram <- filter(df_1gram, frequency >1)

df_2gram <- read_csv("df_ngram_train_2_v2")
df_2gram <- filter(df_2gram, frequency >1)

df_3gram <- read_csv("df_ngram_train_3_v2")
df_3gram <- filter(df_3gram, frequency >1)

df_4gram <- read_csv("df_ngram_train_4_v2")
df_4gram <- filter(df_4gram, frequency >1)


################# calculate non smoothed P
df_1gram$NS_P <- df_1gram$frequency / sum(df_1gram$frequency)
df_2gram$NS_P <- df_2gram$frequency / sum(df_2gram$frequency)
df_3gram$NS_P <- df_3gram$frequency / sum(df_3gram$frequency)
df_4gram$NS_P <- df_4gram$frequency / sum(df_4gram$frequency)


##### calculate KN_P for 4_gram

## set d
d_4 <- 0

## FirstTerm
df_4gram$lastword <- word(df_4gram$feature, sep = "_", -1) # extract last word from 4_gram
df_4gram$minuslast <- word(df_4gram$feature, sep = "_", 1, -2) # extract first 3 words from 4_gram
freq.minuslast <- group_by(df_4gram[,c(2,5)], minuslast)
freq.minuslast <- summarise(freq.minuslast, sum.freq.minuslast = sum(frequency))
df_4gram <- merge(df_4gram, freq.minuslast, by.x = 'minuslast', by.y = 'minuslast', all.x = TRUE)
df_4gram$firstterm <- (df_4gram$frequency - d_4) / df_4gram$sum.freq.minuslast

### lambda
dif.lastword <- as.data.frame(table(df_4gram$lastword))
df_4gram <- merge(df_4gram, dif.lastword, by.x = 'lastword', by.y = 'Var1', all.x = TRUE)
df_4gram <- rename(df_4gram, freq.lastword = Freq)
df_4gram$lambda <- d_4 / df_4gram$sum.freq.minuslast * df_4gram$freq.lastword

## Pcontinuation
dif.minuslast <- as.data.frame(table(df_4gram$minuslast))
df_4gram <- merge(df_4gram, dif.minuslast, by.x = 'minuslast', by.y = 'Var1', all.x = TRUE)
df_4gram <- rename(df_4gram, freq.minuslast = Freq)
df_4gram$Pcontinuation <- df_4gram$freq.minuslast / nrow(df_4gram)

## KN propability
df_4gram$KN_P <- df_4gram$firstterm + df_4gram$lambda * df_4gram$Pcontinuation


##### calculate KN_P for 3_gram

## set d
d_3 <- 0.75

## FirstTerm
df_3gram$lastword <- word(df_3gram$feature, sep = "_", -1) # extract last word from 3_gram
df_3gram$minuslast <- word(df_3gram$feature, sep = "_", 1, -2) # extract first 2 words from 3_gram
freq.minuslast <- group_by(df_3gram[,c(2,5)], minuslast)
freq.minuslast <- summarise(freq.minuslast, sum.freq.minuslast = sum(frequency))
df_3gram <- merge(df_3gram, freq.minuslast, by.x = 'minuslast', by.y = 'minuslast', all.x = TRUE)
df_3gram$firstterm <- (df_3gram$frequency - d_3) / df_3gram$sum.freq.minuslast

### lambda
dif.lastword <- as.data.frame(table(df_3gram$lastword))
df_3gram <- merge(df_3gram, dif.lastword, by.x = 'lastword', by.y = 'Var1', all.x = TRUE)
df_3gram <- rename(df_3gram, freq.lastword = Freq)
df_3gram$lambda <- d_3 / df_3gram$sum.freq.minuslast * df_3gram$freq.lastword

## Pcontinuation
dif.minuslast <- as.data.frame(table(df_3gram$minuslast))
df_3gram <- merge(df_3gram, dif.minuslast, by.x = 'minuslast', by.y = 'Var1', all.x = TRUE)
df_3gram <- rename(df_3gram, freq.minuslast = Freq)
df_3gram$Pcontinuation <- df_3gram$freq.minuslast / nrow(df_3gram)

## KN propability
df_3gram$KN_P <- df_3gram$firstterm + df_3gram$lambda * df_3gram$Pcontinuation



##### calculate KN_P for 2_gram

## set d
d_2 <- 0.75

## FirstTerm
df_2gram$lastword <- word(df_2gram$feature, sep = "_", -1) # extract last word from 3_gram
df_2gram$minuslast <- word(df_2gram$feature, sep = "_", 1, -2) # extract first 2 words from 3_gram
freq.minuslast <- group_by(df_2gram[,c(2,5)], minuslast)
freq.minuslast <- summarise(freq.minuslast, sum.freq.minuslast = sum(frequency))
df_2gram <- merge(df_2gram, freq.minuslast, by.x = 'minuslast', by.y = 'minuslast', all.x = TRUE)
df_2gram$firstterm <- (df_2gram$frequency - d_3) / df_2gram$sum.freq.minuslast

### lambda
dif.lastword <- as.data.frame(table(df_2gram$lastword))
df_2gram <- merge(df_2gram, dif.lastword, by.x = 'lastword', by.y = 'Var1', all.x = TRUE)
df_2gram <- rename(df_2gram, freq.lastword = Freq)
df_2gram$lambda <- d_3 / df_2gram$sum.freq.minuslast * df_2gram$freq.lastword

## Pcontinuation
dif.minuslast <- as.data.frame(table(df_2gram$minuslast))
df_2gram <- merge(df_2gram, dif.minuslast, by.x = 'minuslast', by.y = 'Var1', all.x = TRUE)
df_2gram <- rename(df_2gram, freq.minuslast = Freq)
df_2gram$Pcontinuation <- df_2gram$freq.minuslast / nrow(df_2gram)

## KN propability
df_2gram$KN_P <- df_2gram$firstterm + df_2gram$lambda * df_2gram$Pcontinuation


##### calculate KN_P for 1_gram

## set d
d_1 <- 0.75

## FirstTerm
df_1gram$lastword <- df_1gram$feature  # last word 1 gram = featue
df_1gram$minuslast <- df_1gram$feature # minus last word 1 gram = featue
freq.minuslast <- group_by(df_1gram[,c(2,5)], minuslast)
freq.minuslast <- summarise(freq.minuslast, sum.freq.minuslast = sum(frequency))
df_1gram <- merge(df_1gram, freq.minuslast, by.x = 'minuslast', by.y = 'minuslast', all.x = TRUE)
df_1gram$firstterm <- (df_1gram$frequency - d_3) / df_1gram$sum.freq.minuslast

### lambda
dif.lastword <- as.data.frame(table(df_1gram$lastword))
df_1gram <- merge(df_1gram, dif.lastword, by.x = 'lastword', by.y = 'Var1', all.x = TRUE)
df_1gram <- rename(df_1gram, freq.lastword = Freq)
df_1gram$lambda <- d_3 / df_1gram$sum.freq.minuslast * df_1gram$freq.lastword

## Pcontinuation IS COUNT OF 1GRAM
dif.minuslast <- as.data.frame(table(df_1gram$minuslast))
df_1gram <- merge(df_1gram, dif.minuslast, by.x = 'minuslast', by.y = 'Var1', all.x = TRUE)
df_1gram <- rename(df_1gram, freq.minuslast = Freq)
df_1gram$Pcontinuation <- df_1gram$freq.minuslast / nrow(df_1gram)

## KN propability
df_1gram$KN_P <- df_1gram$firstterm + df_1gram$lambda * df_1gram$Pcontinuation


##### clean
remove(dif.lastword)
remove(dif.minuslast)
remove(freq.minuslast)

##### trim
KN_1gram <- select(df_1gram, minuslast, lastword, KN_P)
KN_2gram <- select(df_2gram, minuslast, lastword, KN_P)
KN_3gram <- select(df_3gram, minuslast, lastword, KN_P)
KN_4gram <- select(df_4gram, minuslast, lastword, KN_P)

##### export KN_P_ngrams
write_csv(KN_1gram, "C:/Users/bstraate/Documents/R/Files/Capstone/KN_1gram")
write_csv(KN_2gram, "C:/Users/bstraate/Documents/R/Files/Capstone/KN_2gram")
write_csv(KN_3gram, "C:/Users/bstraate/Documents/R/Files/Capstone/KN_3gram")
write_csv(KN_4gram, "C:/Users/bstraate/Documents/R/Files/Capstone/KN_4gram")


