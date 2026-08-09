-- ECOMMERCE SALES AND CUSTOMER ANALYSIS PROJECT

-- CREATE NEW TABLE
CREATE TABLE sales_staging
LIKE sales;

INSERT INTO sales_staging 
SELECT *
FROM sales;

-- DATA CLEANING (FORMATTING DATE)
ALTER TABLE sales_staging
ADD COLUMN date_cleaned DATE;

UPDATE sales_staging 
SET date_cleaned = STR_TO_DATE(order_date, '%m/%d/%Y');

SELECT * 
FROM sales_staging;

-- CHECKING ACCURACY OF DATE
SELECT order_date, date_cleaned
FROM sales_staging;

SELECT * 
FROM sales_staging 
WHERE date_cleaned IS NULL;

SELECT COUNT(date_cleaned)
FROM sales_staging;

-- CHECKING FOR NULL VALUES

SELECT * 
FROM sales_staging 
WHERE order_id  IS NULL
OR
customer_id  IS NULL
OR
product_category  IS NULL
OR
region  IS NULL
OR
quantity IS NULL
OR
unit_price IS NULL
OR
discount IS NULL
OR
payment_method IS NULL
OR
delivery_days IS NULL
OR 
customer_rating IS NULL
OR 
revenue IS NULL
OR
date_cleaned IS NULL;

-- DATA EXPLORATION
-- Total sales
SELECT COUNT(*) AS total_sales 
FROM sales_staging;

-- Number of unique customers
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM sales_staging;

-- Number of unique categories
SELECT COUNT(DISTINCT product_category) AS total_category
FROM sales_staging;

-- DATA ANALYSIS
-- Q1. Write an SQL query to retrieve all columns for sales made on 2022/11/05

SELECT *
FROM sales_staging
WHERE date_cleaned = '2022/11/05';

-- Q2. Write a query to retrieve all transactions where category is electronics and quantity sold is more than 3 in the month of January 2023.
SELECT *
FROM sales_staging
WHERE product_category = 'Electronics'
AND quantity > 3
AND date_cleaned >= '2023-11-01'
AND date_cleaned < '2023-12-01';

-- Q3. Write a query to calculate total quantity sold of each category
SELECT (product_category),
SUM(quantity) AS total_quantity_sold
FROM sales_staging
GROUP BY product_category 
ORDER BY total_quantity_sold DESC;

-- Q4. Calculate total revenue for each product category 
SELECT (product_category),
ROUND(SUM(revenue),2) as total_revenue
FROM sales_staging 
GROUP BY product_category
ORDER BY total_revenue DESC;

-- Q5. Which region generated the highest revenue
SELECT (REGION),
ROUND(SUM(revenue),2) AS total_revenue
FROM sales_staging
GROUP BY region
ORDER BY total_revenue DESC
LIMIT 1;

-- Q6. What is the average customer rating for each product category?
SELECT (product_category),
ROUND(AVG(customer_rating),2)AS avg_cust_rating
FROM sales_staging
GROUP BY product_category 
ORDER BY avg_cust_rating DESC;

-- Q7. What is the average delivery time for each region
SELECT (region),
ROUND(AVG(delivery_days)) AS avg_delivery
FROM sales_staging
GROUP BY region
ORDER BY avg_delivery;

-- Q8. Which payment method is used most frequently?
SELECT (payment_method),
COUNT(*) AS times_used
FROM sales_staging
GROUP BY payment_method 
ORDER BY times_used DESC
LIMIT 1;

-- Q9. Calculate the number of orders made in each product category
SELECT product_category,
COUNT(*) AS total_orders
FROM sales_staging 
GROUP BY product_category 
ORDER BY total_orders DESC;

-- Q10. Which customers placed more than 5 orders and in which category?
SELECT customer_id, product_category,
COUNT(*) as total_orders 
FROM sales_staging 
GROUP BY customer_id, product_category
HAVING COUNT(*) > 5
ORDER BY total_orders DESC; 

-- Q11. Find top 10 customers by total revenue generated 
SELECT customer_id,
ROUND(SUM(revenue), 2) AS total_revenue
FROM sales_staging 
GROUP BY customer_id
ORDER BY total_revenue DESC
LIMIT 10;

-- Q12. Find out the month with highest revenue in each year 
SELECT year, month, total_revenue
FROM
( 
SELECT 
EXTRACT(YEAR FROM date_cleaned) as year,
EXTRACT(MONTH FROM date_cleaned) as month,
SUM(revenue) as total_revenue,
RANK() OVER(PARTITION BY EXTRACT(YEAR from date_cleaned) ORDER BY SUM(revenue) DESC) as rank_num
FROM sales_staging
GROUP BY 1, 2
) AS t1
WHERE rank_num = 1;

-- Q13. Do longer delivery times tend to have low customer rating?
SELECT delivery_days,
ROUND(AVG(customer_rating), 2) AS 
avg_rating 
FROM sales_staging
GROUP BY delivery_days
ORDER BY delivery_days;

-- Q14. Which category had the highest average discount 
SELECT product_category,
ROUND(AVG(discount), 4) AS avg_discount 
FROM sales_staging 
GROUP BY product_category 
ORDER BY avg_discount DESC
LIMIT 1;

-- Q15. Rank regions by revenue within each year 
WITH yearly_region_revenue AS
(
SELECT 
EXTRACT(YEAR from date_cleaned) as year,
region,
SUM(revenue) as total_revenue
FROM sales_staging 
GROUP BY year, region
)
SELECT year, region, 
ROUND(total_revenue, 2) AS total_revenue,
RANK() OVER(PARTITION BY year
ORDER BY total_revenue DESC) as rank_num
FROM yearly_region_revenue
ORDER BY year, rank_num;

-- End of project