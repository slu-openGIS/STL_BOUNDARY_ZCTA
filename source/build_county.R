# add additional measures for St. Louis County ####

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

# build St. Louis County data ####
## define counties
focal_counties <- "189"

## create ZCTA geometry
### create
geometry <- create_zcta(source = zips, state = 29, county = focal_counties)

## create total population estimates
### create
total_pop <- estimate_zcta(input = geometry, year = 2019, dataset = "acs", state = 29, county = focal_counties,
                           variable = "B01003_001", class = "tibble")

### calculate percentages
total_pop %>%
  mutate(total_pop = round(B01003_001E)) %>%
  select(GEOID_ZCTA, total_pop) -> total_pop

## create population race estimates
### create
race <- estimate_zcta(input = geometry, year = 2019, dataset = "acs", state = 29, county = focal_counties,
                      variable = c("B02001_001", "B02001_002", "B02001_003", "B02001_004",
                                   "B02001_005", "B02001_006", "B02001_007", "B02001_008",
                                   "B03003_001", "B03003_003"), class = "tibble")

### calculate percentages
race %>%
  mutate(
    race_total = round(B02001_001E),
    race_white = round(B02001_002E),
    race_black = round(B02001_003E),
    race_native = round(B02001_004E),
    race_asian = round(B02001_005E),
    race_islander = round(B02001_006E),
    race_other = round(B02001_007E),
    race_multi = round(B02001_008E),
    ethnic_total = round(B03003_001E),
    ethnic_latino = round(B03003_003E)
  ) %>%
  mutate(blk_pct = B02001_003E/B02001_001E*100) %>%
  select(GEOID_ZCTA, race_total, race_white, race_black, race_native,
         race_asian, race_islander, race_other, race_multi,
         ethnic_total, ethnic_latino) -> race

## create age estimates
### create
age <- estimate_zcta(input = geometry, year = 2019, dataset = "acs", state = 29, county = focal_counties,
                         variable = c("DP05_0005E", "DP05_0006E", "DP05_0007E", "DP05_0008E",
                                      "DP05_0009E", "DP05_0010E", "DP05_0011E", "DP05_0012E",
                                      "DP05_0013E", "DP05_0014E", "DP05_0015E", "DP05_0016E",
                                      "DP05_0017E"), class = "tibble")

### calculate percentages
age %>%
  mutate(
    age_u5 = round(DP05_0005E),
    age_5_9 = round(DP05_0006E),
    age_10_14 = round(DP05_0007E),
    age_15_19 = round(DP05_0008E),
    age_20_24 = round(DP05_0009E),
    age_25_34 = round(DP05_0010E),
    age_35_44 = round(DP05_0011E),
    age_45_54 = round(DP05_0012E),
    age_55_59 = round(DP05_0013E),
    age_60_64 = round(DP05_0014E),
    age_65_74 = round(DP05_0015E),
    age_75_84 = round(DP05_0016E),
    age_gt85 = round(DP05_0017E)
  ) %>%
  select(GEOID_ZCTA, age_u5, age_5_9, age_10_14, age_15_19, age_20_24, age_25_34,
         age_35_44, age_45_54, age_55_59, age_60_64, age_65_74, age_75_84,
         age_gt85) -> age

## combine and write
### combine
all <- left_join(total_pop, race, by = "GEOID_ZCTA") %>%
  left_join(., age, by = "GEOID_ZCTA")

### write
write_csv(all, "data/demographics_extended/STL_ZCTA_St_Louis_County.csv")

# === # === # === # === # === # === # === # === # === # === # === # === # === #
