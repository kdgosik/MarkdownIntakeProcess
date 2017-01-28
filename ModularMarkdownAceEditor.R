library(shiny)
library(shinyAce)
library(knitr)

# Does not render the actual document when called as a module

# MODULE UI
MarkdownAceEditorUI <- function(id) {
  ns <- NS(id)
  
  list(
  shinyUI(
  bootstrapPage(
    headerPanel("Shiny Ace knitr Example"),
    div(
      class="container-fluid",
      div(class="row-fluid",
          div(class="span6",
              h2("Source R-Markdown"),  
              aceEditor(ns("rmd"), mode="markdown", value='### Sample knitr Doc
                        
                        This is some markdown text. It may also have embedded R code
                        which will be executed.
                        
                        ```{r}
                        2*3
                        rnorm(5)
                        ```
                        
                        It can even include graphical elements.
                        
                        ```{r}
                        hist(rnorm(100))
                        ```
                        
                        '),
              actionButton(ns("eval"), "Update")
              ),
          
          div(class="span6",
              h2("Knitted Output"),
              uiOutput(ns("knitDoc"))
          )
          )
          )
    )))
}



# MODULE Server
MarkdownAceEditorServer <- function(input, output, session) {
  output$knitDoc <- renderUI({
    #input$eval
    return(isolate(HTML(knit2html(text = input$rmd, fragment.only = TRUE, quiet = TRUE))))
  })  
}