server <- function(input, output, session) {
  
  
  # Baseline data ----
  baseline_data <- data.frame(
    name = c("test1", "test2", "test3", "test4"),
    contact = c("a@gmail.com", "b@gmail.com", "c@gmail.com", "d@gmail.com"),
    theme = c("climate justice", "gender violance", "racial justice", "immigration justice"),
    level = c("national", "state", "local", "state"),
    geography = c("USA", "NY", "Brooklyn", "CA"),
    toc = c("Fossil Finance", "National Lobbying", "State Lobbying", "Funder"),
    constituency = c("Youth", "National", "Youth", "General Public"),
    type = c("Local", "Grassroots", "National Network", "Grassroots")
  )
  
  # Reactive for uploaded data ----
  uploaded_data <- reactive({
    req(input$file)
    read_excel(input$file$datapath)
  })
  
  # Combine baseline data and uploaded data ----
  combined_data <- reactive({
    if (is.null(input$file)) {
      baseline_data
    } else {
      bind_rows(baseline_data, uploaded_data())
    }
  })
  
  # Update filter options based on combined data ----
  observe({
    updateSelectInput(session, "name", choices = unique(combined_data()$name), selected = NULL)
    updateCheckboxGroupInput(session, "level", choices = unique(combined_data()$level), selected = NULL)
    updateCheckboxGroupInput(session, "type", choices = unique(combined_data()$type), selected = NULL)
    updateCheckboxGroupInput(session, "toc", choices = unique(combined_data()$toc), selected = NULL)
    updateCheckboxGroupInput(session, "constituency", choices = unique(combined_data()$constituency), selected = NULL)
  })
  
  # Reactive filtered data ----
  filteredData <- reactive({
    data <- combined_data()
    
    if (!is.null(input$name) && length(input$name) > 0) {
      data <- data %>% filter(name %in% input$name)
    }
    if (!is.null(input$level) && length(input$level) > 0) {
      data <- data %>% filter(level %in% input$level)
    }
    if (!is.null(input$type) && length(input$type) > 0) {
      data <- data %>% filter(type %in% input$type)
    }
    
    if (!is.null(input$toc) && length(input$toc) > 0) {
      data <- data %>% filter(toc %in% input$toc)
    }
    
    if (!is.null(input$constituency) && length(input$constituency) > 0) {
      data <- data %>% filter(constituency %in% input$constituency)
    }
    
    data
  })
  
  # Output the filtered data table ----
  output$filteredData <- DT::renderDataTable({
    req(filteredData())
    filteredData()
  })
  
  # Generate plot on button click
    output$filteredPlot <- renderPlot({
      req(filteredData())
      
      # Example plot - Modify according to your data structure
      ggplot(filteredData(), aes(x = theme)) +
        geom_bar(stat = "count") +
        labs(title = "Filtered Data Plot", x = "Theme", 
             y = "Frequency") +
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
