
#' Retrieve a raster template that covers the provided spatial data
#'
#' @export
#' @param x spatial data
#' @param res a one or two element numeric of the cell resolution.  If one element
#'   then it is used in x and y directions.
#' @param crs character string of the mesh
#' @param ... further arguments for \code{\link[raster]{raster}}
#' @return a raster layer
default_template <- function(x,
                             res = c(0.01, 0.01),
                             crs = sf::st_crs(x)$proj4string,
                             ...){

  if (length(res) < 2) res <- c(res, res)
  d2 <- res/2
  bb <- as.vector(sf::st_bbox(x))
  raster::raster(
    res = res,
    xmn = bb[1] - d2[1],
    xmx = bb[3] + d2[1],
    ymn = bb[2] - d2[2],
    ymx = bb[4] + d2[2],
    crs = crs,
    ...)
}

#' Interpolate a raster from spatial object
#'
#' @export
#' @param x sf object
#' @param varname character one or more variable names to rasterize
#' @param template a raster template
#' @param ... further arguments for \code{\link[fasterize]{fasterize}} and
#'       \code{link{raster{rasterize}} Think of \code{fun} and \code{na.rm}
#' @return a raster layer (single varname) or raster stack (multiple varname)
as_raster <- function(x,
                      varname = NULL,
                      template = default_template(x),
                      ...){

  if (is.null(varname)) stop("varname is required")
  # convert sfc_POINT to sfc_POLYGON
  if (rasf::is_sf_geometry(x, "sfc_POINT")){
    x <- rasf::points_to_mesh(x, varname = varname) %>%
      dplyr::select(-p1,-p2,-p3)
  }

  if (any(class(x$geometry) %in% c("sfc_POLYGON", "sfc_MULTIPOLYGON"))){
    if (length(varname) == 1){
      r <- fasterize::fasterize(x, template, field = varname, ...)
    } else {
      r <- raster::stack(
        lapply(varname,
               function(v){
                 fasterize::fasterize(x, template, field = v, ...)
               }))
    }
  } else {
    if (length(varname) == 1){
      r <- raster::raster(x, template, field = varname, ...)
    } else {
      r <- raster::stack(
        lapply(varname,
               function(v){
                 raster::raster(x, template, field = v, ...)
               }))
    }
  }
  r
}
