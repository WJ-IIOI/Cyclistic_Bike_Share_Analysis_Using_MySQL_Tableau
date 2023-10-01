-- ===================================================================
-- # 4 STEP
-- Clean data
-- ===================================================================
-- 4.1 Backup data from original table for cleaning
-- -------------------------------------------------------------------
-- add new column called ride_length, caculate the length of each ride
-- total 5667717 rows before cleaning as original table

DROP TABLE IF EXISTS trip_2022_clean;
CREATE TABLE IF NOT EXISTS trip_2022_clean AS 
(	
	SELECT 
		ride_id,
		rideable_type,
		started_at,
		ended_at,
		TIMEDIFF(ended_at, started_at) AS ride_length,
		start_station_name,
        start_station_id,
		end_station_name,
        end_station_id,
		start_lat,
		start_lng,
		end_lat,
		end_lng,
		member_casual
		FROM trip_2022
);   

-- ===================================================================
-- 4.2 Check duplicate data
-- -------------------------------------------------------------------
-- check duplicate rows by 'ride_id' column which is unique value 
-- 0 null value and 0 duplicate

SELECT
	SUM(isnull(ride_id)) AS null_value,
    COUNT(*) - COUNT(DISTINCT ride_id) AS duplicate_rows
FROM trip_2022_clean;

-- ===================================================================
-- 4.3 Remove irrelevant data
-- -------------------------------------------------------------------
-- check datetime range
-- all trips started in 2022 which means each trip record is relevant of 2022

SELECT 
    MIN(started_at),
    MAX(started_at)
FROM trip_2022_clean;

-- ===================================================================
-- 4.4 Deal with outliers and invalid data
-- -------------------------------------------------------------------
-- check ride length outlier
-- any trip with negative ride_length are considered invalid
-- any trip less than 60 ses are potentially false starts or users trying to re-dock a bike to ensure it was secure
-- any trip greater than 24 hrs are considered invalid outliers that are taken by staff as they service and inspect the system

SELECT 
    MIN(ride_length),
    MAX(ride_length)
FROM trip_2022_clean;

SELECT
	started_at,
    ended_at,
	ride_length
FROM trip_2022_clean
WHERE 
	ride_length < '00:01:00'
    OR ride_length > '24:00:00'
ORDER BY ride_length
;

-- remove 126449 rows which ride_length < 1min or > 24hr
DELETE FROM trip_2022_clean
WHERE 
	ride_length < '00:01:00'
	OR ride_length > '24:00:00';


-- ===================================================================
-- 4.5 Check string values
-- -------------------------------------------------------------------

-- check the distinct values in rideable_type column
-- only 3 values 'classic_bike', 'electric_bike', docked_bike

SELECT
	rideable_type,
	count(*)
FROM trip_2022_clean
GROUP BY 1
ORDER BY 2 DESC
;

-- rename rideable_type column for more meaningful
ALTER TABLE trip_2022_clean
RENAME COLUMN rideable_type TO bike_type
;

-- trim string values
START TRANSACTION;

UPDATE trip_2022_clean
SET bike_type = trim('_bike' FROM bike_type)
;

COMMIT;

-- -------------------------------------------------------------------

-- check the distinct values in member_casual column
-- only 2 values with lowercase 'member', 'casual'

SELECT
	member_casual,
	count(*)
FROM trip_2022_cleaned
GROUP BY 1
ORDER BY 2 DESC
;


-- rename member_casual column for more meaningful

ALTER TABLE trip_2022_clean
RENAME COLUMN member_casual TO ride_type
;

-- uppercase the first letter

START TRANSACTION;

UPDATE trip_2022_clean
SET ride_type = CONCAT(UPPER(SUBSTRING(ride_type, 1, 1)), LOWER(SUBSTRING(ride_type, 2)))
;

COMMIT;


-- ===================================================================
-- 4.6 Handle missing data
-- -------------------------------------------------------------------
-- checking the missing values of all columns
-- 802104 null values of start_station_name, start_station_id
-- 845268 null values of end_station_name, end_station_id
-- 702 null values of end_lat, end_lng

SELECT 
	sum(isnull(ride_id)) ride_id,
	sum(isnull(bike_type)) rideable_type,
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
    sum(isnull(ride_type)) member_casual
FROM trip_2022_clean
;

