<h1> Introduction </h1>

This project was completed in my final year of my Computer Science degree.

The main goal of this project is to develop a species distribution model that sorts new observations into high and low reliability categories with the intention of keeping the Victorian Biodiversity Atlas as up todate as possible. The categorisation will guide how (Department of Environment, Land, Water and Planning) DELWP best uses their experts’ time. The second goal is to identify predictors (variables) that have the most impact on successful categorisation.

This project was done in the programming language R and for selected species in Australia.
.

<h1> Method </h1>
The DELWP Biodiversity Division have provided verified datasets of species observations with location, high and low reliability labels and collection method attributes for several selected species. There are several hundred observations per species.<br>

This data includes: <ul>
	<li>Location data</li>
	<li>High and low reliability labels</li>
	<li>Collection method attributes</li>
</ul>

<h2> Data preparation </h2>
Biodiversity data for each relevant species was obtained from the <a href="https://www.gbif.org">Global Biodiversity Information Facility</a>. 
This was done using <a href="https://cran.r-project.org/web/packages/dismo/dismo.pdf">functions</a> from the R package <a href="https://www.rdocumentation.org/packages/dismo/versions/0.7-6/topics/gbif">Dismo</a>.

Once all this data was obtained, preprocessing was done to remove unhelpful data such as outliers and unreliable data.

Relevant environmental data was obtained from <a href="https://www.worldclim.org/data/bioclim.html">WorldClim</a>. 19 bioclimatic variables, which are commonly used in species distribution modeling, was linked to the verified observation locations, thus creating thus creating additional attributes for each observation point on top of the collection method attributes.

<h2> Modelling </h2>
Geo-spatial processing was to extract attribute values from the environmental data for the species observation points.
Pseudo-absence data was also generated for each species and used when creating the models. <br> <br>

The  <a href="https://cran.r-project.org/web/packages/SSDM/vignettes/SSDM.html">SSDM (Stacked Species Distribution Modelling)</a> R package was used to create <a href="https://rdrr.io/cran/SSDM/man/ensemble_modelling.html">Ensemble</a> Species Distribution Models for each of the species.  <br> <br>
After the ensemble Species Distribution Models were created, each ensemble model were stacked in an <a href="https://rdrr.io/cran/SSDM/man/stacking.html">Stacked Species Distribution Model</a>.


<h2> Testing </h2>
After experimenting and testing with the various algorithms, we decided to use the Random Forest as the main algorithm to for the species distribution models.  Models were evaluted using k-fold cross validation.

The AUC for the final model for each species:
![image](https://user-images.githubusercontent.com/84790185/142960591-eb4af18d-6ab3-4b31-8593-4f70e2a6cc99.png)



<h1> The R Shiny App </h1>
The only code needed to run the the app is found in the "DELWP_APP" folder.
Please do not rename, move, or delete any files.

The final model is made to be an interactive Shiny app. This was done using the R package <a href="https://shiny.rstudio.com/">Shiny</a>.

It is recommended to run the application in a Docker container. Instructions for doing so can be found in the Docker folder.

You can run the app without Docker by running the "app.R" script that is found in the DELWP_APP folder.

When you first run the application, this is the main page of the app you will encounter.

![image](https://user-images.githubusercontent.com/84790185/142968893-a9acd777-cf14-48fa-843d-099c37a9890c.png)

The input the model takes is a .csv file containing three columns which include the species, the longitude, and the latitude values. 
The file "EXAMPLE.csv" is an example of a valid input file)
(By default, the maximum number of observations is set to 20,000 and the maximum upload limit is set to 5MB. This can be changed by modifying the first few lines in the "app.R" file.)


After you input a valid .csv file, you can observe and download the resulting data frame by clicking the download button. The data frame will be downloaded as a .csv file

![image](https://user-images.githubusercontent.com/84790185/142969117-2933a044-4b51-4b4d-b1f1-348c420c5dc6.png)

These observations in the inputted .csv file can be observed in the “Visualize inputted observations” tab. Note that this map will not work until a valid .csv file is inputted, and the observations are successfully processed

![image](https://user-images.githubusercontent.com/84790185/142969160-da846c14-bbe0-467f-b350-c51e62b35196.png)


The “Known DELWP observations tab” can be used to visualize the acceptable or confirmed observations in the provided DELWP dataset. The observations are both shown on a map and on a data frame

![image](https://user-images.githubusercontent.com/84790185/142969173-c88a88b1-ef7d-4e92-a0d0-28cf6805f2e4.png)

Now navigate to the “View statistics” tab. You can view the binary and habit suitability map as well as see relevant metrics such as AUC (area under the curve), specificity, and sensitivity. You can also see variable importance and so on for each species.

![image](https://user-images.githubusercontent.com/84790185/142969190-f44d8e71-3ffa-47eb-a0d1-1028937dfcf9.png)

The summary tab provides information regarding how the model was built. This model was built using the Random Forest algorithm using presence only data (the library used to create this model generated pseudo-absence points for us automatically), 5-fold cross validation, and using 2377 observation points.

![image](https://user-images.githubusercontent.com/84790185/142969195-4fcb19dd-74d0-49bc-8e85-42d60ac866e3.png)

<br> <br> <br>

Note: you can zoom in and out of the binary and projection map.

![image](https://user-images.githubusercontent.com/84790185/142969209-7b4104cd-45b2-47c4-9f8d-c6edd6612a5b.png)


There is also a section called “Stacked species”
It uses the stacked species distribution model to providel species richness map which shows how many species you expect to find in certain locations.

![image](https://user-images.githubusercontent.com/84790185/142969222-8ee935ba-0de6-42fc-bd6d-12d44acabf79.png)

You can also view predictors that have the most impact on successful categorisation.
![image](https://user-images.githubusercontent.com/84790185/143008354-fb7818d5-b7ae-43a9-811d-8195ff3dc4be.png)

	
	
	





