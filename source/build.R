# overview ####
# this creates the geometry and demographics for the full four county area covering:
# St. Louis City, St. Louis County, St. Charles County, and Jefferson County
# it also produces estimates and geometries for the individual counties and the combined
# City and County area.

# === # === # === # === # === # === # === # === # === # === # === # === # === #

# dependencies ####

## packages
library(dplyr)
library(readr)
library(sf)
library(tigris)
library(tidycensus)

## functions
source("source/functions/get_zcta.R")
source("source/functions/create_zcta.R")
source("source/functions/estimate_zcta.R")

# download source data ####
## download
zips <- get_zcta()

## clean-up
rm(get_zcta)

# === # === # === # === # === # === # === # === # === # === # === # === # === #

# build regional data ####
## define counties
focal_counties <- c("099", "183", "189", "510")

## create ZCTA geometry
### create
geometry <- create_zcta(source = zips, state = 29, county = focal_counties)

### write geometric data
geometry$target %>%
  st_transform(crs = 4326) %>%
  st_write("data/geometries/STL_ZCTA_Regional.geojson", delete_dsn = TRUE)

## create total population estimates
### create
total_pop <- estimate_zcta(input = geometry, year = 2018, dataset = "acs", state = 29, county = focal_counties,
                      variable = "B01003_001", class = "tibble")

### calculate percentages
total_pop %>%
  mutate(total_pop = round(B01003_001E)) %>%
  select(GEOID_ZCTA, total_pop) -> total_pop

### write data
write_csv(total_pop, "data/demographics/STL_ZCTA_Regional_Total_Pop.csv")

### clean-up
rm(total_pop)

## create population race estimates
### create
race <- estimate_zcta(input = geometry, year = 2018, dataset = "acs", state = 29, county = focal_counties,
                              variable = c("B02001_001", "B02001_002", "B02001_003"), class = "tibble")

### calculate percentages
race %>%
  mutate(wht_pct = B02001_002E/B02001_001E*100) %>%
  mutate(blk_pct = B02001_003E/B02001_001E*100) %>%
  select(GEOID_ZCTA, wht_pct, blk_pct) -> race

### write data
write_csv(race, "data/demographics/STL_ZCTA_Regional_Race.csv")

### clean-up
rm(race)

## create population poverty estimates
### create
poverty <- estimate_zcta(input = geometry, year = 2018, dataset = "acs", state = 29, county = focal_counties,
                              variable = c("B17001_001", "B17001_002"), class = "tibble")

### calculate percentages
poverty %>%
  mutate(pvty_pct = B17001_002E/B17001_001E*100) %>%
  select(GEOID_ZCTA, pvty_pct) -> poverty

### write data
write_csv(poverty, "data/demographics/STL_ZCTA_Regional_Poverty.csv")

### clean-up
rm(poverty)

## clean-up
rm(geometry, focal_counties)

# === # === # === # === # === # === # === # === # === # === # === # === # === #

# build city+county data ####
## define counties
focal_counties <- c("189", "510")

## create ZCTA geometry
### create
geometry <- create_zcta(source = zips, state = 29, county = focal_counties)

### write geometric data
geometry$target %>%
  st_transform(crs = 4326) %>%
  st_write("data/geometries/STL_ZCTA_City_County.geojson", delete_dsn = TRUE)

## create total population estimates
### create
total_pop <- estimate_zcta(input = geometry, year = 2018, dataset = "acs", state = 29, county = focal_counties,
                           variable = "B01003_001", class = "tibble")

### calculate percentages
total_pop %>%
  mutate(total_pop = round(B01003_001E)) %>%
  select(GEOID_ZCTA, total_pop) -> total_pop

### write data
write_csv(total_pop, "data/demographics/STL_ZCTA_City_County_Total_Pop.csv")

### clean-up
rm(total_pop)

## create population race estimates
### create
race <- estimate_zcta(input = geometry, year = 2018, dataset = "acs", state = 29, county = focal_counties,
                      variable = c("B02001_001", "B02001_002", "B02001_003"), class = "tibble")

### calculate percentages
race %>%
  mutate(wht_pct = B02001_002E/B02001_001E*100) %>%
  mutate(blk_pct = B02001_003E/B02001_001E*100) %>%
  select(GEOID_ZCTA, wht_pct, blk_pct) -> race

### write data
write_csv(race, "data/demographics/STL_ZCTA_City_County_Race.csv")

