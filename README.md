# Cyclistic Bike-Share Analysis Case Study

## Introduction
Welcome to my capstone project for the Google Data Analytics Certificate course!\
In this case study, I will tackle many real-world tasks of a data analyst for a bike-share company to analyze historical data to identify trends in how annual members and casual riders use Cyclistic bikes differently and design marketing strategies to convert casual riders to members.

The main tools I used thought this project are **EXCEL**, **MySQL** and **Tableau**. Here are the highlights:
* Tableau Dashboard: [Bike-Share Analysis](https://public.tableau.com/app/profile/jia.wang3280/viz/Bike-shareanalysis2022/Overview).
* Course: [Google Data Analytics Capstone](https://www.coursera.org/learn/google-data-analytics-capstone).
* Data source: [Divvy trip history data](https://divvybikes.com/system-data).

In order to breakdown the tasks, I will follow the steps of the data analysis process down below: 
1. [Ask](https://github.com/WJ-IIOI/Cyclistic_Bike_Share_Analysis_Using_MySQL_Tableau/tree/main#step-1-ask--understand-the-problem)
2. [Prepare](https://github.com/WJ-IIOI/Cyclistic_Bike_Share_Analysis_Using_MySQL_Tableau/tree/main#step-2-prepare--A-description-of-data)
3. [Process](https://github.com/WJ-IIOI/Cyclistic_Bike_Share_Analysis_Using_MySQL_Tableau/tree/main#step-3-process--from-dirty-to-clean)
4. [Analyze](https://github.com/WJ-IIOI/Cyclistic_Bike_Share_Analysis_Using_MySQL_Tableau/tree/main#step-4-analyze--find-the-insights)
5. [Share](https://github.com/WJ-IIOI/Cyclistic_Bike_Share_Analysis_Using_MySQL_Tableau/tree/main#step-5-share---visualizing-findings)
6. [Act](https://github.com/WJ-IIOI/Cyclistic_Bike_Share_Analysis_Using_MySQL_Tableau/tree/main#step-6-act--conclusions-from-the-analysis)

## Scenario
* _I am assuming to be a junior data analyst working in the marketing analyst team at Cyclistic, a bike-share company in Chicago_.
* _Cyclistic’s finance analysts have concluded that annual members are much more profitable than casual riders_.
* _The director of marketing believes that maximizing the number of annual members will be key to the company's future growth_.
* _My team wants to better understand how casual riders and annual members use Cyclistic bikes differently. From these insights, my team will design a new marketing strategy to convert casual riders into annual members_.
* _Cyclistic executives must approve our recommendations, so they must be backed up with compelling data insights and professional data
visualizations_.

## About the company
* _Cyclistic is a bike-share company which has grown to a fleet of 5,824 bicycles and a network of 692 stations across Chicago_.
* _It has 3 flexible pricing plans: single-ride passes, full-day passes, and annual memberships_.
* _Customers who purchase single-ride or full-day passes are referred to as casual riders. Customers who purchase annual memberships are Cyclistic members_.
* _Its users are more likely to ride for leisure, but about 30% use bikes to commute to work each day_.

# **STEP 1 ASK – Understand the problem**
## 1.1 Defining the problem
The main problem for the director of the marketing and marketing analytics team is this: 
Design marketing strategies aimed at converting Cyclistic’s casual riders into annual members.\
There are three questions that will guide this future marketing program. 
1. **How do annual members and casual riders use Cyclistic bikes differently?**
2. **Why would casual riders buy Cyclistic annual memberships?**
3. **How can Cyclistic use digital media to influence casual riders to become members?**

By looking at the data, we will be able to first get a broad sense of certain patterns that are occurring in the two different groups. Understanding the differences will provide more accurate customer profiles for each group. These insights will help the marketing analyst team design high quality targeted marketing for converting casual riders into members. For the executive team, these insights will help Cyclistic maximize the number of annual members and will fuel future growth for the company.

## 1.2 Business task
*	Analyze historical bike trip data to identify trends in how annual members and casual riders use Cyclistic bikes differently.
*	Design marketing strategies aimed at converting casual riders to members.

## 1.3 Identify key stakeholders
* **The director of marketing** who is responsible for the development of campaigns and initiatives to promote the bike-share program.
* **The executive team** which is notoriously detail-oriented and will decide whether to approve the recommended marketing program.
* **The marketing analytics team** which is a team of data analysts who are responsible for collecting, analyzing, and reporting data that helps guide marketing strategies.

# **STEP 2 PREPARE – A description of data**
## 2.1 Data source
I will work through this project by using **Divvy trip history data** from Jan 2022 to Dec 2022.\
_( Note: The datasets have a different name because Cyclistic is a fictional company. )_\
Data can be downloaded: [Divvy trip history data](https://divvy-tripdata.s3.amazonaws.com/index.html).

## 2.2 Licensing, privacy, security and accessibility
* **Licensing**: The data has been made available by Motivate International Inc. under this [license](https://ride.divvybikes.com/data-license-agreement).
* **Privacy**: The data-privacy issues prohibit using riders’ personally identifiable information such as gender and age.
* **Security and accessibility**: This is public data that we can use to work with and released on a monthly schedule.

## 2.3 Credibility of Data
The credibility and integrity of our data can be determined using the **ROCCC** system.
* **Reliable** — The data has a large sample size, reflecting the population size.
* **Original** — We can locate the primary source.
* **Comprehensive** — The data is understandable and does not contain any missing critical information needed to answer the business question or find the solution, nor does it has human error.
* **Current** — The data is relevant and up to date, thus indicating that the source refreshes its data regularly.
* **Cited** — The source has been vetted.

The data integrity and credibility are sufficient to provide reliable and comprehensive insights for analysis.

## 2.4 Data organization
The data is stored in 12 CSV files for each month. Each data is anonymized and includes:
* Unique ride ID
* Bike type
* Rider type (Member, Casual)
* Trip start day and time
* Trip end day and time
* Trip start station
* Trip end station
* Trip start latitude and longitude
* Trip end latitude and longitude

## 2.4 Prepare data in MySQL Workbench
The data contains over millions of ride records. MySQL Workbench is a good tool to work with the huge size data through this project.\
In this step:
1. Creating database and template table for loading files.
2. Importing data from the CSV files of each month.
3. Combining the 12 separate tables into one single table.

After above, it's ready for PROCESS.\
**MySQL query**: [01 Data prepare](https://github.com/WJ-IIOI/Cyclistic_Bike_Share_Analysis_Using_MySQL_Tableau/blob/main/01_trip_2022_import.sql)




# **STEP 3 PROCESS – From dirty to clean**


# **STEP 4 ANALYZE – Find the insights**


# **STEP 5 SHARE –  Visualizing findings**


# **STEP 6 ACT – Conclusions from the analysis**

## 6.1 Futher thinkings
* More bikes?
* More stations?

```
Hello, world!
```
