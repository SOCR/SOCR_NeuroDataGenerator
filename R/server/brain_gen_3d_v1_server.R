source("R/utils.R")

config   <- read_yaml("configs/config.yaml")
uiconfig <- read_yaml("configs/ui_config.yaml")
img_list_p2 <-list()

# load variables from configs
img_folder_path <- config$img_path
img_width       <- uiconfig$img_width
img_height      <- uiconfig$img_height
scale_factor    <- uiconfig$scale_factor




brain_gen_3d_v1_panel_server <- function(input, output, session,py_libs){
  
  # Hardcoded directory path
  hardcoded_path <- paste0(getwd(), "/images")
  
  # Reactive value to store attached events
  rv <- reactiveValues(attached_files = character())
  
  # Call the function to render file tab and attach event handlers
  render_file_tab(rv, input, output, session, hardcoded_path)
  
  
  # render_file_tab(input,output,session,rv)
  
  
  
  observeEvent(input$goButton_p3, {

    resolution_3d <- input$resolution
    ## Start spinner
    shinybusy::show_modal_spinner(
      spin = "semipolar",
      text = paste0("... Please wait, generating synth image ...\n"),
      # text = paste0("... Please wait, generating synth image ...\n", tumour),
      color = "#000000"
    )

    # filepath<- py_libs$inference(input$modelSelect_p3,tumour,sliceOrientation, sliceLocation)
    file_path_model_out<- py_libs$inference(input$modelSelect_p3, resolution_3d)
  
    shinybusy::remove_modal_spinner()
    
    render_3d_volume(input,output,session,file_path_model_out)
    
    # Call the function to render file tab and attach event handlers
    render_file_tab(rv, input, output, session, hardcoded_path)
    
    
    

  })
  
}



## function to render the main plotting window