### clean-up
rm(race)

## create population poverty estimates
### create
poverty <- estimate_zcta(input = geometry, year = 2018, dataset = "acs", state = 29, county = focal_counties,
                         variable = c("B17001_001", "B17001_002"), class = "tibble")

### calculate percentages
poverty %>%
  mutate(pvty_pct = B17001_002E/B17001_001E*100) %>%
  select(GEOID_ZCTA, pvty_pct) -> poverty

### write data
write_csv(poverty, "data/demographics/STL_ZCTA_City_County_Poverty.csv")

### clean-up
rm(poverty)

## clean-up
rm(geometry, focal_counties)

# === # === # === # === # === # === # === # === # === # === # === # === # === #

# build Jefferson County data ####
## define counties
focal_counties <- "099"

## create ZCTA geometry
### create
geometry <- create_zcta(source = zips, state = 29, county = focal_counties)

### write geometric data
geometry$target %>%
  st_transform(crs = 4326) %>%
  st_write("data/geometries/STL_ZCTA_Jefferson_County.geojson", delete_dsn = TRUE)

## create total population estimates
### create
total_pop <- estimate_zcta(input = geometry, year = 2018, dataset = "acs", state = 29, county = focal_counties,
                           variable = "B01003_001", class = "tibble")

### calculate percentages
total_pop %>%
  mutate(total_pop = round(B01003_001E)) %>%
  select(GEOID_ZCTA, total_pop) -> total_pop

### write data
write_csv(total_pop, "data/demographics/STL_ZCTA_Jefferson_County_Total_Pop.csv")

### clean-up
rm(total_pop)

## create population race estimates
### create
race <- estimate_zcta(input = geometry, year = 2018, dataset = "acs", state = 29, county = focal_counties,
                      variable = c("B02001_001", "B02001_002", "B02001_003"), class = "tibble")

### calculate percentages
race %>%
  mutate(wht_pct = B02001_002E/B02001_001E*100) %>%
  mutate(blk_pct = B02001_003E/B02001_001E*100) %>%
  select(GEOID_ZCTA, wht_pct, blk_pct) -> race

### write data
write_csv(race, "data/demographics/STL_ZCTA_Jefferson_County_Race.csv")

### clean-up
rm(race)

## create population poverty estimates
### create
poverty <- estimate_zcta(input = geometry, year = 2018, dataset = "acs", state = 29, county = focal_counties,
                         variable = c("B17001_001", "B17001_002"), class = "tibble")

### calculate percentages
poverty %>%
  mutate(pvty_pct = B17001_002E/B17001_001E*100) %>%
  select(GEOID_ZCTA, pvty_pct) -> poverty

### write data
write_csv(poverty, "data/demographics/STL_ZCTA_Jefferson_County_Poverty.csv")

### clean-up
rm(poverty)

## clean-up
rm(geometry, focal_counties)

# === # === # === # === # === # === # === # === # === # === # === # === # === #

# build St. Charles County data ####
## define counties
focal_counties <- "183"

## create ZCTA geometry
### create
geometry <- create_zcta(source = zips, state = 29, county = focal_counties)

### write geometric data
geometry$target %>%
  st_transform(crs = 4326) %>%
  st_write("data/geometries/STL_ZCTA_St_Charles_County.geojson", delete_dsn = TRUE)

## create total population estimates
### create
total_pop <- estimate_zcta(input = geometry, year = 2018, dataset = "acs", state = 29, county = focal_counties,
                           variable = "B01003_001", class = "tibble")

### calculate percentages
total_pop %>%
  mutate(total_pop = round(B01003_001E)) %>%
  select(GEOID_ZCTA, total_pop) -> total_pop

### write data
write_csv(total_pop, "data/demographics/STL_ZCTA_St_Charles_County_Total_Pop.csv")

### clean-up
rm(total_pop)

## create population race estimates
### create
race <- estimate_zcta(input = geometry, year = 2018, dataset = "acs", state = 29, county = focal_counties,
                      variable = c("B02001_001", "B02001_002", "B02001_003"), class = "tibble")

### calculate percentages
race %>%
  mutate(wht_pct = B02001_002E/B02001_001E*100) %>%
  mutate(blk_pct = B02001_003E/B02001_001E*100) %>%
  select(GEOID_ZCTA, wht_pct, blk_pct) -> race

### write data
write_csv(race, "data/demographics/STL_ZCTA_St_Charles_County_Race.csv")

