
#### accessing database #####
# connection <- ccamlrtools::connect(server = "ross")

load_seasons <- function() {

    data_query = paste ("SELECT * FROM [CCAMLR].[dbo].[CCAMLR_SEASON] ORDER BY [CSN_CODE] desc")
  
  seasons <- ccamlrtools::queryccamlr(query = data_query, asis = FALSE, db = "ccamlr")
  
}

load_vessels <- function() {

data_query_web_VSL = paste ("SELECT [VSL_Version_ID]
      ,[VSL_ID]
      ,[VSL_Name]
      ,[CTY_Authorising_ID]
      ,[CTY_Flag_ID]
      ,[VSL_IRCS]
      ,[VSL_BuiltIn_Year]
      ,[VSL_Registration_Number]
      ,[VSL_IMO_Number]
      ,[VSL_BuiltAt_Location]
      ,[VSL_Crew_Count]
      ,[VSL_Beam]
      ,[VSL_Gross_Tonnage]
      ,[VSL_Length]
      ,[VSL_Engines_Power]
      ,[VSL_Fish_Holds_Capacity]
      ,[VSL_Fish_Holds_Count]
      ,[POR_Registry_ID]
      ,[VSL_External_Markings]
      ,[VSL_Ice_Classification]
      ,[VSL_VMS_Details]
      ,[VSL_Fishing_Master]
      ,[VSL_Fishing_Methods]
      ,[VSL_Comms_Details]
      ,[VSL_Effective_From_Date]
      ,[VSL_Effective_To_Date]
      ,[VSL_Decommissioned_YN]
      ,[VSL_Current_Version_YN]
      ,[VSL_Old_ID]
      ,[CreatedBy]
      ,[CreatedOn]
      ,[ModifiedBy]
      ,[ModifiedOn]
    FROM [VESSEL] INNER JOIN [COUNTRY]
      ON [CTY_Authorising_ID] = [CTY_ID]")

web_Vessel <- ccamlrtools::queryccamlr(query = data_query_web_VSL, db="ccamlr", asis = F)
# write.csv(web_Vessel, file = "web_Vessel.csv")
}

load_ship_codes <- function() {
  
data_query_ship_code = paste ("SELECT [SHIP_ID]
      ,[SHIP_NAME]
      ,[CALL_SIGN]
      ,[SHIP_ID_PREVIOUS]
      ,[SHIP_ID_NEXT]
      ,[FLAG_STATE]
      ,[SHIP_CODE]
      ,[GRT_TONNES]
      ,[LENGTH_METRES]
      ,[HOLD_CAPACITY_CUBIC_METRES]
      ,[FISHING_CODE]
      ,[TIMESTAMP]
      ,[GEAR_CODE]
      ,[DATE_EFFECTIVE_FROM]
      ,[DATE_EFFECTIVE_TO]
      ,[SHIP_TYPE_CODE]
      ,[DOB]
      ,[History_ID]
      ,[LLOYDS_NUMBER]
      ,[PORT_REGISRATION]
      ,[OWNER_NAME]
      ,[OWNER_ADDRESS]
      ,[OWNER_NATIONALITY]
      ,[CHARTERER]
      ,[VESSEL_CONDTION]
      ,[VESSEL_STATUS]
      ,[CDS_VESSEL]
      ,[REGISTRATION_NUMBER]
      ,[rowguid]
      ,[COMMENTS]
      ,[EXTERNAL_MARKINGS]
      ,[WHERE_BUILT]
      ,[BEAM]
      ,[CREW_COMPLEMENT]
      ,[ENGINE_POWER]
      ,[FISH_HOLD_NUMBER]
      ,[CARRYING_CAPACITY]
  FROM [cdb].[dbo].[SHIP_CODES]")

ship_code <- ccamlrtools::queryccamlr(query = data_query_ship_code, db="cdb", asis = F)
# write.csv(ship_code, file = "ship_code.csv")
}

load_vessels_ships_all <- function() {
  
  data_query = paste("
WITH cte (link, SHIP_evaluated, pid, nid, lvl, COLsum)

AS (SELECT distinCT s1.SHIP_CODE
,s2.SHIP_CODE
,s1.SHIP_ID_PREVIOUS
,s1.SHIP_ID_NEXT
,1 as lvl
,BINARY_CHECKSUM(s1.SHIP_CODE, s2.SHIP_CODE, s1.SHIP_ID_PREVIOUS, s1.SHIP_ID_NEXT)
FROM cdb.dbo.SHIP_CODES AS s1
,cdb.dbo.SHIP_CODES AS s2
WHERE (s1.SHIP_CODE=s2.SHIP_CODE
Or s1.SHIP_ID_PREVIOUS=s2.SHIP_CODE
Or s1.SHIP_ID_NEXT=s2.SHIP_CODE
Or s1.SHIP_CODE=s2.SHIP_ID_PREVIOUS
Or s1.SHIP_ID_PREVIOUS=s2.SHIP_ID_PREVIOUS
Or s1.SHIP_ID_NEXT=s2.SHIP_ID_PREVIOUS
Or s1.SHIP_CODE=s2.SHIP_ID_NEXT
Or s1.SHIP_ID_PREVIOUS=s2.SHIP_ID_NEXT
Or s1.SHIP_ID_NEXT=s2.SHIP_ID_NEXT)

UNION ALL

SELECT s1.SHIP_CODE
,cte.SHIP_evaluated
,s1.SHIP_ID_PREVIOUS
,s1.SHIP_ID_NEXT
,cte.lvl +1
,BINARY_CHECKSUM(s1.SHIP_CODE, cte.SHIP_evaluated, s1.SHIP_ID_PREVIOUS,s1.SHIP_ID_NEXT)
FROM cte
,cdb.dbo.SHIP_CODES AS s1
WHERE (s1.SHIP_CODE=cte.link
Or s1.SHIP_ID_PREVIOUS=cte.link
Or s1.SHIP_ID_NEXT=cte.link
Or s1.SHIP_CODE=cte.pid
Or s1.SHIP_ID_PREVIOUS=cte.pid
Or s1.SHIP_ID_NEXT=cte.pid
or s1.SHIP_CODE=cte.nid
Or s1.SHIP_ID_PREVIOUS=cte.nid
Or s1.SHIP_ID_NEXT=cte.nid
)
AND BINARY_CHECKSUM(s1.SHIP_CODE, cte.SHIP_evaluated, s1.SHIP_ID_PREVIOUS,s1.SHIP_ID_NEXT) <> cte.COLsum
AND lvl < 8
)

SELECT DISTINCT cte.SHIP_evaluated
, cte.link AS SHIP_Version
,ccamlr.dbo.VESSEL.VSL_Old_ID
,ccamlr.dbo.VESSEL.VSL_ID
,ccamlr.dbo.VESSEL.VSL_Version_ID
,ccamlr.dbo.VESSEL.VSL_Name
,ccamlr.dbo.VESSEL.CTY_Flag_ID
,ccamlr.dbo.VESSEL.VSL_IMO_Number
,ccamlr.dbo.VESSEL.VSL_Registration_Number
,ccamlr.dbo.VESSEL.VSL_Effective_From_Date
,ccamlr.dbo.VESSEL.VSL_Effective_To_Date
FROM cte LEFT JOIN ccamlr.dbo.VESSEL ON cte.SHIP_Version = ccamlr.dbo.VESSEL.VSL_Old_ID
GROUP BY cte.SHIP_evaluated
,cte.SHIP_Version
,ccamlr.dbo.VESSEL.VSL_Old_ID
,ccamlr.dbo.VESSEL.VSL_ID
,ccamlr.dbo.VESSEL.VSL_Version_ID
,ccamlr.dbo.VESSEL.VSL_Name
,ccamlr.dbo.VESSEL.CTY_Flag_ID
,ccamlr.dbo.VESSEL.VSL_IMO_Number
,ccamlr.dbo.VESSEL.VSL_Registration_Number
,ccamlr.dbo.VESSEL.VSL_Effective_From_Date
,ccamlr.dbo.VESSEL.VSL_Effective_To_Date
ORDER BY cte.SHIP_evaluated, cte.link")

vessel_ship_table <- ccamlrtools::queryccamlr(query = data_query, asis = F)
# write.csv(vessel_ship_table, file = "vessel_ship_table.csv")
}

load_transhipments <- function(start_date = Sys.time() - days(30), end_date = Sys.time()) {
  
  start_date <- start_date %>% format("%Y-%m-%d")
  end_date <- end_date %>% format("%Y-%m-%d")
  
  data_query = paste ("SELECT [THP_ID]
      ,[Transferring_VSL_ID]
	  ,V1.[VSL_NAME] as Transferring_vsl_name
      ,[Receiving_VSL_ID]
  	  ,V2.[VSL_NAME] as Receiving_vsl_name
      ,[THP_Transfer_Date]
      ,[THP_Details]
      ,[GAR_ID]
      ,[Notifying_CTY_ID]
      ,[THP_Latitude]
      ,[THP_Longitude]
      ,[THP_Date_Received]
      ,[Confirmed_Transfer_Date]
      ,[Confirmed_Area]
      ,[Confirmed_Position_Latitude]
      ,[Confirmed_Position_Longitude]
      ,[Date_Report_Confirmed]
      ,[Notified_THP_DETAILS_ID]
      ,[Confirmed_THP_DETAILS_ID]
      ,T.[CreatedOn]
      ,T.[CreatedBy]
      ,T.[ModifiedOn]
  FROM [CCAMLR].[dbo].[TRANSHIPMENT] as T
  INNER JOIN [CCAMLR].[dbo].[VESSEL] as V1
  ON T.[Transferring_VSL_ID] = V1.[VSL_VERSION_ID]
  INNER JOIN [CCAMLR].[dbo].[VESSEL] as V2
  ON T.[Receiving_VSL_ID] = V2.[VSL_VERSION_ID]
  WHERE CONVERT(date, THP_Transfer_Date) >= '",start_date,"'
  AND CONVERT(date, THP_Transfer_Date) <= '",end_date,"'  ", sep = "")

transhipments_1 <- ccamlrtools::queryccamlr(query = data_query, asis = F)
# write.csv(transhipments_1, file = "transhipments_1.csv")

tz(transhipments_1$THP_Transfer_Date) <- "UTC"

min_DETAILS_ID <- transhipments_1 %>% 
  dplyr::filter(!is.na(transhipments_1$Notified_THP_DETAILS_ID)) %>% 
  .$Notified_THP_DETAILS_ID %>% 
  min()

data_query = paste ("SELECT *  FROM [CCAMLR].[dbo].[WEB_TRANSHIPMENT_DETAILS]
                    WHERE THP_DETAILS_ID >= '",min_DETAILS_ID,"'
                    ", sep = "")

transhipments_2 <- ccamlrtools::queryccamlr(query = data_query, asis = F)
# write.csv(transhipments_2, file = "transhipments_2.csv")

# tranship_filtered <- transhipments %>% dplyr::filter(CreatedBy == "henrique")
transhipments <- transhipments_1 %>% left_join(transhipments_2, by = c("Notified_THP_DETAILS_ID" = "THP_DETAILS_ID")) %>% left_join(transhipments_2, by= c("Confirmed_THP_DETAILS_ID" = "THP_DETAILS_ID"))
# 
# tranship_filtered_2 <- transhipments_1 %>% left_join(transhipments_2, by = c("Notified_THP_DETAILS_ID" = "THP_DETAILS_ID")) %>% left_join(transhipments_2, by= c("Confirmed_THP_DETAILS_ID" = "THP_DETAILS_ID")) %>% select(THP_ID, Quantity.x, Quantity.y)
# 
}

load_fsr <- function() {

data_query = "SELECT fsr.CSN_ID
	, fsr.FSR_ID
	, fsr.FSR_Name
	, FSH.TXA_ID
	, TXN_Code
	, FSH.GAR_ID AS GAR_FSH
	, FSH.GTY_ID
	, seas.CSN_Start_Date
	, seas.CSN_End_Date 
	FROM FISHERY_SEASONAL_REGULATION_APPLICABLE_FISHERY AS FSRC
	INNER JOIN FISHERY AS FSH 
	ON FSRC.FSH_ID = FSH.FSH_ID
	RIGHT JOIN FISHERY_SEASONAL_REGULATION AS fsr
	ON FSRC.FSR_ID = fsr.FSR_ID
	INNER JOIN CCAMLR_SEASON AS seas 
	ON seas.CSN_ID = fsr.CSN_ID
	INNER JOIN TAXON AS TXN 
  ON TXN.TXN_ID = FSH.TXA_ID
  ORDER BY fsr.CSN_ID DESC"

fsr <- ccamlrtools::queryccamlr(query = data_query, db = "ccamlr", asis = F)

}

load_fsr_groups <- function(details = F) {

if (details == T) {
  data_query = "SELECT s1.FSR_ID AS FSR_Reference_ID
 ,s1.FSR_Name as FSR_Reference_Name
, s1.FSR_Fishery_Type AS FSR_Type
, s2.FSR_ID AS FSR_related
, FSR.CSN_ID
, s2.FSR_Name
, TXN_Code
, GAR_Name
, GTY_Name
FROM (
	SELECT fsr.FSR_ID
	, fsr.FSR_Fishery_Type
	, fsh.TXA_ID
	, fsh.GAR_ID
	, fsh.GTY_ID
	, fsh.FSH_ID
	, fsr.FSR_Name 
	FROM FISHERY AS fsh 
	INNER JOIN FISHERY_SEASONAL_REGULATION_APPLICABLE_FISHERY AS fa 
	ON fsh.FSH_ID = fa.FSH_ID
	INNER JOIN FISHERY_SEASONAL_REGULATION AS fsr ON fa.FSR_ID = fsr.FSR_ID
	GROUP BY fsr.FSR_ID, fsr.FSR_Fishery_Type, fsh.TXA_ID, fsh.GAR_ID, fsh.GTY_ID, fsh.FSH_ID, fsr.FSR_Name
	) AS s1
, (
	SELECT fsr.FSR_ID
	, fsr.FSR_Fishery_Type
	, fsh.TXA_ID
	, fsh.GAR_ID
	, fsh.GTY_ID
	, fsh.FSH_ID
	, fsr.FSR_Name 
	FROM FISHERY AS fsh 
	INNER JOIN FISHERY_SEASONAL_REGULATION_APPLICABLE_FISHERY AS fa 
	ON fsh.FSH_ID = fa.FSH_ID
	INNER JOIN FISHERY_SEASONAL_REGULATION AS fsr 
	ON fa.FSR_ID = fsr.FSR_ID
	GROUP BY fsr.FSR_ID, fsr.FSR_Fishery_Type, fsh.TXA_ID, fsh.GAR_ID, fsh.GTY_ID, fsh.FSH_ID, fsr.FSR_Name
	)  AS s2 

INNER JOIN GEAR_TYPE AS GTY 
ON GTY.GTY_ID = s2.GTY_ID
INNER JOIN TAXON AS TXN 
ON TXN.TXN_ID = s2.TXA_ID
INNER JOIN FISHERY_SEASONAL_REGULATION AS FSR 
ON s2.FSR_ID = FSR.FSR_ID
INNER JOIN GEOGRAPHICAL_AREA AS GA
ON s2.GAR_ID = GA.GAR_ID
WHERE (s2.FSR_Fishery_Type=s1.FSR_Fishery_Type) And s2.TXA_ID In (s1.TXA_ID) And s2.GAR_ID In (s1.GAR_ID) And (s2.GTY_ID=s1.GTY_ID)
GROUP BY s1.FSR_ID, s1.FSR_Name, s1.FSR_Fishery_Type, s2.FSR_ID, FSR.CSN_ID, s2.FSR_Name, TXN_Code, GAR_Name, GTY_Name
ORDER BY s1.FSR_ID DESC , s2.FSR_ID DESC"
} 
  else {
  data_query <- "SELECT s1.FSR_ID AS FSR_Reference_ID
 ,s1.FSR_Name as FSR_Reference_Name
 ,s1.FSR_Fishery_Type AS FSR_Type
, s2.FSR_ID AS FSR_related
, FSR.CSN_ID
, s2.FSR_Name
, s2.TXA_ID
, s2.GAR_ID
, s2.GTY_ID
, TXN_Code
, GAR_Name
, GTY_Name
FROM (
	SELECT fsr.FSR_ID
	, fsr.FSR_Fishery_Type
	, fsh.TXA_ID
	, fsh.GAR_ID
	, fsh.GTY_ID
	, fsh.FSH_ID
	, fsr.FSR_Name 
	FROM FISHERY AS fsh 
	INNER JOIN FISHERY_SEASONAL_REGULATION_APPLICABLE_FISHERY AS fa 
	ON fsh.FSH_ID = fa.FSH_ID
	INNER JOIN FISHERY_SEASONAL_REGULATION AS fsr ON fa.FSR_ID = fsr.FSR_ID
	GROUP BY fsr.FSR_ID, fsr.FSR_Fishery_Type, fsh.TXA_ID, fsh.GAR_ID, fsh.GTY_ID, fsh.FSH_ID, fsr.FSR_Name
	) AS s1
, (
	SELECT fsr.FSR_ID
	, fsr.FSR_Fishery_Type
	, fsh.TXA_ID
	, fsh.GAR_ID
	, fsh.GTY_ID
	, fsh.FSH_ID
	, fsr.FSR_Name 
	FROM FISHERY AS fsh 
	INNER JOIN FISHERY_SEASONAL_REGULATION_APPLICABLE_FISHERY AS fa 
	ON fsh.FSH_ID = fa.FSH_ID
	INNER JOIN FISHERY_SEASONAL_REGULATION AS fsr 
	ON fa.FSR_ID = fsr.FSR_ID
	GROUP BY fsr.FSR_ID, fsr.FSR_Fishery_Type, fsh.TXA_ID, fsh.GAR_ID, fsh.GTY_ID, fsh.FSH_ID, fsr.FSR_Name
	)  AS s2 

INNER JOIN GEAR_TYPE AS GTY 
ON GTY.GTY_ID = s2.GTY_ID
INNER JOIN TAXON AS TXN 
ON TXN.TXN_ID = s2.TXA_ID
INNER JOIN FISHERY_SEASONAL_REGULATION AS FSR 
ON s2.FSR_ID = FSR.FSR_ID
INNER JOIN GEOGRAPHICAL_AREA AS GA
ON s2.GAR_ID = GA.GAR_ID
WHERE (s2.FSR_Fishery_Type=s1.FSR_Fishery_Type) And s2.TXA_ID In (s1.TXA_ID) And s2.GAR_ID In (s1.GAR_ID) And (s2.GTY_ID=s1.GTY_ID)
GROUP BY s1.FSR_ID, s1.FSR_Fishery_Type, s1.FSR_Name, s2.FSR_ID, FSR.CSN_ID, s2.FSR_Name, s2.TXA_ID, s2.GAR_ID, s2.GTY_ID, TXN_Code, GAR_Name, GTY_Name
ORDER BY s1.FSR_ID DESC , s2.FSR_ID DESC"
}
  
  fsr <- ccamlrtools::queryccamlr(query = data_query, db = "ccamlr", asis = F)
  
}

load_ce_new <- function() {
##/** Data from dec 2017 to current days **/
data_query = "SELECT fme.[FME_ID]
,fmc.FMC_ID
,[VSL_Name]
,[VSL_Old_ID] as SHIP_ID
,VESSEL.VSL_Version_ID
,VESSEL.VSL_ID
,ASD.[GAR_Long_Label] as 'ASD Name'
,DFA.[GAR_Long_Label] as 'DFA Name'
,[GTY_Code]
,[GTY_Name]
,txn_e.[TXN_Code] as 'Target Species'
,[FME_Fishing_Purpose_Code]
,[FME_Catch_Period_Start_Date]
,[FME_Catch_Period_Code]
,[FME_Fishing_Days_Count]
,[FME_Set_Count]
,[FME_Hooks_Set_Count]
,[FME_Hooks_Retrieved_Count]
,[FME_Hooks_Lost_Count]
,[FME_VME_Indicator_Total_Volume]
,[FME_VME_Indicator_Total_Weight]
,[FME_VME_Indicator_Total_Units]
,[FME_Intention]
,[FME_Comment]
,[fme_season_code]
,txn_c.[TXN_Code] as 'Catch species'
,[FMC_Catch_Qty]
,[FMC_Catch_Count]
,[FMC_Released_With_Tag_Count]
,[FMC_Released_Without_Tag_Count]
,[CTY_Name]
FROM [cdb].[dbo].[FISHERY_MONITORING_EFFORT_RECORD] as fme
INNER JOIN TAXON as txn_e
ON fme.TXN_Target_ID = txn_e.TXN_ID
INNER JOIN GEOGRAPHICAL_AREA AS ASD
ON ASD.GAR_ID = fme.GAR_ASD_ID
INNER JOIN GEOGRAPHICAL_AREA AS DFA
ON DFA.GAR_ID = fme.GAR_DFA_ID 
LEFT JOIN  FISHERY_MONITORING_CATCH_RECORD as fmc
ON fme.FME_ID = fmc.FME_ID
LEFT JOIN TAXON as txn_c
ON fmc.TXN_ID = txn_c.TXN_ID
INNER JOIN COUNTRY 
ON fme.cty_flag_id = COUNTRY.CTY_ID
INNER JOIN VESSEL
ON fme.VSL_Version_ID = VESSEL.VSL_Version_ID
INNER JOIN GEAR_TYPE
ON fme.GTY_ID = GEAR_TYPE.GTY_ID"

ce_data_new <- ccamlrtools::queryccamlr(query = data_query, db = "cdb", asis = F)
ce_data_new$FME_Catch_Period_Start_Date <- ce_data_new$FME_Catch_Period_Start_Date %>% as.character() %>% as.POSIXct(tz="UTC")
return(ce_data_new)
}

load_ce_old <- function() {
  
data_query = "SELECT [ID]
      ,[FID]
      ,[SEASON]
      ,[NATIONALITY_CODE]
      ,TAC.[SHIP_CODE]
      ,[CATCH_PERIOD_CODE]
      ,[CATCH_PERIOD_START_DATE]
      ,[ACTIVITY_CODE]
      ,[TARGET_SPECIES]
      ,[ASD_CODE]
      ,[SSRU_CODE]
      ,[FISHING_DAYS]
      ,TAC.[GEAR_CODE]
      ,[EFFORT_COUNT]
      ,[HOOK_POT_COUNT_SET]
      ,[HOOK_POT_COUNT_RETRIEVED]
      ,[HOOK_POT_COUNT_LOST_ATTACHED_TO_SECTIONS]
      ,[VME_INDICATOR_TOTAL_VOLUME_L]
      ,[VME_INDICATOR_TOTAL_WEIGHT_KG]
      ,[VME_INDICATOR_TOTAL_NUMBER_UNITS]
      ,[COMMENT]
      ,[DATA_RESTRICTION]
	  ,[PARENT_ID]
      ,[SPECIES_CODE]
      ,[CAUGHT_KG_TOTAL]
      ,[CAUGHT_N_TOTAL]
      ,[RELEASED_N_TOTAL]
      ,[RELEASED_N_WITH_TAGS]
      ,[RELEASED_N_WITHOUT_TAGS]
      ,[CALCULATED_RELEASED_N_TOTAL]
	  ,SHIP_CODES.FLAG_STATE AS Country
	  ,SHIP_NAME
  FROM [TAC]
  LEFT JOIN TAC_DATA 
  ON TAC_DATA.PARENT_ID = TAC.ID
  INNER JOIN SHIP_CODES
  ON SHIP_CODES.SHIP_ID = TAC.SHIP_CODE"

ce_data_old <- ccamlrtools::queryccamlr(query = data_query, db = "cdb", asis = F)

}

load_notifications <- function() {
  
  data_query = "SELECT fpn.FPN_Reference_Number AS NotificationID
                , COUNTRY.CTY_Name AS Country_Name
                , COUNTRY.CTY_ISO_3_Code AS Country_code
                , CASE    
					 WHEN FPV_Replacement_VSL_ID is NULL THEN FISHERY_PARTICIPATING_VESSEL.VSL_ID   
					 ELSE FPV_Replacement_VSL_ID   
				END AS VSL_ID
				, CASE    
					 WHEN FPV_Replacement_VSL_ID is NULL THEN V1.VSL_Name 
					 ELSE V2.VSL_Name   
				END AS Vessel
				, CASE    
					 WHEN FPV_Replacement_VSL_ID is not NULL THEN V1.VSL_Name 
					 ELSE NULL   
				END AS Replaced_Vessel
                , CCAMLR_SEASON.CSN_Code AS [Year]
                , CCAMLR_SEASON.CSN_Name AS Season
                , FISHERY_SEASONAL_REGULATION.FSR_PerVesselFee AS Fee
                , V1.VSL_Version_ID
                , FPV_Daily_Processing_Capacity
                , FPV_Expected_Level_Catch
                , FISHERY_SEASONAL_REGULATION.FSR_ID
                , FISHERY_SEASONAL_REGULATION.FSR_Name
				, GAR_Name
				, FPV_Status
				, FPV_Replacement_VSL_ID
                FROM FISHERY_PARTICIPATION_NOTIFICATION as fpn 
                INNER JOIN COUNTRY 
                ON fpn.CTY_ID = COUNTRY.CTY_ID
                INNER JOIN FISHERY_SEASONAL_REGULATION 
                ON fpn.FSR_ID = FISHERY_SEASONAL_REGULATION.FSR_ID
                INNER JOIN CCAMLR_SEASON 
                ON FISHERY_SEASONAL_REGULATION.CSN_ID = CCAMLR_SEASON.CSN_ID
                INNER JOIN FISHERY_PARTICIPATING_VESSEL 
                ON fpn.FPN_Reference_Number = FISHERY_PARTICIPATING_VESSEL.FPN_Reference_Number 
                INNER JOIN VESSEL AS V1
                ON FISHERY_PARTICIPATING_VESSEL.VSL_ID = V1.VSL_ID
				LEFT JOIN VESSEL AS V2
                ON FISHERY_PARTICIPATING_VESSEL.FPV_Replacement_VSL_ID = V2.VSL_ID
				LEFT JOIN FISHERY_PARTICIPATING_VESSEL_AREA as fpva
				ON fpn.FPN_Reference_Number = fpva.FPN_Reference_Number and FISHERY_PARTICIPATING_VESSEL.VSL_ID = fpva.VSL_ID
				LEFT JOIN GEOGRAPHICAL_AREA as GA
				ON ga.GAR_ID = fpva.GAR_ID
                WHERE (FPV_Replacement_VSL_ID is NULL AND V1.VSL_Current_Version_YN=1)
				OR (FPV_Replacement_VSL_ID is not NULL AND V2.VSL_Current_Version_YN=1 AND V1.VSL_Current_Version_YN=1)
				ORDER BY Year, FSR_Name, Country_Name, Vessel"
  
  data_query_2 = "SELECT fmlc.FSR_ID
                , vsl.VSL_ID
                , Sum(fmlc.FMC_Catch_Qty) AS catch_qty 
                FROM (SELECT distinct FSR_ID
                , GAR_DFA_ID
                , VSL_VERSION_ID
                , TXN_ID
                , TXN_Target_ID
                , FMC_Catch_Qty 
                FROM [fm].[FISHERY_MONITORING_CATCH_RECORD_WITH_CATCH_LIMIT]) AS fmlc
                INNER JOIN VESSEL AS vsl 
                ON fmlc.VSL_Version_ID = vsl.VSL_Version_ID
                GROUP BY fmlc.FSR_ID, vsl.VSL_ID"
  
  ce_catches <- ccamlrtools::queryccamlr(query = data_query_2, db = "cdb", asis = F)
  
  notifications <- ccamlrtools::queryccamlr(query = data_query, db = "ccamlr", asis = F) %>% left_join(ce_catches)

}

load_gears <- function() {
  
  data_query = "
SELECT VESSEL_GEAR.VSL_ID
  ,COUNT(NET_ALL.VGE_ID) AS GEAR_QUANTITY
  ,VESSEL.VSL_Version_ID
  ,VESSEL.VSL_Name
  ,CASE VESSEL_GEAR.GEA_ID
WHEN 5 THEN 'longline_autoline'
WHEN 4 THEN 'longline_spanish'
WHEN 6 THEN 'longline_trotline'
WHEN 3 THEN 'trawl_bottom_otter' 
WHEN 2 THEN 'trawl_midwater_beam'
WHEN 1 THEN 'trawl_midwater_otter'
WHEN 7 THEN 'pot'END AS GEA_I
  ,NET_ALL.VGA_Trawl_Technique
FROM NET_ALL LEFT JOIN VESSEL_GEAR 
    ON NET_ALL.VGE_ID = VESSEL_GEAR.VGE_ID
	LEFT JOIN VESSEL
	ON VESSEL_GEAR.VSL_ID = VESSEL.VSL_ID
WHERE VESSEL.VSL_Current_Version_YN = 1
AND   (VESSEL_GEAR.VGE_Effective_To_Date is NULL 
OR VESSEL_GEAR.VGE_Effective_To_Date > GETDATE())
GROUP BY VESSEL_GEAR.VSL_ID, VESSEL.VSL_Version_ID, VESSEL.VSL_Name, VESSEL_GEAR.GEA_ID,NET_ALL.VGA_Trawl_Technique
UNION
SELECT  VESSEL_GEAR.VSL_ID
		,COUNT(LONGLINE_ALL.VGE_ID) AS GEAR_QUANTITY
		,VESSEL.VSL_Version_ID
		,VESSEL.VSL_Name
		,CASE VESSEL_GEAR.GEA_ID
		WHEN 5 THEN 'longline_autoline'
		WHEN 4 THEN 'longline_spanish'
		WHEN 6 THEN 'longline_trotline'
		WHEN 3 THEN 'trawl_bottom_otter' 
		WHEN 2 THEN 'trawl_midwater_beam'
		WHEN 1 THEN 'trawl_midwater_otter'
		WHEN 7 THEN 'pot'END AS GEA_I
		,NULL as VGA_Trawl_Technique
FROM LONGLINE_ALL LEFT JOIN VESSEL_GEAR 
    ON LONGLINE_ALL.VGE_ID = VESSEL_GEAR.VGE_ID
	LEFT JOIN VESSEL
	ON VESSEL_GEAR.VSL_ID = VESSEL.VSL_ID
WHERE VESSEL.VSL_Current_Version_YN = 1
AND   (VESSEL_GEAR.VGE_Effective_To_Date is NULL 
OR VESSEL_GEAR.VGE_Effective_To_Date > GETDATE())
GROUP BY VESSEL_GEAR.VSL_ID, VESSEL.VSL_Version_ID, VESSEL.VSL_Name, VESSEL_GEAR.GEA_ID
UNION
SELECT  VESSEL_GEAR.VSL_ID
		,COUNT(POT.VGE_ID) AS GEAR_QUANTITY
		,VESSEL.VSL_Version_ID
		,VESSEL.VSL_Name
		,CASE VESSEL_GEAR.GEA_ID
		WHEN 5 THEN 'longline_autoline'
		WHEN 4 THEN 'longline_spanish'
		WHEN 6 THEN 'longline_trotline'
		WHEN 3 THEN 'trawl_bottom_otter' 
		WHEN 2 THEN 'trawl_midwater_beam'
		WHEN 1 THEN 'trawl_midwater_otter'
		WHEN 7 THEN 'pot'END AS GEA_I
		,NULL as VGA_Trawl_Technique
FROM POT LEFT JOIN VESSEL_GEAR 
    ON POT.VGE_ID = VESSEL_GEAR.VGE_ID
	LEFT JOIN VESSEL
	ON VESSEL_GEAR.VSL_ID = VESSEL.VSL_ID
WHERE VESSEL.VSL_Current_Version_YN = 1
AND   (VESSEL_GEAR.VGE_Effective_To_Date is NULL 
OR VESSEL_GEAR.VGE_Effective_To_Date > GETDATE())
GROUP BY VESSEL_GEAR.VSL_ID, VESSEL.VSL_Version_ID, VESSEL.VSL_Name, VESSEL_GEAR.GEA_ID"
  
  gear <- ccamlrtools::queryccamlr(query = data_query, db = "ccamlr", asis = F)
  
}

load_master_table <- function() {
 
  data_query = "SELECT [CSN_ID]
      ,[CSN_Code]
      ,[CSN_Name]
      ,[CSN_Start_Date]
      ,[CSN_End_Date]
      ,[FSR_ID]
      ,[FSH_ID]
      ,[FSR_Name]
      ,[FSR_Fishery_Type]
      ,[FSR_Notification_Deadline]
      ,[FSR_CM_2103_Applies_YN]
      ,[FSR_PerVesselFee]
      ,MT.[CVM_ID]
	  ,CM.CVM_Reference_Number
      ,[FSR_Reporting_Period_Type]
      ,[FSR_Notification_Required_YN]
      ,[CVM_ID_Reporting]
      ,[FSR_Fishery_Notice_Period]
      ,[FSR_Website_Publication]
      ,[FSR_Monthly_Circ]
      ,[FSR_Updates_To_Fleet]
      ,[FSR_Report_Distrubtion]
      ,[FSR_Report_Type]
      ,[FSR_Report_Specific_Observation]
      ,[DFA_ID]
      ,[DFA_Name]
      ,[DFA_Desc]
      ,[DFA_Parent_ID]
      ,[DFA_Forecast_CalculatedOn_Date]
      ,[DFA_Forecast_Closure_Date]
      ,[DFA_Actual_Closure_Date]
      ,[DFA_Reporting_Period_Override_Type]
      ,[DFA_Override_Start_Date]
      ,[DFL_ID]
      ,TG.[TGR_ID]
	  ,TG.TGR_Name
      ,[DFL_Catch_Limit]
      ,[DFL_Target_Bycatch]
      ,[DFL_Current_Catch_Total]
      ,[DFL_Forecast_Closure_Date]
      ,[DFC_ID]
      ,MT.[GAR_ID]
      ,[GAR_Short_Label]
      ,CASE
    WHEN [DFA_Parent_ID] IS NULL THEN 'Root'
    WHEN DFA_ID IN (SELECT DISTINCT [DFA_Parent_ID] from [CCAMLR].[fm].[FSR_MASTER_TABLE]) THEN 'Inner'
    ELSE 'Leaf'
    END as Level
  FROM [CCAMLR].[fm].[FSR_MASTER_TABLE] as MT
  INNER JOIN [CCAMLR].[dbo].[GEOGRAPHICAL_AREA] as GA
  ON MT.[GAR_ID] = GA.[GAR_ID]
  INNER JOIN [CCAMLR].[dbo].[TAXON_GROUP] as TG
  ON MT.[TGR_ID] = TG.[TGR_ID]
  LEFT JOIN [CCAMLR].[dbo].[CONSERVATION_MEASURES] as CM
    ON MT.[CVM_ID] = CM.[CVM_ID]"
  
  master_table <- ccamlrtools::queryccamlr(query = data_query, db = "ccamlr", asis = F)
  master_table$CSN_Start_Date <- as.POSIXct(as.character(master_table$CSN_Start_Date), tz="UTC")
  master_table$CSN_End_Date <- as.POSIXct(as.character(master_table$CSN_End_Date), tz="UTC")
  return(master_table)
  
}

load_geographic_areas <- function() {
  
  data_query = "SELECT *
  FROM [CCAMLR].[dbo].[GEOGRAPHICAL_AREA] as GA"
  
  ga <- ccamlrtools::queryccamlr(query = data_query, db = "ccamlr", asis = F)
}

load_c2 <- function() {
  
  data_query = "SELECT C2.VSL_VERSION_ID
  , VV.VSL_ID
  , VV.VSL_Name
  , VSL_IMO_Number
  , COUNTRY.CTY_ISO_3_Code
  , LONGLINE_CODE
  , GAR.GAR_ID
  , GAR.GAR_Long_Label
  , CAUGHT_KG_TOTAL as CAUGHT_KG
  , CAUGHT_N_TOTAL as CAUGHT_N
  , C2.ID
  , FISHING_CODE
  , SET_START_DATE
  , SET_END_DATE
  , HAUL_START_DATE
  , HAUL_END_DATE
  , LATITUDE_START_SET
  , LONGITUDE_START_SET
  , LATITUDE_END_SET
  , LONGITUDE_END_SET
  , HOOK_COUNT
  , Season
  , DATA_RESTRICTION
  FROM C2 LEFT JOIN C2_DATA C2D ON C2.Id = C2D.PARENT_ID
  LEFT JOIN C2_AREAS C2A ON C2.ID = C2A.ID
  LEFT JOIN GEOGRAPHICAL_AREA GAR ON C2A.GAR_ID = GAR.GAR_ID
  INNER JOIN VESSEL VV ON VV.VSL_VERSION_ID = C2.VSL_VERSION_ID
  INNER JOIN COUNTRY ON VV.CTY_Authorising_ID = COUNTRY.CTY_ID
  WHERE C2D.SPECIES_CODE IN ('TOP','TOA')
  AND (C2A.GAR_ID IN (SELECT GAR_ID
                      FROM DIRECTED_FISHING_AREA as DFA
                      INNER JOIN DIRECTED_FISHING_AREA_COMPOSITION as DFAC
                      ON DFA.DFA_ID = DFAC.DFA_ID
                      WHERE DFA.DFA_ID Not In (SELECT DFA1.DFA_Parent_ID
                                               FROM DIRECTED_FISHING_AREA AS DFA1
                                               WHERE DFA1.DFA_Parent_ID Is Not Null))
       OR C2A.GAR_ID is null)"
  
  c2 <- ccamlrtools::queryccamlr(query = data_query, db = "cdb", asis = F)
}

load_fishing_licences <- function() {
  
  data_query = "SELECT LICENCE.LIC_ID
, LICENCE.LIC_From_Date
, LICENCE.LIC_To_Date
, VESSEL.VSL_ID
, VESSEL.VSL_Name
, COUNTRY.CTY_ISO_3_Code
, COUNTRY.CTY_Name
, TAXON.TXN_ID
, TAXON.TXN_Code
, TAXON.TXN_Name
, GEOGRAPHICAL_AREA.GAR_ID
, GEOGRAPHICAL_AREA.GAR_Name
, GEOGRAPHICAL_AREA.ATY_ID
, GEAR_TYPE.GTY_ID
, GEAR_TYPE.GTY_Code
, GEAR_TYPE.GTY_Name
, LICENCE.CreatedOn
FROM LICENCE
INNER JOIN COUNTRY ON COUNTRY.CTY_ID = LICENCE.CTY_Authorising
INNER JOIN VESSEL ON VESSEL.VSL_Version_ID = LICENCE.VSL_Version_ID
INNER JOIN LICENCE_AREAS ON LICENCE.LIC_ID = LICENCE_AREAS.LIC_ID
INNER JOIN LICENCE_GEAR ON LICENCE.LIC_ID = LICENCE_GEAR.LIC_ID
INNER JOIN LICENCE_SPECIES ON LICENCE.LIC_ID = LICENCE_SPECIES.LIC_ID
INNER JOIN GEOGRAPHICAL_AREA ON LICENCE_AREAS.GAR_ID = GEOGRAPHICAL_AREA.GAR_ID
INNER JOIN TAXON ON LICENCE_SPECIES.Target_TXA_ID = TAXON.TXN_ID
INNER JOIN GEAR_TYPE ON LICENCE_GEAR.GTY_ID = GEAR_TYPE.GTY_ID"

  fishing_licences <- ccamlrtools::queryccamlr(query = data_query, db = "ccamlr", asis = F)
  
}

load_vms_positions <- function(start_date = Sys.time() - days(10), end_date = Sys.time()) {
  
  start_date <- start_date %>% format("%Y-%m-%d")
  end_date <- end_date %>% format("%Y-%m-%d")
  
  #data filtered to save time. Just current year considered, unless informed otherwise  
  
  data_query = paste ("SELECT TP.LONGITUDE
, TP.LATITUDE
, TP.LOC_DATE
, TP.TP_ID
, TP.VSL_ID
, VSL.VSL_Name
, TP.SOURCE
FROM [dbo].[VESSEL] VSL
INNER JOIN THEMIS_POSITIONS TP
ON VSL.VSL_ID = TP.VSL_ID
WHERE CONVERT(date, TP.LOC_DATE) >= '",start_date,"'
AND CONVERT(date, TP.LOC_DATE) <= '",end_date,"'
AND VSL.VSL_Current_Version_YN = 1",
sep = "")
  
  vms_positions <- ccamlrtools::queryccamlr(query = data_query, asis = FALSE, db = "ccamlr")
  
  tz(vms_positions$LOC_DATE) <- "UTC"
  
  return(vms_positions)  
  
}

load_taxon_groups <- function() {
  
  data_query = "SELECT txg.[TGR_ID]
      ,[TGR_Name]
      ,[TGR_Desc]
	  ,txn.[TXN_ID]
      ,[TXN_Name]
      ,[TXN_Code]
  FROM [CCAMLR].[dbo].[TAXON_GROUP] AS txg
  INNER JOIN [CCAMLR].[dbo].[TAXON_GROUP_COMPOSITION] AS txc
  ON txg.[TGR_ID] = txc.[TGR_ID]
  INNER JOIN [CCAMLR].[dbo].[TAXON] AS txn
  ON txc.[TXN_ID] = txn.[TXN_ID]"
  
  taxon_groups <- ccamlrtools::queryccamlr(query = data_query, db = "ccamlr", asis = F)
  
}

load_movements <- function() {
  
  data_query = "SELECT VESSEL_MOVEMENTS.GAR_ID
  , GEOGRAPHICAL_AREA.GAR_Long_Label
  , VESSEL.VSL_ID
  , VESSEL.VSL_Name
  , COUNTRY.CTY_Name
  , VESSEL_MOVEMENTS.VMO_Entry_Date
  , VESSEL_MOVEMENTS.VMO_Exit_Date
  , VMO_Submitted_CTY_ID
  , VMO_Activity
  , VMO_Date_Received
FROM VESSEL_MOVEMENTS
INNER JOIN VESSEL 
  ON VESSEL_MOVEMENTS.VSL_Version_ID = VESSEL.VSL_Version_ID
INNER JOIN GEOGRAPHICAL_AREA 
  ON VESSEL_MOVEMENTS.GAR_ID = GEOGRAPHICAL_AREA.GAR_ID
INNER JOIN COUNTRY ON VESSEL.CTY_Flag_ID = COUNTRY.CTY_ID"
  
  movements <- ccamlrtools::queryccamlr(query = data_query, db = "ccamlr", asis = F)
  
  #Create a temporary field to generate intervals
  movements$VMO_Exit_Date_temp <- movements$VMO_Exit_Date
  movements$VMO_Exit_Date_temp[is.na(movements$VMO_Exit_Date)==TRUE]<-ymd(Sys.Date())
  
  # Set timezone to UTC (otherwise it will be in AEDT)
  tz(movements$VMO_Entry_Date) <- "UTC"
  tz(movements$VMO_Exit_Date) <- "UTC"
  tz(movements$VMO_Exit_Date_temp) <- "UTC"
  
  # Create an interval between vessel entry and exit
  movements$Presence_Interval<-as.interval(movements$VMO_Entry_Date,movements$VMO_Exit_Date_temp)
  
  # Exclude the temporary field
  movements <- dplyr::select(movements, -VMO_Exit_Date_temp)
  
  return(movements)
}


