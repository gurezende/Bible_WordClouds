# Creating a Word Cloud for each book in the Holy Bible

setwd("/Users/santos@us.ibm.com/Documents/FCD/machineLearning/Cap07/Cap07-R")
getwd()

# Pacotes
#install.packages("slam")
#install.packages("tm")
#install.packages("SnowballC")
#install.packages("wordcloud")
#install.packages("wordcloud2")
#install.packages("gmodels")
#install.packages("e1071")
library(tm)
library(SnowballC)
library(wordcloud)
library(e1071)
library(gmodels)

# Loading the data
dados <- read.csv(file.choose(), stringsAsFactors = FALSE)
head(dados)
View(dados)

# Creating the function that will loop the same analysis to each book
bible_cloud <- function(data) {

  for(i in 1:length(unique(data$b))) {
  # Filter dataset on a single Book
  df_book <- data[data$b==i,]
  # Create Corpus out of the text to give the text a structure to analize the text
  book_corpus <- VCorpus(VectorSource(df_book$t))
  # Cleaning with tm_map()
  book_corpus_clean <- tm_map(book_corpus, content_transformer(tolower))

  # Another cleanup steps (remove numbers, stop words, punctuation)
  book_corpus_clean <- tm_map(book_corpus_clean, removeNumbers) # remove números
  book_corpus_clean <- tm_map(book_corpus_clean, removeWords, stopwords()) # remove stop words
  book_corpus_clean <- tm_map(book_corpus_clean, removePunctuation) # remove pontuação

  # Word stemming
  # Aply Stem to transform the words in different formats in a single root word (learn, learned, learning = learn)
  #book_corpus_clean <- tm_map(book_corpus_clean, stemDocument)

  # Remove white spaces
  book_corpus_clean <- tm_map(book_corpus_clean, stripWhitespace)
  
  # Apply transformation to characters
  lapply(book_corpus[1:3], as.character)
  lapply(book_corpus_clean[1:3], as.character)

  # Generating the Word Cloud
  wordcloud(book_corpus_clean, min.freq = 20, random.order = FALSE, main='Title')
  }
}

#Name your PDF File
pdf('biblewordclouds.pdf')

#Call the function created
bible_cloud(dados)

#Close PDF save
dev.off()

