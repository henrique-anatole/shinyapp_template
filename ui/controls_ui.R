controls <- sidebarPanel( 
  
  ##-- control fields ----
  
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
  #   selectInput("type", "No different approach available yet, sorry...", list("avg_day_cpue")),
  #   
  #   numericInput("rep_period", "how many reporting periods to calculate the averages? Default is all period (leave it blank)", NA)
  #   
  # ),
  # 
  # actionButton("forecast", "Run forecast"),
  
  , width = 3
  
)