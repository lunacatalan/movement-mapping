server <- function(input, output, session) {
  
  
  # Baseline data ----
  baseline_data <- data.frame(
    A = c("Option A1", "Option A2", "Option A3", "Option A1"),
    B = c("Option B1", "Option B2", "Option B3", "Option B1"),
    C = c("Option C1", "Option C2", "Option C3", "Option C1")
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
    updateSelectInput(session, "state", choices = unique(combined_data()$A))
    updateSelectInput(session, "tag", choices = unique(combined_data()$B))
    updateSelectInput(session, "theme", choices = unique(combined_data()$C))
  })
  
  # Reactive filtered data ----
  filteredData <- reactive({
    combined_data() %>%
      filter(A == input$state, 
             B == input$tag, 
             C == input$theme)
  })
  
  # Output the filtered data table ----
  output$filteredData <- DT::renderDataTable({
    req(filteredData())
    filteredData()
  })
  
}
