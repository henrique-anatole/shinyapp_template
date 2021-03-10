
# CCAMLR area activities

get_all_data <- eventReactive(input$get_data, {
  
  date_range <- input$date_range
  
  showModal(modalDialog("Getting data", footer=NULL))
  
  transhipments <- load_transhipments(start_date = date_range[1], end_date = date_range[2])
  
  port_inspections <- check_port_inspections(start_date = date_range[1], end_date = date_range[2], d_tolerance = input$d_tolerance, input$ca)
  
  removeModal()
  
  return(list(transhipments=transhipments
              , port_inspections=port_inspections)
  )
  
 })

  