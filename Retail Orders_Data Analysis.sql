/*
-- Creating table and importing preprocessed csv file from Jupyter Notebook
CREATE TABLE df_orders(
	order_id INT PRIMARY KEY,
	order_date DATE,
	ship_mode VARCHAR(20), 
	segment VARCHAR(20), 
	country VARCHAR(20), 
	city VARCHAR(20), 
	state VARCHAR(20), 
	postal_code VARCHAR(20), 
	region VARCHAR(20), 
	category VARCHAR(20), 
	sub_category VARCHAR(20),
	product_id VARCHAR(20), 
	quantity INT, 
	discount decimal(7, 2), 
	sale_price decimal(7, 2), 
	profit decimal(7, 2)
	)
*/

-- Complete table view
SELECT * 
FROM df_orders


-- SQL Query for the following Data Analysis :

-- 1. Top 10 highest revenue generating products.
SELECT top 10 product_id, SUM(sale_price) AS sales
FROM df_orders
GROUP BY product_id
ORDER BY sales DESC

-- 2. Top 5 highest selling products in each reason.
WITH cte_1 AS (
SELECT region, product_id, SUM(sale_price) AS sales
FROM df_orders
GROUP BY region, product_id
),

cte_2 AS (
SELECT *, 
ROW_NUMBER() OVER(
	PARTITION BY region 
	ORDER BY sales DESC
	) AS serial_num
FROM cte_1
)

SELECT *
FROM cte_2
WHERE serial_num < 6

-- 3. Month over month growth comparison for 2022 and 2023 sales eg : Jan 2022 vs Jan 2023
with compare AS (
SELECT YEAR(order_date) AS years, MONTH(order_date) AS months, 
	   SUM(sale_price) AS sales
FROM df_orders
WHERE YEAR(order_date) IN (2022, 2023)
GROUP BY YEAR(order_date), MONTH(order_date)
)

SELECT months,
	   SUM(CASE WHEN years = 2022 THEN sales ELSE 0 END) AS sales_2022,
	   SUM(CASE WHEN years = 2023 THEN sales ELSE 0 END) AS sales_2023
FROM compare
GROUP BY months
ORDER BY months

-- 4. For each category, which month had highest sales?
with cat AS (
SELECT category, FORMAT(order_date, 'yyyyMM') AS year_month, 
SUM(sale_price) AS sales
FROM df_orders
GROUP BY category, FORMAT(order_date, 'yyyyMM')
),

ranking AS (
SELECT *, 
ROW_NUMBER() OVER (
	PARTITION BY category
	ORDER BY sales DESC
	) AS rn
FROM cat
)

SELECT category, year_month, sales
FROM ranking
WHERE rn = 1

-- 5. For each category and for each year, which month had highest sales?
with cat_year AS (
SELECT category, FORMAT(order_date, 'yyyyMM') AS year_month, 
SUM(sale_price) AS sales
FROM df_orders
GROUP BY category, FORMAT(order_date, 'yyyyMM')
),

ranking_cat AS (
SELECT *,
CASE WHEN year_month > 202200 AND year_month < 202213 THEN 2022 ELSE 2023 END AS years,
MAX(sales) OVER (
	PARTITION BY category, CASE WHEN year_month > 202200 AND year_month < 202213 THEN 2022 ELSE 2023 END
	ORDER BY sales DESC
	) AS max_sales
FROM cat_year
)

SELECT category, years, year_month, sales
FROM ranking_cat
WHERE sales = max_sales
ORDER BY category

-- 6. Sub-Category which had the highest percentage growth by profit in 2023 as compared to 2022
WITH subcat_1 AS (
SELECT sub_category, YEAR(order_date) AS years, SUM(profit) AS profit
FROM df_orders
GROUP BY sub_category, YEAR(order_date)
),

subcat_2 AS (
SELECT sub_category, 
SUM( CASE WHEN years = 2022 THEN profit ELSE 0 END) AS profit_2022,
SUM( CASE WHEN years = 2023 THEN profit ELSE 0 END) AS profit_2023
FROM subcat_1
GROUP BY sub_category
)

SELECT Top 1*, (profit_2023 - profit_2022) * 100 / profit_2022 AS growth_percent
FROM subcat_2
WHERE profit_2022 < profit_2023
ORDER BY growth_percent DESC

-- 7. Top 8 highest quantity of orders placed by state and their ordering trend over the year 2022 and 2023
WITH qa_1 AS (
SELECT YEAR(order_date) AS years, [state], SUM(quantity) AS quantity_ordered
FROM df_orders
GROUP BY [state], YEAR(order_date)
),

qa_2 AS (
SELECT [state],
SUM(CASE WHEN years = 2022 THEN quantity_ordered ELSE 0 END) AS quantity_ordered_2022,
SUM(CASE WHEN years = 2023 THEN quantity_ordered ELSE 0 END) AS quantity_ordered_2023
FROM qa_1 
GROUP BY [state]
)

SELECT TOP 8*, 
(quantity_ordered_2023 - quantity_ordered_2022) AS increase_in_orders
FROM qa_2
ORDER BY quantity_ordered_2022 DESC

select* from df_orders

-- 8. For each region, highest discount offered in which segment?
;WITH rsd_1 AS (
SELECT region, segment, SUM(discount) AS discount
FROM df_orders
GROUP BY region, segment
),

rsd_2 AS (
SELECT *,
ROW_NUMBER() OVER (
	PARTITION BY region
	ORDER BY discount DESC
	) AS sn
FROM rsd_1
)

SELECT region, segment, discount
FROM rsd_2
where sn = 1