#This script merges the world bank data with the teeb dataset

load("data/wb_stats/pop_gdp_long.Rdata")

wb <- pop_gdp_long %>%
  select(country,date,indicator,value) %>%
  dplyr::filter(date=="2010") %>%
  mutate(indicator=case_when(
                   indicator=="Population, total" ~ "Population",
                   indicator=="GDP (current US$)" ~ "GDP"),
         date=as.numeric(date),
         country=ifelse(country=="Lao PDR","Laos",country),
         country=ifelse(country=="United States","United States of America",country),
         country=ifelse(country=="United Kingdom","United Kingdom of Great Britain and Northern Ireland",country),
         country=ifelse(country=="Korea, Rep.","Korea (Republic of)",country),
         country=ifelse(country=="Venezuela, RB","Venezuela (Bolivarian Republic of)",country)
    ) %>%
  spread(key = indicator,value=value)

teeb.wb <- stringdist_left_join(teeb.geo,
                                wb,
                                by=c("Country"="country"),
                                max_dist = 2,
                                method="dl",
                                distance_col="dist") %>% 
  arrange(ValueID,dist) %>%
  distinct(ValueID,.keep_all = T) %>%
  select(-dist)



write_csv(teeb.wb,path = "Tableau/TEEB_updated.csv")

write_csv(wb,"cache/to_review/wb_cleaned.csv")

