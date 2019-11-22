library(here)       # path management
library(dplyr)      #
library(ncdf4)      #
library(sf)         #
library(raster)     #
library(fasterize)  # fast rastrerization
library(leaflet)    #
library(rasf)       # utilities

source_list <- list.files(here("R"), full.names = TRUE, pattern = glob2rx("*.R"))
for (f in source_list) source(f)
