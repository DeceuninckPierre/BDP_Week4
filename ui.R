#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(lattice)

# Define UI for application that draws a histogram
shinyUI(
    navbarPage("Earthquakes DP4", id="nav",
               
               tabPanel("Help page",
                        fluidRow(
                            h4("This application allows to visualise different type of information on significant 
                              earthquakes (magnitude higher than 5.5) that took place between 1965 and 2016."),
                            
                            "Data source is available here on kaggle:",
                            
                            tags$a(href="https://www.kaggle.com/usgs/earthquake-database", 
                                   "https://www.kaggle.com/usgs/earthquake-database"),
                            
                            h3("Input Data"),
                            
                            "Data can be selected in three different ways:",
                            
                            tags$ol(
                                tags$li("By magnitude: use the slider to set the range of magnitude you would like to keep"), 
                                tags$li("By date: use the time range selector (dates can be selected between 1965 and 2016)"), 
                                tags$li("By area: use the map zoom function to select your area of interest")
                            ),
                            
                            h3("Output Data"),
                            
                            "Three types of output plots are proposed:",
                            
                            tags$ol(
                                tags$li("The frequency of earthquakes by magnitude"), 
                                tags$li("The representation of earquakes depth by magnitude"), 
                                tags$li("The evolution of earthquakes magnitude occurences over time")
                            ),
                            
                            h3("Earthquake information"),
                            
                            "On the map, earthquake are represented:",
                            
                            tags$ol(
                                tags$li("In green if the magnitude is below 6.8"), 
                                tags$li("In orange if the magnitude is between 6.8 and 7.8"), 
                                tags$li("In red if the magnitude is above 7.8")
                            ),
                            
                            "Radius is proportional to the Magnitude and clicking on a circle displays the earthquake information" 
                            ),
                        
                            h1("Now Click on the 'Interactive Map' tab above and have fun!")
                        
               ),
               
            tabPanel("Interactive map",
                     
                sidebarLayout(
                         sidebarPanel(width=3,
                             sliderInput("range", "Magnitudes", min(EarthquakeData$Magnitude), max(EarthquakeData$Magnitude),
                                         value = c(6.5,max(EarthquakeData$Magnitude)), step = 0.1
                             ),
                             
                             dateRangeInput("daterange", "Date range:",
                                            start  = format(min(EarthquakeData$Date),format("%Y-%m-%d")),
                                            end    = format(max(EarthquakeData$Date),format("%Y-%m-%d")),
                                            min    = format(min(EarthquakeData$Date),format("%Y-%m-%d")),
                                            max    = format(max(EarthquakeData$Date),format("%Y-%m-%d")),
                                            format = "dd-mm-yyyy"),
                             
                             tags$b(textOutput("selected_var")),
                             
                             tags$br(),
                             
                             plotOutput("histEQs", height = 250),
                             
                             plotOutput("DepthMagnEQs", height = 250),
                             
                             plotOutput("EvolEQs", height = 250)
                         ),
                         mainPanel(width=9,   
                             leafletOutput("map", width = "100%", height = "1000")
                         )
                     )
                )
            
               
    )
)
