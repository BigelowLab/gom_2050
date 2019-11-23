#' Draw points on a leaflet map
#'
#' @param x a sf POINTS table
#' @param varname character the name of the variable int he table to show by color
#' @param opacity for the points 0-1
#' @param palette_name character see \code{\link[leaflet]{colorNumeric}}
#' @return a leaflet object
leaflet_points <- function(x,
                           varname = NULL,
                           opacity = 1,
                           palette_name = 'RdYlBu'){
  stopifnot(rasf::is_sf_geometry(x, "sfc_POINT"))
  pal <- leaflet::colorNumeric(
                    rev(RColorBrewer::brewer.pal(9, palette_name)),
                    domain = x[[varname]],
                    na.color = "transparent")

  leaflet::leaflet(x %>% dplyr::select(varname)) %>%
    leaflet::addTiles() %>%
    leaflet::addCircles(stroke = FALSE,
                        radius = 6,
                        fillOpacity = opacity,
                        fillColor = ~pal(x[[varname]])) %>%
    leaflet::addLegend(pal = pal,
                       position = 'topleft',
                       values = x[[varname]],
                       opacity = opacity)

}

#' Draw a leaflet map of a mesh
#'
#' @param x sf mesh table
#' @param varname character the name of the variable to draw
#' @param opacity for the mesh
#' @param palette_name character see \code{\link[leaflet]{colorNumeric}}
#' @return a leaflet object
leaflet_mesh <- function(x,
                         varname = NULL,
                         opacity = 1,
                         palette_name = 'magma'){
  stopifnot(rasf::is_sf_geometry(x, "sfc_POLYGON"))
  pal <- leaflet::colorNumeric(palette_name,
                      domain = x[[varname]],
                      na.color = "transparent")

  leaflet::leaflet(x %>% dplyr::select(varname)) %>%
    leaflet::addTiles() %>%
    leaflet::addPolygons(stroke = FALSE,
                         fillOpacity = opacity,
                         fillColor = ~pal(x[[varname]])) %>%
    leaflet::addLegend(pal = pal,
                       position = 'topleft',
                       values = x[[varname]],
                       opacity = opacity)
}

#' Draw a leaflet map of a raster
#'
#' @param x raster object
#' @param varname character the name of the variable to draw
#' @param opacity for the raster
#' @param palette_name character see \code{\link[leaflet]{colorNumeric}}
#' @return a leaflet object
leaflet_raster <- function(x,
                           varname = 1,
                           opacity = 1,
                           palette_name = 'magma'){
  stopifnot(inherits(x, "RasterLayer"))
  pal <- leaflet::colorNumeric(palette_name,
                      domain = values(x[[varname]]),
                      na.color = "transparent")

  leaflet::leaflet() %>%
    leaflet::addTiles() %>%
    leaflet::addRasterImage(x[[varname]],
                            opacity = opacity,
                            color = pal) %>%
    leaflet::addLegend(pal = pal,
                       position = 'topleft',
                       values = values(r),
                       opacity = opacity)

}
