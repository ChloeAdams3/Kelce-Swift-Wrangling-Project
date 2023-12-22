rm(list=ls())

df<-read.csv("travisandtaylor.csv")

#splitting into most recent season data only
season_2023<-df[df$season=="2023", ]

#QUESTION 1- In attendance vs non-attendance
#Taylor Swift 2023 Attendance at Games
library(dplyr)
library(ggplot2)

current_season_group<-group_by(season_2023, taylor_in_attendance)
tswfit_attendance<-summarize(current_season_group, Count= n())
tswfit_attendance

ggplot(tswfit_attendance, 
       aes(x="", y=Count, fill=taylor_in_attendance)) +
  geom_bar(stat="identity", width=1) +
  geom_text(aes(label = Count), size=5, position = position_stack(vjust = 0.5), color="white") +
  coord_polar("y", start=0)+ labs(title= "2023 Season Taylor Swift Attendance") +
  theme_void() 




#RECEPTIONS
reception_attendance<-summarize(current_season_group, Average_Receptions=round(mean(receptions),1))
reception_attendance

#barchart
qplot(taylor_in_attendance, Average_Receptions, data=reception_attendance, geom="col", fill= I("red")) +
  geom_text(aes(label=Average_Receptions), size=4, vjust=-0.4) + labs(x = 'Taylor in Attendance?', y = 'Average Receptions')

#boxplot
qplot(taylor_in_attendance, receptions, data=season_2023, geom="boxplot") 

qplot(taylor_in_attendance, receptions, data=season_2023, geom="point") 

#CATCH %
catch_percentage_attendance<-summarize(current_season_group, Average_Catch_Percentage=round(mean(catch_percentage),1))
catch_percentage_attendance

#barchart
qplot(taylor_in_attendance, Average_Catch_Percentage, data=catch_percentage_attendance, geom="col", fill= I("red")) +
  geom_text(aes(label=Average_Catch_Percentage), size=4, vjust=-0.4) + labs(x = 'Taylor in Attendance?', y = 'Average Catch Percentage')


#boxplot
qplot(taylor_in_attendance, catch_percentage, data=season_2023, geom="boxplot") 

qplot(taylor_in_attendance, catch_percentage, data=season_2023, geom="point") 


#YARDS
yards_attendance<-summarize(current_season_group, Average_Yards=round(mean(yards),1))
yards_attendance

#barchart
qplot(taylor_in_attendance, Average_Yards, data=yards_attendance, geom="col", fill= I("red")) +
  geom_text(aes(label=Average_Yards), size=4, vjust=-0.4) + labs(x = 'Taylor in Attendance?', y = 'Average Yards')

#boxplot
qplot(taylor_in_attendance, yards, data=season_2023, geom="boxplot") 

qplot(taylor_in_attendance, yards, data=season_2023, geom="point") 

#TOUCHDOWNS
touchdowns_attendance<-summarize(current_season_group, Average_Touchdowns=round(mean(touchdowns),1))
touchdowns_attendance

qplot(taylor_in_attendance, Average_Touchdowns, data=touchdowns_attendance, geom="col", fill= I("red")) +
  geom_text(aes(label=Average_Touchdowns), size=4, vjust=-0.4) + labs(x = 'Taylor in Attendance?', y = 'Average Touchdowns')

#boxplot
qplot(taylor_in_attendance, touchdowns, data=season_2023, geom="boxplot") 


#scatterplot in regards to tswift attendance
qplot(catch_percentage, 
      yards, 
      data=season_2023, 
      geom="point",
      color=taylor_in_attendance) 




#QUESTION 2-stats since they have been dating vs not dating
#dating games vs non dating
all_seasons_group<-group_by(df, dating)
tswfit_dating<-summarize(all_seasons_group, Count= n())
tswfit_dating

ggplot(tswfit_dating, 
       aes(x="", y=Count, fill=dating)) +
  geom_bar(stat="identity", width=1) +
  geom_text(aes(label = Count), size=5, position = position_stack(vjust = 0.5), color="white") +
  coord_polar("y", start=0)+ labs(title= "2023 Season Taylor Swift Attendance") +
  theme_void() 

#RECEPTIONS
reception_dating<-summarize(all_seasons_group, Average_Receptions=round(mean(receptions),1))
reception_dating

#barchart
qplot(dating, Average_Receptions, data=reception_dating, geom="col", fill= I("orange")) +
  geom_text(aes(label=Average_Receptions), size=4, vjust=-0.4) + labs(x = 'Kelce and TSwft Dating?', y = 'Average Receptions')

#boxplot
qplot(dating, receptions, data=df, geom="boxplot") 

qplot(dating, receptions, data=df, geom="point") 


#CATCH %
catch_percentage_dating<-summarize(all_seasons_group, Average_Catch_Percentage=round(mean(catch_percentage),1))
catch_percentage_dating

#barchart
qplot(dating, Average_Catch_Percentage, data=catch_percentage_dating, geom="col", fill= I("orange")) +
  geom_text(aes(label=Average_Catch_Percentage), size=4, vjust=-0.4) + labs(x = 'Kelce and TSwft Dating?', y = 'Average Catch Percentage')

#boxplot
qplot(dating, catch_percentage, data=df, geom="boxplot") 

qplot(dating, catch_percentage, data=df, geom="point") 


#YARDS
yards_dating<-summarize(all_seasons_group, Average_Yards=round(mean(yards),1))
yards_dating

#barchart
qplot(dating, Average_Yards, data=yards_dating, geom="col", fill= I("orange")) +
  geom_text(aes(label=Average_Yards), size=4, vjust=-0.4) + labs(x = 'Kelce and TSwft Dating?', y = 'Average Yards')

#boxplot
qplot(dating, yards, data=df, geom="boxplot") 

qplot(dating, yards, data=df, geom="point") 


#TOUCHDOWNS
touchdowns_dating<-summarize(all_seasons_group, Average_Touchdowns=round(mean(touchdowns),1))
touchdowns_dating

qplot(dating, Average_Touchdowns, data=touchdowns_dating, geom="col", fill= I("orange")) +
  geom_text(aes(label=Average_Touchdowns), size=4, vjust=-0.4) + labs(x = 'Kelce and TSwft Dating?', y = 'Average Touchdowns')



#scatterplot in regards to tswift dating
qplot(catch_percentage, 
      yards, 
      data=df, 
      geom="point",
      color=dating) 




#QUESTION 3
#attendance differential
chiefs_attendance<-df[which(df$season=="2023" & df$stadium=="Arrowhead Stadium"),  ]

chiefs_attendance$games <- c("Game 1 (9/24)", "Game 2 (10/12)", "Game 3 (10/22)")



library(tidyr)
long_data<-gather(chiefs_attendance, attendance_type, measurement, c(attendance, average_attendance))
table2<-long_data[, c("stadium", "opponent", "attendance_type","measurement")]
table2


ggplot(long_data, 
       aes(x=games, y=measurement, fill=attendance_type)) +
  geom_bar(stat="identity", position=position_dodge())+
  theme(axis.text.x = element_text(vjust=0.5)) + 
  geom_text(aes(label=measurement), color="white", size=4.5, vjust=1.5, position=position_dodge(0.9)) +
  labs(title= "Taylor's Effect on Chief's Home Game Attendance",x = '', y = 'Attendance Values')

