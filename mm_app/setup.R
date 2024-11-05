# setup.R

sidebar_content <-
  list(
  
    # we can make this so that when the data frame is updated, a new list of the themes are included since this is hard coded and is not the best
    # selectizeInput("theme", "Theme",
    #                choices = unique(combined_data$theme)
    
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