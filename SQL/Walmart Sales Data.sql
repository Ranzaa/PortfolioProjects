SELECT * 
FROM  Sales


-- Add the time_of_day column
ALTER TABLE Sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE Sales
SET time_of_day = (
	CASE
	WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);

-- Add day_name column
ALTER TABLE Sales ADD COLUMN day_name VARCHAR(10);

UPDATE Sales
SET day_name = DAYNAME(date);

-- Add month_name column
ALTER TABLE Sales ADD COLUMN month_name VARCHAR(10);

UPDATE Sales
SET month_name = MONTHNAME(date);

-- Generic Questions

-- How many unique cities does the data have?
SELECT COUNT(DISTINCT city) AS unique_cities
FROM Sales

-- In which city is each branch?
SELECT 
    branch,
    city
FROM Sales
GROUP BY branch, city

-- Product Questions

-- How many unique product lines does the data have?
SELECT COUNT(DISTINCT product_line) AS unique_product_lines
FROM Sales

-- What is the most selling product line?
SELECT
    product_line,
    SUM(quantity) as total_quantity
FROM Sales
GROUP BY product_line
ORDER BY total_quantity DESC
LIMIT 1

-- What is the total revenue by month?
SELECT
    month_name AS month,
    SUM(total) AS total_revenue
FROM Sales
GROUP BY month_name 
ORDER BY total_revenue DESC

-- What month had the largest COGS?
SELECT
    month_name AS month,
    SUM(cogs) AS total_cogs
FROM Sales
GROUP BY month_name 
ORDER BY total_cogs DESC
LIMIT 1

-- What product line had the largest revenue?
SELECT
    product_line,
    SUM(total) as total_revenue
FROM Sales
GROUP BY product_line
ORDER BY total_revenue DESC
LIMIT 1

-- What is the city with the largest revenue?
SELECT
    city,
    SUM(total) AS total_revenue
FROM Sales
GROUP BY city 
ORDER BY total_revenue DESC
LIMIT 1

-- What product line had the largest VAT?
SELECT
    product_line,
    AVG(tax_pct) as avg_tax
FROM Sales
GROUP BY product_line
ORDER BY avg_tax DESC
LIMIT 1

-- Fetch each product line and add a column showing "Good" or "Bad"
SELECT 
    product_line,
    CASE
        WHEN AVG(quantity) > (SELECT AVG(quantity) FROM sales) THEN "Good"
        ELSE "Bad"
    END AS remark
FROM Sales
GROUP BY product_line

-- Which branch sold more products than the average product sold?
SELECT 
    branch, 
    SUM(quantity) AS total_quantity
FROM Sales
GROUP BY branch
HAVING total_quantity > (SELECT AVG(quantity) FROM sales)

-- What is the most common product line by gender?
-- Top product line for men
SELECT
    gender,
    product_line,
    COUNT(*) AS total_count
FROM Sales
WHERE gender = 'Male'
GROUP BY gender, product_line
ORDER BY total_count DESC
LIMIT 1

-- Top product line for women
SELECT
    gender,
    product_line,
    COUNT(*) AS total_count
FROM Sales
WHERE gender = 'Female'
GROUP BY gender, product_line
ORDER BY total_count DESC
LIMIT 1
	
-- What is the average rating of each product line?
SELECT
    ROUND(AVG(rating), 2) as avg_rating,
    product_line
FROM Sales
GROUP BY product_line
ORDER BY avg_rating DESC

-- Customers

-- How many unique customer types does the data have?
SELECT COUNT(DISTINCT customer_type) AS unique_customer_types
FROM Sales

-- How many unique payment methods does the data have?
SELECT COUNT(DISTINCT payment) AS unique_payment_methods
FROM Sales

-- What is the most common customer type?
SELECT
    customer_type,
    COUNT(*) as count
FROM Sales
GROUP BY customer_type
ORDER BY count DESC
LIMIT 1

-- Which customer type buys the most?
SELECT
    customer_type,
    COUNT(*) AS total_count
FROM Sales
GROUP BY customer_type
ORDER BY total_count DESC
LIMIT 1

-- What is the gender of most customers?
SELECT
    gender,
    COUNT(*) as gender_count
FROM Sales
GROUP BY gender
ORDER BY gender_count DESC
LIMIT 1

-- What is the gender distribution per branch?
SELECT
    branch,
    gender,
    COUNT(*) as gender_count
FROM Sales
GROUP BY branch, gender
ORDER BY branch, gender_count DESC

-- Which time of the day do customers give the most ratings?
SELECT
    time_of_day,
    AVG(rating) AS avg_rating
FROM Sales
GROUP BY time_of_day
ORDER BY avg_rating DESC
LIMIT 1

-- Which time of the day do customers give the most ratings per branch?
SELECT
    branch,
    time_of_day,
    AVG(rating) AS avg_rating
FROM Sales
GROUP BY branch, time_of_day
ORDER BY branch, avg_rating DESC

-- Which day of the week has the best average ratings?
SELECT
    day_name,
    AVG(rating) AS avg_rating
FROM Sales
GROUP BY day_name 
ORDER BY avg_rating DESC
LIMIT 1

-- Which day of the week has the best average ratings per branch?
SELECT 
    branch,
    day_name,
    AVG(rating) AS avg_rating
FROM Sales
GROUP BY branch, day_name
ORDER BY branch, avg_rating DESC

-- Sales

-- Number of sales made in each time of the day per weekday 
SELECT
    day_name,
    time_of_day,
    COUNT(*) AS total_sales
FROM Sales
GROUP BY day_name, time_of_day 
ORDER BY day_name, total_sales DESC

-- Which customer type brings the most revenue?
SELECT
    customer_type,
    SUM(total) AS total_revenue
FROM Sales
GROUP BY customer_type
ORDER BY total_revenue DESC
LIMIT 1
