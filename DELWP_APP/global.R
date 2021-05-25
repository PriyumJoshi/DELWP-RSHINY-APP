library(pacman)
options(digits = 5)
packages = c("DT", "shinydashboard", "installr", "raster" ,"shinybusy","session", "pacman", "BiocManager", "raster", "rgdal", "dismo", "rJava","sp","maptools","rgeos","ROCR","randomForest","adabag","e1071","tree","neuralnet", "shiny", "leaflet", "smds", "remotes", "rgeos", "adabag" , "randomForest", "maptools" ,"rpart", "tree", "e1071", "lubridate", "dplyr", "spatialEco", "SSDM", "testthat", "knitr", "rmarkdown", "rgdal")



# p_load(packages, character.only = TRUE)
# # # updateR()
# p_loaded(packages, character.only = TRUE)


#Load the libraries
library("rsconnect");library("shinyLP"); library("shinydashboard"); library("shinybusy")
library("DT"); library("maptools");library("shiny");library("leaflet") ;library("SSDM") ;library("dplyr")
colnames(data)
library("raster")


#Load known high reliable/confiremd observations in DELWP dataset
data = read.csv("Monash_sample_VBA.csv", stringsAsFactors = FALSE)
data = data[data$RELIABILITY != "Unconfirmed" & data$RELIABILITY != "" ,]
data = data[,c(4,13,12)]
colnames(data) = c("species", "lon", "lat")

# data = read.csv("SpeciesC.csv", stringsAsFactors = FALSE)
# data  = data[,c(3,4,5)]
df = data

#Load the model
SSDM = readRDS(file = "SSDM")
MODEL = plot(SSDM)


MODEL[["options"]][["height"]] = 1080

#Function to get binary predictions (0 = not reliable, 1 = is reliable)
getBinaryPrediction = function(lon, lat, species)
{
  
  NUM = -1
  # print(tolower(species))
  if (tolower(species) == "white-browed treecreeper") {NUM = 1}
  if (tolower(species) == "southern brown tree frog") {NUM = 2}
  if (tolower(species) == "small triggerplant") {NUM = 3}
  if (tolower(species) == "common beard-heath") {NUM = 4}
  if (tolower(species) == "agile antechinus") {NUM = 5}
  if (tolower(species) == "brown treecreeper") {NUM = 6}
  
  
  if (NUM == -1) {return('Invalid species name')}


  
  # print(NUM)
  df = data.frame("lon" = c(lon), "lat" = c(lat))
  prediction = extract(slot(slot(SSDM, "esdms")[[NUM]], "binary"),df )
  prediction[is.na(prediction)] = "0 (NA value, out of range/invalid)"
  return(prediction)
}




#Get probability for it being reliable
getProjection = function(lon, lat, species)
{
  NUM = -1
  # print(tolower(species))
  if (tolower(species) == "white-browed treecreeper") {NUM = 1}
  if (tolower(species) == "southern brown tree frog") {NUM = 2}
  if (tolower(species) == "small triggerplant") {NUM = 3}
  if (tolower(species) == "common beard-heath") {NUM = 4}
  if (tolower(species) == "agile antechinus") {NUM = 5}
  if (tolower(species) == "brown treecreeper") {NUM = 6}

 
  

  df = data.frame("lon" = c(lon), "lat" = c(lat))
  prediction = extract(slot(slot(SSDM, "esdms")[[NUM]], "projection"),df)
  prediction[is.na(prediction)] = "0 (NA value, out of range/invalid)"
  
  return(prediction)
}
slotNames(SSDM)
#mapply(getProjection, data$lon, data$lat, data$species)
#r = mapply(getProjection, data$lon, data$lat, data$species)
#table(r)

# slot(slot(SSDM, "esdms")[[4]], "name")
# slot(slot(SSDM, "esdms")[[1]], "binary")
# slot(slot(SSDM, "esdms")[[1]], "projection")
#
#
# result = extract(slot(slot(SSDM, "enms")[[6]], "binary"), test)
# result[is.na(result)] = "bs"
# test = data.frame("lon" = c(144.05 ), "lat" = c(-37.223))
#
# tolower(data$species[6]) == "agile antechinus"
#
#
#
# test = function(a,b) {print(a+b)}
#
# tolower(unique(species_list))
