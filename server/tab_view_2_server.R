output$variable_2 <- renderDT({
  
  table_to_show <- get_all_data()
  
  last_col <- dim(table_to_show)[2]-1
  
  small_cols <- c(0,1, 3, 4, 6:last_col)
  large_cols <- c(2, 5)
  center_cols <- c(0,1, 3, 4, 6:last_col)
  # hide <- c(0)
  
  # dt_options_local <- list(autoWidth = F, columnDefs = list(list(visible = F, targets = hide), list(width = '40px', targets =large_cols), list(width = '20px', targets =small_cols), list(className = 'dt-center', targets = center_cols) ))
  dt_options_local <- list(autoWidth = F, columnDefs = list(list(width = '40px', targets =large_cols), list(width = '20px', targets =small_cols), list(className = 'dt-center', targets = center_cols) ))
  
  table_to_show <- datatable(table_to_show, selection = 'none', editable = F, options = append(dt_options, dt_options_local), caption="Due port inspections", filter = 'top', width = "auto",
                             extensions = 'Buttons', rownames = FALSE)
  
  return(table_to_show)
  
}, server = F)

