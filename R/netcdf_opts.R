#' Set Options for Reading NetCDF files
#'
#' When reading NetCDF files in harp, the system needs to know some information
#' about the structure of the NetCDF files. In order to get the domain
#' information it needs to know about the projection and the location of the
#' domain and in order to read the correct data it needs to know the names and
#' order of the dimensions.
#'
#' Note that the order of the dimensions is "Fortran order" rather than "C"
#' order. This means that the order of the dimensions is obtained by reading
#' from right to left in the output of ncdump -h <filename>.
#'
#' The default options can be seen by running \code{netcdf_opts()}, but there
#' are also some options sets that can be selected, currently only those for
#' data held at MET Norway and WRF output files.
#'
#' @param options_set A set of pre-defined options that can be returned.
#'   Currently only available for data at MET Norway.
#' @param proj4_var The variable that holds the projection information in the
#'   NetCDF files. Set to 0 if the proj4 string is a global attribute.
#' @param proj4_att The attribute of \code{proj4_var} that holds the proj4
#'   string.
#' @param proj4 If the proj4 string is not available from the NetCDF files it
#'   can be set here. Set to "wrf" to get the proj4 string from WRF output
#'   files. Note that if \code{proj4 = NULL} then an attempt will be made to get
#'   the proj4 string from \code{proj4_var} and \code{proj4_att}. If proj4 has
#'   any value other than NULL, \code{proj4_var} and \code{proj4_att} will be
#'   ignored.
#' @param x_dim The name of the x dimension.
#' @param y_dim The name of the y dimension.
#' @param lon_var The name of the longitude dimension. This is needed to get the
#'   southwest and northeast corners of the domain. Set to NULL if not available
#'   and an attempt to will be made to get the corners from x_dim and y_dim and
#'   the projection information.
#' @param lat_var The name of the latitude dimension. This is needed to get the
#'   southwest and northeast corners of the domain. Set to NULL if not available
#'   and an attempt to will be made to get the corners from x_dim and y_dim and
#'   the projection information.
#' @param x_rev Set to \code{TRUE} if data in the x direction are in reverse
#'   order.
#' @param y_rev Set to \code{TRUE} if data in the y direction are in reverse
#'   order.
#' @param x_pos The position of the x dimension in multi dimensional arrays.
#' @param y_pos The position of the y dimension in multi dimensional arrays.
#' @param z_pos The position of the z (vertical) dimension in multi dimensional
#'   arrays.
#' @param time_pos The position of the time dimension in multi dimensional
#'   arrays.
#' @param member_pos The position of the ensemble member dimension in multi
#'   dimensional arrays.
#' @param z_var The name of the z (vertical) dimension.
#' @param member_var The name of the ensemble member dimension.
#' @param time_var The name of the time dimension.
#' @param ref_time_var The name of the variable holding the forecast reference
#'   time. Set to NA if it is to be derived from the first value in the time
#'   dimension.
#'
#' @return A list of options for reading netcdf files.
#' @export
#'
#' @examples
#' netcdf_opts()
#' netcdf_opts(options_set = "met_norway_eps")
#' netcdf_opts(options_set = "met_norway_ifsens")
#' netcdf_opts(
#'   member_pos = 3,
#'   z_pos      = 4,
#'   time_pos   = 5,
#'   member_var = "ensemble_member",
#'   z_var      = "pressure"
#' )
netcdf_opts <- function(
  options_set  = c(
    "none",
    "met_norway_eps",
    "met_norway_det",
    "met_norway_ifsens",
    "met_norway_ifshires",
    "wrf",
    "wrf_u_stagger",
    "wrf_v_stagger"
  ),
  proj4_var    = "projection_lambert",
  proj4_att    = "proj4",
  proj4        = NULL,
  x_dim        = "x",
  y_dim        = "y",
  lon_var      = "longitude",
  lat_var      = "latitude",
  x_rev        = FALSE,
  y_rev        = FALSE,
  x_pos        = 1,
  y_pos        = 2,
  z_pos        = NA,
  time_pos     = 3,
  member_pos   = NA,
  z_var        = NA,
  member_var   = NA,
  time_var     = "time",
  ref_time_var = NA
)  {

  options_set <- match.arg(options_set)

  switch(
    options_set,
    "met_norway_eps" = {
      member_pos   <- 3
      z_pos        <- 4
      time_pos     <- 5
      z_var        <- "height1"
      member_var   <- "ensemble_member"
      ref_time_var <- "forecast_reference_time"
    },
    "met_norway_det" = {
      z_var        <- "height1"
      z_pos        <- 3
      time_pos     <- 4
      ref_time_var <- "forecast_reference_time"
    },
    "met_norway_ifsens" = {
      proj4_var    <- "projection_regular_ll"
      x_dim        <- "longitude"
      y_dim        <- "latitude"
      y_rev        <- TRUE
      member_pos   <- 3
      z_pos        <- 4
      time_pos     <- 5
      z_var        <- "surface"
      member_var   <- "ensemble_member"
      ref_time_var <- "forecast_reference_time"
    },
    "met_norway_ifshires" = {
      proj4_var    <- "projection_regular_ll"
      x_dim        <- "longitude"
      y_dim        <- "latitude"
      y_rev        <- TRUE
      z_pos        <- 3
      time_pos     <- 4
      z_var        <- "surface"
      ref_time_var <- "forecast_reference_time"
    },
    "wrf" = {
      proj4    <- "wrf"
      x_dim    <- "west_east"
      y_dim    <- "south_north"
      lon_var  <- "XLONG"
      lat_var  <- "XLAT"
      time_var <- "Times"
    },
    "wrf_u_stagger" = {
      proj4    <- "wrf"
      x_dim    <- "west_east_stag"
      y_dim    <- "south_north"
      lon_var  <- "XLONG_U"
      lat_var  <- "XLAT_U"
      time_var <- "Times"
    },
    "wrf_v_stagger" = {
      proj4    <- "wrf"
      x_dim    <- "west_east"
      y_dim    <- "south_north_stag"
      lon_var  <- "XLONG_V"
      lat_var  <- "XLAT_V"
      time_var <- "Times"
    }

  )

  all_pos <- sort(stats::na.omit(c(
    x_pos      = x_pos,
    y_pos      = y_pos,
    z_pos      = z_pos,
    time_pos   = time_pos,
    member_pos = member_pos
  )))

  if (!all(diff(all_pos) == 1) | min(all_pos) != 1) {
    print(all_pos)
    stop("Positions must be unique integers between 1 and the number of positions.", call. = FALSE)
  }

  list(
    options_set  = options_set,
    proj4_var    = proj4_var,
    proj4_att    = proj4_att,
    proj4        = proj4,
    x_dim        = x_dim,
    y_dim        = y_dim,
    lon_var      = lon_var,
    lat_var      = lat_var,
    x_rev        = x_rev,
    y_rev        = y_rev,
    x_pos        = x_pos,
    y_pos        = y_pos,
    z_pos        = z_pos,
    time_pos     = time_pos,
    member_pos   = member_pos,
    z_var        = z_var,
    member_var   = member_var,
    time_var     = time_var,
    ref_time_var = ref_time_var
  )
}
