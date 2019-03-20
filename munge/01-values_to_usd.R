#This script prepares the exchange rate data that we can use to convert the TEEB values into USD.
#Some of the exchange rate data needs to be added manually


#Read in and subset teeb data that needs currency conversion
teeb.raw <- read_csv(file="data/TEEB_DB.csv")

teeb.select <- teeb.raw %>%
  rename(year=`Year Of Publication`) %>%
  select(ValueID,Value,Unit,Currency,year) %>%
  dplyr::filter(Currency!="US Dollar")


#Load exchange rate data 
load("cache/xe_rates_1995-2017.Rdata")

########################
#Merging with exchange rates

#Using stringdist package to fuzzy match countries names to merge currency exchange rate data
dist.mat <- stringdistmatrix(str_to_lower(teeb.select$Currency),
                             str_to_lower(xe.df$Currency),
                             method = "lcs")

ex.rate.idx <- apply(dist.mat,1,which.min)

teeb.exr <- left_join(teeb.select %>%
                        mutate(Currency.xe=xe.df$Currency[ex.rate.idx]),
                      xe.df,
                      by=c("Currency.xe"="Currency","year"="year"))


write_csv(teeb.exr,path = "cache/to_review/teeb_currency_check.csv")
stop("Fill in missing exchange rates.")

#######################
#Read in updated exchange rate data
teeb.exr <- read_csv(file = "cache/to_review/teeb_currency_checked.csv")

teeb.values <- bind_rows(
  teeb.exr %>%
  mutate(Value=as.numeric(Value),
         Value=Value*usd_per_unit,
         Currency="US Dollar") %>%
  dplyr::filter(!is.na(Value)) %>%
  select(ValueID,Value,Unit,Currency,year),
  teeb.raw %>%
  rename(year=`Year Of Publication`) %>%
  select(ValueID,Value,Unit,Currency,year) %>%
  mutate(Value=as.numeric(Value)) %>%
  dplyr::filter(!is.na(Value)) %>%
  dplyr::filter(Currency=="US Dollar"))

#merging values converted to usd back with full TEEB data
teeb <- inner_join(
  teeb.raw %>%
  rename(year=`Year Of Publication`) %>%
  select(-one_of("Value","Unit","Currency","year")),
  teeb.values,
  by="ValueID"
)

save(teeb,file = "cache/teeb.Rdata")



