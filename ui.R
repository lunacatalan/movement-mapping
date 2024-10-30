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
            fileInput("file", "Upload Excel Sheet", 
                      accept = c(".xlsx", ".xls")),
            
            # Filters for categories A, B, and C ----
            selectInput("state", "State:", choices = c("Option A1", "Option A2", "Option A3")),
            selectInput("tag", "Tag", choices = c("Option B1", "Option B2", "Option B3")),
            selectInput("theme", "Theme", choices = c("Climate Change", "Gender", "Equity")),
            
            # Display filtered data ----
            DT::dataTableOutput("filteredData")
    )
  )
)


# combine all into a dashboard page ---------
dashboardPage(
  
  header, 
  sidebar, 
  body
)
