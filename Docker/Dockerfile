# Base image
FROM gtru1/delwp-intermediary-image

## create directories
RUN mkdir -p /DELWP_APP

## copy files
COPY DELWP_APP/DELWP_APP/ /

EXPOSE 8080

## Run R-script
CMD ["Rscript","app_run.R"]