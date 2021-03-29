output$due_port_inspections <- renderDT({
  
  table_to_show <- get_all_data() %>% 
    .$port_inspections %>% 
    .$pi_due
  
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


#_________________


output$pi_within48 <- renderDT({
  
  table_to_show <- get_all_data() %>% 
    .$port_inspections %>% 
    .$pi_within_48
  
  last_col <- dim(table_to_show)[2]-1
  
  small_cols <- c(0,1, 3, 4, 6:last_col)
  large_cols <- c(2, 5)
  center_cols <- c(0,1, 3, 4, 6:last_col)
  # hide <- c(0)
  
  # dt_options_local <- list(autoWidth = F, columnDefs = list(list(visible = F, targets = hide), list(width = '40px', targets =large_cols), list(width = '20px', targets =small_cols), list(className = 'dt-center', targets = center_cols) ))
  dt_options_local <- list(autoWidth = F, columnDefs = list(list(width = '40px', targets =large_cols), list(width = '20px', targets =small_cols), list(className = 'dt-center', targets = center_cols) ))
  
  table_to_show <- datatable(table_to_show, selection = 'none', editable = F, options = append(dt_options, dt_options_local), caption="Inspections done NOT in 48h after arrival", filter = 'top', width = "auto",
                             extensions = 'Buttons', rownames = FALSE)
  
  return(table_to_show)
  
}, server = F)

output$pi_transmit_within30 <- renderDT({
  
  table_to_show <- get_all_data() %>% 
    .$port_inspections %>% 
    .$pi_transmitted_30
  
  last_col <- dim(table_to_show)[2]-1
  
  small_cols <- c(0,1, 3, 4, 6:last_col)
  large_cols <- c(2, 5)
  center_cols <- c(0,1, 3, 4, 6:last_col)
  # hide <- c(0)
  
  # dt_options_local <- list(autoWidth = F, columnDefs = list(list(visible = F, targets = hide), list(width = '40px', targets =large_cols), list(width = '20px', targets =small_cols), list(className = 'dt-center', targets = center_cols) ))
  dt_options_local <- list(autoWidth = F, columnDefs = list(list(width = '40px', targets =large_cols), list(width = '20px', targets =small_cols), list(className = 'dt-center', targets = center_cols) ))
  
  table_to_show <- datatable(table_to_show, selection = 'none', editable = F, options = append(dt_options, dt_options_local), caption="Reports NOT transmitted within 30 days", filter = 'top', width = "auto",
                             extensions = 'Buttons', rownames = FALSE)
  
  return(table_to_show)
  
}, server = F)


output$dcds_missing <- renderDT({
  
  table_to_show <- get_all_data() %>% 
    .$port_inspections %>% 
    .$dcd_missing
  
  last_col <- dim(table_to_show)[2]-1
  
  small_cols <- c(0,1, 3, 4, 6:last_col)
  large_cols <- c(2, 5)
  center_cols <- c(0,1, 3, 4, 6:last_col)
  # hide <- c(0)
  
  # dt_options_local <- list(autoWidth = F, columnDefs = list(list(visible = F, targets = hide), list(width = '40px', targets =large_cols), list(width = '20px', targets =small_cols), list(className = 'dt-center', targets = center_cols) ))
  dt_options_local <- list(autoWidth = F, columnDefs = list(list(width = '40px', targets =large_cols), list(width = '20px', targets =small_cols), list(className = 'dt-center', targets = center_cols) ))
  
  table_to_show <- datatable(table_to_show, selection = 'none', editable = F, options = append(dt_options, dt_options_local), caption="Port inspections with NO associated DCD", filter = 'top', width = "auto",
                             extensions = 'Buttons', rownames = FALSE)
  
  return(table_to_show)
  
}, server = F)

#_________________

output$all_port_inspections <- renderDT({
  
  table_to_show <- get_all_data() %>% 
    .$port_inspections %>% 
    .$port_inspections
  
  
  last_col <- dim(table_to_show)[2]-1
  
  small_cols <- c(0,1, 3, 4, 6:last_col)
  large_cols <- c(2, 5)
  center_cols <- c(0,1, 3, 4, 6:last_col)
  # hide <- c(0)
  
  # dt_options_local <- list(autoWidth = F, columnDefs = list(list(visible = F, targets = hide), list(width = '40px', targets =large_cols), list(width = '20px', targets =small_cols), list(className = 'dt-center', targets = center_cols) ))
  dt_options_local <- list(autoWidth = F, columnDefs = list(list(width = '40px', targets =large_cols), list(width = '20px', targets =small_cols), list(className = 'dt-center', targets = center_cols) ))
  
  
  
  table_to_show <- datatable(table_to_show, selection = 'none', editable = F, options = append(dt_options, dt_options_local), caption="All port inspections only", filter = 'top', width = "auto",
                             extensions = 'Buttons', rownames = FALSE)
  
  return(table_to_show)
  
}, server = F)

#______________

output$all_dcd_and_pi <- renderDT({
  
  table_to_show <- get_all_data() %>% 
    .$port_inspections %>% 
    .$dcd_port_inspected
  
  
  last_col <- dim(table_to_show)[2]-1
  
  small_cols <- c(0,1, 3, 4, 6:last_col)
  large_cols <- c(2, 5)
  center_cols <- c(0,1, 3, 4, 6:last_col)
  # hide <- c(0)
  
  # dt_options_local <- list(autoWidth = F, columnDefs = list(list(visible = F, targets = hide), list(width = '40px', targets =large_cols), list(width = '20px', targets =small_cols), list(className = 'dt-center', targets = center_cols) ))
  dt_options_local <- list(autoWidth = F, columnDefs = list(list(width = '40px', targets =large_cols), list(width = '20px', targets =small_cols), list(className = 'dt-center', targets = center_cols) ))
  
  
  
  table_to_show <- datatable(table_to_show, selection = 'none', editable = F, options = append(dt_options, dt_options_local), caption="All DCDs and port inspections matches", filter = 'top', width = "auto",
                             extensions = 'Buttons', rownames = FALSE)
  
  return(table_to_show)
  
}, server = F)

#__________