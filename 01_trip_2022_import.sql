-- Lat's get etared

-- ==============================================================
-- # 1 STEP 
-- Create table structure
-- ==============================================================

-- Create a tmplate table structure for January
DROP TABLE IF EXISTS trip_202201;
CREATE TABLE IF NOT EXISTS trip_202201
(
    ride_id VARCHAR(50),
    rideable_type VARCHAR(50),
    started_at DATETIME,
    ended_at DATETIME,
    start_station_name VARCHAR(255),
    start_station_id VARCHAR(50),
    end_station_name VARCHAR(255),
    end_station_id VARCHAR(50),
    start_lat VARCHAR(50),
    start_lng VARCHAR(50),
    end_lat VARCHAR(50),
    end_lng VARCHAR(50),
    member_casual VARCHAR(10)
)  
ENGINE=INNODB DEFAULT CHARSET=UTF8MB4 COLLATE = UTF8MB4_0900_AI_CI
;

-- Check table structrue
SELECT * FROM bike_share_2023_07.trip_202201;
SHOW CREATE TABLE trip_202201;

-- copy template table for another 11 months
DROP TABLE IF EXISTS trip_202202;
CREATE TABLE IF NOT EXISTS trip_202202 LIKE trip_202201;
DROP TABLE IF EXISTS trip_202203;
CREATE TABLE IF NOT EXISTS trip_202203 LIKE trip_202201;
DROP TABLE IF EXISTS trip_202204;
CREATE TABLE IF NOT EXISTS trip_202204 LIKE trip_202201;
DROP TABLE IF EXISTS trip_202205;
CREATE TABLE IF NOT EXISTS trip_202205 LIKE trip_202201;
DROP TABLE IF EXISTS trip_202206;
CREATE TABLE IF NOT EXISTS trip_202206 LIKE trip_202201;
DROP TABLE IF EXISTS trip_202207;
CREATE TABLE IF NOT EXISTS trip_202207 LIKE trip_202201;
DROP TABLE IF EXISTS trip_202208;
CREATE TABLE IF NOT EXISTS trip_202208 LIKE trip_202201;
DROP TABLE IF EXISTS trip_202209;
CREATE TABLE IF NOT EXISTS trip_202209 LIKE trip_202201;
DROP TABLE IF EXISTS trip_202210;
CREATE TABLE IF NOT EXISTS trip_202210 LIKE trip_202201;
DROP TABLE IF EXISTS trip_202211;
CREATE TABLE IF NOT EXISTS trip_202211 LIKE trip_202201;
DROP TABLE IF EXISTS trip_202212;
CREATE TABLE IF NOT EXISTS trip_202212 LIKE trip_202201;


-- ==============================================================
-- # 2 STEP 
-- Import data from 12 CSV files
-- ==============================================================

-- JAN
LOAD DATA INFILE 'F:/CS/01_Data_analysis/03_Project/01_bike_share_202307/01data/202201-divvy-tripdata.csv' 
INTO TABLE trip_202201
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@ride_id, @rideable_type, @started_at, @ended_at, @start_station_name, @start_station_id, @end_station_name, @end_station_id, @start_lat, @start_lng, @end_lat, @end_lng, @member_casual)
SET ride_id = if(@ride_id = ' ', NULL, @ride_id),
    rideable_type = if(@rideable_type = '', NULL, @rideable_type), 
    started_at = if(@started_at = '', NULL, @started_at), 
    ended_at = if(@ended_at = '', NULL, @ended_at), 
    start_station_name = if(@start_station_name = '', NULL, @start_station_name), 
    start_station_id = if(@start_station_id = '', NULL, @start_station_id), 
    end_station_name = if(@end_station_name = '', NULL, @end_station_name), 
    end_station_id = if(@end_station_id = '', NULL, @end_station_id), 
    start_lat = if(@start_lat = '', NULL, @start_lat), 
    start_lng = if(@start_lng = '', NULL, @start_lng), 
    end_lat = if(@end_lat = '', NULL, @end_lat), 
    end_lng = if(@end_lng = '', NULL, @end_lng), 
    member_casual = if(@member_casual = '', NULL, @member_casual)
    ;

