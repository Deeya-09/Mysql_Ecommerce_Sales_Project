# Ecommerce Sales and Customer Analysis Project

## Project Overview

This project focuses on analysing an e-commerce sales dataset with MYSQL. The project involved setting up a database, performing exploratory data analysis(EDA), and answering specific business questions. 

## Objectives 
1. Create a new database 
2. Clean the data by identifying any null values
3. Perform basic exploratory analysis to understand the dataset 
4. Use Mysql to answer specific business questions and derive insights from them. 

## Dataset 
The dataset contains 5000 records with information about e-commerce transactions, which include:
- Order-Id
- Order Date
- Customer ID
- Product Category
- Region
- Quantity
- Unit Price
- Discount
- Payment Methods
- Delivery Days
- Customer Ratings
- Revenue`

## Database Setup:
A database called e-commerce was created. A table named sales is created in this database to store the dataset. 

## Data Cleaning 
The dataset was cleaned before analysis by checking for duplicates, trailing spaces and creating an extra column called date_cleaned for the formatted dates.

```sql 
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
```

## Data Exploration 

```sql 
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
```

## SQL Analysis 

**1. Write an SQL query to retrieve all columns for sales made on 2022/11/05**

```sql
SELECT *
FROM sales_staging
WHERE date_cleaned = '2022/11/05';
```

**2. Write a query to retrieve all transactions where category is electronics and quantity sold is more than 3 in the month of January 2023.**

```sql
SELECT *
FROM sales_staging
WHERE product_category = 'Electronics'
AND quantity > 3
AND date_cleaned >= '2023-11-01'
AND date_cleaned < '2023-12-01';
```

**3. Write a query to calculate total quantity sold of each category.**

```sql
SELECT (product_category),
SUM(quantity) AS total_quantity_sold
FROM sales_staging
GROUP BY product_category 
ORDER BY total_quantity_sold DESC;
```

**4. Calculate total revenue for each product category.**
```sql
SELECT (product_category),
ROUND(SUM(revenue),2) as total_revenue
FROM sales_staging 
GROUP BY product_category
ORDER BY total_revenue DESC;
```

**5. Which region generated the highest revenue.**
```sql 
SELECT (REGION),
ROUND(SUM(revenue),2) AS total_revenue
FROM sales_staging
GROUP BY region
ORDER BY total_revenue DESC
LIMIT 1;
```

**6. What is the average customer rating for each product category?.**
```sql 
SELECT (product_category),
ROUND(AVG(customer_rating),2)AS avg_cust_rating
FROM sales_staging
GROUP BY product_category 
ORDER BY avg_cust_rating DESC;
```

**7. What is the average delivery time for each region.**
```sql
SELECT (region),
ROUND(AVG(delivery_days)) AS avg_delivery
FROM sales_staging
GROUP BY region
ORDER BY avg_delivery;
```

**8. Which payment method is used most frequently?.**
```sql
SELECT (payment_method),
COUNT(*) AS times_used
FROM sales_staging
GROUP BY payment_method 
ORDER BY times_used DESC
LIMIT 1;
```

**9. Calculate the number of orders made in each product category.**
```sql 
SELECT product_category,
COUNT(*) AS total_orders
FROM sales_staging 
GROUP BY product_category 
ORDER BY total_orders DESC;
```

**10. Which customers placed more than 5 orders and in which category?.**
```sql
SELECT customer_id, product_category,
COUNT(*) as total_orders 
FROM sales_staging 
GROUP BY customer_id, product_category
HAVING COUNT(*) > 5
ORDER BY total_orders DESC; 
```

**11. Find top 10 customers by total revenue generated .**
```sql
SELECT customer_id,
ROUND(SUM(revenue), 2) AS total_revenue
FROM sales_staging 
GROUP BY customer_id
ORDER BY total_revenue DESC
LIMIT 10;
```

**12. Find out the month with highest revenue in each year.**
```sql
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
```

**13. Do longer delivery times tend to have low customer rating?.**
```sql
SELECT delivery_days,
ROUND(AVG(customer_rating), 2) AS 
avg_rating 
FROM sales_staging
GROUP BY delivery_days
ORDER BY delivery_days;
```

**14. Which category had the highest average discount.**
```sql
SELECT product_category,
ROUND(AVG(discount), 4) AS avg_discount 
FROM sales_staging 
GROUP BY product_category 
ORDER BY avg_discount DESC
LIMIT 1;
```

**15. Rank regions by revenue within each year.**
```sql 
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
```


## Findings 

- The West region generated the highest total revenue.
- Electronics was the highest-revenue product category.
- Electronics had the highest quantity sold and the highest number of orders. 
- Card was the most frequently used payment method.
- Clothing category had the highest average discount.
- Six days was the average delivery time for all regions.
- Beauty and Clothing had the highest average customer rating at 3.01, while Home had the lowest at 2.94. Overall, the customer ratings were very similar across all product categories.
- Longer delivery times generally showed lower customer ratings, with 11-day deliveries having lowest average rating of 2.89

  ## Conclusion

This is an introductory SQL data analysis project using an E-commerce sales dataset. The project focused on building foundational SQL skills through data cleaning, exploration, and answering business related questions that covered sales performance, customer behaviour, product categories, regional performance, delivery times, discounts, and customer ratings.


