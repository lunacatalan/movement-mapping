# dashboard header ------------------------------
header <- dashboardHeader(
  
  # title -----
  title = "Movement Mapping",
  titleWidth = 400 # change width of the title 
  
  
)



# dashboard sidebar ------------------------------
sidebar <- dashboardSidebar(
  
  # sidebar ----
  sidebarMenu(
    
    # Home menu item
    menuItem(text = "Home", 
             tabName = "home" # unique identifier to refer
    )
  )
) # END sidebar


# dashboard body ------------------------------
body <- dashboardBody(
  
  # Set theme ----
  fresh::use_theme("dashboard-fresh-theme.css"),
  
  # TabItems ----
  tabItems(
    
    # Welcome tabItem ----
    tabItem(tabName = "home",
            h2("Organizations"),
            
            # File upload button ----
            ## alternatively having a link to a google sheet to upload the data there so that the data source is updated not just temporarily
            fileInput("file", "Upload Excel Sheet", 
                      accept = c(".xlsx", ".xls")),
            
            # Filters for categories A, B, and C ----
            #selectInput("name", "Name", choices = baseline_data$name, multiple = TRUE),
            checkboxGroupInput("level", "Level", choices = c("National", "State", "Local")),
            checkboxGroupInput("type", "Type", choices = c("Local", "Grassroots", "National Network", "Grassroots")),
            checkboxGroupInput("toc", "Theory of Change", choices = c("Fossil Finance", "National Lobbying", 
                                                                      "State Lobbying", "Funder")),
            checkboxGroupInput("constituency", "Constituency", choices = c("Youth", "Frontline", "General Public")),
            
            # Display filtered data ----
            DT::dataTableOutput("filteredData"),
            plotOutput("filteredPlot")  # Plot output area
    )
  )
)


# combine all into a dashboard page ---------
dashboardPage(
  
  header, 
  sidebar, 
  body
)
