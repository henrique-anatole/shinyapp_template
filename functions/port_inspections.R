check_port_inspections <- function(start_date, end_date, d_tolerance, ca) {

# Pulls in the DCD data
data_query = paste ("SELECT DISTINCT dcd.[DCD_ID]
      ,[DCD_Document_Number]
      ,[DCD_Issuing_Authority_ORG_ID]
      ,[DCD_Flag_State_Confirmation]
      ,[DCD_Fishing_To_Date]
      ,[DCD_Fishing_From_Date]
      ,[DCD_Port_Departure_Date]
      ,[DCD_Port_Entry_Date]
      ,dcd.[VSL_Version_ID]
	    ,vsl.[VSL_Name]
	    ,vsl.VSL_ID
	    ,c.CTY_Name as 'Vessel Flag'
      ,[DCD_Licence_Number]
      ,[DCD_Landing_Confirmed_YN]
      ,[DCD_Landing_Confirmed_Date]
	    ,fc.[GAR_ID]
	    ,[GAR_Name]
	,fc.[FCT_EEZ_YN]
      ,[POR_NAME] as 'DCD Port'
	    ,c2.CTY_Name as 'DCD Port Country'
  FROM [CCAMLR].[dbo].[DCD] as dcd
  INNER JOIN [dbo].[VESSEL] as vsl
  ON dcd.[VSL_Version_ID] = vsl.[VSL_Version_ID]
  INNER JOIN [dbo].[COUNTRY] as c
  ON vsl.[CTY_Flag_ID] = c.CTY_ID
  INNER JOIN [dbo].[FISH_CAUGHT] as fc
  ON dcd.[DCD_ID] = fc.[DCD_ID]
  INNER JOIN [dbo].[GEOGRAPHICAL_AREA] as ga
  ON fc.GAR_ID = ga.GAR_ID
  INNER JOIN [dbo].[LANDING] as l
  ON dcd.[DCD_ID] = l.[DCD_ID]
  INNER JOIN [dbo].[PORT] as p
  on l.[POR_ID] = p.[POR_ID]
  INNER JOIN [dbo].[COUNTRY] as c2
  ON p.[CTY_ID] = c2.CTY_ID")

dcds_all <- ccamlrtools::queryccamlr(query = data_query, asis = F, db = "ccamlr")
# write.csv(dcds, file = "dcds.csv")

#Pulls in the Port Inspection data  
data_query = paste ("SELECT [PIN_ID]
	    ,vsl.[VSL_Name]
	    ,vsl.VSL_ID
	    ,c.CTY_Name as 'Vessel Flag'
      ,[POR_NAME] 'Inspection port'
	    ,c2.CTY_Name as 'Inspection Port Country'
      ,[Inspection_Date]
      ,[Arrival_Date]
      ,[Comment]
      ,[PIN_Date_Received]
	    ,pin.[CreatedOn] as 'Port Inspection Created date '
  FROM [CCAMLR].[dbo].[PORT_INSPECTION] as pin
  INNER JOIN [dbo].[VESSEL] as vsl
  ON pin.[VSL_Version_ID] = vsl.[VSL_Version_ID]
  INNER JOIN [dbo].[COUNTRY] as c
  ON vsl.[CTY_Flag_ID] = c.CTY_ID
  INNER JOIN [dbo].[PORT] as p
  on pin.[POR_ID] = p.[POR_ID]
  INNER JOIN [dbo].[COUNTRY] as c2
  ON p.[CTY_ID] = c2.CTY_ID")

port_inspections <- ccamlrtools::queryccamlr(query = data_query, asis = FALSE, db = "ccamlr")
# write.csv(port_inspections, file = "port_inspections.csv")

#This line's function designates the Port Entry Date as the Start and as the End
date_filt <- function(start_date, end_date){
  dcds <- dcds_all %>% 
    dplyr::filter(DCD_Port_Entry_Date >= as.POSIXct(start_date), DCD_Port_Entry_Date <= end_date, DCD_Landing_Confirmed_YN == 1)
  return(dcds)
}

dcds <- date_filt(start_date = start_date, end_date=end_date)

#In this function each DCD is checked for a corresponding Port Inspection. The match is done via VSL_ID and arrival date and Port Inspection Date
dcd_check <- function(dcd, d_tolerance) {
  
  # dcds <- dcds_all %>% filter(DCD_Port_Entry_Date >= start_date, DCD_Port_Entry_Date <= end_date)
  
  dcd_data <- dcds %>% dplyr::filter(DCD_ID==dcd) %>% dplyr::select(DCD_ID, DCD_Document_Number, DCD_Port_Entry_Date, DCD_Landing_Confirmed_Date, DCD_Landing_Confirmed_YN, VSL_Name, 'Vessel Flag', VSL_ID, GAR_Name, FCT_EEZ_YN, 'DCD Port', 'DCD Port Country')
  
  unloading <- dcd_data$DCD_Port_Entry_Date
  
  inspection_data <- port_inspections %>% dplyr::filter(VSL_ID==dcd_data$VSL_ID, abs(difftime(.$Arrival_Date, unloading, units = "day")) <= d_tolerance) %>% mutate(DCD_ID = dcd)
  
  joining_data <- dcd_data %>% left_join(inspection_data, by="DCD_ID") %>% mutate(days_to_inspect=difftime(Inspection_Date,Arrival_Date,unit="day"), Days_to_transmit=difftime(PIN_Date_Received,Inspection_Date,unit="day")) 
  
  return(joining_data)
}

#Date range for CCEP
#d_tolerance is the date range
#start date and end date is the Port_Entry Date
  #ca means "CCAMLR area?"
dcd_port_check <- function(dcds, d_tolerance, start_date, end_date, ca) {
  
  if(dim(dcds)[1] > 0) {
  
  dcd_port_temp <- lapply(dcds$DCD_ID, dcd_check, d_tolerance)
  
  for (n in 1:length(dcd_port_temp)) {
    if (n==1) {
      dcd_port_inspected <- dcd_port_temp[[n]]
      
    } else {
      dcd_port_inspected <- dcd_port_inspected %>% rbind(dcd_port_temp[[n]])
    }
    
  }
  
  #filter period
  dcd_port_inspected <- dcd_port_inspected %>% 
    dplyr::filter(PIN_Date_Received >= start_date, PIN_Date_Received <= end_date) %>% 
    unique()
  
  #this filters out DCDs which are outside of the Convention Area. The filter to inform it is in CCAMLR area need review in the future
  if (ca==T) {
    dcd_port_inspected <- dcd_port_inspected %>% dplyr::filter(GAR_Name %in% unique(dcds_all$GAR_Name)[-c(grep("Area*", unique(dcds_all$GAR_Name)), grep("Division 41.3*", unique(dcds_all$GAR_Name)))])
  } 
  
  pi_due <- dcd_port_inspected %>% 
    dplyr::filter(is.na(PIN_ID)) %>% 
    select(DCD_ID,	DCD_Document_Number,	DCD_Port_Entry_Date,	DCD_Landing_Confirmed_Date,	DCD_Landing_Confirmed_YN,	VSL_Name = VSL_Name.x,	Vessel_Flag = `Vessel Flag.x`,	GAR_Name,	FCT_EEZ_YN,	`DCD Port`,	`DCD Port Country`) %>% 
    unique()
  
  pi_within_48 <- dcd_port_inspected %>% 
    dplyr::filter(!is.na(PIN_ID), days_to_inspect > 2) %>% 
    select(PIN_ID,	VSL_Name = VSL_Name.y,	Vessel_Flag = `Vessel Flag.y`,	`Port name` = `Inspection port`,	`Port State` = `Inspection Port Country`, Arrival_Date, Inspection_Date, Days_to_inspect = days_to_inspect) %>% 
    unique()
  
  pi_transmitted_30 <- dcd_port_inspected %>% 
    dplyr::filter(!is.na(PIN_ID), Days_to_transmit > 30) %>% 
    select(PIN_ID,	VSL_Name = VSL_Name.y,	Vessel_Flag = `Vessel Flag.y`,	`Port name` = `Inspection port`,	`Port State` = `Inspection Port Country`, Arrival_Date, Inspection_Date, Days_to_transmit) %>% 
    unique()
  
  pi_missing <- port_inspections %>% 
    dplyr::filter(!(PIN_ID %in% dcd_port_inspected$PIN_ID), PIN_Date_Received >= start_date, PIN_Date_Received <= end_date ) %>% 
    unique()
  
  } else {
    dcd_port_inspected <- NULL
    pi_due <- NULL
    pi_within_48 <- NULL
    pi_transmitted_30 <- NULL
    pi_missing <- NULL
  }
  
  return(list(dcd_port_inspected = dcd_port_inspected
              , pi_missing = pi_missing
              , pi_due = pi_due
              , pi_within_48 = pi_within_48
              , pi_transmitted_30 = pi_transmitted_30))
  
}

port_check <- dcd_port_check(dcds, d_tolerance, start_date, end_date, ca)

return(port_check)

}



