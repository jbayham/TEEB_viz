#Extracting world bank data


#install.packages("wbstats")
library(wbstats)

#Indentifying tables
#wb_cachelist %>% View()

pop_gdp_long <- wb(indicator = c("SP.POP.TOTL", "NY.GDP.MKTP.CD"),
                   startdate = 1974, enddate = 2010)


save(pop_gdp_long,file = "cache/pop_gdp_long.Rdata")