-- if both end_station and end_lat & lng columns are null values
-- they are invalid data and can be deleted

SELECT 
	end_station_name,
    end_station_id,
	end_lat,
	end_lng
FROM trip_2022_clean
WHERE 
	end_station_name is NULL
    AND end_station_id is NULL
	AND end_lat is NULL
	AND end_lng is NULL
;

-- 702 end_lat & lng rows of invalid null data deleted

DELETE FROM trip_2022_clean
WHERE 
	end_station_name is NULL
    AND end_station_id is NULL
	AND end_lat is NULL
	AND end_lng is NULL
;
    
-- -------------------------------------------------------------------
-- check start_station_name, start_station_id wether are both null values
-- 802104 rows start_station_name & id are both null values, but still have start_lat & lng data
SELECT 
    start_station_name, 
    start_station_id,
    start_lat,
    start_lng
FROM trip_2022_clean
WHERE
    start_station_name IS NULL
    AND start_station_id IS NULL
;

-- based on start_lat & lng data, we can identify the miss start_station_name & id
-- check the max, min length of start lat & lng data which are start_station_name & id are null
SELECT
	max(length(start_lat)), -- max 5, length including'.' sign
    min(length(start_lat)), -- min 4, length including'.' sign
	max(length(start_lng)), -- max 6, length including '-','.' sign
    min(length(start_lng)) --  min 5, length including '-','.' sign
FROM trip_2022_clean
WHERE start_station_name IS NULL
	AND start_station_id IS NULL
;

-- check the max, min length of start lat & lng data which are not null
SELECT
	max(length(start_lat)), -- max 18, length including'.' sign
    min(length(start_lat)), -- min 4, length including'.' sign
	max(length(start_lng)), -- max 18, length including '-','.' sign
    min(length(start_lng)) -- min 5, length including '-','.' sign
FROM trip_2022_clean
WHERE start_station_name IS NOT NULL
	AND start_station_id IS NOT NULL
;

-- check the max, min length of start lat & lng data which are start_station_name & id are null
-- which means the precision of all start_lat & lng are only rounded 2 decimals or less

-- total 802104 rows
SELECT 
    start_station_id,
	start_lat, 
    start_lng
FROM trip_2022_clean
WHERE 	
    start_station_name IS NULL
	AND start_station_id IS NULL
    AND length(start_lat) <= 5
    AND length(start_lng) <= 6
ORDER BY 2 DESC
;

-- find the start_station_id with the same start_lat & lng
WITH not_null_station AS 
(	
	SELECT 
		start_station_id,	
		start_lat,
		start_lng,
		count(*) AS count
-- 		ROW_NUMBER() OVER (PARTITION BY start_lat, start_lng ORDER BY count(*) DESC) AS top
	FROM trip_2022_clean
	WHERE 
		start_station_name IS NOT NULL
		AND start_station_id IS NOT NULL
		AND length(start_lat)  <= 5
		AND length(start_lng)  <= 6
	GROUP BY 2, 3, 1
	ORDER BY 2, 3, 4 DESC
)
-- join null start_station_name & id and above CTE on same start_lat & lng 
SELECT 
	t.start_station_id AS n_start_station,
    t.start_lat AS n_start_lat,
    t.start_lng AS n_start_lng,
	n.start_station_id,
    n.start_lat,
    n.start_lng,
    count(*) AS n_count
FROM trip_2022_clean AS t
INNER JOIN not_null_station AS n
	ON t.start_lat = n.start_lat
    AND t.start_lng = n.start_lng
WHERE t.start_station_name IS NULL
	AND t.start_station_id IS NULL
GROUP BY 1, 2, 3, 4, 5, 6
ORDER BY 2, 3, 7 DESC
;

-- after above qurey, we can't simply replace null station_id with start_station_id by the same start_lat & lng
-- because the precision of 2 decimal places is too imprecise,
-- many stations have the same lat & lng, we can't identify the specific start_station_name & id
-- so the data are not satisfied to replace the null values, need to remove all

-- 802104 rows removed

DELETE FROM trip_2022_clean
WHERE 
	start_station_name is NULL
    AND start_station_id is NULL
;

-- -------------------------------------------------------------------
-- same as null end_station_name & id rows
-- remian 445909 rows are same as null values, but still have start_lat & lng data
SELECT 
    end_station_name, 
    end_station_id,
    end_lat,
    end_lng
