#' Dump the ncdf summary to a text file
#'
#' @param x ncdf4 class object
#' @param dst character, destination path - the filename is derived from \code{x}
#' @return the ncdf4 object (invisibly)
dump_nc <- function(x, dst = here::here("data", "ncdump")){
  stopifnot(inherits(x, 'ncdf4'))
  if (!dir.exists(dst)) ok <- dir.create(dst, recursive = TRUE)
  sink(file = file.path(dst, paste0(basename(x$file), ".txt")))
  print(x)
  sink(file = NULL)
  invisible(x)
}

#' Retrieve a list of variable names
#'
#' @return character vector of known variable names
variable_names <- function(){
  c("sss", "sst", "botSalt", "botT",
    "temp.depth", "salt.depth",
    "U.velocity.depth", "V.velocity.depth",
    "velocity.depth", "dic.CMIP5")
}

#' Generate a filename for a ncdf file
#'
#' @param what character the variable name
#' @param dst character the path
#' @return file path
filename_nc <- function(what = variable_names()[1],
                          dst = here::here("data","GOM_2050")){
  base <- switch(what[1],
                 "dic.CMIP5" = "ensmn.2050.GOM.anom.nc",
                 "ROMS.2050.GOM.anom.nc")
  file.path(dst, paste(what[1], base, sep = "."))
}


#' Open by name a netcdf file for access
#'
#' @param what character, the shorthand name of the file
#' @return an opened ncdf4 object
open_nc <- function(what = variable_names()[1]){

  filename <- filename_nc(what)
  if(!file.exists(filename))
    stop(sprintf("file for %s not found: %s", what, filename))
  ncdf4::nc_open(filename)
}

#' Retrieve the location of grid cells in various forms
#'
#' @param x ncdf4 object
#' @param form character indicating desrired output as a list of matrices ("matrix"),
#'   a 2-column table ("table"), or spatial points ("sf")
#' @param crs if \code{form} is 'sf' then use this as the CRS
#' @param to_180 logical, if TRUE then transform longitude to [-180,180]
#' @return varies by value of \code{from}
nc_get_loc <- function(x,
                       form = c("matrix", "table", "sf")[1],
                       crs = "+init=epsg:4326",
                       to_180 = TRUE){

  lon <- ncdf4::ncvar_get(x, "lon")
  if (to_180) lon <- rasf::to180(lon)
  lat <- ncdf4::ncvar_get(x, "lat")
  form <- tolower(form[1])
  if (form %in% c("table", "sf")){
    r <- dplyr::tibble(
      lon = as.vector(lon),
      lat = as.vector(lat)
      )
    if (form == 'sf'){
      r <- sf::st_as_sf(r,
                        coords = c("lon", "lat"),
                        crs = crs,
                        agr = "identity")
    }
  } else {
    r <- list(lon = lon, lat = lat)
  }
  r
}

#' Given a necdf4 object, extract the time
#'
#' @param x ncdf4 object
#' @param var character the name of the time variable
#' @return POSIXct times
nc_get_time <- function(x, var = 'ocean_time'){
  stopifnot(inherits(x, 'ncdf4'))
  if (is.null(x$dim[[var[1]]])) stop("variable not found: ", var[1])
  as.POSIXct("1900-01-01 00:00:00", tz = 'UTC') +
    x$dim[[var[1]]]$vals
}


#' Retrieve variables in various forms
#'
#' @param x ncdf4 object
#' @param form character indicating desrired output as a list of matrices ("matrix"),
#'   a 2-column table ("table"), spatial points ("sf"), or spatial raster ("raster")
#' @param var character the name of the variable to retrieve
#' @param month character the name(s) of the months to retrieve.
#' @param loc spatial points, ignored if \code{form} is "matrix" or "table".  S
#'  Saves a little bit of time to pass in precomputed values.
#' @param raster_template raster used if \code{form} is 'raster'
#' @return varies by value of \code{from}
nc_get_var <- function(x,
                       var = 'ctrl',
                       month = month.abb,
                       loc = nc_get_loc(x, form = 'sf'),
                       form = c("matrix", "table", "sf", "raster")[3],
                       raster_template = NULL){

    form <- tolower(form[1])
    imonth <- match(month, month.abb)
    r <- lapply(imonth,
      function(i, nc = NULL){
        ncdf4::ncvar_get(nc, var,
                         start = c(1,1,i),
                         count = c(-1, -1, 1))
      }, nc = x)
    names(r) <- month

    if (form != 'matrix'){
      r <- dplyr::as_tibble(sapply(r, as.vector))
      if (form %in% c('sf', 'raster')){
        r <- dplyr::bind_cols(loc,r)
        if (form == 'raster'){
          if (is.null(raster_template)) raster_template <- default_template(r)
          r <- as_raster(r, varname = month, na.rm = TRUE,
                         template = raster_template)
        }
      }
    } # !matrix
  r
}


