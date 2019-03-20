#Merging in geographic information from national spatial file


countries.geo <- st_read("data/maps/ne_50m_admin_0_countries_lakes.shp",
                      stringsAsFactors=F) %>%
  select(Country_geo=NAME,
         continent=CONTINENT,
         subregion=SUBREGION,
         region=REGION_WB) 

countries <- countries.geo
st_geometry(countries) <- NULL


#merging teeb data with country
teeb.geo <- stringdist_left_join(teeb %>% mutate(Country=ifelse(Country=="Lao People's Democratic Republic","Laos",Country),
                                             Country=ifelse(Country=="Tanzania, United Republic of","Tanzania",Country),
                                             Country=ifelse(Country=="Bolivia (Plurinational State of)","Bolivia",Country),
                                             Country=ifelse(Country=="Turks and Caicos Islands","Turks and Caicos Is.",Country)),  #changing Laos
                                 countries,
                                 by=c("Country"="Country_geo"),method="lcs",distance_col="dist") %>% 
  dplyr::filter(is.na(dist) | dist==0) %>%
  select(-dist) 


save(teeb.geo,file = "cache/teeb_geo.Rdata")
