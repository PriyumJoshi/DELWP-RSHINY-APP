Build Intermediary Image
-- navigate to the downloaded "Docker" folder in the command line. And then enter into folder "docker-intermediary-image" 
-- type and enter "docker build -t gtru1/delwp-intermediary-image ."
-- * You will need to have your own repository on DockerHub with the same name
-- * as the image given if you would like to change your own name for this image.
-- * The reason being is so that the second image can be built on top of this one.
-- * This process will take a really long time. Approx. 60+ minutes.

Build Image on top of Intermediary image
-- navigate back to folder "Docker" in the command line.
-- type and enter "docker build -t gtru1/delwp-app ."

Running the image created.
-- type and enter "docker run --rm -m 6g -p 8080:8080 gtru1/delwp-app"
-- * --rm: means that once the container is stopped, it will automatically be removed.
-- * -m 4g: means that it is assigning the docker container a certain amount of memory, in this case 6gigs
-- * port 8080 will be assigned for this contianer to be run
-- Wait for Listening on http://0.0.0.0:8080

Opening the app on the web browser.
-- Go to the local ip address. In this case, since I am using docker toolbox, it created its own IP address. (192.168.99.100)
-- If you are using Docker Daemon. Use "localhost:8080"
-- So go to the web browser and type in "192.168.99.100:8080"
