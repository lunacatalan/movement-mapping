library(shiny)
library(shinydashboard)
library(DT)
library(dplyr)
library(readxl)
library(fresh)

library(tidyverse)

library(bslib)

source("setup.R")

# Create custom theme
mytheme <- create_theme(
  adminlte_color(
    light_blue = "#434C5E"
  ),
  adminlte_sidebar(
    width = "400px",
    dark_bg = "#D8DEE9",
    dark_hover_bg = "#81A1C1",
    dark_color = "#2E3440"
  ),
  adminlte_global(
    content_bg = "#FFF",
    box_bg = "#D8DEE9", 
    info_box_bg = "#D8DEE9"
  )
)

# Define UI
ui <- fluidPage(
  
  # Set theme ----
  theme = fresh::use_theme(mytheme),
  
  titlePanel("Mapping the Movement"),
  
  sidebarLayout(
    sidebarPanel(
      sidebar_content
    ),
    
    mainPanel(
      
      # File upload button
      fileInput("file", "Upload Excel Sheet",
                accept = c(".xlsx", ".xls")),
      
      # # Display filtered data
      DT::dataTableOutput("filteredData"),
      plotOutput("filteredPlot")
      
    )
  )
  
  
) # END UI

# Define server
server <- function(input, output, session) {
  
  # Baseline data
  baseline_data <- data.frame(
    name = c("test1", "test2", "test3", "test4"),
    contact = c("a@gmail.com", "b@gmail.com", "c@gmail.com", "d@gmail.com"),
    theme = c("climate justice", "gender violence", "racial justice", "immigration justice"),
    level = c("national", "state", "local", "state"),
    geography = c("USA", "NY", "Brooklyn", "CA"),
    toc = c("Fossil Finance", "National Lobbying", "State Lobbying", "Funder"),
    constituency = c("Youth", "National", "Youth", "General Public"),
    type = c("Local", "Grassroots", "National Network", "Grassroots")
  )
  
  # Reactive for uploaded data
  uploaded_data <- reactive({
    req(input$file)
    read_excel(input$file$datapath)
  })
  
  # Combine baseline data and uploaded data
  combined_data <- reactive({
    if (is.null(input$file)) {
      baseline_data
    } else {
      bind_rows(baseline_data, uploaded_data())
    }
  })
  
  # Update filter options based on combined data
  observe({
    updateCheckboxGroupInput(session, "level", choices = unique(combined_data()$level), selected = NULL)
    updateCheckboxGroupInput(session, "type", choices = unique(combined_data()$type), selected = NULL)
    updateCheckboxGroupInput(session, "toc", choices = unique(combined_data()$toc), selected = NULL)
    updateCheckboxGroupInput(session, "constituency", choices = unique(combined_data()$constituency), selected = NULL)
  })
  
  # Reactive filtered data
  filteredData <- reactive({
    data <- combined_data()
    
    if (!is.null(input$level) && length(input$level) > 0) {
      data <- data %>% 
        filter(level %in% input$level)
    }
    if (!is.null(input$type) && length(input$type) > 0) {
      data <- data %>% 
        filter(type %in% input$type)
    }
    if (!is.null(input$toc) && length(input$toc) > 0) {
      data <- data %>% 
        filter(toc %in% input$toc)
    }
    if (!is.null(input$constituency) && length(input$constituency) > 0) {
      data <- data %>% filter(constituency %in% input$constituency)
    }
    
    data
  })
  
  # Output the filtered data table
  output$filteredData <- DT::renderDataTable({
    req(filteredData())
    filteredData()
  })
  
  # Generate plot
  output$filteredPlot <- renderPlot({
    req(filteredData())
    ggplot(filteredData(), aes(x = theme)) +
      geom_bar(stat = "count") +
      labs(title = "Filtered Data Plot", x = "Theme", y = "Frequency") +
      theme_classic()
  })
  
  # Download handler for the filtered data
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("filtered_data", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      req(filteredData())
      write.csv(filteredData(), file, row.names = FALSE)
    }
  )
}

# Run the application
shinyApp(ui = ui, server = server)
