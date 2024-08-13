###################################################
# SOCR 2D SYnthetic Brain Image Generator
# Prepare a list of available R data sets
###################################################

###################################################
# Global variables
###################################################

###################################################
# https://platform.openai.com/docs/model-index-for-researchers
###################################################

release <- "1.1" # 2D_GAIM_IG version
sqlitePath <- "./data/usage_data.db" # folder to store the synth-generated image results
sqltable <- "usage"
language_model <- "SOCR_GAIM"

# if this file exists, run on the server, otherwise run locally.
# this is used to change app behavior.
on_server <- "on_server.txt"


#' Move an element to the front of a vector
#'
#' The response from GPT3 sometimes contains strings that are not R commands.
#'
#' @param v is the vector
#' @param e is the element
#'
#' @return Returns a reordered vector
move_front <- function(v, e){
  ix <- which(v == e)
  
  # if found, move to the beginning.
  if(length(ix) != 0) {
    v <- v[-ix]
    v <- c(e, v)
  }
  return(v)
}