render_3d_volume <- function(input,output,session,filepath){
  nii_data <- reactive({
    # Replace input$file$datapath with hardcoded_file_path for testing
    nii <- readNIfTI(filepath)
    list(
      data = nii,
      dim = dim(nii)
    )
  })
  
  print(nii_data()$dim)
  
  
  ## render the slides for the plots
  output$dynamic_slider_x <- renderUI({
    # Define the slider
    noUiSliderInput(
      inputId = "slice_x",
      min = 0, max = 32,
      value = 16,orientation = "vertical", height = "150px",
      width = "5px",
      tooltips = FALSE,
      direction = "rtl",
      update_on = "change"
    )
  })
  output$dynamic_slider_y <- renderUI({
    
    # Define the slider
    noUiSliderInput(
      inputId = "slice_y",
      min = 0, max = 32,
      value = 16,orientation = "vertical", height = "150px",
      width = "5px",
      tooltips = FALSE,
      direction = "rtl",
      update_on = "change"
    )
  })
  output$dynamic_slider_z <- renderUI({
    # Define the slider
    noUiSliderInput(
      inputId = "slice_z",
      min = 0, max = 32,
      value = 16,orientation = "vertical", height = "150px",
      width = "5px",
      tooltips = FALSE,
      direction = "rtl",
      update_on = "change"
    )
  })
  
  
  # render the titles for the plots
  output$plot2d_x_title <- renderUI({div(class = "plot-title", "Sagittal")})
  output$plot2d_y_title <- renderUI({div(class = "plot-title", "Coronal")})
  output$plot2d_z_title <- renderUI({div(class = "plot-title", "Axial")})
  
  # Adjust slider limits based on data dimensions
  observe({
    dims <- nii_data()$dim
    updateSliderInput(session, "slice_x", max = dims[1], value = round(dims[1] / 2))
    updateSliderInput(session, "slice_y", max = dims[2], value = round(dims[2] / 2))
    updateSliderInput(session, "slice_z", max = dims[3], value = round(dims[3] / 2))
  })
  # 3D plot
  
  nii <- nii_data()$data
  dims <- nii_data()$dim
  
  flipped_data <- reactive({
    data<- nii
    if (input$flip_checkbox_x) {
      data <- data[rev(seq_len(dims[1])),,]
    } 
    if (input$flip_checkbox_y) {
      data <- data[,rev(seq_len(dims[2])),]
    } 
    if (input$flip_checkbox_z) {
      data <- data[,,rev(seq_len(dims[3]))]
    }
    data  
  })
  
  # nii <- nii[,,rev(seq_len(dims[3]))]
  
  output$plot3d <- renderPlotly({
    
    nii_flipped <- flipped_data()
    
    # dims <- nii_data()$dim
    
    
    
    # Create mesh grid
    x <- seq_len(dims[1])
    y <- seq_len(dims[2])
    z <- seq_len(dims[3])
    
    # z<- rev(z)
    
    grid <- expand.grid(x = x, y = y, z = z)
    values <- as.numeric(nii_flipped)
    print(length(values))
    print(max(values))
    
    df = as.data.frame(cbind(x = grid$x,y=grid$y,z = grid$z,value = values))
    
    
    plot_ly( data = df,
             x = ~x,
             y = ~y,
             z = ~z,
             value = ~value,
             isomin = input$iso_min_3dplot,
             isomax = input$iso_max_3dplot,
             opacity = input$opacity_3dplot,
             surface = list(count = input$surface_count_3dplot),
             colorscale = input$colorscale_3dplot,
             type = "volume"
             # flatshading = FALSE
    ) %>%
      layout(
        scene = list(
          xaxis = list(title = "X"),
          yaxis = list(title = "Y"),
          zaxis = list(title = "Z"),
          surface = list(
            colorbar = list(
              title = "Intensity",
              titleside = "right",
              tickvals = c(0, 1),
              ticktext = c("Low", "High")
            )
          )
        )
      )
  })
  
  # 2D plot along X axis
  output$plot2d_x <- renderPlotly({
    # nii <- nii_data()$data
    nii_flipped <- flipped_data()
    slice_x <- t(nii_flipped[input$slice_x, , ])
    # slice_x <- apply(t(slice_x),2,rev)
    plot_ly(z = ~slice_x, type = "heatmap",zmin = 0, zmax = 1,colorscale = input$colorscale_3dplot) %>%hide_colorbar()%>%
      layout(
      margin = list(l = 0, r = 0, b = 0, t = 0, pad = 0),  # Remove extra margins
      xaxis = list(showticklabels = FALSE, showgrid = FALSE, zeroline = FALSE),
      yaxis = list(showticklabels = FALSE, showgrid = FALSE, zeroline = FALSE),
      title = list(text = "X Slice", y = -0.2, x = 0.5, xanchor = 'center'), margin = list(b = 40)
    )
    
  
    # layout(showlegend = FALSE)
  })
  
  # 2D plot along Y axis
  output$plot2d_y <- renderPlotly({
    # nii <- nii_data()$data
    nii_flipped <- flipped_data()
    slice_y <- nii_flipped[, input$slice_y, ]
    # slice_y <- apply(t(slice_y),2,rev)
    plot_ly(z = ~slice_y, type = "heatmap",zmin = 0, zmax = 1,colorscale = input$colorscale_3dplot) %>%hide_colorbar() %>%
      layout(
        margin = list(l = 0, r = 0, b = 0, t = 0, pad = 0),  # Remove extra margins
        xaxis = list(showticklabels = FALSE, showgrid = FALSE, zeroline = FALSE),
        yaxis = list(showticklabels = FALSE, showgrid = FALSE, zeroline = FALSE),
        title = list(text = "Y Slice", y = -0.2, x = 0.5, xanchor = 'center'), margin = list(b = 40)
      )
  })
  
  # 2D plot along Z axis
  output$plot2d_z <- renderPlotly({
    # nii <- nii_data()$data
    nii_flipped <- flipped_data()
    slice_z <- nii_flipped[, , input$slice_z]
    plot_ly(z = ~slice_z, type = "heatmap", zmin = 0, zmax = 1,colorscale = input$colorscale_3dplot) %>%hide_colorbar() %>%
      layout(
        margin = list(l = 0, r = 0, b = 0, t = 0, pad = 0),  # Remove extra margins
        xaxis = list(showticklabels = FALSE, showgrid = FALSE, zeroline = FALSE),
        yaxis = list(showticklabels = FALSE, showgrid = FALSE, zeroline = FALSE),
        title = list(text = "Z Slice", y = -0.2, x = 0.5, xanchor = 'center'), margin = list(b = 40)
      )
    # layout(showlegend = FALSE)
  })
  
  
  
}



