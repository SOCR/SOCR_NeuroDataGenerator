source("R/utils.R")

config   <- read_yaml("configs/config.yaml")
uiconfig <- read_yaml("configs/ui_config.yaml")
img_list <-list()

# load variables from configs
img_folder_path <- config$img_path
img_width       <- uiconfig$img_width
img_height      <- uiconfig$img_height
scale_factor    <- uiconfig$scale_factor


brain_gen_2d_panel_server <- function(input, output, session,py_libs){
  
  plot_count <- reactive({
    if(input$modelSelect == "brainGen_v1" ){
      plotCount <- 1
    }
    else if(input$modelSelect == "brainGen_diffuser_v1"){
      plotCount <- 1
    }
    else if(input$modelSelect == "brainGenSeg_v1"){
      plotCount <- 2
      
    }
    return(plotCount)
  })
  
  output$plotOutput <- renderUI({
    
    plot_outputs <- lapply(1:plot_count(), function(i) {
      div(
        plotlyOutput(paste0("imageOutput_", i),width = "100%"),
        class = "plot-item"
      )
    })
    
    # fluidRow(do.call(tagList, plot_outputs))
    div(class = "plot-grid", do.call(tagList, plot_outputs))
  })
  
  
  observeEvent(input$goButton, {
    
    
    selectedOption <- input$imageSelect
    if (selectedOption == "With Tumor") {
      print("Generating image with tumour")
      label = 1
    } else if (selectedOption == "Without Tumor") {
      print("Generating image without tumour")
      label = 0
    }
    
    ## Start spinner
    shinybusy::show_modal_spinner(
      spin = "semipolar",
      text = paste0("... Please wait, generating synth image ...\n", selectedOption),
      color = "#000000"
    )
    
    
    if(input$modelSelect == "brainGen_diffuser_v1"){
      filepath<- py_libs$inference_diffuser()
    }
    else{
      filepath<- py_libs$inference(label,input$modelSelect)
    }
    
    # if(input$modelSelect == "brainGen_v1"){
    #   img_list <<- append(img_list,paste0("images/", trimws(filepath)))
    # }
    
    # print(img_list)
    
    ## Stop spinner
    shinybusy::remove_modal_spinner()
    img_pair <- list()
    for (i in 1:plot_count()) {
      img_pair<- append(img_pair,paste0("images/", trimws(filepath[i])))
      print(img_pair)
      i->> i
      output[[paste0("imageOutput_", i)]] <- rPlot(input, img_width, img_height, scale_factor,filepath,i)
    }
    
    img_list <<- append(img_list, list(img_pair))
    print(img_list)
    
    
    output$galOutput <- renderUI({
      render_images(rev(img_list))
    })
    
  })
  
}