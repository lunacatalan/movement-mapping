server <- function(input, output, session) {
  
  
  # Baseline data ----
  baseline_data <- data.frame(
    Name = c("Option 1", "Option 2", "Option 3", "Option 1"),
    Scale = c("Option A1", "Option A2", "Option A3", "Option A1"),
    Type = c("Local", "Grassroots", "National Network", "Grassroots"),
    Constituancy = c("Youth", "National", "Youth", "General Public")
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
    updateSelectInput(session, "name", choices = unique(combined_data()$Name), selected = NULL)
    updateCheckboxGroupInput(session, "scale", choices = unique(combined_data()$Scale), selected = NULL)
    updateCheckboxGroupInput(session, "type", choices = unique(combined_data()$Type), selected = NULL)
    updateCheckboxGroupInput(session, "constituancy", choices = unique(combined_data()$Constituancy), selected = NULL)
  })
  
  # Reactive filtered data ----
  filteredData <- reactive({
    data <- combined_data()
    
    if (!is.null(input$name) && length(input$name) > 0) {
      data <- data %>% filter(Name %in% input$name)
    }
    if (!is.null(input$scale) && length(input$scale) > 0) {
      data <- data %>% filter(Scale %in% input$scale)
    }
    if (!is.null(input$type) && length(input$type) > 0) {
      data <- data %>% filter(Type %in% input$type)
    }
    if (!is.null(input$constituancy) && length(input$constituancy) > 0) {
      data <- data %>% filter(Constituancy %in% input$constituancy)
    }
    
    data
  })
  
  # Output the filtered data table ----
  output$filteredData <- DT::renderDataTable({
    req(filteredData())
    filteredData()
  })
  
}