-- FEB
LOAD DATA INFILE 'F:/CS/01_Data_analysis/03_Project/01_bike_share_202307/01data/202202-divvy-tripdata.csv' 
INTO TABLE trip_202202
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@ride_id, @rideable_type, @started_at, @ended_at, @start_station_name, @start_station_id, @end_station_name, @end_station_id, @start_lat, @start_lng, @end_lat, @end_lng, @member_casual)
SET ride_id = if(@ride_id = ' ', NULL, @ride_id),
    rideable_type = if(@rideable_type = '', NULL, @rideable_type), 
    started_at = if(@started_at = '', NULL, @started_at), 
    ended_at = if(@ended_at = '', NULL, @ended_at), 
    start_station_name = if(@start_station_name = '', NULL, @start_station_name), 
    start_station_id = if(@start_station_id = '', NULL, @start_station_id), 
    end_station_name = if(@end_station_name = '', NULL, @end_station_name), 
    end_station_id = if(@end_station_id = '', NULL, @end_station_id), 
    start_lat = if(@start_lat = '', NULL, @start_lat), 
    start_lng = if(@start_lng = '', NULL, @start_lng), 
    end_lat = if(@end_lat = '', NULL, @end_lat), 
    end_lng = if(@end_lng = '', NULL, @end_lng), 
    member_casual = if(@member_casual = '', NULL, @member_casual)
    ;

-- MAR 
LOAD DATA INFILE 'F:/CS/01_Data_analysis/03_Project/01_bike_share_202307/01data/202203-divvy-tripdata.csv' 
INTO TABLE trip_202203
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@ride_id, @rideable_type, @started_at, @ended_at, @start_station_name, @start_station_id, @end_station_name, @end_station_id, @start_lat, @start_lng, @end_lat, @end_lng, @member_casual)
SET ride_id = if(@ride_id = ' ', NULL, @ride_id),
    rideable_type = if(@rideable_type = '', NULL, @rideable_type), 
    started_at = if(@started_at = '', NULL, @started_at), 
    ended_at = if(@ended_at = '', NULL, @ended_at), 
    start_station_name = if(@start_station_name = '', NULL, @start_station_name), 
    start_station_id = if(@start_station_id = '', NULL, @start_station_id), 
    end_station_name = if(@end_station_name = '', NULL, @end_station_name), 
    end_station_id = if(@end_station_id = '', NULL, @end_station_id), 
    start_lat = if(@start_lat = '', NULL, @start_lat), 
    start_lng = if(@start_lng = '', NULL, @start_lng), 
    end_lat = if(@end_lat = '', NULL, @end_lat), 
    end_lng = if(@end_lng = '', NULL, @end_lng), 
    member_casual = if(@member_casual = '', NULL, @member_casual)
    ;

-- APR
LOAD DATA INFILE 'F:/CS/01_Data_analysis/03_Project/01_bike_share_202307/01data/202204-divvy-tripdata.csv' 
INTO TABLE trip_202204
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@ride_id, @rideable_type, @started_at, @ended_at, @start_station_name, @start_station_id, @end_station_name, @end_station_id, @start_lat, @start_lng, @end_lat, @end_lng, @member_casual)
SET ride_id = if(@ride_id = ' ', NULL, @ride_id),
    rideable_type = if(@rideable_type = '', NULL, @rideable_type), 
    started_at = if(@started_at = '', NULL, @started_at), 
    ended_at = if(@ended_at = '', NULL, @ended_at), 
    start_station_name = if(@start_station_name = '', NULL, @start_station_name), 
    start_station_id = if(@start_station_id = '', NULL, @start_station_id), 
    end_station_name = if(@end_station_name = '', NULL, @end_station_name), 
    end_station_id = if(@end_station_id = '', NULL, @end_station_id), 
    start_lat = if(@start_lat = '', NULL, @start_lat), 
    start_lng = if(@start_lng = '', NULL, @start_lng), 
    end_lat = if(@end_lat = '', NULL, @end_lat), 
    end_lng = if(@end_lng = '', NULL, @end_lng), 
    member_casual = if(@member_casual = '', NULL, @member_casual)
    ;

-- MAY
LOAD DATA INFILE 'F:/CS/01_Data_analysis/03_Project/01_bike_share_202307/01data/202205-divvy-tripdata.csv' 
INTO TABLE trip_202205
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@ride_id, @rideable_type, @started_at, @ended_at, @start_station_name, @start_station_id, @end_station_name, @end_station_id, @start_lat, @start_lng, @end_lat, @end_lng, @member_casual)
SET ride_id = if(@ride_id = ' ', NULL, @ride_id),
    rideable_type = if(@rideable_type = '', NULL, @rideable_type), 
    started_at = if(@started_at = '', NULL, @started_at), 
    ended_at = if(@ended_at = '', NULL, @ended_at), 
    start_station_name = if(@start_station_name = '', NULL, @start_station_name), 
    start_station_id = if(@start_station_id = '', NULL, @start_station_id), 
    end_station_name = if(@end_station_name = '', NULL, @end_station_name), 
    end_station_id = if(@end_station_id = '', NULL, @end_station_id), 
    start_lat = if(@start_lat = '', NULL, @start_lat), 
    start_lng = if(@start_lng = '', NULL, @start_lng), 
    end_lat = if(@end_lat = '', NULL, @end_lat), 
    end_lng = if(@end_lng = '', NULL, @end_lng), 
    member_casual = if(@member_casual = '', NULL, @member_casual)
    ;

