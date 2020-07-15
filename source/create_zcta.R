#' Create a County-level ZCTA File
#'
#'
create_zcta <- function(state, county){

  # download zips
  zip <- tigris::zctas(year = 2018, class = "sf")

  #return output
  return(zip)

}
