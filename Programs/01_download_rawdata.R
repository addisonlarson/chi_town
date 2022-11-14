# ALarson
# 20221114
# Download the easy-to-get datasets from web locations

rm(list=ls())

# Packages
library(dplyr)
library(tigris)
library(sf)
library(tidycensus)
library(here)

# Paths
root <- here()
raw <- file.path(root, "Data/Raw")

census_api_key(scan(file.path(root, "Keys/census_api_key.txt"), what = "character"))

# Downloads -------------------------------------------------------------------

# Neighborhood boundaries, 2018, Chicago Office of Tourism (GEOJSON format)
url <- "https://data.cityofchicago.org/api/geospatial/bbvz-uum9?method=export&format=GeoJSON"
download.file(url, file.path(raw, "nhoods_boundaries.geojson"))

# City boundaries, 2017 (May be contiguous with neighborhood boundaries and therefore duplicative)
url <- "https://data.cityofchicago.org/api/geospatial/ewy2-6yfk?method=export&format=GeoJSON"
download.file(url, file.path(raw, "city_boundaries.geojson"))

# Census tract boundaries, 2021, TIGER/LINE
census_tracts <- tracts(
  state = "IL",
  county = "Cook",
  cb = TRUE,
  year = 2021
)
stopifnot(all(census_tracts$COUNTYFP == "031"))

st_write(census_tracts, file.path(raw, "tract_boundaries.gpkg"), delete_dsn = TRUE)

# Library locations, 2021
url <- "https://data.cityofchicago.org/api/views/wa2i-tm5d/rows.csv?accessType=DOWNLOAD"
download.file(url, file.path(raw, "library_locations.csv"))

# Parks, 2016, Chicago Park District
url <- "https://data.cityofchicago.org/api/geospatial/ej32-qgdr?method=export&format=GeoJSON"
download.file(url, file.path(raw, "parks_locations.geojson"))

# Grocery stores, 2013 (Yes, I know this is old)
url <- "https://data.cityofchicago.org/api/views/53t8-wyrc/rows.csv?accessType=DOWNLOAD"
download.file(url, file.path(raw, "grocery_locations.csv"))

# Median rent (2020 ACS 5-Year)
rent <- get_acs(
  geography = "tract",
  variables = "DP04_0134E",
  year = 2020,
  state = "IL",
  county = "Cook",
  survey = "acs5"
)
write.csv(rent, file.path(raw, "median_rent.csv"))
