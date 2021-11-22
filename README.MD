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

The SSDM (Stacked Species Distribution Modelling) R package was used to create 


<h2> Testing </h2>


<h2> The final model and R Shiny App <h2>






