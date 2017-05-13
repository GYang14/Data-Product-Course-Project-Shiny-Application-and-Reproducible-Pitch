
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(quantmod)

shinyServer(function(input, output) {

  output$distPlot <- renderPlot({
    ticker0<-input$ticker
    ticker<-gsub("OPEN","OBEN",gsub("CLOSE","CL0SE",gsub("LOW","L0W",gsub("HIGH","H1GH",gsub("VOL","V0L",gsub("ADJUST","A0JUST",ticker0))))))
    TimeWindow=paste0(format(input$DR[1], "%Y-%m-%d"),"::",format(input$DR[2], "%Y-%m-%d"))
    #Get base OHLC price and volume
    if(ticker==ticker0){
      data <-
        getSymbols(
          ticker0,
          from = "2000-01-01",
          to = format(Sys.Date(), "%Y-%m-%d"),
          auto.assign = FALSE,
          adjust = TRUE
        )
      names(data)<-c("Open","High","Low","Close","Volume","Adjusted")
      
    }else{
      data <-
        getSymbols(
          ticker0,
          from = "2000-01-01",
          to = format(Sys.Date(), "%Y-%m-%d"),
          auto.assign = FALSE
        )
      names(data)<-c("Open","High","Low","Close","Volume","Adjusted")
      data<-adjustOHLC(data,use.Adjusted = adjust)
    }
    TA_list ='addVo()'
    
    if(input$MA==TRUE){
      TA_list=paste0(TA_list,";","addSMA(n=",input$MA1,")")
    }
    if(input$OS==TRUE){
      TA_list=paste0(TA_list,";","addRSI(n=",input$OS1,")")
      
    }
    if(input$PC==TRUE){
      TA_list=paste0(TA_list,";","addOBV()")
      
    }
    if(input$TI==TRUE){
      TA_list=paste0(TA_list,";","addMACD()")
    }
    myPars<-chart_pars()
    myPars$mar<-c(3,10,0,10)
    chartSeries(data,subset=TimeWindow,name=ticker0,TA=TA_list,theme=chartTheme('white'),pars=myPars)

  },height = 800)

})
