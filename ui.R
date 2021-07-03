# Define UI for application that draws a histogram
shinyUI(fluidPage(
     
  # Application title
   titlePanel("App template"),
   
  # Sidebar with options to choose
  sidebarLayout(
    
    controls,
    
    mainPanel(
      
      tabsetPanel(
        
        # debug #uncomment to use as test, if needed
        tab_view_1,
        tab_view_2
        
      ),
      
    )
  )
)
)
