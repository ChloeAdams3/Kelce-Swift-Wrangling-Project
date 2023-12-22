#scraping 2 Setup
rm(list = ls())

library(xml2)

page<-read_html("https://www.pro-football-reference.com/players/K/KelcTr00/gamelog/2022/")

current_page<-"https://www.pro-football-reference.com/players/K/KelcTr00/gamelog/2022/"
user_agent<- "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Safari/537.36"

page<-read_html(current_page, user_agent)
Sys.sleep(5) #in seconds how long we want to wait 


#Scraping different stats Season 2022

date<-xml_text(xml_find_all(page,"//div[@id='all_stats']//tbody/tr/td[1]"))
date

opponent<-xml_text(xml_find_all(page,"//div[@id='all_stats']//tbody/tr/td[7]"))
opponent

result<-xml_text(xml_find_all(page,"//div[@id='all_stats']//tbody/tr/td[8]"))
result

targets<-xml_text(xml_find_all(page,"//div[@id='all_stats']//tbody/tr/td[10]"))
targets

receptions<-xml_text(xml_find_all(page,"//div[@id='all_stats']//tbody/tr/td[11]"))
receptions

catch_percentage<-xml_text(xml_find_all(page,"//div[@id='all_stats']//tbody/tr/td[15]"))
catch_percentage

yards<-xml_text(xml_find_all(page,"//div[@id='all_stats']//tbody/tr/td[12]"))
yards

touchdowns<-xml_text(xml_find_all(page,"//div[@id='all_stats']//tbody/tr/td[14]"))
touchdowns

urls<-xml_attr(xml_find_all(page,"////div[@id='all_stats']//tbody/tr/td[1]/a"), "href")
urls

#adding to the domain
urls<-paste0("https://www.pro-football-reference.com", urls)
urls

#getting stadium and attendance data
all_stadiums<-character(0)
all_attendance<-character(0)

for (url in urls) {
  # Perform some operation on the URL, e.g., fetch the content using the 'httr' package
  page2<-read_html(url)
  current_page2<-url
  
  page2<-read_html(current_page2, user_agent)
  Sys.sleep(5) 
  
  stadium <-xml_text(xml_find_all(page2,"//div[@class='scorebox_meta']/div[3]/a"))
  stadium
  
  all_stadiums<-c(all_stadiums, stadium) # Append to quotes vector
  
  
  attendance <-xml_text(xml_find_all(page2,"//div[@class='scorebox_meta']/div[4]/a"))
  attendance
  
  all_attendance<-c(all_attendance, attendance) # Append to quotes vector
  print(url)
  print(attendance)
  print(stadium)
  
}

#putting in df
past_season_df<-data.frame(date, opponent, result, targets, receptions, catch_percentage, yards, touchdowns, attendance=all_attendance, stadium=all_stadiums)

#cleaning df 
past_season_df$season<- 2022

#splitting result column
library(tidyverse)

past_season_df <- past_season_df %>%
  separate(result, into = c("result", "score"), sep = " ")

#renaming w result to win and l to loss
past_season_df$result[past_season_df$result=="W"]<-"Win"
past_season_df$result[past_season_df$result=="L"]<-"Loss"


#renaming arrowhead stadium
past_season_df$stadium[past_season_df$stadium=="GEHA Field at Arrowhead Stadium"]<-"Arrowhead Stadium"

#getting rid of comma in attendance
past_season_df$attendance<-gsub(",", "", past_season_df$attendance)

#getting rid of percentage sign
past_season_df$catch_percentage<-gsub("%", " ", past_season_df$catch_percentage)

#changing data types
str(past_season_df)

past_season_df$date<-as.Date(past_season_df$date)
past_season_df$targets<-as.integer(past_season_df$targets)
past_season_df$receptions<-as.integer(past_season_df$receptions)
past_season_df$catch_percentage<-as.numeric(past_season_df$catch_percentage)
past_season_df$yards<-as.integer(past_season_df$yards)
past_season_df$touchdowns<-as.integer(past_season_df$touchdowns)
past_season_df$attendance<-as.integer(past_season_df$attendance)


write.csv(past_season_df, "past_season_df.csv", row.names = FALSE)
