rm(list=ls())

#load libraries
library(quantmod)
library(ggplot2)

#package to replace BatchGetSymbols
#remotes::install_github('msperlin/yfR')
library(yfR)


#initial values
stk.list<-read.csv("tickers.csv")
stk.symbols<-paste0(stk.list$ticker,".TO")
lag.inp<-365
obs.str<-as.Date(Sys.Date()-lag.inp)

#get market data
data<-yf_get(stk.symbols,first_date=obs.str)

#plot
inst.data<-yf_live_prices("CCO.TO") 
inst.data$time_stamp<-as.Date(inst.data$time_stamp)
ggplot(data[data$ticker=="CCO.TO",],aes(x=ref_date,y=price_adjusted))+
  geom_line()+
  geom_point(data=inst.data,aes(x=time_stamp,y=price),inherit.aes = F)

