

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
  titlePanel("Economic Data Series Viewer"),
  h3("User Guide:"),
  p("1. Enter the series_id of the economic data series of your interest into box:",strong("Primary Economic Data Series")),
  p("2. Enter the series_id of the economic data series that you want to compare with the primary series into box:",strong("Secondary Economic Data Series")),
  p("3. Specify the time period of your interest in",strong("Interested Time Window")),
  p("4. Click the bottom",strong("Submit"),"to see your result:time series chart on the right, scatterplot matrix with correlation at bottom"),
  p("Note:",br(), 
    "series_id sample:CPIAUCSL,DEXUSEU, SP500, DGS10, DTB3, and so on",br(), 
    "please see details of source data and full list of series_ids at",a(href="https://fred.stlouisfed.org/","FRED"),br(),
    "please see pitch sildes of the app at",a(href="http://rpubs.com/gaugby88/276757","RPubs")),
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      textInput("PD", "Primary Economic Data Series", "DTB3"),
      textInput("SD", "Secondary Economic Data Series", "DGS10"),
      dateRangeInput("TW","Interested Time Window",min ="2000-01-01",start = "2015-01-01"),
      submitButton(text = "Submit"),
      br(),
      plotOutput("covplot")
    ),
    
    mainPanel(
      plotOutput("distPlot",height = "800px")

      )
  )
))
