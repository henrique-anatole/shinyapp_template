# Define UI for application that draws a histogram
shinyUI(fluidPage(
     
  # Application title
   titlePanel("CCEP tables"),
   
  # Sidebar with options to choose
  sidebarLayout(
    
    controls,
    
    mainPanel(
      
      tabsetPanel(
        
        # debug #uncomment to use as test, if needed
        transhipments_view,
        port_inspections_view
        
      ),
      
    )
  )
)
)
