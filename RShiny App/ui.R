library(shiny)
library(datasets)
library(ggplot2)


# Define UI for application that draws a histogram
fluidPage(
  fluidRow(
    column(10, align = 'center', h1("MSK Challenge: Redefining Cancer Treatment"), offset = 1)),
  fluidRow(
    column(10, align = 'center', em("For this challenge, we were provided with a dataframe 
                                   reporting gene mutations as well with a text file 
                                   of scientific literature on each mutation. Our approach 
                                   involved uncovering patterns in the gene mutation data,
                                   engineering new features, manipulating the text data,
                                   and producing various NLP machine learning models."), offset = 1)),
  fluidRow(
    column(10, align="center", h2('Overview of the Data'), offset = 1)
  ),
  fluidRow(
    column(10,
           dataTableOutput('table')
    )
  ),br(),
  fluidRow(
    column(6,
           plotOutput("barPlot")),
    column(6, 
           plotOutput("mut_barPlot")
    )
  ),
  fluidRow(
    column(8,
           plotOutput("histPlot")
    ),
    column(4, sliderInput("bins",
                          "Number of bins:",
                          min = 1,
                          max = 50,
                          value = 30)
    )
    ),
  fluidRow(
    column(10, align="center", h2('Top Genes in the Training and Test Sets'), offset = 1)
  ),
  fluidRow(
    column(6,
           plotOutput('topGenes')
    ),
    column(6, plotOutput('topGenes_test')
    )
  ),
  fluidRow(
    column(12, align="center", h1('Basic Analysis of Text Data'))
  ),
  fluidRow(
    column(10, align="center", h2('Most Frequent Words by Class'), offset = 1)
  ),
  fluidRow(
    column(12, plotOutput('freq_words'))
  ),
  fluidRow(
    column(10, align="center", h2('Comparisons of Word Frequency Across Classes'), offset = 1)
  ),
  fluidRow(
    column(4, selectInput("var1", "Main Class:",
                          choices = c('1','2','3','4','5','6','7','8','9')),
           selectInput("var2", "Comparison Class 1:",
                       choices = c('1','2','3','4','5','6','7','8','9')),
           selectInput("var3", "Comparison Class 2:",
                       choices = c('1','2','3','4','5','6','7','8','9')),
           helpText('Please choose one class to compare against two others')),
    column(8, plotOutput('wordPlot'))
    ), 
  fluidRow(
    column(10, align="center", h2('Importance of n_gram'), offset = 1)
  ),br(),
  fluidRow(
    column(6, img(src = "ngram1.png")),
    column(6, img(src = "ngram2.png"))
  )
  )


