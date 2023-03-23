/////////// Project brief - Bellabeat is a high-tech manufacturer of beautifully-designed health-focused smart products for women since 2013. Inspiring and empowering women with knowledge about their own health and habits, Bellabeat has grown rapidly and quickly positioned itself as a tech-driven wellness company for females.

The co-founder and Chief Creative Officer, Urška Sršen is confident that an analysis of non-Bellebeat consumer data (ie. FitBit fitness tracker usage data) would reveal more opportunities for growth. Thus we will be analysing the open and public data of Fitbit.

///// Objectives 
- What are the trends identified?
  - How could these trends apply to Bellabeat customers?
  - How could these trends help influence Bellabeat marketing strategy?
  
  ///// Deliverables
- All about data we have used
- Overall summary of what is the findings
- Required visualisations and dashboard
- Clear answer to all the objectves given

//// Stakeholders
- Urška Sršen: Bellabeat’s cofounder and Chief Creative Officer
- Sando Mur: Mathematician, Bellabeat’s cofounder and member of the executive team
- Bellabeat marketing analytics team: A team of data analysts guiding Bellabeat’s marketing strategy.

////Some things about the project and dataset
- This is a based of public data, can be found of kaggle by the name of  "FitBit Fitness Tracker Data"
- This is based on a survey via Amazon Mechanical Turk between 12 March 2016 to 12 May 2016.
- This data includes data of 30 participants and it contain basic health related data like calories, heart rate, steps and related.
- We are using a part of the data in csv file name - "daily_activities"

////Some limitations of the dataset
- Old dataset so can be very much backdated.
- Only 30 participants, which is not a decent sample size, thus can be bias.
- data collected and stored by 3rd party, thus may be inaccurate.
Overall the data is of Low Value.





install.packages("tidyverse")
library(tidyverse)
library(dplyr)
library(ggplot2)
library(lubridate)
library(readr)
library(tidyr)
library(skimr)

////Reading dataset

daily_activities = read.csv("C:\\Users\\aadit\\Documents\\Case Study - Bellabeat\\dailyActivity_merged.csv")

str(daily_activities)


 - Starting process - 
////// Checking for Null values

sum(is.na(daily_activities))

// found no null values




///checking the whole data for basic data type and realted errors

str(daily_activities)

//changing data type of "ActivityDate" from Chr to Date datatype

daily_activities$ActivityDate = as.Date(daily_activities$ActivityDate, "%Y/%m/%d")



unique(daily_activities$Id)

/// Found 33 Ids in place of 30 Ids

/////Adding column and updating column

//Adding Day of the week
DayOfTheWeek = wday(daily_activities$ActivityDate, label=TRUE)
new_daily_activities = cbind(daily_activities, DayOfTheWeek)

//Adding column TotalMins that is sum of VeryActiveMinutes, FairlyActiveMinutes, LightlyActiveMinutes and SedentaryMinutes

new_daily_activities=mutate(new_daily_activities, TotalMinutes = VeryActiveMinutes+FairlyActiveMinutes+LightlyActiveMinutes+SedentaryMinutes)

//adding TotalHours from TotalMinutes

new_daily_activities=mutate(new_daily_activities, TotalHours = round(TotalMinutes/60))


/////Doing the basic statistics

summary(new_daily_activities)


///////// Findings-initial
1) The average SedentaryMinutes is the highest, that means that most of the people are mostly sitting idle during the period of survey
2) The average total steps is showing to be 7638, that is less than the noormal neccessary steps of 8000. So, people are generally not walking enough.
3) Average distance covered is also around 5.5km, that is less that what is normally needed, and that is 5.7kms
4) Average calories burn per day is around 2000-3000/day for man, and 1600-2400/day for woman (adult). here the average is 2304, cant say good or bad due to lack of proper information.


/////Graphs for visualisation

ggplot(data=new_daily_activities, aes(x=DayOfTheWeek,fill=DayOfTheWeek))+geom_bar()+ labs(title = "Activity Logged in the Day of the Week")

//As we can see, peoples most logged in days are weekdays, where weekend are comparitively less, can be because people are most active during weekdays

veryactive = sum(new_daily_activities$VeryActiveMinutes)
fairlyactive = sum(new_daily_activities$FairlyActiveMinutes)
lightlyactive = sum(new_daily_activities$LightlyActiveMinutes)
sedentary = sum(new_daily_activities$SedentaryMinutes)




///adding columns for pie chart

new_daily_activities = cbind(new_daily_activities,veryactive)
new_daily_activities = cbind(new_daily_activities,fairlyactive)
new_daily_activities = cbind(new_daily_activities,lightlyactive)
new_daily_activities = cbind(new_daily_activities,sedentary)

///exporting new dataset
write.csv(new_daily_activities, "new_daily_activities_fitbit.csv")


//////Final Findings
  A) 
    1) There is positive correlation between Calories burned and the amount of steps taken by any particular user/id.
  This can be clearly show by the scatter plot
    2) Majorly people are active or rather most active on week days - tues, Wednesday and thrusday, while other days, they are not the active, specially on weekend.
  This is shown in the bar diagram. Also, this can be because, people may be less active during off days
    3)Most of the people are found to be not that active and mostly sedentary. This is show as the mean of sedentar minutes (991.2) is way higher than any other activity minutes.
  Some of those are mean of VeryActiveMinutes = 21.16, mean of LightlyActiveMinutes = 192.8, mean of FairlyActiveMinutes = 13.56, thus these are allvery less.
  Conclusion people are mostly idle during this period of observation. 
    4)Poeple are not using the device to track fitness activities that much since the maximum of very high activity minutes is 210, whihc is very less. So, the device is not very successful in making people track their fitnes and improve health.

Q) How could these trends apply to apply to Bellabeat customers?
  A) These stats can be shown to bellabeat users to encourange them to indulge more on active lifestyle. All these fitbit stats shows that people are not that active.

Q) How could these trends help influence Bellabeat marketing strategy?
  A) these stats can built a great marketing campaign by letting them know the truth of what is up with their health.
These stats can show them that how thing sare going and how they can move towards a healthier future.
these days, educating customers can be the best marketing strategy, which will eventually led to consumption. 

)