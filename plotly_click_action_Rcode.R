library(plotly)
library(shiny)

# compute a correlation matrix
correlation <- round(cor(mtcars), 3)
cor_order <- hclust(dist(mtcars, method = "binary"))$order
correlation[cor_order, cor_order]
nms <- names(mtcars)

ui <- fluidPage(
  mainPanel(
    plotlyOutput("heat"),
    plotlyOutput("scatterplot")
  ),
  verbatimTextOutput("selection")
)

server <- function(input, output, session) {
  output$heat <- renderPlotly({
    plot_ly(x = nms, y = nms, z = correlation, 
            key = correlation, type = "heatmap") %>%
      layout(xaxis = list(title = ""), 
             yaxis = list(title = ""))
  })
  
  output$selection <- renderPrint({
    s <- event_data("plotly_click")
    if (length(s) == 0) {
      "Click on a cell in the heatmap to display a scatterplot"
    } else {
      cat("You selected: \n\n")
      as.list(s)
    }
  })
  
  output$scatterplot <- renderPlotly({
    s <- event_data("plotly_click")
    if (length(s)) {
      vars <- c(s[["x"]], s[["y"]])
      d <- setNames(mtcars[vars], c("x", "y"))
      yhat <- fitted(lm(y ~ x, data = d))
      plot_ly(d, x = ~x) %>%
        add_markers(y = ~y) %>%
        add_lines(y = ~yhat) %>%
        layout(xaxis = list(title = s[["x"]]), 
               yaxis = list(title = s[["y"]]), 
               showlegend = FALSE)
    } else {
      plotly_empty()
    }
  })
  
}

shinyApp(ui, server)





## Network plot in plotly

library(plotly)
library(igraph)

data(karate, package="igraphdata")
G <- upgrade_graph(karate)
L <- layout_nicely(G)
L <- as.data.frame(L)
colnames(L) <- c("X", "Y")
L$group <- "Node"

vs <- V(G)
v_names <- names(vs)
es <- data.frame(as_edgelist(G), weight = E(G)$weight)

Nv <- length(vs)
Ne <- length(es[1]$X1)

Xn <- L[,1]
Yn <- L[,2]

n <- nrow(L)
for( i in 1 : Ne ) {
  
  v0 <- es[i,]$X1
  v1 <- es[i,]$X2 
  wt <- es[i, ]$weight
  
  mid_x <- (Xn[v0] + Xn[v1])/2
  mid_y <- (Yn[v0] + Yn[v1])/2
  
  L[(i + n), ] <- c(mid_x, mid_y, "EdgeLabel")
  v_names <- c(v_names, wt)
  
}

L$X <- as.numeric(L$X)
L$Y <- as.numeric(L$Y)

network <- plot_ly(data = L, x = ~X, y = ~Y, mode = "markers", text = v_names, hoverinfo = "text", 
                   color = ~group, colors = c("white", "blue"))

edge_shapes <- list()
for( i in 1 : Ne ) {
  v0 <- es[i,]$X1
  v1 <- es[i,]$X2
  
  edge_shape = list(
    type = "line",
    line = list(color = "#030303", width = 0.3),
    x0 = Xn[v0],
    y0 = Yn[v0],
    x1 = Xn[v1],
    y1 = Yn[v1]
  )
  
  edge_shapes[[i]] <- edge_shape
}

axis <- list(title = "", showgrid = FALSE, showticklabels = FALSE, zeroline = FALSE)

p <- layout(
  network,
  title = 'Karate Network',
  shapes = edge_shapes,
  xaxis = axis,
  yaxis = axis
)

ggplotly(p)









library(plotly)

p <- plot_ly(economics,
             type = "scatter",        # all "scatter" attributes: https://plot.ly/r/reference/#scatter
             x = ~date,               # more about scatter's "x": /r/reference/#scatter-x
             y = ~uempmed,            # more about scatter's "y": /r/reference/#scatter-y
             name = "unemployment",   # more about scatter's "name": /r/reference/#scatter-name
             marker = list(           # marker is a named list, valid keys: /r/reference/#scatter-marker
               color="#264E86"        # more about marker's "color" attribute: /r/reference/#scatter-marker-color
             )) %>%
  
  add_trace(x = ~date,                                         # scatter's "x": /r/reference/#scatter-x
            y = ~fitted((loess(uempmed ~ as.numeric(date)))),  # scatter's "y": /r/reference/#scatter-y
            mode = 'lines',                                    # scatter's "y": /r/reference/#scatter-mode
            line = list(                                       # line is a named list, valid keys: /r/reference/#scatter-line
              color = "#5E88FC",                               # line's "color": /r/reference/#scatter-line-color
              dash = "dashed"                                  # line's "dash" property: /r/reference/#scatter-line-dash
            )
  ) %>%
  
  layout(                        # all of layout's properties: /r/reference/#layout
    title = "Unemployment", # layout's title: /r/reference/#layout-title
    xaxis = list(           # layout's xaxis is a named list. List of valid keys: /r/reference/#layout-xaxis
      title = "Time",      # xaxis's title: /r/reference/#layout-xaxis-title
      showgrid = F),       # xaxis's showgrid: /r/reference/#layout-xaxis-showgrid
    yaxis = list(           # layout's yaxis is a named list. List of valid keys: /r/reference/#layout-yaxis
      title = "uidx")     # yaxis's title: /r/reference/#layout-yaxis-title
  )

ggplotly(p)