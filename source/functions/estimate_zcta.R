#' Create County-level ZCTA Population Estimates
#'
#'
estimate_zcta <- function(input, year, dataset, state, county, table, variable, class){

  if (dataset == "acs"){

    # download ACS data
    if (missing(table) == TRUE & missing(variable) == FALSE){
      demos <- tidycensus::get_acs(geography = "zcta", year = year, variables = variable, output = "wide")
    } else if (missing(table) == FALSE & missing(variable) == TRUE){
      demos <- tidycensus::get_acs(geography = "zcta", year = year, table = table, output = "wide")
    } else if (missing(table) == FALSE & missing(variable) == FALSE){
      demos <- tidycensus::get_acs(geography = "zcta", year = year, variables = variable, output = "wide")
      warning("The variable argument supercedes the table argument - only the specified variable has been returned.")
    }

  } else if (dataset == "decennial"){

    # download census data
    if (missing(table) == TRUE & missing(variable) == FALSE){
      demos <- tidycensus::get_decennial(geography = "zcta", year = year, variables = variable, output = "wide")
    } else if (missing(table) == FALSE & missing(variable) == TRUE){
      demos <- tidycensus::get_decennial(geography = "zcta", year = year, table = table, output = "wide")
    } else if (missing(table) == FALSE & missing(variable) == FALSE){
      demos <- tidycensus::get_decennial(geography = "zcta", year = year, variables = variable, output = "wide")
      warning("The variable argument supercedes the table argument - only the specified variable has been returned.")
    }

  }

  # subset returned demographics
  demos <- dplyr::select(demos, GEOID, dplyr::ends_with("E"))
  demos <- dplyr::select(demos, -NAME)
  demos <- dplyr::rename(demos, GEOID_ZCTA = GEOID)
  demos <- dplyr::filter(demos, GEOID_ZCTA %in% input$source$GEOID_ZCTA)

  # create list of variables to interpolate
  names <- names(demos)
  names <- names[2:length(names(demos))]

  # combine with zip geometry
  demos <- dplyr::left_join(input$source, demos, by = "GEOID_ZCTA")

  # interpolate data
  out <- areal::aw_interpolate(input$target, tid = "GEOID_ZCTA", source = demos, sid = "GEOID_ZCTA", weight = "total",
                               output = class, extensive = names)

  if (class == "sf"){
    out <- dplyr::select(out, GEOID_ZCTA, names, geometry)
  }

  # return output
  return(out)

}
