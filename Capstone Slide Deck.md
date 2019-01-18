Capstone Slide Deck
========================================================
author: Boudewijn van Straaten  
date: 01-14-2019
autosize: true

<style>
.reveal .slides section .slideContent{
    font-size: 17pt;
}
</style>

Introduction
========================================================
This slide deck will introduce the final product for the capstone project of Coursera's data science specialiation.

The goal of the capstone project is to build a word prediction algorithm and a shiny application to enable non-technical users to use the word prediction algorithm.

To use the algorithm, please visit [the application](https://bstraaten.shinyapps.io/Capstone_app/)

To view all details of this project, please visit my [github](https://github.com/Bstraaten/Capstone)


Data transformations
========================================================
The algorithm is trained on samples of publicly available data from Twitter, News articles and Blog texts. The samples taken are:
- 100% of News articles
- 10% of blogs texts
- 5% of twitter tweets

Then, 60% of the above samples are allocated to the train set, 40% is allocated to the test set.

On these sample transformations have been done: the texts are cleaned from weird symbols, profanity is removed using Googles 'list of bad words', the text is tokanized and summarized into N-grams (sets of words).

On these data so called ['Kneser-Ney'](http://smithamilli.com/blog/kneser-ney/) smoothing is performed which -in short- takes previous words into account the number of contexts that the word(s) appear in.

The ngrams are stored in tables that are read by the model. This way the model will not have to compute the propabilities on the spot, this will increase performance drastically. To view all details of this project, please visit my [github](https://github.com/Bstraaten/Capstone)


Model and example output
========================================================
Simply put, the model looks for a match between the words it is given and the words in the data to find the most likely word to follow the given combination of words. 

It is constructed to start at the highest n-gram data (in this case 4-gram data) and to 'back-off' to lower n-gram data. It will then give us the 'follow-up' word with the highest propability in these 4,3 or 2-grams. If unsuccessful, the model will back off to the most likely 1-grams.

Some examples:

<table class="table" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> phrase </th>
   <th style="text-align:left;"> prediction_word1 </th>
   <th style="text-align:left;"> prediction_word2 </th>
   <th style="text-align:left;"> prediction_word3 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> We will do this next </td>
   <td style="text-align:left;"> year </td>
   <td style="text-align:left;"> to </td>
   <td style="text-align:left;"> week </td>
  </tr>
  <tr>
   <td style="text-align:left;"> My dear I </td>
   <td style="text-align:left;"> was </td>
   <td style="text-align:left;"> think </td>
   <td style="text-align:left;"> have </td>
  </tr>
  <tr>
   <td style="text-align:left;"> I like manchester </td>
   <td style="text-align:left;"> united </td>
   <td style="text-align:left;"> road </td>
   <td style="text-align:left;"> city </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Let me take </td>
   <td style="text-align:left;"> a </td>
   <td style="text-align:left;"> the </td>
   <td style="text-align:left;"> on </td>
  </tr>
  <tr>
   <td style="text-align:left;"> What if </td>
   <td style="text-align:left;"> you </td>
   <td style="text-align:left;"> the </td>
   <td style="text-align:left;"> they </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Ok </td>
   <td style="text-align:left;"> to </td>
   <td style="text-align:left;"> i </td>
   <td style="text-align:left;"> with </td>
  </tr>
  <tr>
   <td style="text-align:left;"> NO I WONT !!! </td>
   <td style="text-align:left;"> be </td>
   <td style="text-align:left;"> to </td>
   <td style="text-align:left;"> let </td>
  </tr>
  <tr>
   <td style="text-align:left;"> This project is shit </td>
   <td style="text-align:left;"> please do not swear in front of the kids </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
  </tr>
</tbody>
</table>


Application
========================================================
The application is designed to enable non-technical users to use the algorithm. This is done with [Shiny](https://shiny.rstudio.com/). 

The user can enter a phrase in the text box, choose how many words to predict, and hit the 'predict' button. The app should be fairly fast.

<p align = "center"><img src= "screenshot_app.png"/, height = 469, width = 936 >

