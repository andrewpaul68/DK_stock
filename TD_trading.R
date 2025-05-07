#Stock analysis
#5 April 2020


results<-list(NULL)
res.df<-data.frame(stock=character(),advice=character(),ret.lci=numeric(),ret.med=numeric(),
                   ret.uci=numeric(),t5.day.lci=numeric(),t5.day=numeric(),
                   buy=numeric(),sell=numeric(),
                   sell.high=numeric())
for (i in 1:length(tsx.symbols)){
  results[tsx.symbols[i]]<-list(quant.ass(tsx.symbols[i],lag.inp))
  temp<-data.frame(stock=results[[tsx.symbols[i]]][[1]][1],
                         advice=results[[tsx.symbols[i]]][[1]][2],
                         ret.lci=as.numeric(results[[tsx.symbols[i]]][[1]][3]),
                         ret.med=as.numeric(results[[tsx.symbols[i]]][[1]][4]),
                         ret.uci=as.numeric(results[[tsx.symbols[i]]][[1]][5]),
                         t5.day.lci=as.numeric(results[[tsx.symbols[i]]][[1]][6]),
                         t5.day.med=as.numeric(results[[tsx.symbols[i]]][[1]][7]),
                         buy=as.numeric(results[[tsx.symbols[i]]][[1]][8]),
                         sell=as.numeric(results[[tsx.symbols[i]]][[1]][9]),
                         sell.high=as.numeric(results[[tsx.symbols[i]]][[1]][10]))
  res.df<-rbind(res.df,temp)
}




