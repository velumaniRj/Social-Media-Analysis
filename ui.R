# Frontend/client of R shiny app

library(shiny)

shinyUI(fluidPage(
  titlePanel("Sentiment Analysis"),
  
  sidebarLayout(
    sidebarPanel(
      textInput("searchTerm", label = "Enter twitter search keywords below", value = "type here"), 
      
      selectInput('plot_opt', 'Plot options', c('emotion', 'polarity'), selectize=TRUE),
      
      submitButton("Update View")
    ),
    
    mainPanel(plotOutput("plot_emotion"))
  )
))
