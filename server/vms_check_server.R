output$vms_not_reporting <- renderDT({

  table_to_show <- check_vms_frequency(ca_activities()) %>%
        .$vms_not_reporting %>%
        dplyr::mutate_if(is.POSIXt, function(x) {
          format(x, "%d/%m/%Y %H:%M")
        })

      last_col <- dim(table_to_show)[2]-1

      small_cols <- c(0,1, 3, 4, 6:last_col)
      large_cols <- c(2, 5)
      center_cols <- c(0,1, 3, 4, 6:last_col)
      # hide <- c(0)

      # dt_options_local <- list(autoWidth = F, columnDefs = list(list(visible = F, targets = hide), list(width = '40px', targets =large_cols), list(width = '20px', targets =small_cols), list(className = 'dt-center', targets = center_cols) ))
      dt_options_local <- list(autoWidth = F, columnDefs = list(list(width = '40px', targets =large_cols), list(width = '20px', targets =small_cols), list(className = 'dt-center', targets = center_cols) ))


      table_to_show <- datatable(table_to_show, selection = 'none', editable = F, options = append(dt_options, dt_options_local), caption = "Vessels not reporting to vms", filter = 'top', width = "auto",
                extensions = 'Buttons', rownames = FALSE)

      return(table_to_show)

})

output$alert_1 <- renderDT({

  table_to_show <- check_vms_frequency(ca_activities()) %>%
    .$posit_alert_1 %>%
    dplyr::mutate_if(is.POSIXt, function(x) {
      format(x, "%d/%m/%Y %H:%M")
    })

  last_col <- dim(table_to_show)[2]-1

  small_cols <- c(0,1, 3, 4, 6:last_col)
  large_cols <- c(2, 5)
  center_cols <- c(0,1, 3, 4, 6:last_col)
  # hide <- c(0)
  
  # dt_options_local <- list(autoWidth = F, columnDefs = list(list(visible = F, targets = hide), list(width = '40px', targets =large_cols), list(width = '20px', targets =small_cols), list(className = 'dt-center', targets = center_cols) ))
  dt_options_local <- list(autoWidth = F, columnDefs = list(list(width = '40px', targets =large_cols), list(width = '20px', targets =small_cols), list(className = 'dt-center', targets = center_cols) ))
  
  

  table_to_show <- datatable(table_to_show, selection = 'none', editable = F, options = append(dt_options, dt_options_local), caption = "Vessels with more than 12h of delay on vms positions", filter = 'top', width = "auto",
                             extensions = 'Buttons', rownames = FALSE)

  return(table_to_show)

})

output$alert_2 <- renderDT({

  table_to_show <- check_vms_frequency(ca_activities()) %>%
    .$posit_alert_2 %>%
    dplyr::mutate_if(is.POSIXt, function(x) {
      format(x, "%d/%m/%Y %H:%M")
    })

  last_col <- dim(table_to_show)[2]-1

  small_cols <- c(0,1, 3, 4, 6:last_col)
  large_cols <- c(2, 5)
  center_cols <- c(0,1, 3, 4, 6:last_col)
  # hide <- c(0)
  
  # dt_options_local <- list(autoWidth = F, columnDefs = list(list(visible = F, targets = hide), list(width = '40px', targets =large_cols), list(width = '20px', targets =small_cols), list(className = 'dt-center', targets = center_cols) ))
  dt_options_local <- list(autoWidth = F, columnDefs = list(list(width = '40px', targets =large_cols), list(width = '20px', targets =small_cols), list(className = 'dt-center', targets = center_cols) ))
  
  

  table_to_show <- datatable(table_to_show, selection = 'none', editable = F, options = append(dt_options, dt_options_local), caption = "Vessels with more than 3h but less than 12h of delay on vms positions", filter = 'top', width = "auto",
                             extensions = 'Buttons', rownames = FALSE)

  return(table_to_show)

})

output$alert_3 <- renderDT({

  table_to_show <- check_vms_frequency(ca_activities()) %>%
    .$posit_alert_3 %>%
    dplyr::mutate_if(is.POSIXt, function(x) {
      format(x, "%d/%m/%Y %H:%M")
    })

  last_col <- dim(table_to_show)[2]-1

  small_cols <- c(0,1, 3, 4, 6:last_col)
  large_cols <- c(2, 5)
  center_cols <- c(0,1, 3, 4, 6:last_col)
  # hide <- c(0)
  
  # dt_options_local <- list(autoWidth = F, columnDefs = list(list(visible = F, targets = hide), list(width = '40px', targets =large_cols), list(width = '20px', targets =small_cols), list(className = 'dt-center', targets = center_cols) ))
  dt_options_local <- list(autoWidth = F, columnDefs = list(list(width = '40px', targets =large_cols), list(width = '20px', targets =small_cols), list(className = 'dt-center', targets = center_cols) ))
  
  table_to_show <- datatable(table_to_show, selection = 'none', editable = F, options = append(dt_options, dt_options_local), caption = "Vessels with more than 1.5h but less than 3h of delay on vms positions", filter = 'top', width = "auto",
                             extensions = 'Buttons', rownames = FALSE)

  return(table_to_show)

})

output$all_vms_posit <- renderDT({
  
  table_to_show <- check_vms_frequency(ca_activities()) %>%
    .$vsls_positions_processed %>%
    dplyr::mutate_if(is.POSIXt, function(x) {
      format(x, "%d/%m/%Y %H:%M")
    })
  
  last_col <- dim(table_to_show)[2]-1
  
  small_cols <- c(0,1, 3, 4, 6:last_col)
  large_cols <- c(2, 5)
  center_cols <- c(0,1, 3, 4, 6:last_col)
  # hide <- c(0)
  
  # dt_options_local <- list(autoWidth = F, columnDefs = list(list(visible = F, targets = hide), list(width = '40px', targets =large_cols), list(width = '20px', targets =small_cols), list(className = 'dt-center', targets = center_cols) ))
  dt_options_local <- list(autoWidth = F, columnDefs = list(list(width = '40px', targets =large_cols), list(width = '20px', targets =small_cols), list(className = 'dt-center', targets = center_cols) ))
  
  table_to_show <- datatable(table_to_show, selection = 'none', editable = F, options = append(dt_options, dt_options_local), caption = "Vessels with more than 1.5h but less than 3h of delay on vms positions", filter = 'top', width = "auto",
                             extensions = 'Buttons', rownames = FALSE)
  
  return(table_to_show)
  
})