/****** Script for SelectTopNRows command from SSMS  ******/
SELECT *
FROM [SQL Portfolio Projects].[dbo].[csv_daily_activity_details_merged_final]

/** here we are going to go through the whole data
SELECT *
FROM [SQL Portfolio Projects].[dbo].[csv_daily_activity_details_merged_final]

/*** Checking and converting data types 
SELECT ActivityDay
FROM [SQL Portfolio Projects].[dbo].[csv_daily_activity_details_merged_final]

/***
SELECT
CAST(ActivityDay AS Date) AS NewActivityDay
FROM 
[SQL Portfolio Projects].[dbo].[csv_daily_activity_details_merged_final]


SELECT
CONVERT(Date, ActivityDay)
FROM 
[SQL Portfolio Projects].[dbo].[csv_daily_activity_details_merged_final]

/***
Updating table with new date column

UPDATE [SQL Portfolio Projects].[dbo].[csv_daily_activity_details_merged_final]
SET ActivityDay = CAST(ActivityDay AS Date)

/* 
correcting other datatypes

UPDATE [SQL Portfolio Projects].[dbo].[csv_daily_activity_details_merged_final]
SET VeryActiveMinutes = CAST(VeryActiveMinutes AS int)

UPDATE [SQL Portfolio Projects].[dbo].[csv_daily_activity_details_merged_final]
SET FairlyActiveMinutes = CAST(FairlyActiveMinutes AS int)

UPDATE [SQL Portfolio Projects].[dbo].[csv_daily_activity_details_merged_final]
SET LightlyActiveMinutes = CAST(LightlyActiveMinutes AS int)

UPDATE [SQL Portfolio Projects].[dbo].[csv_daily_activity_details_merged_final]
SET SedentaryMinutes = CAST(SedentaryMinutes AS int)

UPDATE [SQL Portfolio Projects].[dbo].[csv_daily_activity_details_merged_final]
SET Calories = CAST(Calories AS int)

UPDATE [SQL Portfolio Projects].[dbo].[csv_daily_activity_details_merged_final]
SET TotalSteps = CAST(TotalSteps AS int)

/***
Checking errors and null values in dataset

SELECT
ActivityDay
FROM 
[SQL Portfolio Projects].[dbo].[csv_daily_activity_details_merged_final]
WHERE
ActivityDay IS NULL

/There is No NUll in the dataset

/*** Find out if tere are duplicates

SELECT
DISTINCT Id
FROM 
[SQL Portfolio Projects].[dbo].[csv_daily_activity_details_merged_final]

/The dataset is little flawed beacuse the number of id is 33, instead of 30. So, there might be some people who has done this survey twice.

/***
Adding a column to show 'the day of the week' to the table

SELECT
DATENAME(WEEKDAY, ActivityDay)
FROM 
[SQL Portfolio Projects].[dbo].[csv_daily_activity_details_merged_final]

/*
Updating table with Day of the Week by creating a column

ALTER TABLE [SQL Portfolio Projects].[dbo].[csv_daily_activity_details_merged_final]
ADD "DayOfTheWeek" varchar(255)

UPDATE [SQL Portfolio Projects].[dbo].[csv_daily_activity_details_merged_final]
SET DayOfTheWeek = DATENAME(WEEKDAY, ActivityDay)

/***
Finding some insides on data - stats

SELECT
AVG(CAST(VeryActiveMinutes AS int))
FROM [SQL Portfolio Projects].[dbo].[csv_daily_activity_details_merged_final]
 
/Found - Average VeryActiveMinutes is just '21 minutes'. This means people are not at all Active. 21mins on average is way too less. 

SELECT
AVG(CAST(FairlyActiveMinutes AS int))
FROM [SQL Portfolio Projects].[dbo].[csv_daily_activity_details_merged_final]

/Found - Average FairlyActiveMinutes is just '13 minutes'. Which is also very less.


SELECT
AVG(CAST(LightlyActiveMinutes AS int))
FROM [SQL Portfolio Projects].[dbo].[csv_daily_activity_details_merged_final]

/Found - Average LightlyActiveMinutes is just '192 minutes'.


SELECT
AVG(CAST(SedentaryMinutes AS int))
FROM [SQL Portfolio Projects].[dbo].[csv_daily_activity_details_merged_final]

/Found - Average SedentaryMinutes is just '991 minutes'. This absolutely shows that people are very idle overall and it is not good for any fitness band owner. People are just not interest in fitness.


SELECT
AVG(CAST(TotalSteps AS int))
FROM [SQL Portfolio Projects].[dbo].[csv_daily_activity_details_merged_final]

/Found - Average Total steps taken by the participants is just 7637. Which is very less when compared to a a normal steps that should be taken a human being to be healthy. It is around 8000-10000 as per sources like mayo clinic.


SELECT
AVG(CAST(Calories AS int))
FROM [SQL Portfolio Projects].[dbo].[csv_daily_activity_details_merged_final]

/Found - Average Calories burned by the participants is just 2303. Which is very less when compared to a average calories that a person should burn everyday, but we can't be pretty sure about the outcome since we don't know about the health condition of people who have participated.