FROM trip_2022_clean
WHERE
    end_station_name IS NULL
    AND end_station_id IS NULL
;

-- check the max, min length of end lat & lng data which are null
SELECT
	max(length(end_lat)), -- max 5, length including'.' sign
    min(length(end_lat)), -- min 4, length including'.' sign
	max(length(end_lng)), -- max 6, length including '-','.' sign
    min(length(end_lng)) --  min 5, length including '-','.' sign
FROM trip_2022_clean
WHERE end_station_name IS NULL
	AND end_station_id IS NULL
;

-- check the max, min length of end lat & lng data which are not null
SELECT
	max(length(end_lat)), -- max 18, length including'.' sign
    min(length(end_lat)), -- min 3, length including'.' sign
	max(length(end_lng)), -- max 18, length including '-','.' sign
    min(length(end_lng)) -- min 3, length including '-','.' sign
FROM trip_2022_clean
WHERE end_station_name IS NOT NULL
	AND end_station_id IS NOT NULL
;

-- the precision of null end_lat & lng are all only rounded 2 decimals or less
SELECT 
    end_station_id,
	end_lat, 
    end_lng
FROM trip_2022_clean
WHERE 	
    end_station_name IS NULL
	AND end_station_id IS NULL
    AND length(end_lat) <= 5
    AND length(end_lng) <= 6
ORDER BY 2 DESC
;

-- 445909 rows same as end_station_name & id rows removed
DELETE FROM trip_2022_clean
WHERE 
	end_station_name is NULL
    AND end_station_id is NULL
;

-- check the min length of end_lat & lng which = 3
SELECT 
	end_station_name,
    end_station_id,
    end_lat,
    end_lng,
    count(*)
FROM trip_2022_clean
GROUP BY 1, 2, 3, 4
HAVING min(length(end_lat)) = 3
	OR min(length(end_lng)) = 3
;

-- remove the end_lat & lng which = 0
DELETE FROM trip_2022_clean
WHERE end_lat = '0.0'
	OR end_lng = '0.0'
;

-- all null values had handled
-- remian 4292546 rows
SELECT
	count(*),
	sum(isnull(ride_id)) ride_id,
	sum(isnull(bike_type)) rideable_type,
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
    sum(isnull(ride_type)) member_casual
FROM trip_2022_clean
;

-- ===================================================================
-- 4.7 Do type conversion
-- -------------------------------------------------------------------

-- check all the lat & lng length
-- for geographic visulization only need 4 decimal places precision
SELECT 
	MAX(length(start_lat)),
	MIN(length(start_lat)),
	MAX(length(start_lng)),
    MIN(length(start_lng)),
	MAX(length(end_lat)),
    MIN(length(end_lat)),
	MAX(length(end_lng)),
    MIN(length(end_lng))
FROM trip_2022_clean
;

-- convert start_lat & end_lat as DECIMAL(6, 4)
-- convert start_lng & end_lng as DECIMAL(7, 4)
ALTER TABLE trip_2022_clean
MODIFY COLUMN start_lat DECIMAL(6, 4),
MODIFY COLUMN start_lng DECIMAL(7, 4),
MODIFY COLUMN end_lat DECIMAL(6, 4),
MODIFY COLUMN end_lng DECIMAL(7, 4)
;

-- SELECT 
-- 	start_lat,
--     start_lng,
--     end_lat,
--     end_lng
-- FROM trip_2022_clean
-- GROUP BY 1, 2, 3, 4
-- ORDER BY 1, 2, 3, 4
-- ;

-- ===================================================================
-- 4.8 Fix ambiguous data and business Logic
-- -------------------------------------------------------------------

-- check distinct values which means some station_id has more than 1 names
-- 1541 start_station_name
-- 1263 start_station_id
SELECT 
	COUNT(DISTINCT trim(start_station_name)), 
	COUNT(DISTINCT trim(start_station_id))
FROM trip_2022_clean;

-- Use window function also discover some start_station_id have lots of different lat & lng
-- 31478 rows, indicating many start_station_id also has more than 1 start_lat & lng
SELECT 
    start_station_id,
    start_lat,
    start_lng,
    COUNT(*) AS no_rides,
    ROW_NUMBER() OVER (PARTITION BY start_station_id ORDER BY count(*) DESC) AS top
