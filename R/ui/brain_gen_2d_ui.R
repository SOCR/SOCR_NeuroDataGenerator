

brain_gen_2d_panel_ui <- function (){
nav_panel(title = "2D Brain Gen", 
          card(
            layout_sidebar(
              div(id = "load_message",
                  h2("SOCR GAIM for 2D Brain Generation"),
                  # h5("... under development, testing & improvement ...")
              ),
              sidebar = sidebar(
                selectInput("modelSelect", "Model:",   choices = c("brainGen_v1","brainGenSeg_v1","brainGen_diffuser_v1")),
                selectInput("imageSelect", "Category:", choices = c("With Tumor", "Without Tumor")),
                actionButton("goButton", "Generate Image"),
                # actionButton("show_modal", "Show Modal Popup")
                # br(),
                # br(),
                actionLink("show_modal", "  ... Help & Info ...")
                
                # id="2D Brain Gen", "2D Brain Gen",
                # bsTooltip("2D Brain Gen", title="2D Brain Gen", trigger = "hover"),
                
              ),
              layout_columns(
                card(
                  uiOutput("plotOutput"),
                ),
                card(
                  uiOutput("galOutput"),
                ),
                
                col_widths = c(8,4)
                # uiOutput("imageGal")
              )
            )),
          # br()
          # uiOutput("plotOutput")
          
          # # plotlyOutput("imageOutput")
)
}