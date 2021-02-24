vms_check <- tabPanel("VMS checking", 
                        h1("Not reporting"),
                        DT::DTOutput("vms_not_reporting"),
                        h1("Alert 1"),
                        DT::DTOutput("alert_1"),
                        h1("Alert 2"),
                        DT::DTOutput("alert_2"),
                        h1("Alert 3"),
                        DT::DTOutput("alert_3"))

all_vms_pos <- tabPanel("All VMS positions", 
                      DT::DTOutput("all_vms_posit"))