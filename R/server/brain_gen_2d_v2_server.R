source("R/utils.R")

config   <- read_yaml("configs/config.yaml")
uiconfig <- read_yaml("configs/ui_config.yaml")
img_list_p2 <-list()

# load variables from configs
img_folder_path <- config$img_path
img_width       <- uiconfig$img_width
img_height      <- uiconfig$img_height
scale_factor    <- uiconfig$scale_factor




brain_gen_2d_v2_panel_server <- function(input, output, session,py_libs){
  
  # print(input$modelSelect_p2)
  
  plot_count <- reactive({
    if(input$modelSelect_p2 == "brainGen_v1"){
      print(input$modelSelect_p2)
      plotCount <- 1
    }
    else if(input$modelSelect_p2 == "brainGenSeg_v1"){
      plotCount <- 2
      
    }
    return(plotCount)
  })

  output$plotOutput_p2 <- renderUI({

    plot_outputs <- lapply(1:plot_count(), function(i) {
      div(
        plotlyOutput(paste0("imageOutput_p2_", i),width = "100%"),
        class = "plot-item"
      )
    })

    # fluidRow(do.call(tagList, plot_outputs))
    div(class = "plot-grid", do.call(tagList, plot_outputs))
  })


  observeEvent(input$goButton_p2, {


    tumour           <- input$imageSelect_p2
    sliceOrientation <- input$sliceOrein_p2
    sliceLocation    <- input$sliceLoc_p2
    
    
    # if (selectedOption == "With Tumor") {
    #   print("Generating image with tumour")
    #   label = 1
    # } else if (selectedOption == "Without Tumor") {
    #   print("Generating image without tumour")
    #   label = 0
    # }

    ## Start spinner
    shinybusy::show_modal_spinner(
      spin = "semipolar",
      text = paste0("... Please wait, generating synth image ...\n", tumour),
      color = "#000000"
    )

    filepath<- py_libs$inference(input$modelSelect_p2,tumour,sliceOrientation, sliceLocation)
    # if(input$modelSelect == "brainGen_v1"){
    #   img_list_p2 <<- append(img_list_p2,paste0("images/", trimws(filepath)))
    # }

    # print(img_list_p2)

    ## Stop spinner
    shinybusy::remove_modal_spinner()
    img_pair <- list()
    for (i in 1:plot_count()) {
      img_pair<- append(img_pair,paste0("images/", trimws(filepath[i])))
      print(img_pair)
      i->> i
      output[[paste0("imageOutput_p2_", i)]] <- rPlot(input,img_width, img_height, scale_factor,filepath,i)
    }

    img_list_p2 <<- append(img_list_p2, list(img_pair))
    print(img_list_p2)


    output$galOutput_p2 <- renderUI({
      render_images(rev(img_list_p2))
    })

  })
  
}