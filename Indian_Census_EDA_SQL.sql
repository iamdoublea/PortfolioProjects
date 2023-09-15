-- Exploring Data --
SELECT 
    *
FROM
    projects_1.indian_census_data1
LIMIT 10;

SELECT 
    *
FROM
    projects_1.indian_census_data2
LIMIT 10;

-- Number of rows present here --
SELECT 
    COUNT(*)
FROM
    projects_1.indian_census_data1
LIMIT 10;

SELECT 
    COUNT(*)
FROM
    projects_1.indian_census_data2
LIMIT 10;

-- Calculate dataset for 2 different states only --

SELECT 
    *
FROM
    projects_1.indian_census_data1
WHERE
    state IN ('Jharkhand' , 'West Bengal');


-- To know the total population in India --
SELECT 
    SUM(Population) AS total_population
FROM
    projects_1.indian_census_data2;

-- Average Growth of India --
SELECT 
    (ROUND(AVG(Growth), 2) * 100) AS avg_growth_percent
FROM
    projects_1.indian_census_data1;

-- Average growth percent for state wise --
SELECT 
    state,
    (ROUND(AVG(Growth), 2) * 100) AS avg_growth_percent_by_state
FROM
    projects_1.indian_census_data1
GROUP BY state;

-- Average sex ration in the coountry --
SELECT 
    ROUND(AVG(Sex_Ratio), 0) AS avg_sex_ratio
FROM
    projects_1.indian_census_data1;

-- Average sex ratio state wise -- 
SELECT 
    state, ROUND(AVG(Sex_Ratio), 0) AS avg_sex_ratio_state_wise
FROM
    projects_1.indian_census_data1
GROUP BY state
ORDER BY ROUND(AVG(Sex_Ratio), 0) DESC;

-- Average literacy rate --
SELECT 
    ROUND(AVG(Literacy), 0) AS avg_literacy_rate
FROM
    projects_1.indian_census_data1;

-- Average literact rate state wise --
SELECT 
    state, ROUND(AVG(Literacy), 0) AS avg_literacy_state_wise
FROM
    projects_1.indian_census_data1
GROUP BY state;

-- Average literacy rate above 90 --
SELECT 
    state,
    ROUND(AVG(Literacy), 0) AS avg_literacy_state_wise_above_90
FROM
    projects_1.indian_census_data1
GROUP BY state
HAVING ROUND(AVG(Literacy), 0) >= 90;

-- Top 3 states showing highest growth ration --
SELECT 
    state, ROUND(AVG(growth), 2) * 100 AS avg_growth
FROM
    projects_1.indian_census_data1
GROUP BY state
ORDER BY AVG(growth) * 100 DESC
LIMIT 3;


-- 3 states showing least growth ration --
SELECT 
    state, ROUND(AVG(growth), 2) * 100 AS avg_growth
FROM
    projects_1.indian_census_data1
GROUP BY state
ORDER BY AVG(growth) * 100 ASC
LIMIT 3;

-- 3 states with least sex ratio --
SELECT 
    state, ROUND(AVG(sex_ratio), 2) * 100 AS avg_sex_ratio
FROM
    projects_1.indian_census_data1
GROUP BY state
ORDER BY AVG(sex_ratio) * 100 ASC
LIMIT 3;

-- Top and Bottom states in terms of literally states --

DROP TABLE IF EXISTS projects_1.top_states_census;
CREATE TABLE projects_1.top_states_census (
    state CHAR(255),
    avg_literacy FLOAT
);

INSERT INTO projects_1.top_states_census
SELECT
state , ROUND(AVG(Literacy),2) AS avg_literacy
FROM projects_1.indian_census_data1
GROUP BY state
ORDER BY ROUND(AVG(Literacy),2) DESC
LIMIT 3; 

DROP TABLE IF EXISTS projects_1.bottom_states_census;
CREATE TABLE projects_1.bottom_states_census (
    state CHAR(255),
    avg_literacy FLOAT
);

