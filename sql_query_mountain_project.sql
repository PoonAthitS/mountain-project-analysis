USE mountain_project -- Initialise the DB to use
-- [INSPECTION] Check null in the initial raw data
SELECT 
	COUNT(*)-COUNT(Length) AS null_Length
	,COUNT(*)-COUNT(Area_Latitude) AS null_Latitude
	,COUNT(*)-COUNT(Area_Longitude) AS null_Longitude
	,COUNT(*)-COUNT(Route) AS null_Route
	--,COUNT(*)-COUNT(Route_Type) AS null_Route_Type
FROM mp_routes;
-----------------------------------------------------------------------------------
-- [INSPECTION] Check distinct value of Route_type and Rating
-- 57 possible types 
SELECT DISTINCT 
	Route_Type
FROM mp_routes;
-- 1069 possible routes
SELECT DISTINCT 
	Rating
FROM mp_routes;
-----------------------------------------------------------------------------------
-- [NEW DRAFT TABLE] Create a new transformed table (dbo.mp_table_draft) from the initial mp_routes
WITH mp_table_CTE1 AS (
	SELECT 
		mpr.Route, Pitches, num_votes, mpr.Location
		-- Replace null in Latitude or Longitude with "unspecified"
		,IIF(Area_Latitude is null, 'unspecified', CAST(Area_Latitude AS varchar(200))) AS Latitude_rm_na
		,IIF(Area_Longitude is null, 'unspecified', CAST(Area_Longitude AS varchar(200))) AS Longitude_rm_na
		
		-- Round the Avg_stars to have only 1 decimal place
		,ROUND(Avg_Stars, 1) AS Avg_Stars_round
		
		-- Change length from foot to meter
		,CAST(Length * 0.3048 AS float) AS Length_meter

		-- Define all 57 Route_type to be either Trad or Sport
		-- Use LEFT due to the exceeding length for parsename function
		,REPLACE(REVERSE(PARSENAME(REPLACE(REVERSE(LEFT(Route_Type, 10)), ' ', '.'), 1)), ',', '') AS Route_Type_approx

		-- Define Rating 
		,CASE WHEN SUBSTRING(Rating, 0, CHARINDEX(' ', Rating)) = '' THEN Rating
		ELSE SUBSTRING(Rating, 0, CHARINDEX(' ', Rating)) 
		END AS Rating_approx
	
		-- splitted location columns from subquery in JOIN
		,temp.location1 AS location1
		,temp.location2 AS location2
		,temp.location3 AS location3

	FROM mp_routes AS mpr
	
	-- Subquery to split more than 4 separators using STRING_SPLIT
	-- if string less than 4 use PARSENAME(REPLACE(String, '>', '.'), 1) is easier
	INNER JOIN 
	(
	SELECT mp_routes.Route, mp_routes.Location, s.location1, s.location2, s.location3
	FROM mp_routes CROSS APPLY 
		(SELECT MAX(CASE WHEN SEQNUM = 1 THEN TRIM(REVERSE(s.value)) END) AS location1,
				MAX(CASE WHEN SEQNUM = 2 THEN TRIM(REVERSE(s.value)) END) AS location2,
				MAX(CASE WHEN SEQNUM = 3 THEN TRIM(REVERSE(s.value)) END) AS location3
		FROM (SELECT s.*
				,ROW_NUMBER() OVER (ORDER BY CHARINDEX('_' + s.value + '_', '_' + mp_routes.Location + '_')) as seqnum
			FROM STRING_SPLIT(REVERSE(mp_routes.Location), '>') AS s
			) AS s
		) AS s
	) AS temp
	ON (temp.Route = mpr.Route AND temp.Location = mpr.Location)

	-- Remove data with null in Route or Length column; this will remove the unqualified route from the table
	WHERE 
		Length is not null 
		AND mpr.Route is not null
		-- Remove some error data
		AND Pitches > 0 
		AND Pitches < 40
		AND mpr.Location <> '#NAME?'
)
SELECT * 
	-- Create RowNum for identifying duplicated routes
	,ROW_NUMBER() OVER (
		PARTITION BY Location, Route
		ORDER BY Route) AS RowNum
		
		-- Retrieve continent and country from Location
		-- Use RIGHT due to the exceeding length for parsename function
		,CASE 
		WHEN location1 = 'International' THEN 
			IIF (location2 = 'Australia', 'Oceania', location2)
		ELSE 'North America'
		END AS Continent
		
		,CASE WHEN location1 = 'International' THEN 
			IIF (location2 = 'Australia', 'Australia', location3)		
		ELSE 'United States'
		END AS Country

		,CASE WHEN location1 = 'International' THEN 'non-US'
		ELSE location1
		END AS State

	-- New table name dbo.mp_table
	INTO dbo.mp_table_draft
FROM mp_table_CTE1;
-----------------------------------------------------------------------------------
-- [CREATE FINAL TABLE] Create a new transformed table (dbo.mp_table) for tableau dashboard
SELECT 
	-- Select initial usable cols
	Route, Pitches, num_votes
	-- Select transformed cols
	,Latitude_rm_na AS Latitude
	,Longitude_rm_na AS Longitude
	,Avg_Stars_round AS Stars
	,Length_meter AS Length
	,Continent
	,State
	,Route_Type_approx As Route_Type
	-- Further transform Country for special cases
	,CASE 
	WHEN Country = 'Cayman Brac'
		THEN 'Cayman Islands'
	WHEN Country = 'Martin'
		THEN 'Saint Martin'
	WHEN Country = 'Virgin Islands'
		THEN 'United States'
	ELSE Country
	END AS Country
	-- Further transform Rating
	,CASE WHEN Rating_approx in ('3rd','4th','Easy','5','5.0','5.1','5.2','5.3','5.4','5.5') 
		THEN 'Less than 5.6'
		ELSE IIF (LEN(Rating_approx) = 7, 
			SUBSTRING(REPLACE(REPLACE(Rating_approx, '-', ''), '+', ''), 1, 5),
			REPLACE(REPLACE(Rating_approx, '-', ''), '+', ''))
		END AS Grade
INTO mp_table
FROM mp_table_draft
-- Remove duplicate and Select route type
-- Remove error length data
WHERE RowNum = 1
	AND Length_meter > 4.5
	AND Length_meter < 1080
	--AND State is not null
	--AND State <> '#NAME?';
-----------------------------------------------------------------------------------
-- Test possible data of cols
SELECT DISTINCT Country, Continent FROM mp_table ORDER BY Country;
SELECT DISTINCT Grade FROM mp_table ORDER BY Grade;
SELECT DISTINCT Pitches FROM mp_table ORDER BY Pitches;
SELECT DISTINCT Length FROM mp_table ORDER BY Length;
SELECT Route, Pitches FROM mp_table ORDER BY Pitches DESC;
SELECT DISTINCT num_votes FROM mp_table ORDER BY num_votes;
SELECT DISTINCT Stars FROM mp_table ORDER BY Stars;
SELECT DISTINCT Country, Continent, State FROM mp_table ORDER BY State;
SELECT Location ,Country, Continent, State FROM mp_table_draft ORDER BY State;
-- Check null value
SELECT 
	COUNT(*)-COUNT(Length) AS null_Length
	,COUNT(*)-COUNT(Route) AS null_Route
	--,COUNT(*)-COUNT(Route_Type) AS null_Route_Type
FROM mp_table;