/* =====================================================
   SALES DATA ANALYSIS PROJECT
   Author: Emil Shafiyev
   Database: PostgreSQL
   ===================================================== */

-- 1. Total revenue by region
-- Business Question:
-- What is the total revenue by region?
SELECT 
  region, 
  SUM(revenue) AS total_revenue
FROM sales
GROUP BY region
ORDER BY total_revenue DESC;
-- Oceania generates the highest total revenue among all regions.

-- 2. Total revenue by product category
-- Business Question:
-- What is the total revenue by product category?
SELECT 
	product_category, 
	SUM(revenue) AS total_revenue
FROM sales
GROUP BY product_category
ORDER BY total_revenue DESC;
-- Automotive is the top-performing product category by revenue.

-- 3. Average Delivery Time by Region
-- Business Question:
-- In what regions does delivery take the longest on average?
SELECT 
	region,
	AVG(delivery_days) AS avg_delivery_days
FROM sales
GROUP BY region
ORDER BY avg_delivery_days DESC;
-- North America has the longest average delivery time.

-- 4. Return Rate Percentage
-- Business Question:
-- What percentage of orders are returned?
SELECT
    ROUND(
        100.0 * SUM(CASE WHEN is_returned = TRUE THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS return_rate
FROM sales;
-- The return rate is 6.06% of total orders.

-- 5. Most Frequently Used Payment Method
-- Business Question:
-- What is the most commonly used payment method?
SELECT
	payment_method,
	COUNT(*) AS number_of_orders
FROM sales
GROUP BY payment_method
ORDER BY number_of_orders DESC;
-- Credit card is the most commonly used payment method.

-- 6. Monthly Revenue Trend
-- Business Question:
-- How does revenue change month to month?
SELECT 
	date_trunc('month', order_date) AS month,
	SUM(revenue) AS total_revenue
FROM sales
GROUP BY month
ORDER BY month;
-- Revenue peaks during November.

-- 7. Impact of Discount on Revenue
-- Business Question:
-- How do discounts affect revenue?
SELECT
    discount_percent,
    AVG(revenue) AS avg_revenue
FROM sales
GROUP BY discount_percent
ORDER BY discount_percent;
-- Higher discounts are associated with decreased average revenue per order.

-- 8. Top 10 Customers by Revenue
-- Business Question:
-- Which clients bring in the most money?
SELECT 
	customer_id AS customer,
	SUM(revenue) AS total_revenue
FROM sales
GROUP BY customer
ORDER BY total_revenue DESC
LIMIT 10;
-- A small group of customers contributes a significant share of total revenue.

-- 9. Revenue Growth Rate
-- Business Question:
-- How is revenue growth changing month-over-month?
SELECT 
    DATE_TRUNC('month', order_date) AS month,
    SUM(revenue) AS revenue,

    LAG(SUM(revenue)) OVER (
        ORDER BY DATE_TRUNC('month', order_date)
    ) AS prev_month_rev,

    ROUND(
        (
            SUM(revenue)
            - LAG(SUM(revenue)) OVER (
                ORDER BY DATE_TRUNC('month', order_date)
            )
        )
        /
        LAG(SUM(revenue)) OVER (
            ORDER BY DATE_TRUNC('month', order_date)
        ) * 100,
        2
    ) AS growth_percent

FROM sales
GROUP BY month
ORDER BY month;
-- Revenue grows significantly in November.

-- 10. Top 3 Products per Region
-- Business Question:
-- What are the 3 most profitable product categories in each region?
SELECT *
FROM (
    SELECT
        region,
        product_category,
        SUM(revenue) AS total_revenue,
        RANK() OVER (
            PARTITION BY region
            ORDER BY SUM(revenue) DESC
        ) AS rank
    FROM sales
    GROUP BY region, product_category
) AS w
WHERE rank <= 3;

-- 11. Cumulative revenue
-- Business Question:
-- How does cumulative revenue grow over time?
SELECT
    order_date,
    SUM(revenue) AS daily_sales,
    SUM(SUM(revenue)) OVER (
        ORDER BY order_date
    ) AS running_total
FROM sales
GROUP BY order_date
ORDER BY order_date
