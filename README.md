# GOM 2050 with ROMS output

### R packages

+ [here](https://cran.r-project.org/package=here)
+ [sf](https://cran.r-project.org/package=sf)
+ [ncdf4](https://cran.r-project.org/package=ncdf4)

### Organization

First start a fresh session of R, set the working directory with `setwd("/path/to/project/")`, and move RStudio's file browser that that directory using the menu `Files > More > Go to Working Directory`.


* `setup.R` a script to setup and source other functions

* `README.md`

* `data` data plus orginal download
    + `GOM_2050` source data
    + `orig` original download
    + ... other items
  
* `R` files with functions

* `scripts` files to manage workflows

### Data source

```
From: James Scott - NOAA Affiliate <james.d.scott@noaa.gov>
Date: Wed, Jul 24, 2019 at 2:05 PM
Subject: ROMS 2050 anomalies
To: Andrew J. Pershing <apershing@gmri.org>, to: Brickman, David <David.Brickman@dfo-mpo.gc.ca>, Mike Alexander <michael.alexander@noaa.gov>, Joe Salisbury <joe.salisbury@unh.edu>, Dwight Gledhill <dwight.gledhill@noaa.gov>, Samantha Siedlecki <samantha.siedlecki@uconn.edu>


Hi, I've made the ROMS 2050 anomalies available on google drive.
https://drive.google.com/drive/folders/1WCSuBWxD0wLiFFVR6AHHQclujhI43PE4?usp=sharing

These netCDF files contain data from ROMS regional ocean model experiments subset for the Gulf of Maine region. Each contain 12 months starting in January, ending in December. Latitude (lat) and longitude (lon) in the model are two-dimensional in (y,x) named (eta_rho, xi_rho). The y,x are not oriented N/S/E/W, but are rotated to follow the NE US coast line.

Each file contains the climate from the control experiment (cntrl) which represents the 1976-2005 climate. Each file also has anomalies (scaled to 2050) where the climate change signal from 3 CMIP5 models was added to the CTRL forcing (gfdl2050, ipsl2050, hadgem2050). These are the downscaled projected changes (relative to 1976-2005) for the 2050 climate in the GOM.

There are 4 single level files:
sss.ROMS.2050.GOM.anom.nc      :Sea Surface Salinity (PSU)
sst.ROMS.2050.GOM.anom.nc      :Sea Surface Temperature (deg C)
botSalt.ROMS.2050.GOM.anom.nc  :Bottom (<300m depth) Salinity (PSU) 
botT.ROMS.2050.GOM.anom.nc     :Bottom (<300m depth) Temperature (deg C)

There are 5 multilevel files with 18 depths 
(10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 125, 150, 175, 200, 225, 250, 275, 300 meters):
These files also contain the model bathymetry for GOM.

temp.depth.ROMS.2050.GOM.anom.nc       :Ocean Temp (deg C)
salinity.depth.ROMS.2050.GOM.anom.nc   :Ocean Salinity (PSU)
U.velocity.depth.ROMS.2050.GOM.anom.nc :Ocean Zonal Velocity (cm/s)
V.velocity.depth.ROMS.2050.GOM.anom.nc :Ocean Meridional Velocity (cm/s)
velocity.depth.ROMS.2050.GOM.anom.nc   :Ocean Velocity Magnitude (cm/s) 
                                       :Use velocity magnitude when interested in 
                                       :changes in total velocity instead of U,V 
                                       :components. Velocity is computed from 5 :day average U, V

One additional file is for dissolved inorganic carbon. It was not produced in the ROMS downscaled experiments since they did not have BGC processes.  This is from the Ensemble Mean CMIP5 BGC models on a 1 degree x 1 degree grid.

dic.CMIP5.ensmn.2050.GOM.anom.nc  :dissolved inorganic carbon and surface
                                  :(10^-2 mol m^-3)  
Contains the Jan-Dec historical climate (climhist) and 2050 anomalies (anom2050) and lat and lon.

You can check your results with the files in the Images directory to see if you are reading the data correctly.
```
