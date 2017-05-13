

# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
#Build a shiny app to show the time series of interested stock price
#with selected technical indicators and SP500 index, and calculate the
#Beta of the interested stock

library(shiny)

shinyUI(fluidPage(
  # Application title
  titlePanel("Stock Trend Viewer"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      textInput("ticker", "Enter stock ticker below:", "SPY"),
      dateRangeInput("DR","Select interested period",min ="2000-01-01",start = "2017-01-01"),
      checkboxInput("MA", strong("Show Moving Average (SMA)"), FALSE),
      numericInput(
        "MA1",
        h5("SMA Range Days"),
        min = 10,
        max = 200,
        value = 50,
        step=10
      ),
      checkboxInput("OS", strong("Show RSI(Relative Strength Index)"), FALSE),
      numericInput(
        "OS1",
        h5("RSI Range Days"),
        min = 14,
        max = 70,
        value = 14,
        step=14
      ),
      checkboxInput("TI", strong("Show MACD (Moving Average Convergence Divergence)"), FALSE),
      checkboxInput("PC", strong("Show On Balance Volume (OBV)"), FALSE),
      
      submitButton(text = "Submit")
      
    ),
    
    # Show a plot of the generated distribution
    mainPanel(plotOutput("distPlot"))
  )
))
