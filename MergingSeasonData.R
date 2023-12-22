#horizontal merging data

rm(list=ls())


#reading in files
current_season_df<-read.csv("current_season_df.csv")

past_season_df<-read.csv("past_season_df.csv")


#Vertically integrating data
all_seasons_df<-rbind(current_season_df, past_season_df)





#horizontal merge
#Adding stadium average attendence in
stadium_attendance_df<-read.csv("stadium_attendance.csv")

#something is going wrong with my stadium values
unique(all_seasons_df$stadium)
unique(stadium_attendance_df$stadium)
setdiff(all_seasons_df$stadium, stadium_attendance_df$stadium)
setdiff(stadium_attendance_df$stadium, all_seasons_df$stadium)

#create new column of stadium data from unique of all seasons dataframe
unique_stadiums<-unique(all_seasons_df$stadium)

stadium_avg_attendance<-data.frame(stadium_attendance_df, unique_stadiums)
stadium_avg_attendance$stadium<-NULL
colnames(stadium_avg_attendance)[colnames(stadium_avg_attendance) == "unique_stadiums"] <- "stadium"

setdiff(all_seasons_df$stadium, stadium_avg_attendance$stadium)
setdiff(stadium_avg_attendance$stadium, all_seasons_df$stadium)

#merge stadium avg data with vertically integrated data
merged_data<-merge(all_seasons_df, stadium_avg_attendance, by="stadium")

str(merged_data)

write.csv(merged_data, "merged_football_data.csv", row.names = FALSE)


#writing one of the values as a date!!!!!!!



