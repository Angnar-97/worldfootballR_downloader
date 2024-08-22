library(fresh)

mytheme <- create_theme(
  
  adminlte_color(
    
    light_blue = "#313131"
    
  ),
  
  adminlte_sidebar(
    
    width = "400px",
    dark_bg = "#D8DEE9",
    dark_hover_bg = "#758bd1",
    dark_color = "#2E3440",
    dark_submenu_color = "#465266"
    
  ),
  
  adminlte_global(
    
    content_bg = "#FFF",
    box_bg = "#C4CECF", 
    info_box_bg = "#2E3440"
    
  ),
  output_file = "themes/mytheme.css"
)
