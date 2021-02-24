output$debug <- renderText({
  
  print(paste(
              "$date_range is ", input$date_range[1], " to ", input$date_range[2],
              "$date_range class is ", class(input$date_range), 
              # "area is ",input$area, " - ",
              # "Preview is ",input$preview, " - ",
              # "Alt date is ",get_alt_date(), " - ",
              # "Species ",input$sp, " - ",
              " Sys date is ", Sys.Date(),
              sep = ""))
  
})