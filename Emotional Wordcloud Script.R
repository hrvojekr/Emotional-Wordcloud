# Packges
install.packages("tidyverse")
install.packages("tidytext")
install.packages("wordcloud")
install.packages("radarchart")

#Load Library
library(tidyverse)
library(tidytext)
library(wordcloud)
library(radarchart)

#Get the data
WholeConversation <- read.delim("gyppwhole.txt") 
WholeConversation_Ch <- as.character(WholeConversation$gypp_text)
WholeConversation_Tibble <- tibble(WholeConversation_Ch)

#Get the nrc lexicon
nrc <- get_sentiments("nrc")


#Prepare the Data
graphData <- WholeConversation_Tibble %>%
  inner_join(nrc, by = c ("WholeConversation_Ch" = "word")) %>% 
  filter (!grepl("positive|negative", sentiment)) %>% 
  count (sentiment, WholeConversation_Ch) %>% 
  spread(sentiment, n, fill = 0) %>% 
  data.frame(row.names = "WholeConversation_Ch")

#Preview the Data
head(graphData)

#Plot the Data
comparison.cloud(graphData, scale = c(4,.5), max.words = 50, title.size = 1.5)


#prepare the Data for Radar Plot
radarGraphData <- WholeConversation_Tibble %>%
  inner_join(nrc, by = c ("WholeConversation_Ch" = "word")) %>% 
  filter (!grepl("positive|negative", sentiment)) %>% 
  count (sentiment) %>% 
  group_by(sentiment) %>% 
  rename("Count" = "n")


# JavaScript radar chart
chartJSRadar(radarGraphData)
