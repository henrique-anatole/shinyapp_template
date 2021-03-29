
# CCAMLR area activities

get_transhipments <- function(date_range) {
  
  start_date <- date_range[1]
  end_date <- date_range[2]
  #Load data from server
  transhipments <- load_transhipments(start_date = start_date, end_date = end_date)

  #Load vessel data to get countries and join
  vessels_tranfer <- load_vessels() %>% 
    dplyr::select(c("VSL_Version_ID", Transferring_vessel_country = "CTY_ISO_3_Code"))
  vessels_receive <- load_vessels() %>% 
    dplyr::select(c("VSL_Version_ID", Receiving_vessel_country = "CTY_ISO_3_Code"))
  
  transhipments <- transhipments %>% 
    left_join(vessels_tranfer, by = c("Transferring_VSL_ID" = "VSL_Version_ID")) %>% 
    left_join(vessels_receive, by = c("Receiving_VSL_ID" = "VSL_Version_ID"))
  
  #Create the alerts
  #Alert 1 is 72h between notification and intention if HMLR B or F
  transhipments_check_HMLR <- transhipments %>% 
    dplyr::filter(Includes_HMLR_B_F == 1) %>% 
    dplyr::mutate('Transfering vessel time difference (h)' = round(difftime(Notified_Start_Transfer_Date, Notified_Date_Receipt_Transferring_Vessel, units = "hours"), digits = 2), 'Receiving vessel time difference (h)' = round(difftime(Notified_Start_Transfer_Date,Notified_Date_Receipt_Receiving_Vessel, units = "hours"), digits = 2)) %>% 
    dplyr::select(THP_ID, 'Transferring vessel' = Transferring_vsl_name, 'Transferring country' = Transferring_vessel_country, 'Notification date: Tranferring vessel' = Notified_Date_Receipt_Transferring_Vessel, 'Receiving vessel' = Receiving_vsl_name, 'Receiving country' = Receiving_vessel_country, 'Notification date: Receiving vessel' = Notified_Date_Receipt_Receiving_Vessel, 'Notified transhipment start' = Notified_Start_Transfer_Date, 'Notified transhipment end' = Notified_End_Transfer_Date, 'Transfering vessel time difference (h)', 'Receiving vessel time difference (h)', Includes_HMLR_B_F) %>% 
    unique() %>% 
    dplyr::filter(`Transfering vessel time difference (h)` < 72 | `Receiving vessel time difference (h)` < 72)
  
  #Alert 2 is 2h between notification and intention if others
  transhipments_check_others <- transhipments %>% 
    dplyr::filter(Includes_HMLR_B_F == 0) %>% 
    dplyr::mutate('Transfering vessel time difference (h)' = round(difftime(Notified_Start_Transfer_Date, Notified_Date_Receipt_Transferring_Vessel, units = "hours"), digits = 2), 'Receiving vessel time difference (h)' = round(difftime(Notified_Start_Transfer_Date,Notified_Date_Receipt_Receiving_Vessel, units = "hours"), digits = 2)) %>% 
    dplyr::select(THP_ID, 'Transferring vessel' = Transferring_vsl_name, 'Transferring country' = Transferring_vessel_country, 'Notification date: Tranferring vessel' = Notified_Date_Receipt_Transferring_Vessel, 'Receiving vessel' = Receiving_vsl_name, 'Receiving country' = Receiving_vessel_country, 'Notification date: Receiving vessel' = Notified_Date_Receipt_Receiving_Vessel, 'Notified transhipment start' = Notified_Start_Transfer_Date, 'Notified transhipment end' = Notified_End_Transfer_Date, 'Transfering vessel time difference (h)', 'Receiving vessel time difference (h)', Includes_HMLR_B_F) %>% 
    unique() %>% 
    dplyr::filter(`Transfering vessel time difference (h)` < 2 | `Receiving vessel time difference (h)` < 2)
  
  #Alert 3 is 3 bussiness days to confirm the transhipments
  transhipments_check_confirmation <- transhipments %>% 
    dplyr::filter(THP_Status == "completed") %>% 
    dplyr::mutate(reference_date = Confirmed_Start_Transfer_Date)
  
  #Change the reference days for calculation according to what you have
  transhipments_check_confirmation$reference_date[which(is.na(transhipments_check_confirmation$reference_date))] <- transhipments_check_confirmation$Confirm_End_Transfer_Date[which(is.na(transhipments_check_confirmation$reference_date))]
  
  #Check on 3 bussiness day to confirm the transhipments
  transhipments_check_confirmation <- transhipments_check_confirmation %>% 
    dplyr::mutate(transferring_vessel_confirmation = round(difftime(Confirmed_Date_Receipt_Transferring_Vessel, reference_date, units = "days"), digits = 2), receiving_vessel_confirmation = round(difftime( Confirmed_Date_Receipt_Receiving_Vessel, reference_date, units = "days"), digits = 2)) %>% 
    dplyr::select(THP_ID, 'Transferring vessel' = Transferring_vsl_name, 'Transferring country' = Transferring_vessel_country, 'Confirmation date: Tranferring vessel' = Confirmed_Date_Receipt_Transferring_Vessel, 'Receiving vessel' = Receiving_vsl_name, 'Receiving country' = Receiving_vessel_country, 'Confirmation date: Receiving vessel' = Confirmed_Date_Receipt_Receiving_Vessel, 'Confirmed transhipment start' = Confirmed_Start_Transfer_Date, 'Confirmed transhipment end' = Confirm_End_Transfer_Date, 'Transfering vessel time difference (days)'= transferring_vessel_confirmation, 'Receiving vessel time difference (days)'= receiving_vessel_confirmation, Includes_HMLR_B_F, reference_date) %>% 
    unique() %>% 
    dplyr::filter(`Transfering vessel time difference (days)` > 3 | `Receiving vessel time difference (days)` > 3)
  
  week_function <- function(a, b) { 
    if (!is.na(b)) {
      sum(!weekdays(seq(a, b, "days")) %in% c("Saturday", "Sunday"))
    } else {
      NA
    }
  }
  
  Nweekdays <- Vectorize(week_function)
  
  transhipments_check_confirmation <- transhipments_check_confirmation %>% 
    mutate("Receiving vessel: weekdays" = Nweekdays(reference_date, `Confirmation date: Receiving vessel`), "Transferring vessel: weekdays" = Nweekdays(reference_date, `Confirmation date: Tranferring vessel`)) %>% 
    dplyr::select(-reference_date)
  
  return(list(transhipments_all = transhipments
              ,transhipments_check_HMLR = transhipments_check_HMLR
              ,transhipments_check_others = transhipments_check_others
              ,transhipments_check_confirmation = transhipments_check_confirmation
              )
  )
  
}

  

