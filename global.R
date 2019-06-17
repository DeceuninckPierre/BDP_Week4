library(dplyr)

EarthquakeData <- read.csv(paste0(getwd(),"/data/database.csv"))
EarthquakeData <- EarthquakeData %>% 
    filter(Type=="Earthquake") %>% 
    mutate(Time=as.POSIXct(paste(Date,Time),format="%d/%m/%Y %H:%M:%S")) %>% 
    mutate(Date=as.Date(Date,format="%d/%m/%Y")) %>% 
    select(c("Date","Time","Depth","Magnitude","Magnitude.Type","Latitude","Longitude")) %>%
    filter(!is.na(Date)) %>%
    arrange(Time)


getColor <- function(quakes) {
    sapply(quakes$Magnitude, function(mag) {
        if(mag <= 6.8) {
            "green"
        } else if(mag <= 7.8) {
            "orange"
        } else {
            "red"
        } })
}