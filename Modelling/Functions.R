library(pacman)
packages = c(
  "installr" ,
  "session",
  "pacman",
  "BiocManager",
  "raster",
  "rgdal",
  "dismo",
  "rJava",
  "sp",
  "maptools",
  "ROCR",
  "randomForest",
  "adabag",
  "e1071",
  "tree",
  "neuralnet",
  "shiny",
  "leaflet",
  "smds",
  "remotes",
  "rgeos",
  "rpart",
  "lubridate",
  "dplyr",
  "spatialEco",
  "SSDM",
  "testthat",
  "knitr",
  "rmarkdown",
  "DT",
  "rsconnect",
  "shinyLP",
  "shinydashboard",
  "shinybusy"
)

p_load(packages, character.only = TRUE) 
#updateR()
p_loaded(packages, character.only = TRUE) 



#This function generates psuedo-abscene points THAT ARE CLOSE to our observaiton points.
#It uses the spaitalEco library's function to do so
#It takes in a dataframe containing the longitude/latitude values (named lon/lat) and a value 'n'
#which is roughly the number of psuedo-abscene points generated
generatePsuedoAbscenePoints = function(observations, n)
{
  data(wrld_simpl)
  coordinates(observations) = ~lon+lat
  crs(observations) <- crs(wrld_simpl)
  
  pa = pseudo.absence(observations, n = n)
  pa = as.data.frame(pa)
  
  pa = pa[,base::c(2,3)] #lon/lat values
  colnames(pa) = base::c("lon", "lat")
  
  return(head(pa,n))
}


#This function generates background points randomly. It generates these points randomly all around. 
#An 'extent' value is given stating the range where these random points should be generated
#It takes in prescene points (lon/lat dataframe) and an extent. It returns a dataframe containing lon/lat values which represent random points
#It also rejects any points that in Australia and also all duplicates are removed. The amount of background points generated is roughly
#equal to the number.


generateRandomPoints = function(pres, extent_) {
  backgr <-
    data.frame(randomPoints(predictors, NROW(pres), ext = extent_))
  
  #Cross checking. REJECT ANY COORDINATE NOT IN AUSTRALIA
  coordinates(backgr) = ~ x + y
  crs(backgr) <- crs(wrld_simpl)
  ovr <- over(backgr, wrld_simpl)
  i <- which(ovr$NAME == "Australia")
  backgr = data.frame(backgr[c(i),])
  colnames(backgr) = c("lon", "lat")
  
  
  
  return(distinct(data.frame(backgr)))
}


#This function takes in prescene and abscene points in a dataframe format with lon/lat values. It also takes a raster of predictors.
#It returns a dataframe, free from any NA values, containing the values of the predictors at the prescene and abscene points. 
#An abscene point is considered to have a reliability of '0' while a prescene point is considered to have a reliability of '1'
extractPredictorsValues = function(pres, abs, predictors) {
  library(raster)
  presvals  = data.frame(raster::extract(predictors, pres))
  absvals = data.frame(raster::extract(predictors, abs))
  reliability = c(rep(1, nrow(presvals)), rep(0, nrow(absvals)))
  return(na.omit(data.frame(cbind(
    reliability, rbind(presvals, absvals)
  ))))
}

#Very simple function. Given a dataframe containing the lon/lat values, it returns an extent representing the bounds.
#E.G. if the lon values range from 150-160 and the lat values range from -30 to -40 then it will return extent(150,160,-40,-30)

getExtent = function(coordinates.c) {
  ext = raster::extent(
    min(coordinates.c$lon),
    max(coordinates.c$lon),
    min(coordinates.c$lat),
    max(coordinates.c$lat)
  )
  return(ext)
}


#Our own plot function to reduce repetitive code when ploting.
#It takes prescene and abscene points in the form of a dataframe that containing the lon/lat values for these points
#It also takes an extent value representing the ylim and xlim of the plot
#A boolean value is also provided determing if it should plot the abscene points or not
#The prescene points will be orange and the abscene points will be red
plot_ = function(p, a, extent, plotAbs = TRUE) {
  x = c(slot(extent, "xmin"), slot(extent, "xmax"))
  y = c(slot(extent, "ymin"), slot(extent, "ymax"))
  
  
  plot(
    wrld_simpl,
    ylim = y,
    xlim = x,
    axes = TRUE,
    col = "light yellow"
  )
  box()
  
  points(p$lon,
         p$lat,
         col = 'orange',
         pch = 20,
         cex = 0.75)
  
  
  
  if (plotAbs) {
    points(a$lon, a$lat, col = 'red')
  } #Psuedo abscene
  
}

