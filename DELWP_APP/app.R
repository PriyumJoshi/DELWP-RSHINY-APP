source("global.R")

# detach("package:rstan", unload=TRUE)

MAX_UPLOAD_MB = 5
MAX_OBSERVATIONS = 20000
options(shiny.maxRequestSize = MAX_UPLOAD_MB*1024^2)
#This is focus on the interface aspects and not the processing
ui <- dashboardPage(
 

  
  #Create 4 tabsn
  dashboardHeader(title = "DELWP Project"),
  dashboardSidebar(
    sidebarMenu(
      #The 4 tabs
      menuItem("Make prediction", tabName = "Predict",icon = icon("star")),
      menuItem("Visualize inputted observations", tabName = "Visualize", 
               icon = icon("star")),
      menuItem("Known DELWP observations", tabName = "Overview", icon = 
                 icon("star")),
      menuItem("View statistics", tabName = "Stats",icon = icon("star")))),
  
  dashboardBody(
    
    #The tab called View statistics" will simply output model stats generated
    #From the library
    tabItems(
      tabItem(tabName = "Stats", MODEL),
      

      #Tab called "Visualize inputted observations" will
      #show observations in inputted .csv file. 
      #Will contain text explaining how it works
      tabItem(
        tabName = "Visualize",
        box(
          title = "Inputted observations",
          width = 10.8,
          height = 8 ,
          status = "primary",
          solidHeader = TRUE,
          p("This map shows the observations inputted in the 'Make prediction'
            tab. If nothing/an error shows below, ensure you imported data in 
            the 'Make prediction' first. Click on individual points to see 
            additional information such as the reliability."),
          leafletOutput("mymap2", height = 600, width = 1200)
        )
      ),
    
      
      #Tab called "Visualize inputted observations" will
      #Contain leaflet map showing observations from DELWP dataset
      #Will contain text explaining how it works
      tabItem(tabName = "Overview",
              
              fluidRow(
                
                box(title = "Information", status = "primary", solidHeader = TRUE,
                    
                    p(h4("The purpose of this tab is to give a quick overview of
                         the 6 species in the provided DELWP dataset.")),
                    p(h4("The interactive map on the right can be used to explore
                         the", strong("acceptable or confirmed"), "observations 
                         in the provided DELWP dataset.", br(), br(),  "Hovering
                         over a specific point and clicking on it will bring out
                         a tooltip showing the exact longitute and latitude
                         coordinates.")),
                    p(h4("The data-frame below also shows the exact longitute 
                         and latitude coordinates for these observations."))
                    
                    
                ),
                
                
                box(title = "Reliable DELWP Observations", width = 6, height = 8
                    ,status = "primary", solidHeader = TRUE, 
                    leafletOutput("mymap", height = 800, width = 600))),
              
              fluidRow(div(DTOutput("table"),
                           style = "font-size: 125%; width: 49%"))
              
              
              
              
      ),
      
      #Tab for making the actual predictions;"Make prediction" tab
      #You input a .csv file
      #Contains text explaining how it works
      tabItem(tabName = "Predict",
              
              
              column(4,
                     
                     box(fileInput("csv", "Choose CSV file",
                                   multiple = FALSE,
                                   accept =  c('.csv')
                     ), width = 400, height = 900, status = "primary", solidHeader = TRUE, title = "CSV input",
                     downloadButton("downloadData", "Download"),
                     p(br(),
                       h5(strong("VERY IMPORTANT: ENSURE THAT THE LONGITUDE/LATITUDE COLUMNS ONLY CONTAIN NUMBERS OTHERWISE IT MAY IMPACT THE PREDICTIONS FOR ALL OBSERVATIONS.") , br(), br(), strong("DEPENDING ON THE FILE SIZE IT CAN TAKE SEVERAL MINUTES FOR THE RESULTS TO SHOW. TO ENSURE RESULTS ARE COMPUTED IN A REASONABLE TIME, THE FILE LIMIT IS SET TO 5MB AND THE NUMBER OF ROWS/OBSERVATION POINTS IS SET TO A MAXIMUM OF 20,000 BY DEFAULT. THESE RESTRICTIONS CAN BE REMOVED BY MODIFYING THE CODE."), br(), br(),
                         "Enter a .csv file that contains 3 columns representing the latitude, longitude and species (with these column names, case insensitive).",
                         br(),
                         br(),
                         "Considering that the observation points for the 6 species in the DELWP dataset are all at/near Australia, any coordinates outside this extent will automatically be assigned with a probability of 0. Specifically, longitude values outside of the range (100,160) and latitude values outside of the range (-50,15) will be assigned a probability of 0.",
                         br(),
                         br(),
                         "The predictions will only be made for the 6 species in the provided DELWP dataset (case insensitive).", br(), br(), "Specifically these
                         species are:", br(), strong("'Brown Treecreeper'"), br(), strong("'Agile antechinus'"), br(), strong("'Common Beard-heath"), br(), strong("'Small Triggerplant'"), br(), strong("'Southern Brown Tree Frog'"), br(), strong("'White-browed Treecreeper'"), br(), br(), "What will be returned (shown on the right) are 5 columns which contain the longitude, latitude, species, probability, and binary prediction for each row in the provided .csv file. A value of 1 = high reliability, a value of 0 = low reliability.", br(), br(), "This results can also be downloaded as a .csv file with the download button above and the results will also be mapped which can be seen in the 'Visualize inputted observations' tab."))
                     
                     )),
              
              column(8,
                     add_busy_spinner(position = c("full-page")),
                     box(
                       width = 10,
                       height = 800,
                         div(
                         DTOutput("table2"),
                         style = "font-size: 100%; width: 95%",
                         status = "primary",
                         solidHeader = TRUE,
                         title = "Predictions"
                       )
                     ))
              
              
              
      )      
      
      
    )))




server <- function(input, output, session) {
  
  #Make the map data
  DELWP_data = reactive({x = df})
  
  #Output leaflet map, add legend. 
  output$mymap <- renderLeaflet({
    df =  DELWP_data()
    
    pal = colorFactor("viridis", domain = df$species)
    
    m = leaflet(options = leafletOptions(minZoom = 5), data = df) %>%
      addTiles()  %>%
      
      #add colors to represnet different specie
      addCircleMarkers(lng =  ~lon, 
                       lat = ~lat, color = ~pal(species),
                       popup  = 
                         paste("Longitude: ", df$lon, "<br>", "Latitude: ", df$lat, "<br>"
                                                                                    , "Species: ", df$species))   %>%
      #Focus zoom on victoria and limit zoom
      setView(145, -37, zoom = 9) %>%
      setMaxBounds(140, -50, 160 ,15) %>%
      #Add legend
      addLegend("topright", pal = pal, values = ~species, title = "Species",opacity = 1 )
    
    
    
  })
  

  
  #Output  observations from DELWP dataset
  output$table = renderDT(df, options = list(lengthChange = FALSE, pageLength = 10))
  
  
  #This is for the inputted data
  data <- reactive({

      #Input vaidation
    
      #Only output something if something is inputted.
      if (is.null(input$csv))
        return(NULL)
    
      #Read the input
      data = read.csv(input$csv$datapath, fileEncoding="UTF-8-BOM")
     
      #Rename lon/lat to longitude and latitude. 
      if (any(tolower(names(data)) == 'lon')) {data = dplyr::rename(data, "longitude" = "lon")}
      if (any(tolower(names(data)) == 'lat')) {data = dplyr::rename(data, "latitude" = "lat")}
      
       
      #Ensure inputted .csv file contains 'species' column
      if (!(any(tolower(names(data)) == "species"))) {
        showModal(
          modalDialog(
            title = "ERROR - DATAFRAME CONTAINS NO 'species' COLUMN",
            footer = modalButton("OK"),
            size = c("l"),
            easyClose = FALSE,
            fade = TRUE
          )
        ) 
        return(NULL)
        }
      

      #Number of observations limited to 20,000. CHANGE THIS IF U WANT TO
      #REMOVE THESE RESTRICTIONS
      if (NROW(data) > MAX_OBSERVATIONS) {
        showModal(
          modalDialog(
            title = "ERROR - PLEASE ENSURE NUMBER OF ROWS/OBSERVATION POINTS IS NO GREATER THAN 20,000 ",
            footer = modalButton("OK"),
            size = c("l"),
            easyClose = FALSE,
            fade = TRUE
          ))
          return(NULL)
    }
        
      #Ensure longitude column exist
      if (!(any(tolower(names(data)) == "longitude"))) {
        showModal(
          modalDialog(
            title = "ERROR - DATAFRAME CONTAINS NO 'longitude' COLUMN",
            footer = modalButton("OK"),
            size = c("l"),
            easyClose = FALSE,
            fade = TRUE
          )
        ) 
        return(NULL)
      }
      
      #Ensure latitude column exist
      if (!(any(tolower(names(data)) == "latitude"))) {
        showModal(
          modalDialog(
            title = "ERROR - DATAFRAME CONTAINS NO 'latitude' COLUMN",
            footer = modalButton("OK"),
            size = c("l"),
            easyClose = FALSE,
            fade = TRUE
          )
        ) 
       return(NULL)
      }
      
      # species_list = c("Southern Brown Tree Frog", "White-browed Treecreeper", "Common Beard-heath" , "Small Triggerplant" , "Brown Treecreeper"  ,  "Agile antechinus"  )
      # sp = as.vector(tolower(data$species) %in% tolower(unique(species_list)))
      # # print(sp)
      # if (length(sp[sp == FALSE]) > 0) {
      #   showModal(
      #     modalDialog(
      #       title = "ERROR -  AT LEAST ONE SPECIES IN THE SPECIES COLUMN NOT RECOGNIZED",
      #       footer = modalButton("OK"),
      #       size = c("l"),
      #       easyClose = FALSE,
      #       fade = TRUE
      #     )
      #   ) 
      #   return(NULL)
      # }
      # 
  
      #If it passes all the input checks, it then outputs a dialog 
      #informing the user that the predictions are being mde
      showModal(
        modalDialog(
          title = "PLEASE BE PATIENT FOR THE RESULTS. THIS CAN TAKE SEVERAL MINUTES DEPENDING ON THE FILE SIZE AND NUMBER OF OBSERVATIONS",
          footer = modalButton("OK"),
          size = c("l"),
          easyClose = FALSE,
          fade = TRUE
        )
      ) 
      
  
    #These access the model
    #From the 'global.R' file
    #For each observation, use the correct model to get the values
    #getProjection, getBinaryPrediction functions in 'global.R" file+
      
      
    #data = read.csv("EXAMPLE.csv", fileEncoding="UTF-8-BOM") 
      
    colnames(data) = tolower(colnames(data))
    data = dplyr::select(data,"longitude","latitude","species")
    #These results get put into two new columns
    data$probability = (mapply(getProjection, data$lon, data$lat, data$species))
    data$category = (mapply(getBinaryPrediction, data$lon, data$lat, data$species))


    #Return the new dataframe
    return(data)
      
  })
  
  #Output. Similiar strucutre to the one used to output for known DELWP 
  #Observations
  output$mymap2 <- renderLeaflet({
    df = data()
    
    pal = colorFactor("viridis", domain = df$species)
    
    m = leaflet(options = leafletOptions(minZoom = 5), data = df) %>%
      addTiles()  %>%
      addCircleMarkers(lng =  ~longitude, lat = ~latitude, color = ~pal(species), popup  = paste("Longitude: ", df$longitude, "<br>", "Latitude: ", df$latitude, "<br>"
                                                                                      , "Species: ", df$species, "<br>", "reliability (1 = high, 0 = low): ", df$category, "<br>", "Predicted probability (higher = more reliable): ", df$probability))   %>%
      setView(145, -37, zoom = 9) %>%
      setMaxBounds(140, -50, 160 ,15) %>%
      addLegend("topright", pal = pal, values = ~species, title = "Species",opacity = 1 )
    
    
    
  })
  
  #Output observations in inputted .csv file to dataframe
  output$table2 = DT::renderDT(data(),  options = list(lengthChange = FALSE, pageLength = 10))
  output$downloadData <- downloadHandler(
    
    filename = function() {
      "predictions.csv"
    },
    content = function(file) {
      write.csv(data(), file, row.names = FALSE)
    })                           
  
  
}


#RUN
shinyApp(ui, server, options = list(height = 1080))