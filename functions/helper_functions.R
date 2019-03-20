#helper functions


#Input a character vector of dates and return a character vector of nearest business days
nearest_biz_day <- function(date.list){
  require(lubridate)
  require(RQuantLib)
  #for each date, check whether business day and if not, add a day
  date.output <- rep("",length(date.list))
  for(i in 1:length(date.list)){
    date.element <- ymd(date.list[i])
    cntr=0
    while(!isBusinessDay(calendar="TARGET",dates=date.element+cntr)){
      cntr=cntr+1
    }
    date.output[i] <- as.character(date.element+cntr)
  }
  return(date.output)
}
#Unit test
# date.list <- year.list #or some other vector of dates
# test <- nearest_biz_day(date.list)
# isBusinessDay(calendar="TARGET",dates=ymd(test))
