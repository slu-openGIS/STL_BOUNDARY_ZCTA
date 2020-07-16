#' Download ZCTA Geomery
#'
#'
get_zcta <- function(){

  # download
  source <- tigris::zctas(year = 2018, class = "sf")

  # re-project
  source <- sf::st_transform(source, crs = 6350)

  # subset
  source <- dplyr::select(source, GEOID10)
  source <- dplyr::rename(source, GEOID_ZCTA = GEOID10)

  return(source)

}
