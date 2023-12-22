#Data Project 
rm(list=ls())

#install.packages("dplyr")
#install.packages("readxl")

library(dplyr)

travis_stats<- read.csv("merged_football_data.csv")
str(travis_stats)
travis_stats$date<- as.Date(travis_stats$date, format = "%Y-%m-%d")


timeline<- read.csv("taylortimeline.csv")
str(timeline)
timeline$date <- as.Date(timeline$date, format = "%m/%d/%Y")

final_file<-merge(travis_stats, timeline, by="date")

write.csv(final_file, "travisandtaylor.csv", row.names = FALSE)