-- JUN
LOAD DATA INFILE 'F:/CS/01_Data_analysis/03_Project/01_bike_share_202307/01data/202206-divvy-tripdata.csv' 
INTO TABLE trip_202206
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@ride_id, @rideable_type, @started_at, @ended_at, @start_station_name, @start_station_id, @end_station_name, @end_station_id, @start_lat, @start_lng, @end_lat, @end_lng, @member_casual)
SET ride_id = if(@ride_id = ' ', NULL, @ride_id),
    rideable_type = if(@rideable_type = '', NULL, @rideable_type), 
    started_at = if(@started_at = '', NULL, @started_at), 
    ended_at = if(@ended_at = '', NULL, @ended_at), 
    start_station_name = if(@start_station_name = '', NULL, @start_station_name), 
    start_station_id = if(@start_station_id = '', NULL, @start_station_id), 
    end_station_name = if(@end_station_name = '', NULL, @end_station_name), 
    end_station_id = if(@end_station_id = '', NULL, @end_station_id), 
    start_lat = if(@start_lat = '', NULL, @start_lat), 
    start_lng = if(@start_lng = '', NULL, @start_lng), 
    end_lat = if(@end_lat = '', NULL, @end_lat), 
    end_lng = if(@end_lng = '', NULL, @end_lng), 
    member_casual = if(@member_casual = '', NULL, @member_casual)
    ;

-- JUL
LOAD DATA INFILE 'F:/CS/01_Data_analysis/03_Project/01_bike_share_202307/01data/202207-divvy-tripdata.csv' 
INTO TABLE trip_202207
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@ride_id, @rideable_type, @started_at, @ended_at, @start_station_name, @start_station_id, @end_station_name, @end_station_id, @start_lat, @start_lng, @end_lat, @end_lng, @member_casual)
SET ride_id = if(@ride_id = ' ', NULL, @ride_id),
    rideable_type = if(@rideable_type = '', NULL, @rideable_type), 
    started_at = if(@started_at = '', NULL, @started_at), 
    ended_at = if(@ended_at = '', NULL, @ended_at), 
    start_station_name = if(@start_station_name = '', NULL, @start_station_name), 
    start_station_id = if(@start_station_id = '', NULL, @start_station_id), 
    end_station_name = if(@end_station_name = '', NULL, @end_station_name), 
    end_station_id = if(@end_station_id = '', NULL, @end_station_id), 
    start_lat = if(@start_lat = '', NULL, @start_lat), 
    start_lng = if(@start_lng = '', NULL, @start_lng), 
    end_lat = if(@end_lat = '', NULL, @end_lat), 
    end_lng = if(@end_lng = '', NULL, @end_lng), 
    member_casual = if(@member_casual = '', NULL, @member_casual)
    ;

-- AUG
LOAD DATA INFILE 'F:/CS/01_Data_analysis/03_Project/01_bike_share_202307/01data/202208-divvy-tripdata.csv' 
INTO TABLE trip_202208
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@ride_id, @rideable_type, @started_at, @ended_at, @start_station_name, @start_station_id, @end_station_name, @end_station_id, @start_lat, @start_lng, @end_lat, @end_lng, @member_casual)
SET ride_id = if(@ride_id = ' ', NULL, @ride_id),
    rideable_type = if(@rideable_type = '', NULL, @rideable_type), 
    started_at = if(@started_at = '', NULL, @started_at), 
    ended_at = if(@ended_at = '', NULL, @ended_at), 
    start_station_name = if(@start_station_name = '', NULL, @start_station_name), 
    start_station_id = if(@start_station_id = '', NULL, @start_station_id), 
    end_station_name = if(@end_station_name = '', NULL, @end_station_name), 
    end_station_id = if(@end_station_id = '', NULL, @end_station_id), 
    start_lat = if(@start_lat = '', NULL, @start_lat), 
    start_lng = if(@start_lng = '', NULL, @start_lng), 
    end_lat = if(@end_lat = '', NULL, @end_lat), 
    end_lng = if(@end_lng = '', NULL, @end_lng), 
    member_casual = if(@member_casual = '', NULL, @member_casual)
    ;

