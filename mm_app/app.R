library(shiny)
library(shinydashboard)
library(DT)
library(dplyr)
library(readxl)
library(fresh)

library(tidyverse)

library(bslib)
library(thematic)
library(openxlsx)

source("setup.R")

# change plots
thematic_shiny()

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
ui <- page_sidebar(
  
  # Set theme ----
  theme = bs_theme(bootswatch = "superhero"),
  
  title = "Mapping the Movement",
  
  sidebar = sidebar(
    
    sidebar_content
  ),
  
  layout_columns(
  
        # Card 1: File upload button
        card(
        
          # display all data
          DT::dataTableOutput("combinedData")),
  
        #Card 2: Output plots
        card(plotOutput("combinedPlot")),
        
        
        # Card 3: filtered data
        card(DT::dataTableOutput("filteredData")),
        
        #Card 4: Output plots
        card(plotOutput("filteredPlot")),
        
        # Card 5:file output button 
        card(downloadButton("filteredFile", label = "Download Selected Organizations")),
        
        # Card 6: Data upload button
        card(fileInput("file", "Upload Excel Sheet",
                       accept = c(".xlsx", ".xls"))),
        
        
        col_widths = c(8, 4, 8, 4, 4, 4)
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
  
  # Reactive filtered data - rows that meet ANY of the conditions will be shown
  filteredData <- reactive({
    data <- combined_data()
      
    # Initialize an empty logical vector for OR filtering
    filter_condition <- rep(FALSE, nrow(data))
    
    # Update filter_condition based on each input
    if (!is.null(input$level) && length(input$level) > 0) {
      filter_condition <- filter_condition | (data$level %in% input$level)
    }
    if (!is.null(input$type) && length(input$type) > 0) {
      filter_condition <- filter_condition | (data$type %in% input$type)
    }
    if (!is.null(input$toc) && length(input$toc) > 0) {
      filter_condition <- filter_condition | (data$toc %in% input$toc)
    }
    if (!is.null(input$constituency) && length(input$constituency) > 0) {
      filter_condition <- filter_condition | (data$constituency %in% input$constituency)
    }
    
    # Apply the filter condition - only values with TRUE are shown
    data <- data[filter_condition, ]
    
    data
  })
  
  # Render data table with row selection enabled
  output$combinedData <- DT::renderDataTable({
    DT::datatable(
      combined_data(), 
      selection = "multiple", 
      options = list(pageLength = 5, autoWidth = TRUE)
    )
  })
  # Render data table with row selection enabled
  output$filteredData <- DT::renderDataTable({
    DT::datatable(
      filteredData(), 
      selection = "multiple", 
      options = list(pageLength = 5, autoWidth = TRUE)
    )
  })
  
  output$filteredFile <- downloadHandler(
    filename = function() {
      paste("filtered_data", ".xlsx", sep = "")
    },
    content = function(file) {
      openxlsx::write.xlsx(filteredData(), file)
    }
  )
  
  # Output all data plot
  output$combinedPlot <- renderPlot({
    req(combined_data())
    ggplot(combined_data(), 
           aes(x = theme,
               fill = level)) +
      geom_bar(stat = "count") +
      labs(title = "All Data Plot", 
           x = "", 
           y = "# of Organizations")
  })
  
  # Generate plot
  output$filteredPlot <- renderPlot({
    req(filteredData())
    ggplot(filteredData(), 
           aes(x = theme,
               fill = level)) +
      geom_bar(stat = "count") +
      labs(title = "Filtered Data Plot", 
           x = "", 
           y = "# of Organizations")
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
