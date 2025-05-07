#part of the Shiny app
#for global variables
#and initial set up

#clear all existing objects
rm(list=ls())

first.run<<-TRUE

library(shiny)
library(quantmod)
library(IBrokers)
library(hash)
library(obAnalytics)
library(orderbook)
library(spuRs)
library(ggplot2)
library(quantreg)
library(boot)
library(arm)
library(formattable)

#function file
source("stock_functions.R")

#initial values
tsx.symbols.init<-"CNQ.TO,SU.TO,YRI.TO,SLB,ENB.TO,RY.TO,CM.TO,
CTC-A.TO,UNH,TD,CNR.TO,CSU.TO,CCO.TO,ABX.TO,SCL.TO,OSB.TO,CCL"
lag.inp<<-10

#on opening don't run anything
first.run<<-TRUE
# tsx.temp<-sub("\n","",tsx.symbols.init)
# tsx.symbols<<-unlist(strsplit(tsx.temp,","))
# source("TD_trading.R")

#create reactiveValue for updating tables and figures
rv<-reactiveValues(update=0)