FROM trip_2022_clean
GROUP BY 1, 2, 3
ORDER BY 1 DESC, 4 DESC, 5
;

-- for viz requires each station has unique lat & lng
-- use start_station_id to identify unique start_lat & lng by ranking 1 with the most rides 
-- 1263 rows
SELECT
	s.start_station_id,
    s.start_lat,
    s.start_lng,
    s.no_rides
FROM 
(
	SELECT 
	start_station_id,
    start_lat,
    start_lng,
    count(*) AS no_rides,
    -- Use PARTITION BY function to rank num of the lat & lng by each station_id
    ROW_NUMBER() OVER (PARTITION BY start_station_id ORDER BY count(*) DESC) AS top
	FROM trip_2022_clean
	GROUP BY 1, 2, 3
	ORDER BY 1, 4 DESC, 5
) AS s
-- Find the top 1 of each station_id which means the most accrate location
WHERE s.top = 1
ORDER BY 2, 3, 4 DESC
;

-- transaction
START TRANSACTION;

-- update start_station_id by unique start_lat & lng
UPDATE trip_2022_clean AS t
JOIN 
(
	SELECT
		s.start_station_id,
		s.start_lat,
		s.start_lng,
		s.no_rides
	FROM 
	(
		SELECT 
			start_station_id,
			start_lat,
			start_lng,
			count(*) AS no_rides,
			-- Use PARTITION BY function to rank num of the lat & lng by each station_id
			ROW_NUMBER() OVER (PARTITION BY start_station_id ORDER BY count(*) DESC) AS top
		FROM trip_2022_clean
		GROUP BY 1, 2, 3
		ORDER BY 1, 4 DESC, 5
	) AS s
	-- Find the top 1 of each station_id which means the most accrate location
	WHERE s.top = 1
	ORDER BY 2, 3, 4 DESC
) AS i
ON t.start_station_id = i.start_station_id
SET t.start_lat = i.start_lat,
	t.start_lng = i.start_lng
;

COMMIT;

-- -------------------------------------------------------------------
-- check the start_station_id which have more than 1 name
-- 554 rows have 'no_id' > 1 group by start_station_name & id

WITH start_stations AS
(	SELECT 
		start_station_name, 
        start_station_id, 
        COUNT(*) AS rides
	FROM trip_2022_clean
	GROUP BY 1 , 2
	ORDER BY 3 DESC, 1
),
count_id AS
(	SELECT
		start_station_id, 
		COUNT(*) AS no_id
	FROM start_stations
	GROUP BY 1
	ORDER BY 2 DESC, 1 DESC
)
SELECT 
	a.start_station_name,
    a.start_station_id,
    a.rides,
    c.no_id
FROM start_stations AS a
INNER JOIN count_id AS c
	ON a.start_station_id = c.start_station_id
WHERE c.no_id > 1
ORDER BY 4 DESC, 2 DESC
;

-- update start_station_name
START TRANSACTION;

-- set start_station_name to the name of the most rides station by the same station_id
UPDATE trip_2022_clean AS t
JOIN 
(
	SELECT
		s.start_station_name,
		s.start_station_id
	FROM 
	(
		SELECT 
			start_station_name,
			start_station_id,
			count(*) AS no_rides,
			-- Use PARTITION BY function to rank num of the lat & lng by each station_id
			ROW_NUMBER() OVER (PARTITION BY start_station_id ORDER BY count(*) DESC) AS top
		FROM trip_2022_clean
		GROUP BY 1, 2
		ORDER BY 2 DESC, 4, 3 DESC, 1
	) AS s
	WHERE s.top = 1
) AS i
ON t.start_station_id = i.start_station_id
SET t.start_station_name = i.start_station_name
;

COMMIT;

-- -------------------------------------------------------------------
-- -------------------------------------------------------------------
-- Handle with ambiguities and errors of end_station_name & id by the same ways

-- check distinct values which means some station_id has more than 1 names
-- 1583 end_station_name
-- 1275 end_station_id
SELECT 
	COUNT(DISTINCT trim(end_station_name)), 
	COUNT(DISTINCT trim(end_station_id))
FROM trip_2022_clean;

