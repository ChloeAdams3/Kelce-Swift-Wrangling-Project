#Scraping
rm(list = ls())

page<-read_html("https://www.pro-football-reference.com/players/K/KelcTr00.htm") 

library(xml2)
user_agent<- "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Safari/537.36"
user_agent

current_page<-"https://www.pro-football-reference.com/players/K/KelcTr00.htm"

page<-read_html(current_page, user_agent)
Sys.sleep(5) #in seconds how long we want to wait before it is processed



# Scrape 2023 season:
date<-xml_text(xml_find_all(page,"//div[@class='table_wrapper']//tbody/tr/th[1]"))
date

opponent<-xml_text(xml_find_all(page,"//div[@class='table_wrapper']//tbody/tr//td[3]"))
opponent

result<-xml_text(xml_find_all(page,"//div[@class='table_wrapper']//tbody/tr//td[4]"))
result

targets<-xml_text(xml_find_all(page,"//div[@class='table_wrapper']//tbody/tr//td[5]"))
targets

receptions<-xml_text(xml_find_all(page,"//div[@class='table_wrapper']//tbody/tr//td[6]"))
receptions

catch_percentage<-xml_text(xml_find_all(page,"//div[@class='table_wrapper']//tbody/tr//td[11]"))
catch_percentage

yards<-xml_text(xml_find_all(page,"//div[@class='table_wrapper']//tbody/tr//td[7]"))
yards

touchdowns<-xml_text(xml_find_all(page,"//div[@class='table_wrapper']//tbody/tr//td[9]"))
touchdowns

urls<-xml_attr(xml_find_all(page,"//div[@class='table_wrapper']//tbody/tr/th[1]/a"), "href")
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
current_season_df<-data.frame(date, opponent, result, targets, receptions, catch_percentage, yards, touchdowns, attendance=all_attendance, stadium=all_stadiums)

#creating season column
current_season_df$season<- 2023


#splitting result column
library(tidyverse)

current_season_df <- current_season_df %>%
  separate(result, into = c("result", "score"), sep = " ")

#renaming w result to win and l to loss
current_season_df$result[current_season_df$result=="W"]<-"Win"
current_season_df$result[current_season_df$result=="L"]<-"Loss"

#renaming arrowhead stadium
current_season_df$stadium[current_season_df$stadium=="GEHA Field at Arrowhead Stadium"]<-"Arrowhead Stadium"

#getting rid of comma in attendance
current_season_df$attendance<-gsub(",", "", current_season_df$attendance)


#getting rid of percentage sign in catch percentage
current_season_df$catch_percentage<-gsub("%", " ", current_season_df$catch_percentage)

#changing data types
str(current_season_df)

current_season_df$date<-as.Date(current_season_df$date)
current_season_df$targets<-as.integer(current_season_df$targets)
current_season_df$receptions<-as.integer(current_season_df$receptions)
current_season_df$catch_percentage<-as.numeric(current_season_df$catch_percentage)
current_season_df$yards<-as.integer(current_season_df$yards)
current_season_df$touchdowns<-as.integer(current_season_df$touchdowns)
current_season_df$attendance<-as.integer(current_season_df$attendance)

#writing to csv
write.csv(current_season_df, "current_season_df.csv", row.names = FALSE)

