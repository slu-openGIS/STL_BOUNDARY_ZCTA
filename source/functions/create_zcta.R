#' Create a County-level ZCTA File
#'
#'
create_zcta <- function(source, state, county){

  # re-project zips
  if (sf::st_crs(source)$input != "EPSG:6350"){
    source <- sf::st_transform(source, crs = 6350)
    warning("Provided zip data transformed to Albers. Transform prior to function call to increase efficiency.")
  }

  # download counties
  counties <- tigris::counties(state = state, year = 2018, class = "sf")
  counties <- dplyr::filter(counties, COUNTYFP %in% county)
  counties <- sf::st_transform(counties, crs = 6350)

  # geoprocess target object
  target <- sf::st_intersection(source, counties)
  target <- sf::st_collection_extract(target, "POLYGON")
  target <- dplyr::select(target, GEOID_ZCTA)
  target <- dplyr::group_by(target, GEOID_ZCTA)
  target <- dplyr::summarise(target)
  target <- sf::st_collection_extract(target, "POLYGON")

  # process source object
  source <- dplyr::filter(source, GEOID_ZCTA %in% target$GEOID_ZCTA)

  # create list
  out <- list(
    source = source,
    target = target
  )

  #return output
  return(out)

}
