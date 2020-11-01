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

  # pull out duplicate geometries
  # only applies to Lincoln and Warren Counties
  if (length(county) == 1){

      ## pull out duplicated zips
      if (county == "113"){

        partial_a1 <- dplyr::filter(input$target, GEOID_ZCTA == "63383")
        partial_a1 <- dplyr::filter(partial_a1, row_number() == 1)

        partial_a2 <- dplyr::filter(input$target, GEOID_ZCTA == "63383")
        partial_a2 <- dplyr::filter(partial_a2, row_number() == 2)

        input$target <- dplyr::filter(input$target, GEOID_ZCTA %in% "63383" == FALSE)
        input$target <- rbind(input$target, partial_a1)

      } else if (county == "219"){

        partial_a1 <- dplyr::filter(input$target, GEOID_ZCTA == "63348")
        partial_a1 <- dplyr::filter(partial_a1, row_number() == 1)

        partial_a2 <- dplyr::filter(input$target, GEOID_ZCTA == "63348")
        partial_a2 <- dplyr::filter(partial_a2, row_number() == 2)

        partial_b1 <- dplyr::filter(input$target, GEOID_ZCTA == "63351")
        partial_b1 <- dplyr::filter(partial_b1, row_number() == 1)

        partial_b2 <- dplyr::filter(input$target, GEOID_ZCTA == "63351")
        partial_b2 <- dplyr::filter(partial_b2, row_number() == 2)

        input$target <- dplyr::filter(input$target, GEOID_ZCTA %in% c("63348", "63351") == FALSE)
        input$target <- rbind(input$target, partial_a1, partial_b1)

      } else if (county == "071"){

        partial_a1 <- dplyr::filter(input$target, GEOID_ZCTA == "63091")
        partial_a1 <- dplyr::filter(partial_a1, row_number() == 1)

        partial_a2 <- dplyr::filter(input$target, GEOID_ZCTA == "63091")
        partial_a2 <- dplyr::filter(partial_a2, row_number() == 2)

        input$target <- dplyr::filter(input$target, GEOID_ZCTA %in% "63091" == FALSE)
        input$target <- rbind(input$target, partial_a1)

      }

  } else if (length(county) > 1 & any(focal_counties == "219")){

    partial_a1 <- dplyr::filter(input$target, GEOID_ZCTA == "63351")
    partial_a1 <- dplyr::filter(partial_a1, row_number() == 1)

    partial_a2 <- dplyr::filter(input$target, GEOID_ZCTA == "63351")
    partial_a2 <- dplyr::filter(partial_a2, row_number() == 2)

    input$target <- dplyr::filter(input$target, GEOID_ZCTA %in% "63351" == FALSE)
    input$target <- rbind(input$target, partial_a1)

  }


  # interpolate data
  out <- areal::aw_interpolate(input$target, tid = "GEOID_ZCTA", source = demos, sid = "GEOID_ZCTA", weight = "total",
                               output = class, extensive = names)

  if (length(county) == 1){
    if (county == "113"){

      partial_a2_result <- areal::aw_interpolate(partial_a2, tid = "GEOID_ZCTA", source = demos, sid = "GEOID_ZCTA", weight = "total",
                                                 output = class, extensive = names)

      out <- rbind(out, partial_a2_result)

    } else if (county == "219"){

      partial_a2_result <- areal::aw_interpolate(partial_a2, tid = "GEOID_ZCTA", source = demos, sid = "GEOID_ZCTA", weight = "total",
                                                 output = class, extensive = names)

      partial_b2_result <- areal::aw_interpolate(partial_b2, tid = "GEOID_ZCTA", source = demos, sid = "GEOID_ZCTA", weight = "total",
                                                 output = class, extensive = names)

      out <- rbind(out, partial_a2_result, partial_b2_result)

    } else if (county == "113"){

      partial_a2_result <- areal::aw_interpolate(partial_a2, tid = "GEOID_ZCTA", source = demos, sid = "GEOID_ZCTA", weight = "total",
                                                 output = class, extensive = names)

      out <- rbind(out, partial_a2_result)

    }
  } else if (length(county) > 1 & any(focal_counties == "219")){

    partial_a2_result <- areal::aw_interpolate(partial_a2, tid = "GEOID_ZCTA", source = demos, sid = "GEOID_ZCTA", weight = "total",
                                               output = class, extensive = names)

    out <- rbind(out, partial_a2_result)

  }

  if (class == "sf"){
    out <- dplyr::select(out, GEOID_ZCTA, names, geometry)
  }

  # return output
  return(out)

}
