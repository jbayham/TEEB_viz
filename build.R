#This script builds the dataset for transfer to Tableau

################
#Load init functions
source("functions/init_functions.R")

#Loading and installing packages
init.pacs(
  c("tidyverse","readxl","lubridate",       #tidy tools
          "rvest","naptime",                #web scraping and pause
          "sf",                             #managing geographic data
          "RQuantLib",                      #for calendar of business days
          "Quandl",                         #for cpi
          "wbstats",                        #API to world bank stats (pop, gdp)
          "stringdist","fuzzyjoin"))        #fuzzy joining on strings


#################
#Load helper functions
run.script("functions")

#################
#Load cached data if exists otherwise build data
cache.files <- dir("cache",pattern = ".Rdata") 
if(!is_empty(cache.files)){
  for(cache in cache.files){
    message(str_c("Loading ",cache," from cache... \n"))
    load(str_c("cache/",cache))
  }
  message("To rebuild data from scratch, empty cache folder.")
} else {
  for(munge in dir("munge",pattern = ".R")){
    message(str_c("Running ",str_c("munge/",munge),"... \n"))
    source(str_c("munge",munge))
  }
}

##################
#Additional messages to user
message("Run scripts in data/get_er_dat to update exchange rate data. \n")
message("Run scripts in data/wb_stats to pull gdp and population data from World Bank. \n")


