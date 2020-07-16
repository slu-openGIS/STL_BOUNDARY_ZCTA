
# load functions
source("source/functions/get_zcta.R")
source("source/functions/create_zcta.R")

zips <- get_zcta()

stl_city <- create_zcta(source = zips, state = 29, county = 510)

stl_city <- estimate_zcta(input = stl_city, year = 2018, dataset = "acs", state = 29, county = 510, table = "B02001")
