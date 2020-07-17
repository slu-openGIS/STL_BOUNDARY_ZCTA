# STL_BOUNDARY_ZCTA
## Motivation
Public health data are often released by ZIP code rather than Census tracts or similar geographies. This practice has well-established shortcomings, but remains common. One signification issue is that ZIP codes do not stop at county lines, yet much of our public health data does. In order to address this, this repository creates interpolated population estimates for modified ZCTA boundaries that are limited to the extent of specific counties.

## Contents
This repository contains two sets of data for St. Louis area ZCTAs:

  1. Geometric data for ZCTAs in `.geojson` format
  2. Estimated population data for ZCTAs in `.csv` format
  
These data are available for four specific counties: Jefferson County, St. Charles County, St. Louis County, and the City of St. Louis. There are also geometric data and estimates for two regions - one containing the City and the County, and one containing all four counties.
