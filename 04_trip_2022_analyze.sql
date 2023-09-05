-- Step 6
-- Data analysis

SELECT 
    *
FROM
    trip_2022_cleaned;


-- Sum no. of member_casual and caculate each percentage
-- member 3271029
-- casual 2268343
SELECT 
    member_casual,
    COUNT(*) AS total,
    ROUND((COUNT(*) / (SELECT 
                    COUNT(*)
                FROM
                    trip_2022_cleaned)) * 100,
            2) AS pct
FROM
    trip_2022_cleaned
GROUP BY member_casual;


-- Sum No. of each bike types users 
SELECT 
    rideable_type,
    member_casual,
    COUNT(*) AS total,
    ROUND((COUNT(*) / (SELECT 
                    COUNT(*)
                FROM
                    trip_2022_cleaned)) * 100,
            2) AS pct
FROM
    trip_2022_cleaned
GROUP BY rideable_type , member_casual
ORDER BY 3 DESC;


-- Per ride_length of member_casual
SELECT 
    MAX(ride_length) AS max_len,
    MIN(ride_length) AS min_len,
    AVG(ride_length) / 60 AS avg_ride_length
FROM
    trip_2022_cleaned;


-- Ride length time format by member_casual
SELECT 
    member_casual,
    MAX(ride_length) AS max_len,
    MIN(ride_length) AS min_len,
    ROUND(AVG(ride_length) / 60) AS avg_ride_length,
    SEC_TO_TIME(ROUND(AVG(ride_length), 0)) AS avg_ride_length_01,
    TIME_FORMAT(SEC_TO_TIME(AVG(ride_length)),
            '%H:%i:%s') AS avg_ride_length_02
FROM
    trip_2022_cleaned
GROUP BY member_casual
;


-- caculate total users and avg_ride_length of each month
SELECT 
    EXTRACT(MONTH FROM started_at) AS month,
    member_casual,
    COUNT(*) AS users,
    ROUND(AVG(ride_length) / 60, 2) AS avg_ride_length
FROM
    trip_2022_cleaned
GROUP BY 2 , 1
;


-- caculate total users and avg_ride_length of each weekday
SELECT 
    WEEKDAY(started_at) AS weekday,
    member_casual,
    COUNT(*) AS users,
    ROUND(AVG(ride_length) / 60, 2) AS avg_ride_length
FROM
    trip_2022_cleaned
GROUP BY 2 , 1
ORDER BY 1 , 2
;


-- caculate total users and avg_ride_length of every hour
SELECT 
    EXTRACT(HOUR FROM started_at) AS hour,
    member_casual,
    COUNT(*) AS users,
    ROUND(AVG(ride_length) / 60, 2) AS avg_ride_length
FROM
    trip_2022_cleaned
GROUP BY 2 , 1
ORDER BY 1 , 2
;
 
-- ##############################################################
-- Station analysis
-- Total 1541 different stations
SELECT 
    start_station_name, COUNT(*)
FROM
    trip_2022_cleaned
GROUP BY start_station_name
ORDER BY 2 DESC
;


-- Check the top 20 statt and end stations
-- Top 20 start stations of total rides
SELECT 
   ROW_NUMBER() OVER (ORDER BY count(*) DESC) AS top_20,
   start_station_name,
   count(*) AS total_rides
FROM trip_2022_cleaned
GROUP BY 2
ORDER BY 3 DESC
LIMIT 20
;


-- Top 20 end stations of total rides
SELECT 
   ROW_NUMBER() OVER (ORDER BY count(*) DESC) AS top_20,
   end_station_name,
   count(*) AS total_rides
FROM trip_2022_cleaned
GROUP BY 2
ORDER BY 3 DESC
LIMIT 20
;
-- The top 20 start and end station by total rides are almost same,
-- because the number of the total rides are very close,
-- only the ranking of some stations are slightly different. 


-- Top 10 stations by members, using ROW_NUMBER() function
SELECT 
   ROW_NUMBER() OVER (ORDER BY count(*) DESC) AS top_10,
   member_casual,
   start_station_name,
   count(*) AS users
FROM trip_2022_cleaned
WHERE member_casual = 'member'
GROUP BY 3, 2
ORDER BY 4 DESC
LIMIT 10
;


-- Top 10 users stations by casuals, using RANK() function
SELECT 
   RANK() OVER (ORDER BY count(*) DESC) AS top_10,
   member_casual,
   start_station_name,
   count(*) AS users
FROM trip_2022_cleaned
WHERE member_casual = 'casual'
GROUP BY 3, 2
ORDER BY 4 DESC
LIMIT 10
;


-- Finding top10 stations by a specific datetimeframe 
SELECT 
   RANK() OVER (ORDER BY count(*) DESC) AS top_10,
   EXTRACT(MONTH FROM started_at) AS month,
   member_casual,
   start_station_name,
   count(*) AS users
FROM trip_2022_cleaned
WHERE 
   member_casual = 'casual'
   AND EXTRACT(MONTH FROM started_at) = 7	
GROUP BY 3, 2, 4
ORDER BY 5 DESC
LIMIT 10
;


-- Checking for the null values of start_station name and id whether same
-- start_station total 833064
-- end_station total 892742
-- end_lat, end_lng total 5858
SELECT 
   start_station_name,
   end_station_name,
   start_lat,
   start_lng,
   end_lat,
   end_lng
FROM
   trip_2022_cleaned
WHERE
    start_station_name IS NULL
        AND start_lat = 41.7900
        AND start_lng = - 87.6;
    -- start_station_id is NULL
SELECT 
    COUNT(TRIM(start_station_name))
FROM
    trip_2022_cleaned
GROUP BY TRIM(start_station_name)
ORDER BY 1 DESC;

-- ##############################################################
-- geographic latitude and longitude not all match the station location
-- find each station its most count latitude and longitude, it should be the right station location
-- both update the start and end stations 

SELECT
   start_station_name,
   start_lat,
   start_lng
FROM (
	SELECT 
   start_station_name,
   start_lat,
   start_lng,
   count(*) AS ride_num,
   -- Use PARTITION BY function to rank num of the lat&lng by each station
   ROW_NUMBER() OVER(PARTITION BY start_station_name ORDER BY count(*) DESC) AS top
   FROM trip_2022_cleaned
   GROUP BY
   start_station_name,
   start_lat,
   start_lng
	ORDER BY 
   start_station_name,
   count(*) DESC
   ) AS sgeo
-- Find the rank 1 of each station which means the most useful location
WHERE top = 1
ORDER BY ride_num DESC
INTO OUTFILE 'F:/CS/01_Data_analysis/03_Project/01_bike_share_20230725/01data/trip_2022_start_lat_lng_cleaned.csv' 
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
;


SELECT
   end_station_name,
   end_lat,
   end_lng
FROM (
   SELECT 
   end_station_name,
   end_lat,
   end_lng,
   count(*) AS ride_num,
   -- Use PARTITION BY function to rank num of the lat&lng by each station
   ROW_NUMBER() OVER(PARTITION BY end_station_name ORDER BY count(*) DESC) AS top
   FROM trip_2022_cleaned
   GROUP BY
   end_station_name,
   end_lat,
   end_lng
   ORDER BY 
   end_station_name,
   count(*) DESC
   ) AS sgeo
-- Find the rank 1 of each station which means the most useful location
WHERE top = 1
ORDER BY ride_num DESC
INTO OUTFILE 'F:/CS/01_Data_analysis/03_Project/01_bike_share_20230725/01data/trip_2022_end_lat_lng_cleaned.csv' 
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
;




