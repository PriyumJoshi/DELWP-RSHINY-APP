# Base image https://hub.docker.com/u/rocker/
FROM rocker/r-base:latest

## install debian packages
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
libcurl4-openssl-dev \
libssl-dev

## copy files
COPY install_packages/DELWP.install.packages.r install_packages/DELWP.install.packages.r

## install R-packages
RUN Rscript install_packages/DELWP.install.packages.r