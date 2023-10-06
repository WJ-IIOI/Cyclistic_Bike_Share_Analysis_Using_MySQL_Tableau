-- ===================================================================
-- # 5 STEP
-- Data analysis
-- ===================================================================
-- 5.1 caculate number and proportion by user type
-- -------------------------------------------------------------------

-- caculate number and proportion by year
-- casual 1731089, 40.33%
-- member 2561457, 59.67%
SELECT 
    user_type,
    COUNT(*) AS rides,
    ROUND((COUNT(*) / (SELECT COUNT(*) FROM trip_2022_clean)) * 100, 2) AS pct
FROM trip_2022_clean
GROUP BY 1
;

-- caculate number and proportion by month
SELECT 
    EXTRACT(MONTH FROM started_at) AS month,
    user_type,
    COUNT(*) AS rides,
    ROUND((COUNT(*) / (SELECT COUNT(*) FROM trip_2022_clean)) * 100, 2) AS pct
FROM trip_2022_clean
GROUP BY 1 , 2
;

-- caculate number and proportion by weekday
SELECT 
    WEEKDAY(started_at) AS weekday,
    user_type,
    COUNT(*) AS rides,
    ROUND((COUNT(*) / (SELECT COUNT(*) FROM trip_2022_clean)) * 100, 2) AS pct
FROM trip_2022_clean
GROUP BY 1 , 2
ORDER BY 1 , 2
;

-- caculate number and proportion by hour
SELECT 
    HOUR(started_at) AS hour,
    user_type,
    COUNT(*) AS rides,
    ROUND((COUNT(*) / (SELECT COUNT(*) FROM trip_2022_clean)) * 100, 2) AS pct
FROM trip_2022_clean
GROUP BY 1 , 2
ORDER BY 1 , 2
;

-- ===================================================================
-- 5.2 caculate number and proportion by bike type
-- -------------------------------------------------------------------

-- caculate number and proportion by year
SELECT 
    bike_type,
    user_type,
    COUNT(*) AS rides,
    ROUND((COUNT(*) / (SELECT COUNT(*) FROMntrip_2022_clean)) * 100, 2) AS pct
FROM trip_2022_clean
GROUP BY 1 , 2
ORDER BY 3 DESC
;

-- caculate number and proportion by month
SELECT 
    EXTRACT(MONTH FROM started_at) AS month,
    bike_type,
    user_type,
    COUNT(*) AS rides,
    ROUND((COUNT(*) / (SELECT COUNT(*) FROM trip_2022_clean)) * 100, 2) AS pct
FROM trip_2022_clean
GROUP BY 1 , 2 , 3
;

-- ===================================================================
-- 5.3 caculate average ride length by user type
-- -------------------------------------------------------------------

-- caculate AVG ride_length of all rides 
-- 17.3 mins
SELECT 
    ROUND(MAX(TIME_TO_SEC(ride_length) / 60), 1) AS max_len,
    ROUND(MIN(TIME_TO_SEC(ride_length) / 60), 1) AS min_len,
    ROUND(AVG(TIME_TO_SEC(ride_length) / 60), 1) AS avg_len
FROM trip_2022_clean
;

-- caculate AVG ride_length of user type by 3 method
SELECT 
    user_type,
    ROUND(AVG(TIME_TO_SEC(ride_length) / 60), 1) AS avg_len,
    SEC_TO_TIME(ROUND(AVG(TIME_TO_SEC(ride_length)), 0)) AS avg_len_time,
    TIME_FORMAT(SEC_TO_TIME(AVG(TIME_TO_SEC(ride_length))), '%H:%i:%s') AS avg_len_format
FROM trip_2022_clean
GROUP BY 1
;

-- caculate total users and avg_ride_length of each month
SELECT 
    EXTRACT(MONTH FROM started_at) AS month,
    user_type,
    COUNT(*) AS rides,
    ROUND(AVG(TIME_TO_SEC(ride_length) / 60), 1) AS avg_len
FROM trip_2022_clean
GROUP BY 1 , 2
;

-- caculate total users and avg_ride_length of each weekday
SELECT 
    WEEKDAY(started_at) AS weekday,
    user_type,
    COUNT(*) AS rides,
    ROUND(AVG(TIME_TO_SEC(ride_length) / 60), 1) AS avg_len
