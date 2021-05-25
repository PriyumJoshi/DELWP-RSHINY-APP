Each folder contains their own README.txt
The only folder required to run the app is "DELWP APP"

FOLDERS
Testing - used for testing

Preprocessing - used to preprocess DELWP provided data and obtain additional data from the Global Biodiversity Information Facility (GBIF) . Then saved the the result into a new .csv file which is used for modelling

Modelling - used to create the actual models. Used the cleaned .csv files from the Preprocessing step. Saves these models

DELWP APP - Main app. Uses the saved models from the Modelling step. Creates the Shiny app.

User manuals - contains the Basic End User Guide and Technical User Guide and Code Report