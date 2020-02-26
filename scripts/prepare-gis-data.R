#------------------------------------------------------------------------------*
# Prepare simplified shapes
#------------------------------------------------------------------------------*
  
# Load used packages
library(package = "tidyverse")


# Read in raw shapes
buildings_usac <- sf::read_sf("data/usac.osm", layer = "multipolygons") %>%
  print()

# Define university limits
limits <- usac %>%
  filter(name == "Universidad de San Carlos de Guatemala") %>%
  print()

# Get the roads
roads_usac <-  sf::read_sf("data/usac.osm", layer = "lines") %>%
  filter(
    name != "Universidad de San Carlos de Guatemala",
    !sapply(sf::st_within(., limits), is_empty)
  ) %>%
  print()

# Filter the buildings
buildings_usac <- buildings_usac %>%
  filter(
    name != "Universidad de San Carlos de Guatemala",
    !sapply(sf::st_within(., limits), is_empty)
  )


# Write reference table
buildings_usac %>%
  as.data.frame() %>%
  select(osm_id, osm_way_id, name) %>% {
    if(!file.exists("output/buildings_ref.xlsx")) {
      writexl::write_xlsx(., path = "output/buildings_ref.xlsx")
    }
  }


# Test buildings
buildings_usac %>%
  leaflet::leaflet() %>%
  # leaflet::addTiles() %>%
  leaflet::addPolygons(data = limits, color = "#dddddd", fillOpacity = 1) %>%
  leaflet::addPolygons(label = ~name, weight = 1) %>%
  leaflet::addPolylines(
    data = roads_usac, color = "red", label = ~name, weight = 1
  )


# End of script
