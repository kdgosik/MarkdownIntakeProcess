library(shiny)
library(rhandsontable)
library(ggplot2)
library(plotly)

# source("Modulars/ModularControlChart.R")


# MODULE UI
EditDataTableUI <- function(id) {
  ns <- NS(id)
  
  list(
    div(
      bootstrapPage(
        
        fluidRow(
                     
                     dateRangeInput("daterange", "Select Time Range",
                                    start = Sys.Date() - 360,
                                    end = Sys.Date(),
                                    min = Sys.Date() - 360,
                                    max = Sys.Date() + 30),
                     
                     selectInput("date_interval", "Select Date Interval", 
                                 choices = c("day", "week", "payperiod", "month", "quarter"), selected = "month"),
                     
                     textInput("var1", "Enter Plot Variable", value = "var1"),
                     
                     actionButton("update_data", "Update Data"),
                     
                     rHandsontableOutput("hot"),
                     
                     plotlyOutput("plotly_chart")
                     # ControlChartUI("control")
        )
    )
  )
  )
}



# MODULE Server
EditDataTableServer <- function(input, output, session) {
  
  values <- reactiveValues()
  
  
  Data <- reactive({
    
    if ( !is.null(input$hot) ) {
      
      DF <- hot_to_r(input$hot)
      
    } else {
      if (is.null(values[["DF"]])){
        
        DF <- data.frame(
          Date = seq(from = input$daterange[1], to = input$daterange[2], by = input$date_interval),
          Response = 0
        )
        
        colnames(DF) <- c("Date", input$var1)
        # DF = mtcars
        
      }else{
        DF <- values[["DF"]]
      }
    }
    
    values[["DF"]] <- DF
    DF
    
    
    
  })
  
  output$plotly_chart <- renderPlotly({
    
    p <- ggplot(Data(), aes_string("Date", input$var1)) + geom_point()
    ggplotly(p)
    
  })
  
  # callModule(ControlChartServer, "control", data = Data, "Date", "Response")
  
  output$hot <- renderRHandsontable({
    
    DF = Data()
    if (!is.null(DF))
      rhandsontable(DF) 
    
  })
  
}