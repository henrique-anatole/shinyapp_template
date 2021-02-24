output$vsl_presence_details <- renderDT({
  
  table_to_show <- ca_activities()$vms_mov_join %>% 
        arrange(GAR_Long_Label, VSL_Name) %>% 
        ungroup() %>% 
        dplyr::mutate_if(is.POSIXt, function(x) {
          format(x, "%d/%m/%Y %H:%M")
        })
      
      last_col <- dim(table_to_show)[2]-1
      
      small_cols <- c(2:5,7:last_col)
      large_cols <- c(1, 6)
      center_cols <- c(2:5,7:last_col)
      hide <- c(0)
      
      dt_options_local <- list(autoWidth = F, columnDefs = list(list(visible = F, targets = hide), list(width = '40px', targets =large_cols), list(width = '20px', targets =small_cols), list(className = 'dt-center', targets = center_cols) ))
      # dt_options_local <- list(autoWidth = F, columnDefs = list(list(width = '40px', targets =large_cols), list(width = '20px', targets =small_cols), list(className = 'dt-center', targets = center_cols) ))
      
  
      table_to_show <- datatable(table_to_show, selection = 'none', editable = F, options = append(dt_options, dt_options_local), caption = "Vessel presence detailed information", filter = 'top', width = "auto",
                extensions = 'Buttons', rownames = FALSE)
    
      return(table_to_show)

})
