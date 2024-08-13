library(ggplot2)
library(shiny)
library(bslib)

data(penguins, package = "palmerpenguins")
release = "v1.2"


source("ui.R")
source("server.R")


shinyApp(ui = ui, server )