# Required libraries
library(shiny)
library(golem)
library(yaml)
library(magick)


#' Add external Resources to the Application
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path("www", app_sys("app/www"))
  
  tags$head(
    favicon(ico="icon", rel="shortcut icon", resources_path="www", ext="png"),
    bundle_resources(path = app_sys("app/www"),
                     app_title = "SOCR 2D Synth Brain Image Generator")
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}

#' Access files in the current app
#'
#' NOTE: If you manually change your package name in the DESCRIPTION,
#' don't forget to change it here too, and in the config file.
#' For a safer name change mechanism, use the `golem::set_golem_name()` function.
#'
#' @param ... character vectors, specifying subdirectory and file(s)
#' within your package. The default, none, returns the root of the app.
#'
#' @noRd
app_sys <- function(...) {
  system.file(..., package = "Synth_2D_Brain_Img_Gen")
}


#' Read App Config
#'
#' @param value Value to retrieve from the config file.
#' @param config GOLEM_CONFIG_ACTIVE value. If unset, R_CONFIG_ACTIVE.
#' If unset, "default".
#' @param use_parent Logical, scan the parent directory for config file.
#' @param file Location of the config file
#'
#' @noRd
get_golem_config <- function(
    value,
    config = Sys.getenv("GOLEM_CONFIG_ACTIVE",
                        Sys.getenv("R_CONFIG_ACTIVE", "default")
    ),
    use_parent = TRUE,
    # Modify this if your config file is somewhere else
    file = app_sys("golem-config.yml")
) {
  config::get(value=value, config=config, file=file, use_parent=use_parent)
}