FROM trip_2022_clean
GROUP BY 2 , 1
ORDER BY 1 , 2
;

-- caculate total users and avg_ride_length of every hour
SELECT 
    EXTRACT(HOUR FROM started_at) AS hour,
    user_type,
    COUNT(*) AS rides,
    ROUND(AVG(TIME_TO_SEC(ride_length) / 60), 1) AS avg_len
FROM trip_2022_clean
GROUP BY 2 , 1
ORDER BY 1 , 2
;
 
-- ===================================================================
-- 5.4 Analyze distribution of ride length by user type
-- -------------------------------------------------------------------

-- use case clause to aggregate distribution of ride length 
SELECT 
    user_type,
    (CASE
        WHEN ride_length <= 500 THEN '5min'
        WHEN ride_length > 500 AND ride_length <= 1000 THEN '10min'
        WHEN ride_length > 1000 AND ride_length <= 2000 THEN '20min'
        WHEN ride_length > 2000 AND ride_length <= 3000 THEN '30min'
        WHEN ride_length > 3000 AND ride_length <= 4000 THEN '40min'
        WHEN ride_length > 4000 AND ride_length <= 5000 THEN '50min'
        ELSE '60min'
    END) AS mins,
    COUNT(*) AS rides,
    ROUND((COUNT(*) / (SELECT COUNT(*) FROM trip_2022_clean)) * 100, 2) AS pct
FROM trip_2022_clean
GROUP BY 1 , 2
ORDER BY 2 , 1
;

-- ===================================================================
-- 5.5 Analyze the distribution of stations by user type
-- -------------------------------------------------------------------

-- calculate the number rides of each station by all users
-- total 1253 different stations
SELECT 
    ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) AS top,
    start_station_name,
    COUNT(*)
FROM trip_2022_clean
GROUP BY 2
ORDER BY 3 DESC
-- LIMIT 20
;

-- calculate the number rides and percentage of top 10 stations by user_type
WITH top_station AS
(
    SELECT 
        ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) AS top,
        start_station_name, 
        COUNT(*) AS count
    FROM trip_2022_clean
    GROUP BY 2
    ORDER BY 3 DESC
    LIMIT 10
)
SELECT
    t.top,
    u.start_station_name, 
    u.user_type,
    COUNT(*) AS rides,
    SUM(COUNT(*)) OVER (PARTITION BY u.start_station_name) AS subtotal,
    COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY u.start_station_name) AS sub_pct
FROM trip_2022_clean AS u
JOIN top_station AS t
ON u.start_station_name = t.start_station_name
GROUP BY 2, 3
ORDER BY 1, 2, 3
LIMIT 20
;

-- -------------------------------------------------------------------

-- compare top 10 start & end stations of total rides 
-- the top 10 start and end station by total rides are almost same
-- only the ranking of some stations are slightly different
-- but the number of the rides are very close
WITH end_station AS
(
    -- top 10 end stations of total rides
    SELECT 
        ROW_NUMBER() OVER (ORDER BY count(*) DESC) AS e_top,
        end_station_name,
        count(*) AS rides
    FROM trip_2022_clean
    GROUP BY 2
    ORDER BY 3 DESC
)
SELECT 
    ROW_NUMBER() OVER (ORDER BY count(*) DESC) AS s_top,
    s.start_station_name,
    count(*) AS rides,
    e.e_top,
    e.end_station_name,
    e.rides
FROM trip_2022_clean AS s
JOIN end_station AS e
ON s.start_station_name = e.end_station_name
GROUP BY 2
ORDER BY 1
LIMIT 10
;

-- compare top 10 start & end stations by casual users
WITH start_station AS
(
    SELECT 
        ROW_NUMBER() OVER (ORDER BY count(*) DESC) AS s_casual_top,
        start_station_name,
        count(*) AS rides
    FROM trip_2022_clean
    WHERE user_type = 'Casual'
    GROUP BY 2
    ORDER BY 3 DESC
),
end_station AS
(
    SELECT 
        ROW_NUMBER() OVER (ORDER BY count(*) DESC) AS e_casual_top,
        end_station_name,
        count(*) AS rides
    FROM trip_2022_clean
    WHERE user_type = 'Casual'
    GROUP BY 2
    ORDER BY 3 DESC
)
SELECT 
    s.s_casual_top,
    s.start_station_name,
    s.rides,
    e.e_casual_top,
    e.end_station_name,
    e.rides
