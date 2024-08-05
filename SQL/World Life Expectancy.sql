SELECT * 
FROM world_life_expectancy

SELECT Country, Year, CONCAT(Country, Year), COUNT(CONCAT(Country, Year))
FROM world_life_expectancy
GROUP BY Country, Year, CONCAT(Country, Year) 
HAVING COUNT(CONCAT(Country, Year)) > 1


SELECT *
FROM (
	SELECT Row_ID, 
	CONCAT(Country, Year) AS Row_merge,
	ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS Row_numb
	FROM world_life_expectancy
	) AS Row_table
WHERE Row_numb > 1


DELETE FROM world_life_expectancy
WHERE 
		Row_ID IN (
		SELECT Row_ID 
	FROM (
		SELECT Row_ID, 
		CONCAT(Country, Year) AS Row_merge,
		ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS Row_numb
		FROM world_life_expectancy
	) AS Row_table
WHERE Row_numb > 1
)

SELECT DISTINCT(Status)
FROM world_life_expectancy
WHERE Status <> ''


SELECT DISTINCT(Country) 
FROM world_life_expectancy 
WHERE Status = 'Developing'

UPDATE world_life_expectancy 
SET Status = 'Developing'
WHERE Country IN (SELECT DISTINCT(Country) 
					FROM world_life_expectancy 
					WHERE Status = 'Developing')


UPDATE world_life_expectancy AS t1
JOIN world_life_expectancy AS t2
	ON t1.Country = t2.Country 
SET t1.Status = 'Developing'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developing'

WITH CTE AS (
    SELECT t1.*
    FROM world_life_expectancy t1
    JOIN world_life_expectancy t2
    ON t1.Country = t2.Country
    WHERE t1.Status = ''
    AND t2.Status = 'Developing'
)
UPDATE CTE
SET Status = 'Developing';