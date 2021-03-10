port_inspections_view <- tabPanel("Port Inspections", 
                        h1("Missing inspections"),
                        DT::DTOutput("missing_port_inspections"),
                        h1("All inspections"),
                        DT::DTOutput("all_port_inspections"))
