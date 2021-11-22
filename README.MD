<h1> Introduction </h1>

This project was completed in my final year of my Computer Science degree.

The main goal of this project is to develop a species distribution model that sorts new observations into high and low reliability categories with the intention of keeping the Victorian Biodiversity Atlas as up todate as possible. The categorisation will guide how (Department of Environment, Land, Water and Planning) DELWP best uses their experts’ time. The second goal is to identify predictors (variables) that have the most impact on successful categorisation.

.

<h1> Method </h1>
The DELWP Biodiversity Division have provided verified datasets of species observations with location, high and low reliability labels and collection method attributes for several selected species. There are several hundred observations per species

Biodiversity data for each relevant species was obtained from the <a href="https://www.gbif.org">Global Biodiversity Information Facility</a>.


<h2> Structure </h2>

Each folder contains their own README.txt
The only folder required to run the app is "DELWP APP"


FOLDERS
Testing - used for testing

Preprocessing - used to preprocess DELWP provided data and obtain additional data from the Global Biodiversity Information Facility (GBIF) . Then saved the the result into a new .csv file which is used for modelling

Modelling - used to create the actual models. Used the cleaned .csv files from the Preprocessing step. Saves these models

DELWP APP - Main app. Uses the saved models from the Modelling step. Creates the Shiny app.

User manuals - contains the Basic End User Guide and Technical User Guide and Code Report


<h1>The model </h1>



