library(ggplot2)
library(plotly)
library(shiny)
library(bslib)
library(shinydashboard)
library(shinydashboardPlus)
library(shinythemes)
library( shinyWidgets )

source("R/ui/about_ui.R")
source("R/ui/brain_gen_2d_ui.R")
source("R/ui/brain_gen_2d_v2_ui.R")
source("R/ui/brain_gen_3d_v1_ui.R")
source("R/ui/footer_ui.R")

release = "v1.2"
ui <- shinyUI(page_navbar(
  title = "SOCR Synthetic Brain Generator",
  # theme = shinytheme("cerulean"),
  # theme = bs_theme(version = 5),
  header = tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
  ),
  footer = footer_ui(),

  bg = "#2D89C8",
  theme = bs_theme(bootswatch = "minty"),
  # theme = bs_theme(version = 5),
  inverse = TRUE,
  
  # 3d model panel
  brain_gen_3d_v1_panel_ui(),
  
  # version 2 panel
  brain_gen_2d_v2_panel_ui(),
  
  # version 1 panel
  brain_gen_2d_panel_ui(),
  
  # about panel
  about_panel_ui(),
  
  nav_spacer(),
  nav_menu(
    title = "Links",
    align = "right",
    nav_item(tags$a("SOCR", href = "https://socr.umich.edu/"))
  ),
  
  
)
)