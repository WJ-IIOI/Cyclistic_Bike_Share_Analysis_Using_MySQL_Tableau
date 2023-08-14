-- #########################################################
-- # 4 STEP
-- Query data

-- Checking for number of null values in all columns
-- start_station total 833064
-- end_station total 892742
-- end_lat, end_lng total 5858
-- 7.672 sec duration
SELECT 
	COUNT(*) - COUNT(ride_id) ride_id,
	COUNT(*) - COUNT(rideable_type) rideable_type,
	COUNT(*) - COUNT(started_at) started_at,
	COUNT(*) - COUNT(ended_at) ended_at,
	COUNT(*) - COUNT(start_station_name) start_station_name,
	COUNT(*) - COUNT(start_station_id) start_station_id,
	COUNT(*) - COUNT(end_station_name) end_station_name,
	COUNT(*) - COUNT(end_station_id) end_station_id,
	COUNT(*) - COUNT(start_lat) start_lat,
	COUNT(*) - COUNT(start_lng) start_lng,
	COUNT(*) - COUNT(end_lat) end_lat,
	COUNT(*) - COUNT(end_lng) end_lng,
	COUNT(*) - COUNT(member_casual) member_casual
FROM `trip_2022`;

-- OR use sum(isnull()) to count total null values
-- 9.5 sec duration
SELECT 
	sum(isnull(ride_id)) ride_id,
	sum(isnull(rideable_type)) rideable_type,
	sum(isnull(started_at)) started_at,
	sum(isnull(ended_at)) ended_at,
	sum(isnull(start_station_name)) start_station_name,
	sum(isnull(start_station_id)) start_station_id,
	sum(isnull(end_station_name)) end_station_name,
	sum(isnull(end_station_id)) end_station_id,
	sum(isnull(start_lat)) start_lat,
	sum(isnull(start_lng)) start_lng,
	sum(isnull(end_lat)) end_lat,
	sum(isnull(end_lng)) end_lng,
	sum(isnull(member_casual)) member_casual
FROM `trip_2022`;

-- Checking for the null values of start_station name and id whether same
-- start_station total 833064
-- end_station total 892742
-- end_lat, end_lng total 5858
SELECT 
	start_station_name,
	start_station_id,
	end_station_name, 
	end_station_id,
	end_lat,
	end_lng
FROM trip_2022
WHERE 
	start_station_name is NULL 
	AND start_station_id is NULL 
	AND end_station_name is NULL 
	AND end_station_id is NULL 
	AND end_lat is NULL 
	AND end_lng is NULL;
    

-- Checking for the null values of start_station name and id whether same
-- start_station total 833064
-- end_station total 892742
-- end_lat, end_lng total 5858
-- 126449 ride_length > 1day and < 1 min
-- Most NULL station name with same lat ane lng, which means no values, need to delete
SELECT 
	start_station_name,
	end_station_name, 
	start_lat,
	start_lng,
	end_lat,
	end_lng
FROM trip_2022
WHERE 
	start_station_name is NULL
	AND start_lat = 41.7900
	AND start_lng = -87.6;
-- start_station_id is NULL
-- end_station_name is NULL AND
-- end_station_id is NULL AND
-- end_lat is NULL AND
-- end_lng is NULL;
    
SELECT 
	timediff(ended_at, started_at) as ride_sec,
	start_station_name,
	end_station_name,
	end_lat,
	end_lng
FROM trip_2022
WHERE 
	timediff(ended_at, started_at) > TIME('24:00:00')
    	OR timediff(ended_at, started_at) < TIME('00:01:00')
ORDER BY 1 DESC;


-- Checking for duplicate rows
SELECT 
   	-- COUNT(DISTINCT ride_id) AS unique_ride_id,
    COUNT(ride_id) - COUNT(DISTINCT ride_id) AS duplicate_rows
FROM `trip_2022`;

-- ride_id - all have length of 16
SELECT LENGTH(ride_id) AS length_ride_id
FROM `trip_2022`
GROUP BY length_ride_id;


-- Caculate ride_length and sort them by descening
-- Check for trips which has duration longer than a day
-- and the trips having less than a minute duration 
-- or having end time earlier than start time so need to remove them 
SELECT started_at, ended_at, timediff(ended_at, started_at) 
FROM trip_2022
-- filter ride_length more than 1 day = 5360 rows
WHERE 
	timediff(ended_at, started_at) > TIME('24:00:00')
ORDER BY 3 DESC;

SELECT started_at, ended_at, timediff(ended_at, started_at) 
FROM trip_2022
-- filter ride_length more than 1 min = 121089 rows
WHERE 
	timediff(ended_at, started_at) < TIME('00:01:00')
ORDER BY 3 DESC;

-- 5156 rows 
SELECT timediff(ended_at, started_at), end_lat, end_lng
FROM trip_2022
WHERE 
	(timediff(ended_at, started_at) > TIME('24:00:00') 
	OR timediff(ended_at, started_at) < TIME('00:01:00'))
	AND (end_lat IS NULL AND end_lng IS NULL)
ORDER BY 1;


-- caculate the total people of member and casual, and percentage
SELECT 
	member_casual, 
	count(*) AS user,
	count(*) / (SELECT COUNT(*) FROM trip_2022) AS percentage
FROM trip_2022
GROUP BY member_casual;