FROM start_station AS s
JOIN end_station AS e
ON s.s_casual_top = e.e_casual_top
ORDER BY 1
LIMIT 20
;

-- -------------------------------------------------------------------
-- compare top 10 start stations by user_type 
WITH c_start_stations AS
(
    SELECT 
        ROW_NUMBER() OVER (ORDER BY count(*) DESC) AS c_top_10,
        user_type,
        start_station_name,
        count(*) AS rides
    FROM trip_2022_clean
    WHERE user_type = 'Casual'
    GROUP BY 2, 3
    ORDER BY 4 DESC
),
m_start_stations AS
(
    SELECT 
        ROW_NUMBER() OVER (ORDER BY count(*) DESC) AS m_top_10,
        user_type,
        start_station_name,
        count(*) AS rides
    FROM trip_2022_clean
    WHERE user_type = 'Member'
    GROUP BY 2, 3
    ORDER BY 4 DESC
)
SELECT 
    c.c_top_10,
    c.user_type,
    c.start_station_name,
    c.rides,
    m.m_top_10,
    m.user_type,
    m.start_station_name,
    m.rides
FROM c_start_stations AS c
JOIN m_start_stations AS m
ON c.c_top_10 = m.m_top_10
ORDER BY 1
LIMIT 10
;

-- same comparision of top 10 end stations by user_type
WITH c_end_stations AS
(
    SELECT 
        ROW_NUMBER() OVER (ORDER BY count(*) DESC) AS c_top_10,
        user_type,
        end_station_name,
        count(*) AS rides
    FROM trip_2022_clean
    WHERE user_type = 'Casual'
    GROUP BY 2, 3
    ORDER BY 4 DESC
),
m_end_stations AS
(
    SELECT 
        ROW_NUMBER() OVER (ORDER BY count(*) DESC) AS m_top_10,
        user_type,
        end_station_name,
        count(*) AS rides
    FROM trip_2022_clean
    WHERE user_type = 'Member'
    GROUP BY 2, 3
    ORDER BY 4 DESC
)
SELECT 
    c.c_top_10,
    c.user_type,
    c.end_station_name,
    c.rides,
    m.m_top_10,
    m.user_type,
    m.end_station_name,
    m.rides
FROM c_end_stations AS c
JOIN m_end_stations AS m
ON c.c_top_10 = m.m_top_10
ORDER BY 1
LIMIT 10
;

-- -------------------------------------------------------------------
-- find top 10 stations by a specific date time frame 
SELECT 
    ROW_NUMBER() OVER (ORDER BY count(*) DESC) AS top_10,
    EXTRACT(MONTH FROM started_at) AS month,
    WEEKDAY(started_at) AS weekday,
    HOUR(started_at) AS hour,
    user_type,
    start_station_name,
    count(*) AS rides
FROM trip_2022_clean
WHERE 
    user_type = 'Casual'
    AND EXTRACT(MONTH FROM started_at) = 8 -- 8 = August
    AND WEEKDAY(started_at)  = 0 -- 0 = Monday
    AND HOUR(started_at) = 11
GROUP BY 2, 3, 4, 5, 6
ORDER BY 7 DESC
LIMIT 10
;


-- ==============================================================
-- # 6 STEP
-- Export data for visulization
-- ==============================================================

-- Export data to CSV file fast with command lines 
SELECT 
    'ride_id',
    'bike_type',
    'started_at',
    'ended_at',
    'ride_length',
    'start_station_name',
    'start_station_id',
    'end_station_name',
    'end_station_id',
    'start_lat',
    'start_lng',
    'end_lat',
    'end_lng',
    'user_type'
UNION ALL 
SELECT *
FROM trip_2022_clean 
INTO OUTFILE 'F:/CS/01_Data_analysis/03_Project/01_bike_share_202307/01data/trip_2022_final.csv' 
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY ''
;


-- ===================================================================
-- -------------------------------------------------------------------
-- It's time for data visualization
-- -------------------------------------------------------------------
-- ===================================================================