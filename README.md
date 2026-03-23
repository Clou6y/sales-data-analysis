# Sales-data-analysis
Data analysis project using PostgreSQL to clean, transform, and analyze sales data to generate business insights.

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

## Analysis Approach

The analysis focuses on key business performance indicators, including:

- Revenue distribution across regions and product categories
- Customer purchasing behavior
- Delivery performance
- Return rates
- Sales trends over time
- Impact of discounts on revenue

## Repository Structure

sales-data-analysis

README.md 
queries.sql
LICENSE
