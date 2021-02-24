# Define UI for application that draws a histogram
shinyUI(fluidPage(
     
  # Application title
   titlePanel("Transhipments"),
   
  # Sidebar with options to choose
  sidebarLayout(
    
    controls,
    
    mainPanel(
      
      tabsetPanel(
        
        # debug #uncomment to use as test, if needed
        main
        
      ),
      
    )
  )
)
)
