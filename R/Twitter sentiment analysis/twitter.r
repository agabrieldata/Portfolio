# 1.0 Loading Libraries

library(twitteR) #Provides access to twitter API
library(ROAuth) #Provides an interface to the OAuth specification allowing users to authenticate via OAuth to the server of their choice.
library(tidytext) #Makes text mining tasks easier, more effective and consistent with tools.
library(tm) #Provides tool for text mining. (things like cleaning texts, DF's, CSV compatibilities etc)
library(wordcloud) #Enables the creation of wordclouds for sentiment analysis
library(igraph) #Assists in the plotting of big data
library(glue) #Concatenates strings and numbers, basically print(paste())
library(networkD3) #Creates D3 JavaScript network, tree, dendrogram, and Sankey graphs from R.
library(rtweet) #Provides users a range of functions designed to extract data from Twitter's REST and streaming APIs.
library(plyr) #Set of clean and consistent tools that implement the split-apply-combine pattern in R
library(stringr) #wrapper functions for common string operations
library(ggplot2) #plots
library(ggeasy) # Helps ggplot2
library(plotly) #Obsolete
library(dplyr) # Grammar of data manipulation (provides very useful functions)
library(hms) #provides time of day values
library(lubridate) #Helps formatting dates and time
library(magrittr) #Provides different types of pipes (%>%)
library(tidyverse) #Set of packages
library(janeaustenr) #Jane Austen's complete novels. Used for creating examples.
library(widyr) #Widen, process and re-write data.
library(shiny) #Used to create the interactive app

# 2.0 APi integration

#Note: Replace below with your credentials following above reference
api_key <- 'Please add your api_key'
api_secret <- "Please add your api_secret"
access_token <- "Please add your access_token"
access_token_secret <- "Please add your access_token_secret"

#Note: This will ask us permission for direct authentication, type '1' for yes:
setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)

# 3.0 Extracting global warming tweets

# extracting 4000 tweets related to global warming topic
tweets <- searchTwitter("#pdpaola", n=4000, lang="en") #Check if filtering by country is possible
n.tweet <- length(tweets)

# convert tweets to a data frame
tweets.df <- twListToDF(tweets)

# 4.0 Formatting and cleaning the tweets

tweets.txt <- sapply(tweets, function(t)t$getText())

# Ignore graphical Parameters to avoid input errors
tweets.txt <- str_replace_all(tweets.txt,"[^[:graph:]]", " ")

## pre-processing text:
clean.text = function(x)
{
  # convert to lower case
  x = tolower(x)
  # remove rt
  x = gsub("rt", "", x)
  # remove at
  x = gsub("@\\w+", "", x)
  # remove punctuation
  x = gsub("[[:punct:]]", "", x)
  # remove numbers
  x = gsub("[[:digit:]]", "", x)
  # remove links http
  x = gsub("http\\w+", "", x)
  # remove tabs
  x = gsub("[ |\t]{2,}", "", x)
  # remove blank spaces at the beginning
  x = gsub("^ ", "", x)
  # remove blank spaces at the end
  x = gsub(" $", "", x)
  # some other cleaning text
  x = gsub('https://','',x)
  x = gsub('http://','',x)
  x = gsub('[^[:graph:]]', ' ',x)
  x = gsub('[[:punct:]]', '', x)
  x = gsub('[[:cntrl:]]', '', x)
  x = gsub('\\d+', '', x)
  x = str_replace_all(x,"[^[:graph:]]", " ")
  return(x)
}

cleanText <- clean.text(tweets.txt)

# remove empty results (if any)
idx <- which(cleanText == " ")
cleanText <- cleanText[cleanText != " "]


# 5.0 Frequency of tweets

tweets.df %<>% 
  mutate(
    created = created %>% 
      # Remove zeros.
      str_remove_all(pattern = '\\+0000') %>%
      # Parse date.
      parse_date_time(orders = '%y-%m-%d %H%M%S')
  )

tweets.df %<>% 
  mutate(Created_At_Round = created%>% round(units = 'hours') %>% as.POSIXct())

