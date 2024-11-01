# load packages ----
library(shiny)
library(tidyverse)
library(dplyr)
library(readxl)

library(bslib)

# has the selections for themes
source("setup.R")

# _ layout
# _ card and value boxes
# _ logo
# _ theme and colors 

ui <- page_sidebar(
  title = "Mapping the movement",
  sidebar = sidebar(
    
    sidebar_content
  )
)

server <- function(input, output, session) {
  
  
} 

# Create the Shiny app
shinyApp(ui = ui, server = server)