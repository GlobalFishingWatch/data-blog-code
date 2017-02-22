

#Packages for making plots
library(sp)
library(devtools)
library(ggplot2)
library(dplyr)
library(scales)
library(rgeos)
library(rgdal)  
library(ggalt)   #devtools::install_github("hrbrmstr/ggalt")
library(grid)
library(readr)


#SHAPEFILES

#load shape files to plot continents: File downloaded from Natural Earth
# http://www.naturalearthdata.com/downloads/110m-physical-vectors/
setwd("~/Downloads/ne_110m_land")
land <- readOGR('.', "ne_110m_land")
land_df <- fortify(land)


#load shape file for EEZs: File downloaded from Marine Regions
# http://www.marineregions.org/downloads.php
setwd('~/Downloads/World_EEZ_v8_20140228_LR')
eez <- readOGR('.', "World_EEZ_v8_2014")
eez_df <- fortify(eez)



#Read in the likely and potential transshipments from CSV
likely_transshipments = read_csv('GFW_transshipment_data_20170222/likely_transshipments_20170222.csv')
head(likely_transshipments)
potential_transshipments = read_csv('GFW_transshipment_data_20170222/potential_transshipments_20170222.csv')
head(potential_transshipments)


#Generate the map

vessel_world_pos = ggplot(land_df, aes(long,lat, group=group, fill = hole)) +
    geom_polygon(data = eez_df, aes(long, lat), fill = 'dodgerblue4', color = 'gray50' ) +
    geom_polygon(aes(fill = hole), color = 'grey10') +
    geom_point(data = potential_transshipments, aes(longitude,latitude, fill = NULL, group = NULL), 
               color = 'skyblue', alpha = 0.6, size = 0.3) +
    geom_point(data = likely_transshipments, aes(longitude, latitude, fill = NULL, group = NULL), 
               color = 'red', fill = 'orange', shape = 21, size = .7) +
    scale_fill_manual(values=c("grey10", 'dodgerblue4'), guide="none") +
    theme(axis.title.x = element_blank(),
          axis.title.y = element_blank(),
          axis.text.x = element_blank(),
          axis.text.y = element_blank(),
          axis.ticks = element_blank(),
          axis.line = element_blank(),
          panel.background = element_rect(fill = 'dodgerblue4')) +
    ggtitle('Global Footprint of Transshipments')
vessel_world_pos



