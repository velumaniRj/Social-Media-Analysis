# Backend/server of R app
# Performs sentiment analysis of tweets based on emotion and polarity classification
# The visualization of the sentiment class distributions is performed using ggplot2 package

# required pakacges
library(twitteR)
library(sentiment)
install.packages("SentimentAnalysis")
install.packages("sentimentr")
install.packages("twitteR")

library(plyr)
library(ggplot2)
library(RColorBrewer)


# loading twitter credentials
#load("twitteR_credentials")
#registerTwitterOAuth(twitCred)
APIKey="pWwgrd2U1qS1iwmFF48xeCE6E"
APISecret="CDihEUEQvfkNZmSYN8tcU77HuBWQK1JbT8lMM2OoQEgAHqOD7l"
AccessToken="77792512-T6iZCI65S9ctgOfHTRrHwr1WTyJPlN0BkHFtymdnK"
AccessTokenSecret="VUHim6ltYOjSPbFSvyE8frZqch0TzLvsVIY7v21EDyvNI"


setup_twitter_oauth(APIKey,APISecret,AccessToken,AccessTokenSecret)

# loading the helper functions
source('helpers.R')

shinyServer(function(input, output) {
  
  # Step 1: Getting the tweets based on search terms
  # cainfo="cacert.pem" is required for data access
  tweets <- reactive ({ searchTwitter(input$searchTerm,n=1000, lang="en") })
  
  # Step2: Preprocessing to clean up the tweets
  txtTweets <- reactive ({ preprocess_tweet (tweets()) })
  
  output$plot_emotion <- renderPlot({  
    
    # Step 3: Emotion sentiment analysis
    emotion <- emotionSentimentAnal(txtTweets())
    
    # Step 4: Polarity sentiment analysis
    polarity <- polaritySentimentAnal(txtTweets())
    
    # Step 5: Store results in dataframe
    results_df <- data.frame(text=txtTweets(), emotion=emotion, polarity=polarity)
    
    # Step 6: Plot distribution of tweet sentiments
    if (input$plot_opt == 'emotion') {
      
      ggplot(results_df) +
        geom_bar(aes(x=emotion, y=..count.., fill=emotion)) +
        ggtitle(paste('Sentiment Analysis of Search Term "', input$searchTerm, '"', sep='')) +      
        xlab("Emotion Class") + ylab("No of Tweets") +
        scale_fill_brewer(palette="Set1") +
        theme_bw() +
        theme(axis.text.y = element_text(colour="black", size=18, face='plain')) +
        theme(axis.title.y = element_text(colour="black", size=18, face='plain', vjust=2)) + 
        theme(axis.text.x = element_text(colour="black", size=18, face='plain', angle=90, hjust=1)) +
        theme(axis.title.x = element_text(colour="black", size=18, face='plain')) + 
        theme(plot.title = element_text(colour="black", size=20, face='plain', vjust=2.5)) +
        theme(legend.text = element_text(colour="black", size=16, face='plain')) +
        theme(legend.title = element_text(colour="black", size=18, face='plain')) +
        guides(fill = guide_legend(keywidth = 2, keyheight = 2))
      
    } else {
      
      ggplot(results_df, aes()) +
        geom_bar(aes(x=polarity, y=..count.., fill=polarity), width=0.6) +
        ggtitle(paste('Sentiment Analysis of Search Term "', input$searchTerm, '"', sep='')) +
        xlab("Polarity Class") + ylab("No of Tweets") +   
        scale_fill_brewer(palette="Set1") +
        theme_bw() +
        theme(axis.text.y = element_text(colour="black", size=18, face='plain')) +
        theme(axis.title.y = element_text(colour="black", size=18, face='plain', vjust=2)) + 
        theme(axis.text.x = element_text(colour="black", size=18, face='plain', angle=90, hjust=1)) +
        theme(axis.title.x = element_text(colour="black", size=18, face='plain')) + 
        theme(plot.title = element_text(colour="black", size=20, face='plain', vjust=2.5)) +
        theme(legend.text = element_text(colour="black", size=16, face='plain')) +
        theme(legend.title = element_text(colour="black", size=18, face='plain')) +
        guides(fill = guide_legend(keywidth = 2, keyheight = 2))
      
    } 
    
  })  
  
})