-- SEP
LOAD DATA INFILE 'F:/CS/01_Data_analysis/03_Project/01_bike_share_202307/01data/202209-divvy-tripdata.csv' 
INTO TABLE trip_202209
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@ride_id, @rideable_type, @started_at, @ended_at, @start_station_name, @start_station_id, @end_station_name, @end_station_id, @start_lat, @start_lng, @end_lat, @end_lng, @member_casual)
SET ride_id = if(@ride_id = ' ', NULL, @ride_id),
    rideable_type = if(@rideable_type = '', NULL, @rideable_type), 
    started_at = if(@started_at = '', NULL, @started_at), 
    ended_at = if(@ended_at = '', NULL, @ended_at), 
    start_station_name = if(@start_station_name = '', NULL, @start_station_name), 
    start_station_id = if(@start_station_id = '', NULL, @start_station_id), 
    end_station_name = if(@end_station_name = '', NULL, @end_station_name), 
    end_station_id = if(@end_station_id = '', NULL, @end_station_id), 
    start_lat = if(@start_lat = '', NULL, @start_lat), 
    start_lng = if(@start_lng = '', NULL, @start_lng), 
    end_lat = if(@end_lat = '', NULL, @end_lat), 
    end_lng = if(@end_lng = '', NULL, @end_lng), 
    member_casual = if(@member_casual = '', NULL, @member_casual)
    ;

-- OCT
LOAD DATA INFILE 'F:/CS/01_Data_analysis/03_Project/01_bike_share_202307/01data/202210-divvy-tripdata.csv' 
INTO TABLE trip_202210
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@ride_id, @rideable_type, @started_at, @ended_at, @start_station_name, @start_station_id, @end_station_name, @end_station_id, @start_lat, @start_lng, @end_lat, @end_lng, @member_casual)
SET ride_id = if(@ride_id = ' ', NULL, @ride_id),
    rideable_type = if(@rideable_type = '', NULL, @rideable_type), 
    started_at = if(@started_at = '', NULL, @started_at), 
    ended_at = if(@ended_at = '', NULL, @ended_at), 
    start_station_name = if(@start_station_name = '', NULL, @start_station_name), 
    start_station_id = if(@start_station_id = '', NULL, @start_station_id), 
    end_station_name = if(@end_station_name = '', NULL, @end_station_name), 
    end_station_id = if(@end_station_id = '', NULL, @end_station_id), 
    start_lat = if(@start_lat = '', NULL, @start_lat), 
    start_lng = if(@start_lng = '', NULL, @start_lng), 
    end_lat = if(@end_lat = '', NULL, @end_lat), 
    end_lng = if(@end_lng = '', NULL, @end_lng), 
    member_casual = if(@member_casual = '', NULL, @member_casual)
    ;

-- NOV
LOAD DATA INFILE 'F:/CS/01_Data_analysis/03_Project/01_bike_share_202307/01data/202211-divvy-tripdata.csv' 
INTO TABLE trip_202211
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@ride_id, @rideable_type, @started_at, @ended_at, @start_station_name, @start_station_id, @end_station_name, @end_station_id, @start_lat, @start_lng, @end_lat, @end_lng, @member_casual)
SET ride_id = if(@ride_id = ' ', NULL, @ride_id),
    rideable_type = if(@rideable_type = '', NULL, @rideable_type), 
    started_at = if(@started_at = '', NULL, @started_at), 
    ended_at = if(@ended_at = '', NULL, @ended_at), 
    start_station_name = if(@start_station_name = '', NULL, @start_station_name), 
    start_station_id = if(@start_station_id = '', NULL, @start_station_id), 
    end_station_name = if(@end_station_name = '', NULL, @end_station_name), 
    end_station_id = if(@end_station_id = '', NULL, @end_station_id), 
    start_lat = if(@start_lat = '', NULL, @start_lat), 
    start_lng = if(@start_lng = '', NULL, @start_lng), 
    end_lat = if(@end_lat = '', NULL, @end_lat), 
    end_lng = if(@end_lng = '', NULL, @end_lng), 
    member_casual = if(@member_casual = '', NULL, @member_casual)
    ;

