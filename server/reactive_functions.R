
# CCAMLR area activities

get_tranships_data <- reactive({
  
  date_range <- input$date_range
  
  showModal(modalDialog("Getting all data", footer=NULL))
  
  transhipments <- load_transhipments(start_date = date_range[1], end_date = date_range[2])
  
  removeModal()
  
  return(transhipments)
  
 })

  