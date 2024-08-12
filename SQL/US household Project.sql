SELECT * 
FROM us_household_income;

SELECT * 
FROM us_household_income_statistics;

SELECT id, COUNT(id)
FROM us_household_income 
GROUP BY id
HAVING COUNT(id) > 1;

SELECT * 
FROM (
    SELECT row_id,
           id,
           ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) AS row_num
    FROM us_household_income
) AS derived_table
WHERE row_num > 1;

DELETE FROM us_household_income
WHERE row_id IN (
    SELECT row_id 
    FROM (
        SELECT row_id,
               id,
               ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) AS row_num
        FROM us_household_income
    ) AS duplicates
    WHERE row_num > 1
);

SELECT id, COUNT(id)
FROM us_household_income_statistics 
GROUP BY id
HAVING COUNT(id) > 1;

SELECT *
FROM us_household_income;

SELECT State_Name, COUNT(State_Name)
FROM us_household_income 
GROUP BY State_Name;

UPDATE us_household_income
SET State_Name = 'Alabama'
WHERE State_Name = 'alabama'; 

SELECT DISTINCT *
FROM us_household_income
WHERE County = 'Autauga County'
ORDER BY 1;

UPDATE us_household_income
SET Place = 'Autaugaville'
WHERE County = 'Autauga County'
AND City = 'Vinemont';

SELECT Type, COUNT(Type) AS TypeCount
FROM us_household_income
GROUP BY Type;

UPDATE us_household_income
SET Type = 'Borough'
WHERE Type = 'Boroughs';

SELECT ALand, AWater
FROM us_household_income 
WHERE (ALand = 0 OR ALand = '' OR ALand IS NULL);

SELECT TOP 10 State_Name, 
       SUM(ALand) AS Total_Land, 
       SUM(AWater) AS Total_Water
FROM us_household_income
GROUP BY State_Name 
ORDER BY Total_Water DESC;

SELECT * 
FROM us_household_income;

SELECT * 
FROM us_household_income_statistics;

SELECT u.State_Name, County, Type, [Primary], Mean, Median 
FROM us_household_income u 
INNER JOIN us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0 ;

SELECT u.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1) 
FROM us_household_income u 
INNER JOIN us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0 
GROUP BY u.State_Name 
ORDER BY 2 DESC;

SELECT Type, COUNT(Type), ROUND(AVG(Mean),1), ROUND(AVG(Median),1) 
FROM us_household_income u 
INNER JOIN us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0 
GROUP BY Type
HAVING COUNT(Type) > 100
ORDER BY 2 DESC
;

SELECT * 
FROM us_household_income 
WHERE Type = 'Community';

SELECT u.State_Name, City, ROUND(AVG(Mean),1) 
FROM us_household_income u 
JOIN us_household_income_statistics us 
	ON u.id = us.id
GROUP BY u.State_Name, City
ORDER BY ROUND(AVG(Mean),1) DESC; 

