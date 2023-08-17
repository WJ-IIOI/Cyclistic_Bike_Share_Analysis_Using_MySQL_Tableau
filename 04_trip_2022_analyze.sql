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
-- geographic latitude and longitude not match the station_name
-- average all the latitude and longitude by same station, then sum the total users by station

SELECT 'start_station_name', 'lat', 'lng' 
UNION ALL SELECT 
    start_station_name, AVG(start_lat), AVG(start_lng)
FROM
    trip_2022_cleaned
GROUP BY start_station_name INTO OUTFILE 'F:/CS/01_Data_analysis/03_Project/01_bike_share_20230725/01data/trip_2022_lat_lng_cleaned.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '
'
;

SELECT 
    start_station_name, COUNT(*)
FROM
    trip_2022_cleaned
GROUP BY start_station_name
ORDER BY 2 DESC
;

SELECT 
    start_station_name, COUNT(*)
FROM
    trip_2022_cleaned
WHERE
    member_casual = 'member'
GROUP BY start_station_name
ORDER BY 2 DESC
;