### clean-up
rm(race)

## create population poverty estimates
### create
poverty <- estimate_zcta(input = geometry, year = 2018, dataset = "acs", state = 29, county = focal_counties,
                         variable = c("B17001_001", "B17001_002"), class = "tibble")

### calculate percentages
poverty %>%
  mutate(pvty_pct = B17001_002E/B17001_001E*100) %>%
  select(GEOID_ZCTA, pvty_pct) -> poverty

### write data
write_csv(poverty, "data/demographics/STL_ZCTA_St_Charles_County_Poverty.csv")

### clean-up
rm(poverty)

## clean-up
rm(geometry, focal_counties)

# === # === # === # === # === # === # === # === # === # === # === # === # === #

# build St. Louis County data ####
## define counties
focal_counties <- "189"

## create ZCTA geometry
### create
geometry <- create_zcta(source = zips, state = 29, county = focal_counties)

### write geometric data
geometry$target %>%
  st_transform(crs = 4326) %>%
  st_write("data/geometries/STL_ZCTA_St_Louis_County.geojson", delete_dsn = TRUE)

## create total population estimates
### create
total_pop <- estimate_zcta(input = geometry, year = 2018, dataset = "acs", state = 29, county = focal_counties,
                           variable = "B01003_001", class = "tibble")

### calculate percentages
total_pop %>%
  mutate(total_pop = round(B01003_001E)) %>%
  select(GEOID_ZCTA, total_pop) -> total_pop

### write data
write_csv(total_pop, "data/demographics/STL_ZCTA_St_Louis_County_Total_Pop.csv")

### clean-up
rm(total_pop)

## create population race estimates
### create
race <- estimate_zcta(input = geometry, year = 2018, dataset = "acs", state = 29, county = focal_counties,
                      variable = c("B02001_001", "B02001_002", "B02001_003"), class = "tibble")

### calculate percentages
race %>%
  mutate(wht_pct = B02001_002E/B02001_001E*100) %>%
  mutate(blk_pct = B02001_003E/B02001_001E*100) %>%
  select(GEOID_ZCTA, wht_pct, blk_pct) -> race

### write data
write_csv(race, "data/demographics/STL_ZCTA_St_Louis_County_Race.csv")

### clean-up
rm(race)

## create population poverty estimates
### create
poverty <- estimate_zcta(input = geometry, year = 2018, dataset = "acs", state = 29, county = focal_counties,
                         variable = c("B17001_001", "B17001_002"), class = "tibble")

### calculate percentages
poverty %>%
  mutate(pvty_pct = B17001_002E/B17001_001E*100) %>%
  select(GEOID_ZCTA, pvty_pct) -> poverty

### write data
write_csv(poverty, "data/demographics/STL_ZCTA_St_Louis_County_Poverty.csv")

### clean-up
rm(poverty)

## clean-up
rm(geometry, focal_counties)

# === # === # === # === # === # === # === # === # === # === # === # === # === #

# build St. Louis County data ####
## define counties
focal_counties <- "510"

## create ZCTA geometry
### create
geometry <- create_zcta(source = zips, state = 29, county = focal_counties)

### write geometric data
geometry$target %>%
  st_transform(crs = 4326) %>%
  st_write("data/geometries/STL_ZCTA_St_Louis_City.geojson", delete_dsn = TRUE)

## create total population estimates
### create
total_pop <- estimate_zcta(input = geometry, year = 2018, dataset = "acs", state = 29, county = focal_counties,
                           variable = "B01003_001", class = "tibble")

### calculate percentages
total_pop %>%
  mutate(total_pop = round(B01003_001E)) %>%
  select(GEOID_ZCTA, total_pop) -> total_pop

### write data
write_csv(total_pop, "data/demographics/STL_ZCTA_St_Louis_City_Total_Pop.csv")

### clean-up
rm(total_pop)

## create population race estimates
### create
race <- estimate_zcta(input = geometry, year = 2018, dataset = "acs", state = 29, county = focal_counties,
                      variable = c("B02001_001", "B02001_002", "B02001_003"), class = "tibble")

### calculate percentages
race %>%
  mutate(wht_pct = B02001_002E/B02001_001E*100) %>%
  mutate(blk_pct = B02001_003E/B02001_001E*100) %>%
  select(GEOID_ZCTA, wht_pct, blk_pct) -> race