-- Use window function also discover some end_station_id have lots of different lat & lng
-- 1626 rows, indicating many end_station_id also has more than 1 start_lat & lng
SELECT 
    end_station_id,
    end_lat,
    end_lng,
    COUNT(*) AS no_rides,
    ROW_NUMBER() OVER (PARTITION BY end_station_id ORDER BY count(*) DESC) AS top
FROM trip_2022_clean
GROUP BY 1, 2, 3
ORDER BY 1 DESC, 4 DESC, 5
;

-- for viz requires each station has unique lat & lng
-- use end_station_id to identify unique end_lat & lng by ranking 1 with the most rides 
-- 1275 rows
SELECT
	s.end_station_id,
    s.end_lat,
    s.end_lng,
    s.no_rides
FROM 
(
	SELECT 
	end_station_id,
    end_lat,
    end_lng,
    count(*) AS no_rides,
    -- Use PARTITION BY function to rank num of the lat & lng by each station_id
    ROW_NUMBER() OVER (PARTITION BY end_station_id ORDER BY count(*) DESC) AS top
	FROM trip_2022_clean
	GROUP BY 1, 2, 3
	ORDER BY 1, 4 DESC, 5
) AS s
-- Find the top 1 of each station_id which means the most accrate location
WHERE s.top = 1
ORDER BY 2, 3, 4 DESC
;

-- transaction
START TRANSACTION;

-- update end_station_id by unique end_lat & lng
UPDATE trip_2022_clean AS t
JOIN 
(
	SELECT
		s.end_station_id,
		s.end_lat,
		s.end_lng,
		s.no_rides
	FROM 
	(
		SELECT 
			end_station_id,
			end_lat,
			end_lng,
			count(*) AS no_rides,
			-- Use PARTITION BY function to rank num of the lat & lng by each station_id
			ROW_NUMBER() OVER (PARTITION BY end_station_id ORDER BY count(*) DESC) AS top
		FROM trip_2022_clean
		GROUP BY 1, 2, 3
		ORDER BY 1, 4 DESC, 5
	) AS s
	-- Find the top 1 of each station_id which means the most accrate location
	WHERE s.top = 1
	ORDER BY 2, 3, 4 DESC
) AS i
ON t.end_station_id = i.end_station_id
SET t.end_lat = i.end_lat,
	t.end_lng = i.end_lng
;

COMMIT;

-- -------------------------------------------------------------------
-- check the end_station_id which have more than 1 name
-- 606 rows have 'no_id' > 1 group by end_station_name & id

WITH end_stations AS
(	SELECT 
		end_station_name, 
        end_station_id, 
        COUNT(*) AS rides
	FROM trip_2022_clean
	GROUP BY 1 , 2
	ORDER BY 3 DESC, 1
),
count_id AS
(	SELECT
		end_station_id, 
		COUNT(*) AS no_id
	FROM end_stations
	GROUP BY 1
	ORDER BY 2 DESC, 1 DESC
)
SELECT 
	a.end_station_name,
    a.end_station_id,
    a.rides,
    c.no_id
FROM end_stations AS a
INNER JOIN count_id AS c
	ON a.end_station_id = c.end_station_id
WHERE c.no_id > 1
ORDER BY 4 DESC, 2 DESC
;

-- update end_station_name
START TRANSACTION;

-- set end_station_name to the name of the most rides station by the same station_id
UPDATE trip_2022_clean AS t
JOIN 
(
	SELECT
		s.end_station_name,
		s.end_station_id
	FROM 
	(
		SELECT 
			end_station_name,
			end_station_id,
			count(*) AS no_rides,
			-- Use PARTITION BY function to rank num of the lat & lng by each station_id
			ROW_NUMBER() OVER (PARTITION BY end_station_id ORDER BY count(*) DESC) AS top
		FROM trip_2022_clean
		GROUP BY 1, 2
		ORDER BY 2 DESC, 4, 3 DESC, 1
	) AS s
	WHERE s.top = 1
) AS i
ON t.end_station_id = i.end_station_id
SET t.end_station_name = i.end_station_name
;

COMMIT;

-- ===================================================================
-- -------------------------------------------------------------------
-- Now, the data is clean, accurate, consistent, complete and ready for ANALYSIS.
-- -------------------------------------------------------------------
-- ===================================================================
