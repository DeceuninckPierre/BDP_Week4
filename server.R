#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    
    
    
    # Reactive expression for the data subsetted to what the user selected
    filteredData <- reactive({
        bounds <- input$map_bounds
        latRng <- range(bounds$north, bounds$south)
        lngRng <- range(bounds$east, bounds$west)
      
        EarthquakeData %>% 
            filter(EarthquakeData$Magnitude >= input$range[1] & EarthquakeData$Magnitude <= input$range[2] &
            EarthquakeData$Date >= input$daterange[1] & EarthquakeData$Date <= input$daterange[2] &
                EarthquakeData$Latitude >= latRng[1] & EarthquakeData$Latitude <= latRng[2] &
                EarthquakeData$Longitude >= lngRng[1] & EarthquakeData$Longitude <= lngRng[2]) %>%
            arrange(Time)
    })
    
    output$map <- renderLeaflet({
        # Use leaflet() here, and only include aspects of the map that
        # won't need to change dynamically (at least, not unless the
        # entire map is being torn down and recreated).
        leaflet(EarthquakeData) %>% addTiles() %>%
            fitBounds(~min(Longitude), ~min(Latitude), ~max(Longitude), ~max(Latitude)) 
    })
    
    output$histEQs <- renderPlot({
        # If no zipcodes are in view, don't plot
        if (nrow(filteredData()) == 0)
            return(NULL)
        
        hist(filteredData()$Magnitude,
             main = "Selected Earthquakes",
             xlab = "Magnitude",
             border = 'white',
             col = 'blue'
             )
    })
    
    output$DepthMagnEQs <- renderPlot({
        # If no points are in view, don't plot
        if (nrow(filteredData()) == 0)
            return(NULL)
        
        print(xyplot(Depth ~ Magnitude, data = filteredData()))
    })
    
    output$EvolEQs <- renderPlot({
        # If no points are in view, don't plot
        if (nrow(filteredData()) == 0)
            return(NULL)
        
        print(xyplot(Magnitude ~ Time, data = filteredData(), type = "l"))
    })
    
    # Incremental changes to the map (in this case, replacing the
    # circles when a new color is chosen) should be performed in
    # an observer. Each independent set of things that can change
    # should be managed in its own observer.
    observe({
        leafletProxy("map", data = filteredData()) %>%
            clearMarkers() %>%
            addCircleMarkers( 
                popup = paste0("<b>Date:</b> ", filteredData()$Time,
                               "<br><b>Magnitude:</b> ", filteredData()$Magnitude,
                               "<br><b>Depth:</b> ", filteredData()$Depth),
                weight = 1,
                radius = 10^(filteredData()$Magnitude/6),
                color = getColor(filteredData())
            )
        
        output$selected_var <- renderText({ 
            paste(nrow(filteredData()), "Earthquakes selected")
        })
    })  
    
    
    
   
})
