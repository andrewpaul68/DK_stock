###########################
#Functions

###########################


# Define UI 
fluidPage(
  
  # Application title
  titlePanel("Stock Analysis"),
  
  actionButton("run","Run stock analysis"),
  
  tabsetPanel(
        tabPanel("Stocks",
                 textInput("tsx.symbols.ui","Stock symbols",tsx.symbols.init,width="100%"),
                 h5("Symbols must match Yahoo Finance"),
                 numericInput("lag.inp.ui","Time lag (days)",lag.inp,min=3,step=1)
                 ),
        tabPanel("Table",
                 tableOutput("stock.table")
                 ),
        tabPanel("Time series",
                 plotOutput("TSPlot")
        ),
        tabPanel("Histograms",
                 plotOutput("HistoPlot")
        )
      )
)#end Fluidpage