generate_plot <- function(input,imagepath, img_width, img_height, scale_factor) {

  t1_slider <- input$t1_slider
  t2_slider <- input$t2_slider
  flair_slider <- input$flair_slider
  
  image <- image_read(imagepath)
  
  # Flip and rotate the image
  # image <- image_flip(image)
  # image <- image_rotate(image, 90)
  
  # Extract channels
  red_channel <- image_channel(image, "red")
  green_channel <- image_channel(image, "green")
  blue_channel <- image_channel(image, "blue")
  
  # Adjust channel intensities based on slider values
  red_channel <- image_modulate(red_channel, brightness = t1_slider * 100)
  green_channel <- image_modulate(green_channel, brightness = t2_slider * 100)
  blue_channel <- image_modulate(blue_channel, brightness = flair_slider * 100)
  
  # Combine channels back into an image
  modified_image <- image_combine(c(red_channel, green_channel, blue_channel))
  
  # image <- readImage(imagepath)
  # image <- flip(image)
  # image <- rotate(image, 90)
  #  
  # 
  # # Example slider values for opacity (0 to 1)
  # red_opacity <- 0.5
  # green_opacity <- 0.75
  # blue_opacity <- 0.9
  # 
  # # Extract channels
  # red_channel <- channel(image, "red")
  # green_channel <- channel(image, "green")
  # blue_channel <- channel(image, "blue")
  # 
  # # Adjust channel intensities based on opacity values
  # red_channel <- red_channel     * t1_slider
  # green_channel <- green_channel * t2_slider
  # blue_channel <- blue_channel   * flair_slider
  # 
  # # Combine channels back into an image
  # modified_image <- combine(red_channel, green_channel, blue_channel)
  # image <- image_read(imagepath)
  

  
  # image <- load.image(imagepath)  # Replace "path/to/image.jpg" with the actual path to your image file

  # Convert the image to an array
  # image_array <- as.array(image)
  
  # image_array<- as.integer(image_data(image))
  # 
  # # Display information about the image array
  # print("t1_slider : ")
  # print(t1_slider)  # Print the dimensions of the image array
  # print(t2_slider)  
  # print(imagepath)
  # 
  # # print(image_array)
  # # image_array[, , 1, 1] <- image_array[, , 1, 1] * t1_slider
  # # image_array[, , 1, 2] <- image_array[, , 1, 2] * t2_slider
  # # image_array[, , 1, 3] <- image_array[, , 1, 3] * flair_slider
  # 
  # 
  # image_array[ , ,1] <- image_array[, ,1] * t1_slider
  # image_array[ , ,2] <- image_array[, ,2] * t2_slider
  # image_array[ , ,3] <- image_array[, ,3] * flair_slider
  # 
  # # Convert the modified array back to an image
  # # modified_image <- as.cimg(image_array)
  # modified_image <- image_read(image_array)
  
  
  
  # image <- image_read(imagepath)
  # 
  # # Convert the image to an array
  # image_array <- image_data(image, channels = "rgb")
  # 
  # # Ensure the array is numeric and scale appropriately
  # image_array <- as.numeric(image_array)
  # 
  # # Get the dimensions of the image
  # height <- image_info(image)$height
  # width <- image_info(image)$width
  # 
  # # Reshape to (height, width, channels)
  # dim(image_array) <- c(height, width, 3)
  # 
  # # Adjust the channel values based on the slider inputs
  # image_array[,,1] <- image_array[,,1] * red_opacity   # Red channel
  # image_array[,,2] <- image_array[,,2] * green_opacity # Green channel
  # image_array[,,3] <- image_array[,,3] * blue_opacity  # Blue channel
  # 
  # # Ensure the values are within the range 0-255
  # image_array <- pmin(image_array, 255)
  # image_array <- pmax(image_array, 0)
  # 
  # # Normalize the values back to the range 0-1
  # # image_array <- image_array / 255
  # 
  # # Convert the array to a matrix for each channel
  # red_channel <- matrix(image_array[,,1], nrow = height, ncol = width)
  # green_channel <- matrix(image_array[,,2], nrow = height, ncol = width)
  # blue_channel <- matrix(image_array[,,3], nrow = height, ncol = width)
  # 
  # # Combine the channels back into an array
  # combined_array <- array(c(red_channel, green_channel, blue_channel), dim = c(height, width, 3))
  
  # Write the array to a temporary file
  # temp_file <- tempfile(fileext = ".png")
  # writePNG(combined_array, temp_file)
  
  # Read the image back from the temporary file
  # image_modified <- image_read(temp_file)
  
  
  if (grepl("seg", imagepath)) {
    renderimagepath <-"images/temp_seg.png"
    print(renderimagepath)
  } else {
    renderimagepath <-"images/temp.png"
    print(renderimagepath)
  }
  
  # 
  
  # result <- paste("images/temp_", t1_slider, sep = "")
  # renderimagepath <- paste(result, ".png", sep = "")
  # print(renderimagepath)
  # Save the modified image to a file
  # save.image(modified_image,renderimagepath)
  
  # writePNG(modified_image, renderimagepath)
  image_write(modified_image, renderimagepath)
  
  image_url <- paste0(renderimagepath, "?", Sys.time())
  
  print(image_url)
  
  
  
  fig <- plot_ly(width=img_width * scale_factor,
                 height=img_height * scale_factor
  ) %>%
    add_trace( x= c(0, img_width * scale_factor),
               y= c(0, img_height * scale_factor),
               type = 'scatter',  mode = 'markers', alpha = 0)

  # Configure axes
  xconfig <- list(
    title = "",
    zeroline = FALSE,
    showline = FALSE,
    showticklabels = FALSE,
    showgrid = FALSE,
    range = c(0, img_width * scale_factor)
  )

  yconfig <- list(
    title = "",
    zeroline = FALSE,
    showline = FALSE,
    showticklabels = FALSE,
    showgrid = FALSE,
    range = c(0, img_height * scale_factor),
    scaleanchor="x"
  )

  fig <- fig %>% layout(xaxis = xconfig, yaxis = yconfig)

  # Add image

  fig <- fig %>% layout(
    images = list(
      list(
        source = image_url,
        x=0,
        sizex=img_width * scale_factor,
        y=img_height * scale_factor,
        sizey=img_height * scale_factor,
        xref="x",
        yref="y",
        opacity=1.0,
        layer="below",
        sizing="stretch"
      )
    ))

  # Configure other layout
  #
  m = list(r=0, l=0, b=0, t=0)
  fig <- fig %>% layout(margin = m) %>%
    layout(plot_bgcolor='#e5ecf6',
           xaxis = list(
             zerolinecolor = '#ffff',
             zerolinewidth = 2,
             gridcolor = 'ffff'),
           yaxis = list(
             zerolinecolor = '#ffff',
             zerolinewidth = 2,
             gridcolor = 'ffff')
    )

  
  
  return(fig)
}




rPlot<- function (input,img_width, img_height, scale_factor,filepath,i){
  
  t1_slider <- input$t1_slider
  
  imagepath <- paste0("images/", trimws(filepath[i]))
  print("In rplot")
  print(imagepath)
  renderPlotly({
    fig <- generate_plot(input,imagepath, img_width, img_height, scale_factor)
    # print(i)
    print(img_height)
    return(fig)
  })
}


render_images <- function(files_list) {
  # Apply lapply to each inner list of files
  image_tags <- lapply(files_list, function(files) {
    # Create a list of image tags for each inner list
    images_in_row <- lapply(files, function(file) {
      tags$img(src = file, width = "200px", class = "gallery-img-row")
    })
    
    # Wrap the images in a row div
    div(class = "gallery-img", images_in_row)
  })
  
  # Wrap the rows of images in a gallery div
  tagList(
    div(class = "gallery", image_tags)
  )
}