tweets.df %>% pull(created) %>% min()

tweets.df %>% pull(created) %>% max()

plt <- tweets.df %>% 
  dplyr::count(Created_At_Round) %>% 
  ggplot(mapping = aes(x = Created_At_Round, y = n)) +
  theme_light() +
  geom_line() +
  xlab(label = 'Date') +
  ylab(label = 'Tweets') +
  ggtitle(label = 'Number of Tweets per Hour')

plt %>% ggplotly()


# 6.0 Loading sentiment words

positive = scan('C:\\Data science\\Proyectos\\Sentiment analysis on twitter\\Positive_negative_words\\positive-words.txt', what = 'character', comment.char = ';')
negative = scan('C:\\Data science\\Proyectos\\Sentiment analysis on twitter\\Positive_negative_words\\negative-words.txt', what = 'character', comment.char = ';')

# add your list of words below as you wish if missing in above read lists
pos.words = c(positive,'upgrade','Congrats','prizes','prize','thanks','thnx',
              'Grt','gr8','plz','trending','recovering','brainstorm','leader')
neg.words = c(negative,'wtf','wait','waiting','epicfail','Fight','fighting',
              'arrest','no','not')

# 7.0 Sentiment scoring function

score.sentiment = function(sentences, pos.words, neg.words, .progress='none')
  {
  require(plyr)
  require(stringr)
  
  # we are giving vector of sentences as input. 
  # plyr will handle a list or a vector as an "l" for us
  # we want a simple array of scores back, so we use "l" + "a" + "ply" = laply:
  
  scores = laply(sentences, function(sentence, pos.words, neg.words) {
    
    # clean up sentences with R's regex-driven global substitute, gsub() function:
    sentence = gsub('https://','',sentence)
    sentence = gsub('http://','',sentence)
    sentence = gsub('[^[:graph:]]', ' ',sentence)
    sentence = gsub('[[:punct:]]', '', sentence)
    sentence = gsub('[[:cntrl:]]', '', sentence)
    sentence = gsub('\\d+', '', sentence)
    sentence = str_replace_all(sentence,"[^[:graph:]]", " ")
    
    # and convert to lower case:
    sentence = tolower(sentence)
    
    # split into words. str_split is in the stringr package
    word.list = str_split(sentence, '\\s+')
    
    # sometimes a list() is one level of hierarchy too much
    words = unlist(word.list)
    
    # compare our words to the dictionaries of positive & negative terms
    pos.matches = match(words, pos.words)
    neg.matches = match(words, neg.words)
    
    # match() returns the position of the matched term or NA
    # we just want a TRUE/FALSE:
    pos.matches = !is.na(pos.matches)
    neg.matches = !is.na(neg.matches)
    
    # TRUE/FALSE will be treated as 1/0 by sum():
    score = sum(pos.matches) - sum(neg.matches)
    
    return(score)
  }, pos.words, neg.words, .progress=.progress )
  
  scores.df = data.frame(score=scores, text=sentences)
  return(scores.df)
}

# 8.0 Calculating the analysis score

analysis <- score.sentiment(cleanText, pos.words, neg.words)

table(analysis$score)

# 9.0 Histograms of sentiment score

analysis %>%
  ggplot(aes(x=score)) + 
  geom_histogram(binwidth = 1, fill = "lightblue")+ 
  ylab("Frequency") + 
  xlab("sentiment score") +
  ggtitle("Distribution of Sentiment scores of the tweets") +
  ggeasy::easy_center_title()

# 10.0 Barplot of sentiment score

neutral <- length(which(analysis$score == 0))
positive <- length(which(analysis$score > 0))
negative <- length(which(analysis$score < 0))
Sentiment <- c("Negative","Neutral","Positive")
Count <- c(negative, neutral, positive)
output <- data.frame(Sentiment,Count)
output$Sentiment<-factor(output$Sentiment,levels=Sentiment)
ggplot(output, aes(x=Sentiment,y=Count))+
  geom_bar(stat = "identity", aes(fill = Sentiment))+
  ggtitle("Barplot of Sentiment type of 4000 tweets")

