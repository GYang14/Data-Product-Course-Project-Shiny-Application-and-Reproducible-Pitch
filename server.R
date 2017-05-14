
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(quantmod)
library(ggplot2)
shinyServer(function(input, output) {
  dataInput <- reactive({
    PD<-getSymbols(input$PD,src='FRED',auto.assign = FALSE)
    names(PD)<-"PD"
    SD<-getSymbols(input$SD,src='FRED',auto.assign = FALSE)
    names(SD)<-"SD"
    TimeWindow=paste0(format(input$TW[1], "%Y-%m-%d"),"::",format(input$TW[2], "%Y-%m-%d"))
    PD<-PD[TimeWindow]
    SD<-SD[TimeWindow]
    comb<-merge(PD,SD)
    return(comb)
  })

  output$distPlot <- renderPlot({
    comb<-dataInput()
    PD<-comb$PD
    Last<-comb$SD
    name<-paste("top chart:",input$PD,"; bottom chart:",input$SD)
    chartSeries(PD, line.type = "b",name=name)
    addTA(Last,on=NA, type = 'b' )

  })
  
  output$covplot<-renderPlot({
    cov_data<-as.data.frame(dataInput())
    cov_data<-cov_data[c('PD','SD')]
    cov_data<-cov_data[complete.cases(cov_data),]
    names(cov_data)<-c(input$PD,input$SD)
    panel.cor <- function(x, y, digits=2, prefix="", cex.cor, ...)
    {
      usr <- par("usr"); on.exit(par(usr))
      par(usr = c(0, 1, 0, 1))
      r <- cor(x, y)
      txt <- format(c(r, 0.123456789), digits=digits)[1]
      txt <- paste(prefix, txt, sep="")
      if(missing(cex.cor)) cex.cor <- 0.4/strwidth(txt)
      text(0.5, 0.5, txt, cex = cex.cor)
    }
    pairs(~.,data=cov_data,
          lower.panel=panel.smooth,upper.panel=panel.cor,
          pch=20,main=paste(input$PD,"v.s.",input$SD,"Scatterplot Matrix: Correlation on Top Right"))
    
  })

})
