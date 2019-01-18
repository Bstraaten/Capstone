##################### CAPSTONE - shiny app

# https://shiny.rstudio.com/articles/build.html
# https://shiny.rstudio.com/images/shiny-cheatsheet.pdf


## packages
library(quanteda) 
library(readr)
library(ggplot2)
library(tidyr)
library(stringr)
library(dplyr)

library(shiny)
library(shinythemes)


############################################################# Load data

df_2gram <- read_csv("KN_2gram")
df_3gram <- read_csv("KN_3gram")
df_4gram <- read_csv("KN_4gram")

profanity <- read_csv("Profanity/full-list-of-bad-words-banned-by-google.csv", 
                      col_names = FALSE)

############################################################# Load prediction function
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

############################################################# define UI

library(shiny)
library(shinythemes)

###### build the user interface  ----

ui <- fluidPage(
  titlePanel("The rabbit word prediction algorithm"),
  
  # choose layout
  sidebarLayout(
    
    # create input and control panel
    sidebarPanel(
      textInput("text", 
                h4("Please enter text here"), 
                value = "coursera courses are very"),
      br(),
      radioButtons("radio", 
                   h4("Choose how many words to predict"),
                   choices = list("1 word" = 1, 
                                  "2 words" = 2,
                                  "3 words" = 3), 
                   selected = 1),
      br(),
      h4("Hit the predict button to see prediction"),
      submitButton("Predict")),
    
    
    # create output text box  
    mainPanel(
      p("This prediction algorithm is trained on twitter, news and blog texts.
        This data is preprocessed by constructing 1, 2, 3 en 4grams.
        The algorithm will take a maximum of 3 words from the text you provide.
        The model uses a back-off method with a so called",
        a("Kneser-Ney smoothing,",
          href = "http://smithamilli.com/blog/kneser-ney/"),
        "which means it will first  match your text with the highest ngram
        then 'back off' to lower ngrams. It will then choose the predictions with
        the highest Kneser-Ney propability. Since the algorithm is rapid I 
        included a rabbit as mascot."),
      br(),
      p(strong("some examples you can use:")),
      em("We will do this next, My dear I, I like manchester, Let me take, 
         What if, Ok, NO I WONT !!!, This project is shit"),
      br(),
      br(),
      br(),
      br(),
      p("--- your prediction ---", align = "center"),
      h2(textOutput("result1"), align = "center"),
      br(),
      br(),
      br(),
      img(src = "rabbit.png", height = 395, width = 435))
  )
)

###### Define server logic ----
server <- function(input, output) {
  
  output$result1 <- renderText({ 
    predict_word(input$text)[1:input$radio]
  })
  
}

# Run the app ----
shinyApp(ui = ui, server = server)

