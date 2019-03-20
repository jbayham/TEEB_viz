#This script Scrapes xe.com for exchange rate data

#Set vector of dates on which to scrape.  Note: it needs to be a business day
year.list <- nearest_biz_day(c("1995-12-18",str_c(c(1996:2017),"-06-15")) )

#Shell to populate with estimates
xe.list <- vector("list",length = length(year.list))


for(i in 1:length(year.list)){
  #Read page
  xe.html <- read_html(str_c("https://www.xe.com/currencytables/?from=USD&date=",year.list[i]))
  
  #Read table with exchange rates
  xe.list[[i]] <- xe.html %>%
    html_node("table") %>%
    html_table() %>%
    mutate(year=year(ymd(year.list[i])))
  
  #naptime(10)
  print(i)
}

#Bind the elements of the list vertically
xe.df <- bind_rows(xe.list) 

#Reset the column names
colnames(xe.df) <- c("Code","Currency","unit_per_usd","usd_per_unit","year")

xe.df <- xe.df %>%
   select(-unit_per_usd)

save(xe.df,file = "cache/xe_rates_1995-2017.Rdata")






