#functions for stock analysis

quant.ass<-function(name,lag){
  obs.str<-as.Date(Sys.Date()-lag)
  options("getSymbols.warning4.0"=FALSE)
  suppressWarnings(
  data<-getSymbols(name,auto.assign=F,src="yahoo",from=obs.str,
                             warnings=F)
  )#end suppressWarnings()
  
  #reshape data so high,low,close,open are in one column
  data<-data.frame(data)
  data$date<-as.Date(row.names(data))
  colnames(data)[1:4]<-c("open","high","low","close")
  data<-reshape(data,direction="long",
                varying=c("open","high","low","close"),
                times=c("open","high","low","close"),
                v.names="Price")
  data$date.num<-as.numeric(data$date)
  #work with logged price
  data$logPrice<-log(data$Price)
  
  #bootstrap function
  quan.boot<-function(x,i,prob) quantile(x$logPrice[i],probs = prob)
  
  out.med<-boot::boot(data,statistic=quan.boot,R=999,prob=0.5)
  out.75<-boot::boot(data,statistic=quan.boot,R=999,prob=0.75)
  out.90<-boot::boot(data,statistic=quan.boot,R=999,prob=0.90)
  e.return<-exp(out.75$t)/exp(out.med$t)
  #trend analysis
  out.trend<-lm(logPrice~date,data=data)
  out.slope<-arm::sim(out.trend,n.sims=999)
  out.slope<-coef(out.slope)[,2]
  #5 day projected 75th quantile given the trend
  e.return.trend<-(exp(out.75$t)*exp(out.slope*5))/exp(out.med$t)
  
  #formulate advice
  #if first two conditions met than either an ok, good or excellent investment 
  #unlikely to be a loss
  if (quantile(e.return,0.05)>0.99 &  #95% chance expected loss <1% without trend
      quantile(out.slope,0.05)>0 # and 95% chance trend is not negative
      ){  
          if (quantile(e.return.trend,0.75)>1.10 & 
              quantile(e.return,0.5)>1.05) advice<-"excellent" 
          else if (quantile(e.return.trend,0.05)>1 & 
                   quantile(e.return,0.75)>1.10) advice<-"excellent"
          else if (quantile(e.return.trend,0.05)>1 & 
                   quantile(e.return,0.5)>1.05) advice<-"good"
          else advice<-"ok"
      
  }else {
    if (quantile(e.return,0.95)>1.05){ #ignore trend go with 5% chance of 5% gain 
      advice<-"volatility"
    } else advice<-"bad" #bad investment - likely loss
  }
    
  buy<-exp(median(out.med$t)); sell<-exp(median(out.75$t))
  sell.high<-max(c(exp(median(out.90$t)),quantile(e.return.trend,0.75)*buy))
  return(list(c(name,advice,quantile(e.return,probs=c(0.025,0.5,0.975)),
                exp(quantile(out.slope,0.05)*5),
                exp(median(out.slope*5)),buy,sell,sell.high),
              list(expected.return=e.return,trend=out.trend,
                   expected.return.trend=e.return.trend,
              data=data)))
}

#function to plot stock ts
stock.ts<-function(names,df.ls){
  data<-df.ls[[names[1]]][[2]]$data
  data$name<-rep(names[1],length(data[,1]))
  data$predicted<-df.ls[[names[1]]][[2]]$trend$fitted.values
  for (i in 2:length(names)){
    temp<-df.ls[[names[i]]][[2]]$data
    temp$name<-rep(names[i],length(temp[,1]))
    temp$predicted<-df.ls[[names[i]]][[2]]$trend$fitted.values
    colnames(temp)<-colnames(data)
    data<-rbind(data,temp)
  }
  stock.ts<-ggplot(data=data,aes(x=date,y=Price))+
    geom_point()+
    geom_smooth(method="lm")+
    geom_line(aes(y=exp(predicted)),colour="red",size=1.25)+
    facet_wrap(~name,scales="free")
  return(stock.ts)
}
#function to plot expected returns histogram
return.density<-function(names,df.ls){
    data<-data.frame(e.ret=df.ls[[names[1]]][[2]]$expected.return)
    data$e.ret.trnd<-df.ls[[names[1]]][[2]]$expected.return.trend
    data$name<-rep(names[1],length(data[,1]))
    for (i in 2:length(names)){
      temp<-data.frame(e.ret=df.ls[[names[i]]][[2]]$expected.return)
      temp$e.ret.trnd<-df.ls[[names[i]]][[2]]$expected.return.trend
      temp$name<-rep(names[i],length(temp[,1]))
      data<-rbind(data,temp)
    }
    return.hist<-ggplot(data=data,aes(x=e.ret))+
      geom_density(fill="red",alpha=0.5)+
      geom_density(aes(x=e.ret.trnd),fill="purple",alpha=0.5)+
      facet_wrap(~name)+
      geom_vline(xintercept = 1,linetype=2)+
      labs(x="Expected return")
    return(return.hist)
}

