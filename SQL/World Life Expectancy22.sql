SELECT *
  FROM world_life_expectancy;

SELECT Country, Year, CONCAT(Country, Year), COUNT(CONCAT(Country, Year))
FROM world_life_expectancy 
GROUP BY Country, Year, CONCAT(Country, Year)
HAVING COUNT(CONCAT(Country, Year)) > 1; 

SELECT *
FROM (
    SELECT Row_ID, 
           Country, 
           Year,
           CONCAT(Country, Year) AS CountryYear,
           ROW_NUMBER() OVER(PARTITION BY Country, Year ORDER BY (SELECT NULL)) AS Row_Num
    FROM world_life_expectancy
) AS Row_table 
WHERE Row_Num > 1;

DELETE FROM world_life_expectancy
WHERE Row_ID IN (
    SELECT Row_ID
    FROM (
        SELECT Row_ID,
               CONCAT(Country, Year) AS Row_merge,
               ROW_NUMBER() OVER(PARTITION BY Country, Year ORDER BY (SELECT NULL)) AS Row_numb
        FROM world_life_expectancy
    ) AS Row_table
    WHERE Row_numb > 1
);

SELECT *
  FROM world_life_expectancy
WHERE Status IS NULL;

SELECT DISTINCT(Status)
  FROM world_life_expectancy
WHERE Status IS NULL;

SELECT DISTINCT(Country)
FROM world_life_expectancy
WHERE Status = 'Developing';

UPDATE world_life_expectancy
SET Status = 'Developing'
WHERE Country IN (SELECT DISTINCT(Country)
				FROM world_life_expectancy
				WHERE Status = 'Developing');

UPDATE t1
SET t1.Status = 'Developing'
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
ON t1.Country = t2.Country
WHERE t1.Status IS NULL
AND t2.Status IS NOT NULL
AND t2.Status = 'Developing';

SELECT *
  FROM world_life_expectancy
WHERE Country = 'United States of America';

UPDATE t1
SET t1.Status = 'Developed'
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
ON t1.Country = t2.Country
WHERE t1.Status IS NULL
AND t2.Status IS NOT NULL
AND t2.Status = 'Developed';

SELECT *
  FROM world_life_expectancy
WHERE [Life expectancy] IS NULL;

SELECT Country, Year, [Life expectancy]
FROM world_life_expectancy;

SELECT t1.Country, t1.Year, t1.[Life expectancy],
t2.Country, t2.Year, t2.[Life expectancy],
t3.Country, t3.Year, t3.[Life expectancy],
ROUND((t2.[Life expectancy] + t3.[Life expectancy])/2,1)
FROM world_life_expectancy t1
JOIN world_life_expectancy t2 
	ON t1.Country = t2.Country 
	AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3 
	ON t1.Country = t3.Country 
	AND t1.Year = t3.Year + 1
WHERE t1.[Life expectancy] IS NULL;

UPDATE t1
SET t1.[Life Expectancy] = ROUND((t2.[Life Expectancy] + t3.[Life Expectancy]) / 2.0, 1)
FROM world_life_expectancy t1
JOIN world_life_expectancy t2 
    ON t1.Country = t2.Country 
    AND t1.Year = t2.Year + 1
JOIN world_life_expectancy t3 
    ON t1.Country = t3.Country 
    AND t1.Year = t3.Year - 1
WHERE t1.[Life Expectancy] IS NULL;


SELECT Country, 
MIN([Life Expectancy]), 
MAX([Life Expectancy]),
ROUND(MAX([Life Expectancy])-MIN([Life Expectancy]),1) AS Life_Increase_15_Years
FROM world_life_expectancy 
GROUP BY Country 
HAVING MIN([Life Expectancy]) <> 0
AND MAX([Life Expectancy]) <>0
ORDER BY Life_Increase_15_Years DESC;

SELECT Year, ROUND(AVG([Life Expectancy]),2)
FROM world_life_expectancy 
WHERE [Life Expectancy] <> 0
AND [Life Expectancy] <>0
GROUP BY Year 
ORDER BY Year;

SELECT Country,
       ROUND(AVG([Life Expectancy]), 1) AS Life_Exp,
       ROUND(AVG(GDP), 1) AS GDP
FROM world_life_expectancy
GROUP BY Country
HAVING ROUND(AVG([Life Expectancy]), 1) > 0
   AND ROUND(AVG(GDP), 1) > 0
ORDER BY GDP DESC;

SELECT 
SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) High_GDP_Count,
AVG(CASE WHEN GDP >= 1500 THEN [Life Expectancy] ELSE NULL END) High_GDP_Life_Expectancy,
SUM(CASE WHEN GDP <= 1500 THEN 1 ELSE 0 END) Low_GDP_Count,
AVG(CASE WHEN GDP <= 1500 THEN [Life Expectancy] ELSE NULL END) Low_GDP_Life_Expectancy
FROM world_life_expectancy; 

SELECT Status, ROUND(AVG([Life Expectancy]),1)
FROM world_life_expectancy 
GROUP BY Status; 

SELECT Status, COUNT(DISTINCT Country) AS CountryCount, ROUND(AVG([Life Expectancy]),1)
FROM world_life_expectancy
GROUP BY Status;

SELECT Country,
       ROUND(AVG([Life Expectancy]), 1) AS Life_Exp,
       ROUND(AVG(BMI), 1) AS BMI
FROM world_life_expectancy
GROUP BY Country
HAVING ROUND(AVG([Life Expectancy]), 1) > 0
   AND ROUND(AVG(BMI), 1) > 0
ORDER BY BMI DESC;

SELECT Country,
       ROUND(AVG([Life Expectancy]), 1) AS Life_Exp,
       ROUND(AVG([ BMI ]), 1) AS BMI_count
FROM world_life_expectancy
GROUP BY Country
HAVING ROUND(AVG([Life Expectancy]), 1) > 0
   AND ROUND(AVG([ BMI ]), 1) > 0
ORDER BY ROUND(AVG([ BMI ]), 1) DESC;

SELECT Country,
Year, 
[Life Expectancy],
[Adult Mortality],
SUM([Adult Mortality]) OVER(PARTITION BY Country ORDER BY Year) Rolling_Total
FROM world_life_expectancy
WHERE Country LIKE '%United%';
