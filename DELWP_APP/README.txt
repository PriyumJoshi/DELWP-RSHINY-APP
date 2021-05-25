Open the 'app.R' in R Studio and run it if you want to use the app locally. 
The 'app.R' file sources the 'global.R' file whichs loads all the libraries/the model (SSDM file) as well as the "SpeciesC.csv" file which contains all the observation points from the original DELWP dataset as well as from the Global Biodiversity Information Facility

The app contains information on how to use it. Upload a .csv file (containing columns 'species', 'latitude', 'longitude') in the 'Make prediction' tab. To see an example of a valid .csv file, see the 'EXAMPLE.csv' file (which contains all the observations from the original DELWP dataset).

There is a .mp4 file called "Running_the_app.mp4" showing predictions being made from all the observations points in the sample DELWP dataset, exploring some basic features of the app, and showing how you can change the maximum upload limit/maximum number of observations
 
It is also published at https://pjos0001.shinyapps.io/DELWP/ (Till November 31st 2019)

FILES
rsconnect - this is used to create publish the shiny app. Don't worry about it.
SSDM - this is main R object that represents the model
Monash_sample_VBA - DELWP provided dataset
SpeciesC.csv - contains all the observation points from the original DELWP dataset as well as from the Global Biodiversity Information Facility
EXAMPLE.csv - valid .csv file for input to the Shiny app. Contains all the observations from the original DELWP dataset
app.R - main code to run the shiny app; references global.R 
global.R - loads the model/libraries/functions required to run the main app
MODEL_INFO - contains information about the model. Here you can access things such as the raster files used to make the predictions for each species and relevant tables (.csv format) such as model evaluation, data used, etc..