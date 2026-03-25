# Sales-data-analysis
Data analysis project using PostgreSQL to clean, transform, and analyze sales data to generate business insights.

## Dataset

Name: Synthetic E-Commerce Sales Dataset 2025

Source: Kaggle

Author: Emirhan Akkuş

Link:
[https://www.kaggle.com/USERNAME/DATASET-NAME](https://www.kaggle.com/datasets/emirhanakku/synthetic-e-commerce-sales-dataset-2025)

Note:
The original dataset is large, so a sample version is included in this repository.

## Project Objective

The objective of this project is to analyze sales performance across regions, product categories, and customer segments to identify revenue trends, operational efficiency, and customer behavior patterns.

## Tools
- PostgreSQL
- SQL

## Dataset Description
Dataset: sales

Number of rows: 100,001  
Number of columns: 13
| Column           | Data Type | Description                 |
| ---------------- | --------- | --------------------------- |
| order_id         | INT       | Unique order identifier     |
| customer_id      | TEXT      | Customer unique ID          |
| product_category | TEXT      | Product category            |
| product_price    | NUMERIC   | Price per unit              |
| quantity         | INT       | Number of items             |
| order_date       | DATE      | Date of order               |
| region           | TEXT      | Sales region                |
| payment_method   | TEXT      | Payment type                |
| delivery_days    | INT       | Delivery duration           |
| is_returned      | BOOLEAN   | Whether order was returned  |
| customer_rating  | NUMERIC   | Customer satisfaction score |
| discount_percent | NUMERIC   | Discount applied            |
| revenue          | NUMERIC   | Total revenue               |

## Data Cleaning

- Imported CSV into PostgreSQL
- All columns initially loaded as TEXT
- Converted non-TEXT columns into appropriate data types:
```sql
ALTER TABLE public.sales
    ALTER COLUMN order_id TYPE INT USING order_id::INT,
    ALTER COLUMN product_price TYPE NUMERIC USING product_price::NUMERIC,
    ALTER COLUMN quantity TYPE INT USING quantity::INT,
    ALTER COLUMN order_date TYPE DATE USING order_date::DATE,
    ALTER COLUMN delivery_days TYPE INT USING delivery_days::INT,
    ALTER COLUMN is_returned TYPE BOOLEAN USING is_returned::BOOLEAN,
    ALTER COLUMN customer_rating TYPE NUMERIC USING customer_rating::NUMERIC,
    ALTER COLUMN discount_percent TYPE NUMERIC USING discount_percent::NUMERIC,
    ALTER COLUMN revenue TYPE NUMERIC USING revenue::NUMERIC;
```
## Business Questions

1. What is the total revenue by region?
2. Which product category generates the highest revenue?
3. What is the average delivery time by region?
4. What percentage of orders are returned?
5. Which payment method is used most frequently?
6. How does revenue change over time (monthly trend)?
7. How do discounts affect revenue?
8. Who are the top 10 customers by revenue?
9. What is the month-over-month revenue growth rate?
10. What are the top 3 product categories in each region by revenue?

## Results and Insights
### Question 1: What is the total revenue by region?
```sql
SELECT 
  region, 
  SUM(revenue) AS total_revenue
FROM sales
GROUP BY region
ORDER BY total_revenue DESC;
```
Result:
| region         | total_revenue |
|----------------|--------------|
| Oceania        | 12,438,433.06 |
| Asia           | 12,360,438.71 |
| North America  | 12,252,077.01 |
| Europe         | 12,144,770.62 |
| South America  | 12,115,717.22 |
| Africa         | 12,103,363.48 |

Insight: Oceania generates the highest total revenue among all regions.

### Question 2: What is the total revenue by product category?
```sql
SELECT 
	product_category, 
	SUM(revenue) AS total_revenue
FROM sales
GROUP BY product_category
ORDER BY total_revenue DESC;
```
Result:
| product_category | total_revenue |
|------------------|--------------|
| Automotive       | 10,575,483.05 |
| Sports           | 10,557,715.15 |
| Toys             | 10,553,989.81 |
| Fashion          | 10,497,301.76 |
| Electronics      | 10,488,698.57 |
| Beauty           | 10,372,151.15 |
| Home             | 10,369,460.61 |

Insight: Automotive is the top-performing product category by revenue.

### Question 3: In what regions does delivery take the longest on average?
```sql
SELECT 
	region,
	AVG(delivery_days) AS avg_delivery_days
FROM sales
GROUP BY region
ORDER BY avg_delivery_days DESC;
```
Result:
| region         | avg_delivery_days |
|----------------|------------------|
| North America  | 5.02 |
| Africa         | 4.99 |
| South America  | 4.99 |
| Asia           | 4.98 |
| Europe         | 4.97 |
| Oceania        | 4.96 |

Insight: North America has the longest average delivery time of 5.02 days.

### Question 4: What percentage of orders are returned?
```sql
SELECT
    ROUND(
        100.0 * SUM(CASE WHEN is_returned = TRUE THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS return_rate
FROM sales;
```
Result:
| return_rate |
|-----------------|
| 6.06 |

Insight: The return rate is 6.06% of total orders.

### Question 5: What is the most commonly used payment method?
```sql
SELECT
	payment_method,
	COUNT(*) AS number_of_orders
FROM sales
GROUP BY payment_method
ORDER BY number_of_orders DESC;
```
Result:
| payment_method | number_of_orders |
|----------------|-----------------|
| CreditCard     | 25,222 |
| BankTransfer   | 25,083 |
| PayPal         | 24,985 |
| Cash           | 24,710 |

Insight: Credit cards are the most commonly used payment method.

### Question 6:  How does revenue change month to month?
```sql
SELECT 
	date_trunc('month', order_date) AS month,
	SUM(revenue) AS total_revenue
FROM sales
GROUP BY month
ORDER BY month;
```
Result:
| month | total_revenue |
|------|---------------|
| 2023-01 | 2,020,616.50 |
| 2023-02 | 1,782,552.59 |
| 2023-03 | 2,017,121.91 |
| 2023-04 | 1,974,421.77 |
| 2023-05 | 2,075,931.00 |
| 2023-06 | 2,025,248.62 |
| 2023-07 | 2,024,576.50 |
| 2023-08 | 2,066,567.76 |
| 2023-09 | 1,962,855.76 |
| 2023-10 | 2,083,371.13 |
| 2023-11 | 2,327,911.41 |
| 2023-12 | 2,056,519.51 |
| 2024-01 | 1,999,938.15 |
| ... |
| 2025-10 | 2,046,029.51 |
| 2025-11 | 2,456,581.85 |
| 2025-12 | 2,083,637.83 |

Insight: Revenue peaks during November.

### Question 7: How do discounts affect revenue?
```sql
SELECT
    discount_percent,
    AVG(revenue) AS avg_revenue
FROM sales
GROUP BY discount_percent
ORDER BY discount_percent;
```
Result:
| discount_percent | avg_revenue |
|------------------|-------------|
| 0  | 772.80 |
| 5  | 735.60 |
| 10 | 700.45 |
| 15 | 649.26 |
| 20 | 614.94 |

Insight: Higher discounts are associated with decreased average revenue per order.

### Question 8: Which clients bring in the most money?
```sql
SELECT 
	customer_id AS customer,
	SUM(revenue) AS total_revenue
FROM sales
GROUP BY customer
ORDER BY total_revenue DESC
LIMIT 10;
```
Result:
| customer_id | total_revenue |
|-------------|--------------|
| bd4f82d1-f5c2-436f-85f0-ca7ee66f0cb2 | 2,699.14 |
| d406d1d3-c3b5-44c4-9b35-b6a2febe63a9 | 2,698.81 |
| 26f82440-9f80-4462-a363-b3a261f3f0af | 2,695.79 |
| 2eaba5c6-b7c3-4d7a-adc7-dacd067f3774 | 2,693.30 |
| d7b31071-085f-46f4-bc9b-b425e812bd36 | 2,692.06 |
| ea044387-c743-4603-84cd-79ee5501bb39 | 2,690.60 |
| d727b52b-f011-4887-872c-706345300c86 | 2,685.26 |
| b58244ab-788f-4376-98b8-17d462618710 | 2,677.27 |
| 3de8de21-11d8-4be1-aeb9-c7a5fb0eb61b | 2,676.62 |
| 0d53257b-67e5-4a26-afbc-bd43af57d32e | 2,671.00 |

Insight: A small group of customers contributes a significant share of total revenue.

### Question 9: How is revenue growth changing month-over-month?
```sql
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
```
Result:
| month | revenue | prev_month_rev | growth_percent |
|------|--------|-----------------------|-----------|
| 2023-02 | 1,782,552.59 | 2,020,616.50 | -11.78 |
| 2023-03 | 2,017,121.91 | 1,782,552.59 | 13.16 |
| 2023-04 | 1,974,421.77 | 2,017,121.91 | -2.12 |
| 2023-05 | 2,075,931.00 | 1,974,421.77 | 5.14 |
| 2023-06 | 2,025,248.62 | 2,075,931.00 | -2.44 |
| ... |
| 2025-11 | 2,456,581.85 | 2,046,029.51 | 20.07 |
| 2025-12 | 2,083,637.83 | 2,456,581.85 | -15.18 |

Insight: Revenue grows significantly in November.

### Question 10: What are the 3 most profitable product categories in each region?
```sql
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
```
Result:
| region | product_category | total_revenue | rank |
|-------|------------------|--------------|-----|
| Africa | Sports | 1,741,033.40 | 1 |
| Africa | Automotive | 1,738,649.80 | 2 |
| Africa | Toys | 1,738,530.03 | 3 |
| Asia | Electronics | 1,834,722.73 | 1 |
| Asia | Automotive | 1,812,036.02 | 2 |
| Asia | Sports | 1,783,981.07 | 3 |
| Europe | Automotive | 1,758,535.47 | 1 |
| Europe | Toys | 1,754,848.82 | 2 |
| Europe | Electronics | 1,753,402.29 | 3 |
| North America | Fashion | 1,811,207.47 | 1 |
| North America | Automotive | 1,769,313.39 | 2 |
| North America | Beauty | 1,756,494.31 | 3 |
| Oceania | Fashion | 1,849,317.33 | 1 |
| Oceania | Toys | 1,804,317.11 | 2 |
| Oceania | Home | 1,798,355.09 | 3 |
| South America | Toys | 1,807,370.08 | 1 |
| South America | Sports | 1,783,024.25 | 2 |
| South America | Automotive | 1,758,093.29 | 3 |

### Question 11: How does cumulative revenue grow over time?
```sql
SELECT
    order_date,
    SUM(revenue) AS daily_sales,
    SUM(SUM(revenue)) OVER (
        ORDER BY order_date
    ) AS running_total
FROM sales
GROUP BY order_date
ORDER BY order_date
```
Result:
| order_date | daily_sales | running_total |
|------------|--------------|---------------|
| 2023-01-01 | 53,967.21 | 53,967.21 |
| 2023-01-02 | 56,759.49 | 110,726.70 |
| 2023-01-03 | 63,499.54 | 174,226.24 |
| 2023-01-04 | 83,437.61 | 257,663.85 |
| 2023-01-05 | 62,431.85 | 320,095.70 |
| ... |
| 2025-09-21 | 75,080.44 | 66,279,135.28 |
| 2025-09-22 | 62,914.24 | 66,342,049.52 |
| 2025-09-23 | 55,138.06 | 66,397,187.58 |
| 2025-09-24 | 57,383.37 | 66,454,570.95 |
| 2025-09-25 | 61,022.64 | 66,515,593.59 |
| 2025-09-26 | 58,226.43 | 66,573,820.02 |

## Analysis Approach

The analysis focuses on key business performance indicators, including:

- Revenue distribution across regions and product categories
- Customer purchasing behavior
- Delivery performance
- Return rates
- Sales trends over time
- Impact of discounts on revenue

## Repository Structure

## Project Structure

```text
sales-data-analysis/
├── data/
│   ├── results/
│   │   ├── avg_delivery_time_by_region.csv
│   │   ├── cumulative_revenue.csv
│   │   ├── discount_on_rev_impact.csv
│   │   ├── most_freq_pay_md.csv
│   │   ├── return_rate_percentage.csv
│   │   ├── revenue_change_m_to_m.csv
│   │   ├── revenue_growth_rate.csv
│   │   ├── top_10_customer_by_rev.csv
│   │   ├── top_3_prod_per_region.csv
│   │   ├── total_revenue_by_product_category.csv
│   │   └── total_revenue_by_region.csv
│   └── sample_dataset/
│       └── sample_sales.csv
├── sql/
│   └── queries.sql
├── LICENSE
└── README.md