# 11.0 Wordcloud
#Text must be in a corpus type. the tm package helps in transforming the 
#stream of tweets into corpus for the package to be able to create the wordcloud

text_corpus <- Corpus(VectorSource(cleanText))
text_corpus <- tm_map(text_corpus, content_transformer(tolower))
text_corpus <- tm_map(text_corpus, function(x)removeWords(x,stopwords("english")))
text_corpus <- tm_map(text_corpus, removeWords, c("global","globalwarming"))
tdm <- TermDocumentMatrix(text_corpus)
tdm <- as.matrix(tdm)
tdm <- sort(rowSums(tdm), decreasing = TRUE)
tdm <- data.frame(word = names(tdm), freq = tdm)
set.seed(123) #For reproducibility

wordcloud(text_corpus, min.freq = 1, max.words = 100, scale = c(2.2,1),
          colors=brewer.pal(8, "Dark2"), random.color = T, random.order = F)

# 12.0 Word frequency plot

ggplot(tdm[1:20,], aes(x=reorder(word, freq), y=freq)) + 
  geom_bar(stat="identity") +
  xlab("Terms") + 
  ylab("Count") + 
  coord_flip() +
  theme(axis.text=element_text(size=7)) +
  ggtitle('Most common word frequency plot') +
  ggeasy::easy_center_title()

# 13.0 bigram analysis

bi.gram.words <- tweets.df %>% 
  unnest_tokens(
    input = text, 
    output = bigram, 
    token = 'ngrams', 
    n = 2
  ) %>% 
  filter(! is.na(bigram))

bi.gram.words %>% 
  select(bigram) %>% 
  head(10)

# 13.1 Removal of stopwords. Extra stopwords can be added into extra.stop.words

extra.stop.words <- c('https') 

stopwords.df <- tibble(
  word = c(stopwords(kind = 'es'),
           stopwords(kind = 'en'),
           extra.stop.words)
)

#13.2 Filtering

bi.gram.words %<>% 
  separate(col = bigram, into = c('word1', 'word2'), sep = ' ') %>% 
  filter(! word1 %in% stopwords.df$word) %>% 
  filter(! word2 %in% stopwords.df$word) %>% 
  filter(! is.na(word1)) %>% 
  filter(! is.na(word2)) 

#13.3 Group and counting words

bi.gram.count <- bi.gram.words %>% 
  dplyr::count(word1, word2, sort = TRUE) %>% 
  dplyr::rename(weight = n)

bi.gram.count %>% head()

#13.4 Plotting of bigram

bi.gram.count %>% 
  mutate(weight = log(weight + 1)) %>% 
  ggplot(mapping = aes(x = weight)) +
  theme_light() +
  xlab("log(weight)")+
  geom_histogram() +
  labs(title = "Bigram log-Weight Distribution")

#14.0 Creating interactive network graph.

threshold <- 80

network <-  bi.gram.count %>%
  filter(weight > threshold) %>%
  graph_from_data_frame(directed = FALSE)

# Store the degree.
V(network)$degree <- strength(graph = network)

# Compute the weight shares.
E(network)$width <- E(network)$weight/max(E(network)$weight)

# Create networkD3 object.
network.D3 <- igraph_to_networkD3(g = network)

# Define node size.
network.D3$nodes %<>% mutate(Degree = (1E-2)*V(network)$degree)

# Define color group
network.D3$nodes %<>% mutate(Group = 1)

# Define edges width. 
network.D3$links$Width <- 10*E(network)$width

forceNetwork(
  Links = network.D3$links, 
  Nodes = network.D3$nodes, 
  Source = 'source', 
  Target = 'target',
  NodeID = 'name',
  Group = 'Group', 
  opacity = 0.9,
  Value = 'Width',
  Nodesize = 'Degree', 
  
  # We input a JavaScript function.
  linkWidth = JS("function(d) { return Math.sqrt(d.value); }"), 
  fontSize = 12,
  zoom = TRUE, 
  opacityNoHover = 1
)
