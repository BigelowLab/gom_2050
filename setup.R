library(here)         # path management
library(dplyr)        #
library(ncdf4)        #
library(sf)           #
library(raster)       #
library(fasterize)    # fast rastrerization
library(leaflet)      # html based graphics
library(rasterVis)    # lattice based graphics
library(RColorBrewer) # color palettes
library(rasf)         # utilities for raster and sf

source_list <- list.files(here("R"), full.names = TRUE, pattern = glob2rx("*.R"))
for (f in source_list) source(f)
