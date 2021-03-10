port_inspections_view <- tabPanel("Port Inspections", 
                        h1("Due inspections"),
                        DT::DTOutput("pi_due"),
                        h1("Inspections done in 48h after landing"),
                        DT::DTOutput("pi_within48"),
                        h1("Reports transmitted within 30 days"),
                        DT::DTOutput("pi_transmit_within30"),
                        h1("All inspections"),
                        DT::DTOutput("all_port_inspections"))
