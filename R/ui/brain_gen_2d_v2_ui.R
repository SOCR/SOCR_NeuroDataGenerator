brain_gen_2d_v2_panel_ui <- function (){
  nav_panel(title = "2D Brain Gen  V2", 
            card(
              layout_sidebar(
                div(id = "load_message",
                    h2("SOCR GAIM for 2D Brain Generation"),
                    # h5("... under development, testing & improvement ...")
                ),
                sidebar = sidebar(
                  selectInput("modelSelect_p2", "Model:",   choices = c("brainGen_v1","brainGenSeg_v1")),
                  selectInput("imageSelect_p2", "Category:", choices = c("With Tumor", "Without Tumor")),
                  selectInput("sliceOrein_p2",  "Slice Orientation", choices = c("Axial", "Sagittal","Coronal")),
                  selectInput("sliceLoc_p2", "Slice Location:", choices = NULL),
                  
                  actionButton("goButton_p2", "Generate Image"),
                  # actionButton("show_modal", "Show Modal Popup")
                  # br(),
                  # br(),
                  actionLink("show_modal_p2", "  ... Help & Info ...")
                  
                  # id="2D Brain Gen", "2D Brain Gen",
                  # bsTooltip("2D Brain Gen", title="2D Brain Gen", trigger = "hover"),
                  
                ),
                layout_columns(
                  card(
                    card(
                    uiOutput("plotOutput_p2"),
                    ),
                    card(
                    fluidRow(
                      column(4, sliderInput("t1_slider", label = "t1", min = 0.0, max = 1.0, value = 1.0)),
                      column(4, sliderInput("t2_slider", label = "t2", min = 0.0, max = 1.0, value = 1.0)),
                      column(4, sliderInput("flair_slider", label = "flair", min = 0.0, max = 1.0, value = 1.0))
                    )
                    )
                    # sliderInput("t1_slider", label = "t1", min = 0.0, max = 1.0, value = 0.8),
                    # sliderInput("t2_slider", label = "t2", min = 0.0, max = 1.0, value = 0.8),
                    # sliderInput("flair_slider", label = "flair", min = 0.0, max = 1.0, value = 0.8)
                  ),
                  card(
                    uiOutput("galOutput_p2"),
                  ),
                  
                  col_widths = c(8,4)
                  # uiOutput("imageGal")
                )
              )),
          
  )
}