controls <- sidebarPanel( 
  
  ##-- control fields ----
  h1("General variables"),
  dateRangeInput("date_range", "Date range input",
                 start = Sys.Date() - 10, end = Sys.Date()),
  
  # selectInput("season", "Choose the season", as.list(seasons$CSN_Code), selected = 2021), #max(seasons$CSN_Name)
  # 
  # uiOutput('area'),
  # 
  # uiOutput('sp'),
  # 
  # checkboxInput("config", "Change configuration", value = F),
  # 
  # 
  # conditionalPanel(
  #   
  #   condition = "input.config == true",
  #   
  #   
  #   
  #   checkboxInput("change_vsls", "Change vessels participating", value = F),
  #   
  #   conditionalPanel(
  #     
  #     condition = "input.change_vsls == true",
  #     
  #     withTags({
  #       h4("Vessels fishing x Not fishing")
  #     }),
  #     
  #     uiOutput('choose_vsl'),
  #     br(),
  #     # actionButton("update_vsl", "Update vsls"),
  #     # br(),
  #     br()
  #     
  #   ),
  #   
  h1("Specific port inspection variables"),
  checkboxInput("ca", "Only consider catches in CCAMLR area", value = T),
  #   
  numericInput("d_tolerance", "how many days of tolerance for port_inspections?", 20),
  #   
  # ),
  # 
  actionButton("get_data", "Click to check results"),
  
  , width = 3
  
)