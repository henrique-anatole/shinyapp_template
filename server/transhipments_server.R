output$transhipments_alert1 <- renderDT({
  
  table_to_show <- get_all_data() %>% 
    .$transhipments %>% 
    .$transhipments_check_HMLR
  
  # %>%
  #   .$posit_alert_1 %>%
  #   dplyr::mutate_if(is.POSIXt, function(x) {
  #     format(x, "%d/%m/%Y %H:%M")
  #   })
  # 
  last_col <- dim(table_to_show)[2]-1
  
  small_cols <- c(0,1, 3, 4, 6:last_col)
  large_cols <- c(2, 5)
  center_cols <- c(0,1, 3, 4, 6:last_col)
  # hide <- c(0)
  
  # dt_options_local <- list(autoWidth = F, columnDefs = list(list(visible = F, targets = hide), list(width = '40px', targets =large_cols), list(width = '20px', targets =small_cols), list(className = 'dt-center', targets = center_cols) ))
  dt_options_local <- list(autoWidth = F, columnDefs = list(list(width = '40px', targets =large_cols), list(width = '20px', targets =small_cols), list(className = 'dt-center', targets = center_cols) ))
  
  
  
  table_to_show <- datatable(table_to_show, selection = 'none', editable = F, options = append(dt_options, dt_options_local), caption="Transhipments of marine life resources, fuel or bait notified with less than 72h", filter = 'top', width = "auto",
                             extensions = 'Buttons', rownames = FALSE)
  
  return(table_to_show)
  
}, server = F)


output$transhipments_alert2 <- renderDT({
  
  table_to_show <- get_all_data() %>% 
    .$transhipments %>% 
    .$transhipments_check_others
  
  # %>%
  #   .$posit_alert_1 %>%
  #   dplyr::mutate_if(is.POSIXt, function(x) {
  #     format(x, "%d/%m/%Y %H:%M")
  #   })
  # 
  last_col <- dim(table_to_show)[2]-1
  
  small_cols <- c(0,1, 3, 4, 6:last_col)
  large_cols <- c(2, 5)
  center_cols <- c(0,1, 3, 4, 6:last_col)
  # hide <- c(0)
  
  # dt_options_local <- list(autoWidth = F, columnDefs = list(list(visible = F, targets = hide), list(width = '40px', targets =large_cols), list(width = '20px', targets =small_cols), list(className = 'dt-center', targets = center_cols) ))
  dt_options_local <- list(autoWidth = F, columnDefs = list(list(width = '40px', targets =large_cols), list(width = '20px', targets =small_cols), list(className = 'dt-center', targets = center_cols) ))
  
  
  
  table_to_show <- datatable(table_to_show, selection = 'none', editable = F, options = append(dt_options, dt_options_local), caption="Other Transhipments notified with less than 2h", filter = 'top', width = "auto",
                             extensions = 'Buttons', rownames = FALSE)
  
  return(table_to_show)
  
}, server = F)


output$transhipments_alert3 <- renderDT({
  
  table_to_show <- get_all_data() %>% 
    .$transhipments %>% 
    .$transhipments_check_confirmation
  
  # %>%
  #   .$posit_alert_1 %>%
  #   dplyr::mutate_if(is.POSIXt, function(x) {
  #     format(x, "%d/%m/%Y %H:%M")
  #   })
  # 
  last_col <- dim(table_to_show)[2]-1
  
  small_cols <- c(0,1, 3, 4, 6:last_col)
  large_cols <- c(2, 5)
  center_cols <- c(0,1, 3, 4, 6:last_col)
  # hide <- c(0)
  
  # dt_options_local <- list(autoWidth = F, columnDefs = list(list(visible = F, targets = hide), list(width = '40px', targets =large_cols), list(width = '20px', targets =small_cols), list(className = 'dt-center', targets = center_cols) ))
  dt_options_local <- list(autoWidth = F, columnDefs = list(list(width = '40px', targets =large_cols), list(width = '20px', targets =small_cols), list(className = 'dt-center', targets = center_cols) ))
  
  
  table_to_show <- datatable(table_to_show, selection = 'none', editable = F, options = append(dt_options, dt_options_local), caption="Transhipments confirmed after 3 working days", filter = 'top', width = "auto",
                             extensions = 'Buttons', rownames = FALSE)
  
  return(table_to_show)
  
}, server = F)

output$transhipments_all <- renderDT({

  table_to_show <- get_all_data() %>% 
    .$transhipments %>% 
    .$transhipments_all
  
  # %>%
  #   .$posit_alert_1 %>%
  #   dplyr::mutate_if(is.POSIXt, function(x) {
  #     format(x, "%d/%m/%Y %H:%M")
  #   })
  # 
  last_col <- dim(table_to_show)[2]-1
  
  small_cols <- c(0,1, 3, 4, 6:last_col)
  large_cols <- c(2, 5)
  center_cols <- c(0,1, 3, 4, 6:last_col)
  # hide <- c(0)
  
  # dt_options_local <- list(autoWidth = F, columnDefs = list(list(visible = F, targets = hide), list(width = '40px', targets =large_cols), list(width = '20px', targets =small_cols), list(className = 'dt-center', targets = center_cols) ))
  dt_options_local <- list(autoWidth = F, columnDefs = list(list(width = '40px', targets =large_cols), list(width = '20px', targets =small_cols), list(className = 'dt-center', targets = center_cols) ))
  
  
  
  table_to_show <- datatable(table_to_show, selection = 'none', editable = F, options = append(dt_options, dt_options_local), caption="All Transhipments during the period", filter = 'top', width = "auto",
                             extensions = 'Buttons', rownames = FALSE)
  
  return(table_to_show)

}, server = F)