-- DEC
LOAD DATA INFILE 'F:/CS/01_Data_analysis/03_Project/01_bike_share_202307/01data/202212-divvy-tripdata.csv' 
INTO TABLE trip_202212
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@ride_id, @rideable_type, @started_at, @ended_at, @start_station_name, @start_station_id, @end_station_name, @end_station_id, @start_lat, @start_lng, @end_lat, @end_lng, @member_casual)
SET ride_id = if(@ride_id = ' ', NULL, @ride_id),
    rideable_type = if(@rideable_type = '', NULL, @rideable_type), 
    started_at = if(@started_at = '', NULL, @started_at), 
    ended_at = if(@ended_at = '', NULL, @ended_at), 
    start_station_name = if(@start_station_name = '', NULL, @start_station_name), 
    start_station_id = if(@start_station_id = '', NULL, @start_station_id), 
    end_station_name = if(@end_station_name = '', NULL, @end_station_name), 
    end_station_id = if(@end_station_id = '', NULL, @end_station_id), 
    start_lat = if(@start_lat = '', NULL, @start_lat), 
    start_lng = if(@start_lng = '', NULL, @start_lng), 
    end_lat = if(@end_lat = '', NULL, @end_lat), 
    end_lng = if(@end_lng = '', NULL, @end_lng), 
    member_casual = if(@member_casual = '', NULL, @member_casual)
    ;

-- Double check the first and last month table to confirm loading properly
SELECT *
FROM trip_202201;

SELECT *
FROM trip_202212;


-- ==============================================================
-- # 3 STEP
-- Combine 12 month tables into a single main table
-- ==============================================================

-- Combine tables by using UNION ALL command
DROP TABLE IF EXISTS trip_2022;
CREATE TABLE if NOT EXISTS trip_2022 AS (
    SELECT * FROM bike_share_2023_07.trip_202201
    UNION ALL
    SELECT * FROM bike_share_2023_07.trip_202202
    UNION ALL
    SELECT * FROM bike_share_2023_07.trip_202203
    UNION ALL
    SELECT * FROM bike_share_2023_07.trip_202204
    UNION ALL
    SELECT * FROM bike_share_2023_07.trip_202205
    UNION ALL
    SELECT * FROM bike_share_2023_07.trip_202206
    UNION ALL
    SELECT * FROM bike_share_2023_07.trip_202207
    UNION ALL
    SELECT * FROM bike_share_2023_07.trip_202208
    UNION ALL
    SELECT * FROM bike_share_2023_07.trip_202209
    UNION ALL
    SELECT * FROM bike_share_2023_07.trip_202210
    UNION ALL
    SELECT * FROM bike_share_2023_07.trip_202211
    UNION ALL
    SELECT * FROM bike_share_2023_07.trip_202212
);

-- Mian table has total 5667717 rows  
SELECT count(*) FROM bike_share_2023_07.trip_2022;

-- Count # rows of each month
SELECT MAX(month(started_at)) AS date_month, count(*) FROM bike_share_2023_07.trip_202201
UNION ALL
SELECT MAX(month(started_at)) AS date_month, count(*) FROM bike_share_2023_07.trip_202202
UNION ALL
SELECT MAX(month(started_at)) AS date_month, count(*) FROM bike_share_2023_07.trip_202203
UNION ALL
SELECT MAX(month(started_at)) AS date_month, count(*) FROM bike_share_2023_07.trip_202204
UNION ALL
SELECT MAX(month(started_at)) AS date_month, count(*) FROM bike_share_2023_07.trip_202205
UNION ALL
SELECT MAX(month(started_at)) AS date_month, count(*) FROM bike_share_2023_07.trip_202206
UNION ALL
SELECT MAX(month(started_at)) AS date_month, count(*) FROM bike_share_2023_07.trip_202207
UNION ALL
SELECT MAX(month(started_at)) AS date_month, count(*) FROM bike_share_2023_07.trip_202208
UNION ALL
SELECT MAX(month(started_at)) AS date_month, count(*) FROM bike_share_2023_07.trip_202209
UNION ALL
SELECT MAX(month(started_at)) AS date_month, count(*) FROM bike_share_2023_07.trip_202210
UNION ALL
SELECT MAX(month(started_at)) AS date_month, count(*) FROM bike_share_2023_07.trip_202211
UNION ALL
SELECT MAX(month(started_at)) AS date_month, count(*) FROM bike_share_2023_07.trip_202212;


-- ===================================================================
-- -------------------------------------------------------------------
-- It's ready for data cleaning
-- -------------------------------------------------------------------
-- ===================================================================