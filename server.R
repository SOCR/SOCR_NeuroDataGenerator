library(shiny)
library(golem)
library(shinydashboard)
library(shinydashboardPlus)
library(shinythemes)
library(shinyBS)
library(plotly)
library(png)
library(yaml)
library(reticulate)
library(ggplot2)
library(oro.nifti)



##### For Server Deployment use a virtual Python Env
# virtualenv_create('pyDev',python = 'python3')
# virtualenv_install("pyDev", packages = c('torch','pillow','numpy','pybase64','uuid','diffusers','accelerate','nibabel'))
use_virtualenv("pyDev", required = TRUE)
py_libs <- import("cgan_inference")
py_libs_inference_v2 <- import("cgan_inference_v2")

# For local PC testing use  conda...
# Create a new "pytorch_env" environment first
#   https://rstudio.github.io/reticulate/articles/python_packages.html
#    library(reticulate)
#    conda_create(name = "pytorch_env", 
#       packages = c("python=3.8", "torch", "pillow", "numpy", "pybase64", "uuid"))

#    in terminal
#        %> conda create --name pytorch_env python=3.8 
#        %> conda activate pytorch_env
#        %> pip install torch pillow numpy pybase64 uuid


# use_condaenv(condaenv = "pytorch_env", required = TRUE)
# # conda_install(envname = "pytorch_env", packages = "nibabel")
# py_libs <- import("cgan_inference")
# py_libs_inference_v2 <- import("cgan_inference_v2")
# py_libs_inference_3d_v1 <- import("gan_3d_inference_v1")


imgpath <- paste0(getwd() , "/images/")
addResourcePath("images", imgpath)

# app_server <- function(input, output) {}



# read configuration file
config   <- read_yaml("configs/config.yaml")
uiconfig <- read_yaml("configs/ui_config.yaml")
img_list <-list()

# load variables from configs
img_folder_path <- config$img_path
img_width       <- uiconfig$img_width
img_height      <- uiconfig$img_height
scale_factor    <- uiconfig$scale_factor


source("R/server/brain_gen_2d_server.R")
source("R/server/brain_gen_2d_v2_server.R")
source("R/server/brain_gen_3d_v1_server.R")




app_server <- function(input, output, session) {
  
  
  observeEvent(input$sliceOrein_p2, {
    choices <- switch(input$sliceOrein_p2,
                      "Axial"    = c("Superior", "Middle", "Inferior"),
                      "Sagittal" = c("Left",     "Middle", "Right"),
                      "Coronal"  = c("Front",    "Middle", "Back"),
                      NULL)
    updateSelectInput(session, "sliceLoc_p2", choices = choices)
  })
  
  brain_gen_3d_v1_panel_server(input, output, session,py_libs_inference_3d_v1)
  brain_gen_2d_v2_panel_server(input, output, session,py_libs_inference_v2)
  brain_gen_2d_panel_server(input, output, session,py_libs)
  
  
  # img_list <-list()


  output$session_info <- renderUI({
    i <- c("<h4>R session info </h4>")
    i <- c(i, capture.output(sessionInfo()))
    HTML(paste(i, collapse = "<br/>"))
  })

  observeEvent(input$show_modal, {
    shiny::showModal(
      shiny::modalDialog(title = "SOCR 2D Synthetic Brain Image Generator Help",
                         size = "l", easyClose	= TRUE,
                         h5(paste0("See the About tab for additional information ",
                                   "About GAN GAIM model, app organization and use, and other ",
                                   "supporting information.")),
                         h5("The SOCR 2D Synthetic Image Generator is free and requires no external ",
                            "pay-to-play API keys.",
                            h6(
                              paste(input$modelSelect_p2," is a conditional deep learning model for brain image generation with 7.7 million parameters.")
                            ),
                            
                            # if(input$modelSelect == "brainGen_v1"){
                            #   h6("'brainGen_v1' is a deep learning model for brain image generation with 7.7 million parameters. ")
                            # }
                            # else if(input$modelSelect == "brainGenSeg_v1"){
                            #   h6("brainGenSeg_v1 is a deep learning model for brain image generation with 7.7 million parameters.
                            #     It is capable of generating sythentic 2D brain mri images along with segmatation mask of tumours.")
                            #   
                            # },
                            footer = modalButton("Close")
                         )
      ) )

  })
  
  observeEvent(input$show_modal_p2, {
    shiny::showModal(
      shiny::modalDialog(title = "SOCR 2D Synthetic Brain Image Generator Help",
                         size = "l", easyClose	= TRUE,
                         h5(paste0("See the About tab for additional information ",
                                   "About GAN GAIM model, app organization and use, and other ",
                                   "supporting information.")),
                         h5("The SOCR 2D Synthetic Image Generator is free and requires no external ",
                            "pay-to-play API keys.",
                            h6(
                            paste(input$modelSelect_p2," is a conditional deep learning model for brain image generation with 7.7 million parameters.")
                            ),
                            # if(input$modelSelect == "brainGen_v1"){
                            #   h6("'brainGen_v1' is a conditional deep learning model for brain image generation with 7.7 million parameters. ")
                            # }
                            # else if(input$modelSelect == "brainGenSeg_v1"){
                            #   h6("brainGenSeg_v1 is a conditional deep learning model for brain image generation with 7.7 million parameters.
                            #     It is capable of generating sythentic 2D brain mri images along with segmatation mask of tumours.")
                            #   
                            # },
                            footer = modalButton("Close")
                         )
      ) )
    
  })
}