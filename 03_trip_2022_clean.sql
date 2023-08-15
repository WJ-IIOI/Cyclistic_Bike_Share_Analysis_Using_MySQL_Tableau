-- #########################################################
-- Step 5
-- Create cleaned data table for analysis
DROP TABLE IF EXISTS bike_share_2023_07.trip_2022_cleaned;

-- Creating new table with cleaned data
-- Add new column called ride_length
-- Add new column called month for ride month
-- Add new column called day_of_week for ride weekday
-- Exclude NULL values of lat, lng of start and end
-- Exclude ride_length > 1day and < 1 min
CREATE TABLE IF NOT EXISTS bike_share_2023_07.trip_2022_cleaned AS (SELECT ride_id,
    rideable_type,
    started_at,
    ended_at,
    TIME_TO_SEC(TIMEDIFF(ended_at, started_at)) AS ride_length,
    start_station_name,
    end_station_name,
    start_lat,
    start_lng,
    end_lat,
    end_lng,
    member_casual FROM
    bike_share_2023_07.trip_2022
WHERE
    start_station_name IS NOT NULL
    AND start_station_id IS NOT NULL
    AND end_station_id IS NOT NULL
    AND end_station_id IS NOT NULL
    AND end_lat IS NOT NULL
    AND end_lng IS NOT NULL
    AND TIMEDIFF(ended_at, started_at) < TIME('24:00:00')
    AND TIMEDIFF(ended_at, started_at) > TIME('00:01:00'));   

-- Total 4921805 rows clean data for analysis
SELECT count(*) FROM trip_2022_cleaned;
		
-- Check rows which ride_length > 1day and < 1 min, expect none
SELECT 
    *
FROM
    bike_share_2023_07.test_cleaned
WHERE
    ride_length > TIME('24:00:00')
	AND ride_length < TIME('00:01:00');
		
-- Check null values of all columns
-- Null values of station_names are acceptable for analysis
SELECT 
    SUM(ISNULL(ride_id)) ride_id,
    SUM(ISNULL(rideable_type)) rideable_type,
    SUM(ISNULL(started_at)) started_at,
    SUM(ISNULL(ended_at)) ended_at,
    SUM(ISNULL(ride_length)) ride_length,
    SUM(ISNULL(start_station_name)) start_station_name,
    SUM(ISNULL(end_station_name)) end_station_name,
    SUM(ISNULL(start_lat)) start_lat,
    SUM(ISNULL(start_lng)) start_lng,
    SUM(ISNULL(end_lat)) end_lat,
    SUM(ISNULL(end_lng)) end_lng,
    SUM(ISNULL(member_casual)) member_casual
FROM
    trip_2022_cleaned;            


-- ---------------------------------------------------------
-- #########################################################
-- ---------------------------------------------------------

-- Export big data to csv file fast with command lines for visualization
-- Normaliy without headers, must select hears strings union whole table
SELECT 
	'ride_id', 
    'rideable_type', 
    'started_at', 
    'ended_at', 
    'ride_length', 
    -- 'month', 
    -- 'day_of_week', 
    'start_station_name', 
    'end_station_name', 
    'start_lat', 
    'start_lng', 
    'end_lat', 
    'end_lng', 
    'member_casual'
    -- 'ride_secs'
UNION ALL
SELECT *
FROM trip_2022_cleaned
INTO OUTFILE 
'F:/CS/01_Data_analysis/03_Project/01_bike_share_20230725/01data/trip_2022_cleaned.csv'
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
;
