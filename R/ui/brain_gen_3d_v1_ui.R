library(shiny)

brain_gen_3d_v1_panel_ui <- function (){
  nav_panel(title = "3D Brain Gen  V1", 
            card(
              layout_sidebar(
                div(id = "load_message",
                    # h2("SOCR GAIM for 3D Brain Generation"),
                    # h5("... under development, testing & improvement ...")
                ),
                sidebar = sidebar(
                  selectInput("modelSelect_p3", "Model:",   choices = c("brain3DGen_v1")),
                  selectInput("resolution", "Model resolution:", choices = c("32x32x32", "64x64x64")),
                  # selectInput("imageSelect_p2", "Choose an option:", choices = c("With Tumor", "Without Tumor")),
                  # selectInput("sliceOrein_p2",  "Slice Orientation", choices = c("Axial", "Sagittal","Coronal")),
                  # selectInput("sliceLoc_p2", "Slice Location:", choices = NULL),
                
                  actionButton("goButton_p3", "Generate Image"),
                  # actionButton("show_modal", "Show Modal Popup")
                  # br(),
                  # br(),
                  actionLink("show_modal_p3", "  ... Help & Info ..."),
                  
                  card(
                    
                    # 
                    # fluidRow(
                    #   
                    #   column(6,selectInput("colorscale_3dplot", "Colorscale", choices = c("Viridis", "Cividis", "Inferno", "Magma",
                    #                                                                       "Plasma", "Turbo", "Hot", "Jet", "Rainbow",
                    #                                                                       "Electric", "YlGnBu", "RdBu", "Blues", "Greens", "Greys")),
                    #   ),
                    #   column(6,numericInput("surface_count_3dplot", "Surface count", value = 1, min = 1, max = 30, step = 1)),
                    # ),
                  
                    selectInput("colorscale_3dplot", "Colorscale", choices = c("Viridis", "Cividis", "Inferno", "Magma",
                                                                             "Plasma", "Turbo", "Hot", "Jet", "Rainbow",
                                                                             "Electric", "YlGnBu", "RdBu", "Blues", "Greens", "Greys","Thermal")),
                    numericInput("surface_count_3dplot", "Surface count", value = 1, min = 1, max = 30, step = 1),
                    fluidRow(
                      column(6,numericInput("iso_min_3dplot", "Iso min", value = 0.1, min = 0, max = 1, step = 0.05),),
                      column(6,numericInput("iso_max_3dplot", "Iso max", value = 0.9, min = 0, max = 1, step = 0.05),),
                      
                    ),
                    p("Flip Axes"),
                    fluidRow(
                      column(4,checkboxInput("flip_checkbox_x", "x", value = FALSE)),
                      column(4,checkboxInput("flip_checkbox_y", "y", value = FALSE)),
                      column(4,checkboxInput("flip_checkbox_z", "z", value = FALSE))
                      )
                    ,
                    
                    sliderInput("opacity_3dplot", label = "opacity", min = 0.0, max = 1.0, value = 0.5)
                  
                  )
                  
                  
                  
                 
                  
                  
                  
                  # id="2D Brain Gen", "2D Brain Gen",
                  # bsTooltip("2D Brain Gen", title="2D Brain Gen", trigger = "hover"),
                  
                ),
                layout_columns(
                  # card(
                    
                    fluidRow(
                      column(width = 9, plotlyOutput("plot3d", height = "600px")),
                      column(width = 3,
                             
                            fluidRow(
                               
                            column(width = 9,
                                   plotlyOutput("plot2d_x", height = "150px", width = "150px"),
                                   uiOutput("plot2d_x_title"),
                             
                            ),
                            column(width = 3,
                                    uiOutput("dynamic_slider_x"),
                             )
                            ),
                            
                            fluidRow(
                              
                              column(width = 9,
                                     plotlyOutput("plot2d_y", height = "150px", width = "150px"),
                                     uiOutput("plot2d_y_title"),
                              ),
                              column(width = 3,
                                     uiOutput("dynamic_slider_y"),
                                     
                              )
                            ),
                            
                            fluidRow(
                              
                              column(width = 9,
                                     
                                     plotlyOutput("plot2d_z", height = "150px", width = "150px"),
                                     uiOutput("plot2d_z_title"),
                              ),
                              column(width = 3,
                                     uiOutput("dynamic_slider_z"),
                              )
                            ),
                      )
                    )
                  ,
                  card(
                    card_header("Files",downloadButton("download_all", "Download All Files", class = "down-all-btn custom-btn btn-primary"),),
                    card_body(
                    class = "p-0",
                    uiOutput("file_cards"),
                    # uiOutput("modal_slices")
                    )
                  ),
                  
                  col_widths = c(9,3),
                  # uiOutput("imageGal")
                  
                 
                )
              )),
            
            
            
          
  )
}