### write data
write_csv(race, "data/demographics/STL_ZCTA_St_Louis_City_Race.csv")

### clean-up
rm(race)

## create population poverty estimates
### create
poverty <- estimate_zcta(input = geometry, year = 2018, dataset = "acs", state = 29, county = focal_counties,
                         variable = c("B17001_001", "B17001_002"), class = "tibble")

### calculate percentages
poverty %>%
  mutate(pvty_pct = B17001_002E/B17001_001E*100) %>%
  select(GEOID_ZCTA, pvty_pct) -> poverty

### write data
write_csv(poverty, "data/demographics/STL_ZCTA_St_Louis_City_Poverty.csv")

### clean-up
rm(poverty)

## clean-up
rm(geometry, focal_counties)

# === # === # === # === # === # === # === # === # === # === # === # === # === #

# build Warren County data ####
## define counties
focal_counties <- "219"

## create ZCTA geometry
### create
geometry <- create_zcta(source = zips, state = 29, county = focal_counties)

### write geometric data
geometry$target %>%
  st_transform(crs = 4326) %>%
  st_write("data/geometries/STL_ZCTA_Warren_County.geojson", delete_dsn = TRUE)

## create total population estimates
### create
total_pop <- estimate_zcta(input = geometry, year = 2018, dataset = "acs", state = 29, county = focal_counties,
                           variable = "B01003_001", class = "tibble")

### calculate percentages
total_pop %>%
  mutate(total_pop = round(B01003_001E)) %>%
  select(GEOID_ZCTA, total_pop) -> total_pop

### write data
write_csv(total_pop, "data/demographics/STL_ZCTA_Warren_County_Total_Pop.csv")

### clean-up
rm(total_pop)

## create population race estimates
### create
race <- estimate_zcta(input = geometry, year = 2018, dataset = "acs", state = 29, county = focal_counties,
                      variable = c("B02001_001", "B02001_002", "B02001_003"), class = "tibble")

### calculate percentages
race %>%
  mutate(wht_pct = B02001_002E/B02001_001E*100) %>%
  mutate(blk_pct = B02001_003E/B02001_001E*100) %>%
  select(GEOID_ZCTA, wht_pct, blk_pct) -> race

### write data
write_csv(race, "data/demographics/STL_ZCTA_Warren_County_Race.csv")

### clean-up
rm(race)

## create population poverty estimates
### create
poverty <- estimate_zcta(input = geometry, year = 2018, dataset = "acs", state = 29, county = focal_counties,
                         variable = c("B17001_001", "B17001_002"), class = "tibble")

### calculate percentages
poverty %>%
  mutate(pvty_pct = B17001_002E/B17001_001E*100) %>%
  select(GEOID_ZCTA, pvty_pct) -> poverty

### write data
write_csv(poverty, "data/demographics/STL_ZCTA_Warren_County_Poverty.csv")

### clean-up
rm(poverty)

## clean-up
rm(geometry, focal_counties)

# === # === # === # === # === # === # === # === # === # === # === # === # === #

# build Franklin County data ####
## define counties
focal_counties <- "071"

## create ZCTA geometry
### create
geometry <- create_zcta(source = zips, state = 29, county = focal_counties)

### write geometric data
geometry$target %>%
  st_transform(crs = 4326) %>%
  st_write("data/geometries/STL_ZCTA_Franklin_County.geojson", delete_dsn = TRUE)

## create total population estimates
### create
total_pop <- estimate_zcta(input = geometry, year = 2018, dataset = "acs", state = 29, county = focal_counties,
                           variable = "B01003_001", class = "tibble")

### calculate percentages
total_pop %>%
  mutate(total_pop = round(B01003_001E)) %>%
  select(GEOID_ZCTA, total_pop) -> total_pop

### write data
write_csv(total_pop, "data/demographics/STL_ZCTA_Franklin_County_Total_Pop.csv")

### clean-up
rm(total_pop)

## create population race estimates
### create
race <- estimate_zcta(input = geometry, year = 2018, dataset = "acs", state = 29, county = focal_counties,
                      variable = c("B02001_001", "B02001_002", "B02001_003"), class = "tibble")

### calculate percentages
race %>%
  mutate(wht_pct = B02001_002E/B02001_001E*100) %>%
  mutate(blk_pct = B02001_003E/B02001_001E*100) %>%
  select(GEOID_ZCTA, wht_pct, blk_pct) -> race