## Function to render the file tab
render_file_tab <- function(rv, input, output, session, hardcoded_path) {
  # Reactive expression to get list of NIfTI files
  nii_files <- reactive({
    if (is.null(hardcoded_path)) {
      return(NULL)
    }
    # Get the list of files
    files <- list.files(hardcoded_path, pattern = "\\.nii\\.gz$", full.names = TRUE)
    
    if (length(files) == 0) {
      return(NULL)
    }
    
    # Get file info including creation times
    file_info <- file.info(files)
    
    # Order files by creation time (newest first)
    ordered_files <- files[order(file_info$ctime, decreasing = TRUE)]
    
    return(ordered_files)
  })
  
  # Render file list in a UI card
  output$file_cards <- renderUI({
    files <- nii_files()
    if (is.null(files) || length(files) == 0) {
      return(h4("No folder selected or no NIfTI files found in the folder."))
    }
    file_cards <- lapply(files, function(file) {
      file_name <- basename(file)
      card_body <- div(
        p(strong(file_name)),
        downloadButton(outputId = paste0("download_", file_name), label = "Download", class = "custom-btn btn-primary"),
        actionButton(inputId = paste0("qview_", file_name), label = "Q View", class = "custom-btn btn-secondary"),
        actionButton(inputId = paste0("open_", file_name), label = "Open", class = "custom-btn btn-secondary")
      )
      card <- div(class = "card mb-2", div(class = "card-body", card_body))
      card
    })
    do.call(tagList, file_cards)
  })
  
  # Observe file changes and attach event handlers
  observe({
    files <- nii_files()
    new_files <- setdiff(files, rv$attached_files)
    
    lapply(new_files, function(file) {
      file_name <- basename(file)
      local({
        f <- file
        fn <- file_name
        
        output[[paste0("download_", fn)]] <- downloadHandler(
          filename = function() { fn },
          content = function(con) {
            file.copy(f, con)
          }
        )
        
        observeEvent(input[[paste0("open_", fn)]], {
          render_3d_volume(input, output, session, f)
        })
        
        observeEvent(input[[paste0("qview_", fn)]], {
          # Read NIfTI file and extract slices
          nii <- readNIfTI(f)
          dims <- dim(nii)
          
          slice_x <- nii[round(dims[1] / 2), , ]
          slice_y <- nii[, round(dims[2] / 2), ]
          slice_z <- nii[, , round(dims[3] / 2)]
          
          output$plot2d_x_Qview <- renderPlotly({
            plot_ly(z = ~slice_x, type = "heatmap") %>% hide_colorbar()
          })
          
          output$plot2d_y_Qview <- renderPlotly({
            plot_ly(z = ~slice_y, type = "heatmap") %>% hide_colorbar()
          })
          
          output$plot2d_z_Qview <- renderPlotly({
            plot_ly(z = ~slice_z, type = "heatmap") %>% hide_colorbar()
          })
          
          showModal(modalDialog(
            title = tags$div(class = "modal-title", paste("File:", fn)),
            size = "l",
            fluidRow(
              column(4, plotlyOutput("plot2d_x_Qview", height = "200px", width = "200px"), div(class = "plot-title", "Sagittal")),
              column(4, plotlyOutput("plot2d_y_Qview", height = "200px", width = "200px"), div(class = "plot-title", "Coronal")),
              column(4, plotlyOutput("plot2d_z_Qview", height = "200px", width = "200px"), div(class = "plot-title", "Axial"))
            ),
            footer = modalButton("Close")
          ))
        })
      })
      
      # Mark this file as having event handlers attached
      rv$attached_files <- c(rv$attached_files, file)
    })
  })
  
  # Download handler for all files
  output$download_all <- downloadHandler(
    filename = function() { "all_nii_files.zip" },
    content = function(file) {
      files <- nii_files()
      zip::zipr(file, files) # Use zip::zipr to create the zip file
    }
  )
}
