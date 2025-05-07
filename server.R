

# Define server logic 
function(input, output) {
  
  #set reactivity
  datasetInput<-reactive({
    rv$update<-rv$update+1
    tsx.temp<-sub("\n","",input$tsx.symbols.ui)
    tsx.symbols<<-unlist(strsplit(tsx.temp,","))
    lag.inp<<-input$lag.inp.ui
    withProgress(message='Running (finding stock quotes be patient)...',
                 value=0.5,{
      source("TD_trading.R")
    })
  })#end reactive

  
  #run analysis through datasetInput() reactive function
  observeEvent(input$run,{
      first.run<<-FALSE
      datasetInput()
      rv$update<-rv$update+1
  })#end event
  
  #Stock table
  output$stock.table<-renderTable({
    rv$update
    if (first.run){
      return(NULL)
    }else {
      res.df
    }
  },rownames=TRUE)
  
  #Time Series plot  
  output$TSPlot<-renderPlot({
    rv$update
    if (first.run){
      return(NULL)
    }else {
      print(stock.ts(tsx.symbols,results))
    }
  })
  
  #Histograms 
  output$HistoPlot<-renderPlot({
    rv$update
    if (first.run){
      return(NULL)
    }else {
      print(return.density(tsx.symbols,results))
    }
  })
  
}