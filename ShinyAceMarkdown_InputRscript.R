library(shiny)
library(shinyAce)
library(shinydashboard)
library(knitr)

shinyApp(

shinyUI(
  
  bootstrapPage(
    
    fluidRow(
      
      column(width = 2,
             box(width = 12,
                 numericInput("num1", "Select rnorm number", value = 5, min = 1, max = 100),
                 selectInput("modular", "Select Modualr", choices = dir("Modulars", pattern = ".R"))
                 
                 ) # box
             ), # column
      
      column(width = 5,
             
             box(width = 12,
                       
              h2("Source R-Markdown"),  
              uiOutput("ace_ui"),
#               aceEditor("rmd", mode = "markdown", 
#                               value = '### Sample knitr Doc
# 
# This is some markdown text. It may also have embedded R code
# which will be executed.
# 
# ```{r}
# 2*3
# rnorm(5)
# ```
# 
# It can even include graphical elements.
# 
# ``{r}
# hist(rnorm(100))
# ```
# 
# '),
              
              actionButton("eval", "Update")
              
              ) # box
             
              ), # column
      
      column(width = 5,
             
             box(width = 12,
              
              h2("Knitted Output"),
              htmlOutput("knitDoc")
             
             ) # box
          ) # column
      ) # fluidRow
  ) # bootsrapPage
),


shinyServer(function(input, output, session) {
  
  output$ace_ui <- renderUI({
    num_inpt <- input$num1
    
    val <- paste('### Sample knitr Doc
This is some markdown text. It may also have embedded R code
which will be executed.

```{r}
2*3
rnorm(', num_inpt, ')
```')
    
    aceEditor("rmd", mode = "markdown", value = val)
    
  })
  
  output$knitDoc <- renderUI({
    
    input$eval
    
    return(
      isolate(
        HTML(
          knit2html(text = input$rmd, fragment.only = TRUE, quiet = TRUE)
          )
        )
      )
    
  }) 
  
})

)