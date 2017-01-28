library(shiny)
library(shinyAce)
library(shinydashboard)
library(knitr)

source("Modulars/ModularEditDataTable.R")

shinyApp(

shinyUI(
  
  bootstrapPage(
    
    fluidRow(
      
      column(width = 4,
             box(
             
             EditDataTableUI("edit_data")
             
             )
      ),
      
      column(width = 4,
             
             box(width = 12,
                       
              h2("Source R-Markdown"),  
              
              textInput("project_name", "Project Name", value = "GENERIC NAME"),
              
              textAreaInput("project_description", "Project Description", "Enter Project Description", width = "500px"),
              
              textAreaInput("project_intervention", "Interventions", "Enter Interventions", width = "500px"),
              
              textAreaInput("project_outcome", "Outcome", "Enter Outcome", width = "500px"),
              
              textAreaInput("project_measures", "Measures", "Enter Measures", width = "500px"),
              
              textAreaInput("project_comments", "Comments", "Other Comments", width = "500px"),
              
              aceEditor("rmd", mode = "markdown", value ='
```{r, echo = FALSE}
f <- function(x,y) (x*y/2) %% 255
image(outer(1:100,1:100, f), col = gray(1:100/100))
```')
              
              ) # box
             
              ), # column
      
      column(width = 4,
             
             box(width = 12,
              
              h2("Knitted Output"),
              htmlOutput("knitDoc")
             
             ) # box
          ) # column
      
      ) # fluidRow
  ) # bootsrapPage
),


shinyServer(function(input, output, session) {
  
  callModule(EditDataTableServer, "edit_data")
  
  output$desription_value <- renderText({ input$project_desription })
  output$interention_value <- renderText({ input$project_intervention })
  output$outcome_value <- renderText({ input$project_outcome })
  output$measures_value <- renderText({ input$project_measures })
  output$comments_value <- renderText({ input$project_comments })
  
  output$knitDoc <- renderUI({
    
    markdown_text <- paste(
'#', 
input$project_name, 
'
## Description  \n',
input$project_description,  
'
## Intervention  \n',
input$project_intervention,

'
## Outcome  \n',
input$project_outcome, 
'

## Measures  \n',
input$project_measures, 
'
## Comments  \n',
input$project_comments,
'
', 
input$rmd
)
    
    return(
      isolate(
        HTML(
          knit2html(text = markdown_text, fragment.only = TRUE, quiet = TRUE)
          )
        )
      )
    
  }) 
  
})

)