### write data
write_csv(race, "data/demographics/STL_ZCTA_Franklin_County_Race.csv")

### clean-up
rm(race)

## create population poverty estimates
### create
poverty <- estimate_zcta(input = geometry, year = 2018, dataset = "acs", state = 29, county = focal_counties,
                         variable = c("B17001_001", "B17001_002"), class = "tibble")

### calculate percentages
poverty %>%
  mutate(pvty_pct = B17001_002E/B17001_001E*100) %>%
  select(GEOID_ZCTA, pvty_pct) -> poverty

### write data
write_csv(poverty, "data/demographics/STL_ZCTA_Franklin_County_Poverty.csv")

### clean-up
rm(poverty)

## clean-up
rm(geometry, focal_counties)

# === # === # === # === # === # === # === # === # === # === # === # === # === #

# build Lincoln County data ####
## define counties
focal_counties <- "113"

## create ZCTA geometry
### create
geometry <- create_zcta(source = zips, state = 29, county = focal_counties)

### write geometric data
geometry$target %>%
  st_transform(crs = 4326) %>%
  st_write("data/geometries/STL_ZCTA_Lincoln_County.geojson", delete_dsn = TRUE)

## create total population estimates
### create
total_pop <- estimate_zcta(input = geometry, year = 2018, dataset = "acs", state = 29, county = focal_counties,
                           variable = "B01003_001", class = "tibble")

### calculate percentages
total_pop %>%
  mutate(total_pop = round(B01003_001E)) %>%
  select(GEOID_ZCTA, total_pop) -> total_pop

### write data
write_csv(total_pop, "data/demographics/STL_ZCTA_Lincoln_County_Total_Pop.csv")

### clean-up
rm(total_pop)

## create population race estimates
### create
race <- estimate_zcta(input = geometry, year = 2018, dataset = "acs", state = 29, county = focal_counties,
                      variable = c("B02001_001", "B02001_002", "B02001_003"), class = "tibble")

### calculate percentages
race %>%
  mutate(wht_pct = B02001_002E/B02001_001E*100) %>%
  mutate(blk_pct = B02001_003E/B02001_001E*100) %>%
  select(GEOID_ZCTA, wht_pct, blk_pct) -> race

### write data
write_csv(race, "data/demographics/STL_ZCTA_Lincoln_County_Race.csv")

### clean-up
rm(race)

## create population poverty estimates
### create
poverty <- estimate_zcta(input = geometry, year = 2018, dataset = "acs", state = 29, county = focal_counties,
                         variable = c("B17001_001", "B17001_002"), class = "tibble")

### calculate percentages
poverty %>%
  mutate(pvty_pct = B17001_002E/B17001_001E*100) %>%
  select(GEOID_ZCTA, pvty_pct) -> poverty

### write data
write_csv(poverty, "data/demographics/STL_ZCTA_Lincoln_County_Poverty.csv")

### clean-up
rm(poverty)

## clean-up
rm(geometry, focal_counties)

# === # === # === # === # === # === # === # === # === # === # === # === # === #

# create illinois data

## create state of illinois boundary
il <- states(class = "sf") %>%
  filter(GEOID == "17") %>%
  select(GEOID) %>%
  st_transform(crs = 6350)

## combine with ZCTA boundaries
il_zips <- st_intersection(zips, il) %>%
  select(GEOID_ZCTA) %>%
  st_collection_extract(type = "POLYGON")

## create metro east boundary
metro_east <- st_read("data/source/daily_snapshot_mo_xl.geojson", crs = 4326, stringsAsFactors = FALSE) %>%
  filter(state == "Illinois" & GEOID != "17003") %>%
  select(state) %>%
  group_by(state) %>%
  summarise() %>%
  # st_collection_extract(type = "POLYGON") %>%
  st_transform(crs = 6350) %>%
  mutate(region = "Metro East") %>%
  select(region)

## intersect IL ZCTAs with metro east boundary to create list of ZIPs to include
intersect_zips <- st_intersection(il_zips, metro_east) %>%
  st_collection_extract(type = "POLYGON")

## create metro east zip geometry,
metro_east_zips <- filter(il_zips, GEOID_ZCTA %in% c(intersect_zips$GEOID_ZCTA, "62092", "62016", "62098"))

## clean-up
rm(il, metro_east, intersect_zips)

## write geometric data
metro_east_zips %>%
  st_transform(crs = 4326) %>%
  st_write("data/geometries/STL_ZCTA_Metro_East.geojson", delete_dsn = TRUE)

