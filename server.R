
# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    # run all files listed as source. lapply did not worked here
    # 
    
    for (f in 1:length(server_files)) {
        source(server_files[f], local = TRUE)
    }
    
    # ##-- reactive functions ----
    # source(paste(folder,"server/reactive_functions.R", sep = ""), local = TRUE)
    # 
    # ##-- main tab
    # source(paste(folder,"server/main.R", sep = ""), local = TRUE)
    # 
    # ##-- table tab
    # source(paste(folder,"server/table.R", sep = ""), local = TRUE)
    # 
    # ##-- email tab
    # source(paste(folder,"server/emailDT.R", sep = ""), local = TRUE)
    # 
    # ##-- download report
    # source(paste(folder,"server/downloadHandler_server.R", sep = ""), local = TRUE)
    
})