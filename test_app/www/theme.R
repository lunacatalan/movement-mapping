set_theme<-function(){
  
  theme<-fresh::create_theme(
    
    fresh::adminlte_color(
      light_blue = "#383F48",
      aqua = "#094357",
      green = "#094357",
      blue = "#383F48"
    ),
    
    fresh::adminlte_global(
      box_bg = "#FFFFFF",
      info_box_bg = "#D1E0E5"
    ),
    
    fresh::adminlte_vars(
      "sidebar-width" = "275px",
      "sidebar-dark-bg" = "#3A3F46",
      "sidebar-dark-hover-color" = "#FFB151",
      "btn-border-radius" = "1px"
    )
  )
  
  shiny::addResourcePath('www', system.file("www", package = "myPackage"))
  
  return(theme)
  
}