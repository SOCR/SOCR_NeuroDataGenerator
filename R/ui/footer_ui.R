release = "v1.6"

footer_ui <- function(){
  tags$footer(
    div(shinyUI(bootstrapPage(div(
      # include The SOCR footer HTML
      includeHTML("./www/SOCR_footer.html")
    )))),
    
    div(paste("SOCR synthetic brain generator:  Version ", release),
        align = 'center'
    ),
    class = 'site-footer',
    
    # style="background-color: '#FFFFFF',
  )
}