## total population
total_pop <- get_acs(geography = "zcta", year = 2018, dataset = "acs",
                variable = "B01003_001", output = "wide") %>%
  filter(GEOID %in% metro_east_zips$GEOID_ZCTA)

### calculate percentages
total_pop %>%
  mutate(total_pop = round(B01003_001E)) %>%
  rename(GEOID_ZCTA = GEOID) %>%
  select(GEOID_ZCTA, total_pop) -> total_pop

### write data
write_csv(total_pop, "data/demographics/STL_ZCTA_Metro_East_Total_Pop.csv")

### clean-up
rm(total_pop)

## race
race <- get_acs(geography = "zcta", year = 2018, dataset = "acs",
                   variable = c("B02001_001", "B02001_002", "B02001_003"), output = "wide") %>%
  filter(GEOID %in% metro_east_zips$GEOID_ZCTA)

### calculate percentages
race %>%
  mutate(wht_pct = B02001_002E/B02001_001E*100) %>%
  mutate(blk_pct = B02001_003E/B02001_001E*100) %>%
  rename(GEOID_ZCTA = GEOID) %>%
  select(GEOID_ZCTA, wht_pct, blk_pct) -> race

### write data
write_csv(race, "data/demographics/STL_ZCTA_Metro_East_Race.csv")

### clean-up
rm(race)

## poverty
poverty <- get_acs(geography = "zcta", year = 2018, dataset = "acs",
                 variable = c("B17001_001", "B17001_002"), output = "wide") %>%
  filter(GEOID %in% metro_east_zips$GEOID_ZCTA)

### calculate percentages
poverty %>%
  mutate(pvty_pct = B17001_002E/B17001_001E*100) %>%
  rename(GEOID_ZCTA = GEOID) %>%
  select(GEOID_ZCTA, pvty_pct) -> poverty

### write data
write_csv(poverty, "data/demographics/STL_ZCTA_Metro_East_Poverty.csv")

### clean-up
rm(poverty)

# === # === # === # === # === # === # === # === # === # === # === # === # === #

# build regional data ####
## define counties
focal_counties <- c("071", "099", "113", "183", "189", "219", "510")

## create ZCTA geometry
### create
geometry <- create_zcta(source = zips, state = 29, county = focal_counties)

### write geometric data
geometry$target %>%
  st_transform(crs = 4326) %>%
  st_write("data/geometries/STL_ZCTA_Metro_West.geojson", delete_dsn = TRUE)

## create total population estimates
### create
total_pop <- estimate_zcta(input = geometry, year = 2018, dataset = "acs", state = 29, county = focal_counties,
                           variable = "B01003_001", class = "tibble")

### calculate percentages
total_pop %>%
  mutate(total_pop = round(B01003_001E)) %>%
  select(GEOID_ZCTA, total_pop) -> total_pop

### write data
write_csv(total_pop, "data/demographics/STL_ZCTA_Metro_West_Total_Pop.csv")

### clean-up
rm(total_pop)

## create population race estimates
### create
race <- estimate_zcta(input = geometry, year = 2018, dataset = "acs", state = 29, county = focal_counties,
                      variable = c("B02001_001", "B02001_002", "B02001_003"), class = "tibble")

### calculate percentages
race %>%
  mutate(wht_pct = B02001_002E/B02001_001E*100) %>%
  mutate(blk_pct = B02001_003E/B02001_001E*100) %>%
  select(GEOID_ZCTA, wht_pct, blk_pct) -> race

### write data
write_csv(race, "data/demographics/STL_ZCTA_Metro_West_Race.csv")

### clean-up
rm(race)

## create population poverty estimates
### create
poverty <- estimate_zcta(input = geometry, year = 2018, dataset = "acs", state = 29, county = focal_counties,
                         variable = c("B17001_001", "B17001_002"), class = "tibble")

### calculate percentages
poverty %>%
  mutate(pvty_pct = B17001_002E/B17001_001E*100) %>%
  select(GEOID_ZCTA, pvty_pct) -> poverty

### write data
write_csv(poverty, "data/demographics/STL_ZCTA_Metro_West_Poverty.csv")

### clean-up
rm(poverty)

## clean-up
rm(geometry, focal_counties)

# === # === # === # === # === # === # === # === # === # === # === # === # === #

# final clean-up ####
rm(zips, create_zcta, estimate_zcta)