INSERT INTO projects_1.bottom_states_census
SELECT
state , ROUND(AVG(Literacy),2) AS avg_literacy
FROM projects_1.indian_census_data1
GROUP BY state
ORDER BY ROUND(AVG(Literacy),2) ASC
LIMIT 3;


SELECT 
    *
FROM
    projects_1.top_states_census 
UNION ALL SELECT 
    *
FROM
    projects_1.bottom_states_census;

-- states starting with letter 'W' or end with letter 'D' -- 

SELECT DISTINCT
    state
FROM
    projects_1.indian_census_data1
WHERE
    UPPER(state) LIKE 'W%'
        OR UPPER(state) LIKE '%D';

-- To get the total number of females from the table --

WITH Temp AS (SELECT
A.District, A.state,A.sex_ratio,B.population,
(B.Population/((A.sex_ratio/1000) + 1)) AS male_pop,
(B.Population - (B.Population/((A.sex_ratio/1000) + 1))) AS female_pop
FROM
projects_1.indian_census_data1 AS A
INNER JOIN
projects_1.indian_census_data2 AS B
USING (District))
SELECT
District,State, ROUND(male_pop) AS male, ROUND(female_pop) AS female
FROM
Temp;

-- To get the total number of females from the table at a District level --

WITH Temp AS (SELECT
A.District, A.sex_ratio,B.population,
(B.Population/((A.sex_ratio/1000) + 1)) AS male_pop,
(B.Population - (B.Population/((A.sex_ratio/1000) + 1))) AS female_pop
FROM
projects_1.indian_census_data1 AS A
INNER JOIN
projects_1.indian_census_data2 AS B
USING (District))
SELECT
District, ROUND(male_pop) AS male, ROUND(female_pop) AS female
FROM
Temp;

-- Total literacy rate -- 
WITH Temp AS (SELECT
A.District AS District, A.state AS State ,A.literacy,B.population AS Total_population,
(B.Population*(A.literacy)/100) AS literate,
(B.Population*(100-A.literacy)/100) AS illiterate
FROM
projects_1.indian_census_data1 AS A
INNER JOIN
projects_1.indian_census_data2 AS B
USING (District))
SELECT
District,State,Total_population,ROUND(literate) AS Literate,ROUND(illiterate) AS Illiterate
FROM
Temp;


-- Total literacy rate State wise -- 
WITH Temp AS (SELECT
A.District AS District, A.state AS State ,A.literacy,B.population AS Total_population,
(B.Population*(A.literacy)/100) AS literate,
(B.Population*(100-A.literacy)/100) AS illiterate
FROM
projects_1.indian_census_data1 AS A
INNER JOIN
projects_1.indian_census_data2 AS B
USING (District))
SELECT
State,SUM(ROUND(literate,2)) AS Literate,SUM(ROUND(illiterate,2)) AS Illiterate
FROM
Temp
GROUP BY
State;


-- Population in previous census --
WITH Temp AS (SELECT A.District AS District,A.State AS State,B.Population AS Population,A.Growth AS Growth
FROM projects_1.indian_census_data1 AS A
INNER JOIN projects_1.indian_census_data2 AS B
USING(District))
SELECT
*, FLOOR(Population/(1+Growth)) AS Prev_yr_popu
FROM
Temp;

-- Total Population Now vs Total Population Previously --

WITH Temp_1 AS (WITH Temp AS (SELECT A.District AS District,A.State AS State,B.Population AS Population,A.Growth AS Growth
FROM projects_1.indian_census_data1 AS A
INNER JOIN projects_1.indian_census_data2 AS B
USING(District))
SELECT
*, FLOOR(Population/(1+Growth)) AS Prev_yr_popu
FROM
Temp)
SELECT
SUM(Population)AS total_pop_now, SUM(Prev_yr_popu) AS total_pop_prev
FROM Temp_1;


-- Top 3 District from each State who has the highest literary rate --
SELECT
District,State,Literacy
FROM
(SELECT *,
RANK() OVER(PARTITION BY State ORDER BY Literacy DESC) AS literacy_rank
FROM projects_1.indian_census_data1) AS Table_1
WHERE
literacy_rank <= 3;