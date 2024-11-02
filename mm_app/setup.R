# setup.R

sidebar_content <-
  list(
    # Filters for categories A, B, and C
    checkboxGroupInput("level", "Level", 
                       choices = c("National", "State", "Local")),
    checkboxGroupInput("type", "Type", 
                       choices = c("Local", "Grassroots", "National Network", "Grassroots")),
    checkboxGroupInput("toc", "Theory of Change", 
                       choices = c("Fossil Finance", 
                                   "National Lobbying",
                                   "State Lobbying", "Funder")),
    checkboxGroupInput("constituency", "Constituency", 
                       choices = c("Youth", "Frontline", "General Public")),
    
    "This app allows users to find coalitions they want to work with!."
  )