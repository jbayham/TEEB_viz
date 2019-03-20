#Converting the values to 2018 dollars

if(file.exists("cache/cpi.Rdata")){
  load("data/cpi/cpi.Rdata")
} else {
  #Get CPI data from Quandl
  cpi <- Quandl("FRED/CPIAUCSL")
  save(cpi,file = "cache/cpi.Rdata")
}

#####################
cpi <- cpi %>%
  mutate(year=year(Date)) %>%
  group_by(year) %>%
  summarise(Value=mean(Value)) %>%
  mutate(deflator=Value/Value[year==2018]) %>%
  select(-Value) %>%
  ungroup() %>%
  as_tibble()
  

# extracting data that haven't been standardized to 2007 and uses the cpi to convert Values to 2018 USD
teeb.2018 <- inner_join(teeb %>%
                         mutate(year=if_else(`standardized 2007 value?`,2007,year)) %>%
                         select(ValueID,Value,year),
                        cpi,
                        by="year") %>%
    mutate(Value=Value/deflator) %>%
    select(-one_of("deflator","year"))
  
#Joining 2018 values back to dataset
teeb <- inner_join(teeb %>% select(-one_of("Value")),
                   teeb.2018,
                   by="ValueID")  

save(teeb,file = "cache/teeb_checked.Rdata")
  

