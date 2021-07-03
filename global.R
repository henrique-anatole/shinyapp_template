# This file will load everything that will be required when the app starts

# 1 libraries
  library(shiny)
  library(readr)
  library(tidyverse)
  library(lubridate)
  library(CCAMLRGIS)
  library(ccamlrtools)
  library(DT)
  library(plotly)

# 2 clean the working space
  rm(list=ls())

# 3 Load functions source files ( ‘ ~ / functions ’ )
  # check all files in the folder
  func_files <- list.files(path = "functions", full.names = T, recursive = T)
  # run all files listed as source
  suppressMessages(lapply(func_files, source))

# 4	Call variables for menu controls and others here
 
  # Options for T tables template
  dt_options <- list(lengthMenu = c(25, 50), pageLength = 50, dom = 'rtipB',  buttons = c('copy', 'csv', 'excel'))

# 5 Load ui files for the interface ( ‘ ~ / ui ’ ) ----
  # check all files in the folder
  ui_files <- list.files(path = "ui", full.names = T, recursive = T)
  # run all files listed as source
  suppressMessages(lapply(ui_files, source))

# 6 Load server files for the interface ( ‘ ~ / server ’ ) ----
  # check all files in the folder
  server_files <- list.files(path = "server", full.names = T, recursive = T)
  # don't run here, only in the server.R file as 'local' to that environment

