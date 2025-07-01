-- Project in PostgreSQL 
-- Create the database
CREATE DATABASE retail_data_warehouse;
\c retail_data_warehouse;

-- Product Dimension
CREATE TABLE dim_products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    brand VARCHAR(50)
);

-- Customer Dimension
CREATE TABLE dim_customers (
    customer_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50)
);

-- Store Dimension
CREATE TABLE dim_stores (
    store_id SERIAL PRIMARY KEY,
    store_name VARCHAR(100),
    location VARCHAR(100),
    region VARCHAR(50)
);

-- Time Dimension
CREATE TABLE dim_time (
    time_id SERIAL PRIMARY KEY,
    date DATE,
    day INT,
    month INT,
    year INT,
    quarter INT,
    weekday VARCHAR(15)
);

CREATE TABLE fact_sales (
    sales_id SERIAL PRIMARY KEY,
    product_id INT REFERENCES dim_products(product_id),
    customer_id INT REFERENCES dim_customers(customer_id),
    store_id INT REFERENCES dim_stores(store_id),
    time_id INT REFERENCES dim_time(time_id),
    quantity INT,
    unit_price DECIMAL(10, 2),
    total_amount DECIMAL(12, 2)
);

-- Products
INSERT INTO dim_products (product_name, category, brand) VALUES
('Laptop X1', 'Electronics', 'Lenovo'),
('iPhone 14', 'Mobile Phones', 'Apple'),
('Samsung TV 55"', 'Home Appliances', 'Samsung');

-- Customers
INSERT INTO dim_customers (full_name, email, phone, city, state, country) VALUES
('Alice Smith', 'alice@mail.com', '555-1234', 'New York', 'NY', 'USA'),
('Bob Jones', 'bob@mail.com', '555-5678', 'Los Angeles', 'CA', 'USA');

-- Stores
INSERT INTO dim_stores (store_name, location, region) VALUES
('TechStore NYC', 'New York', 'East'),
('GadgetMart LA', 'Los Angeles', 'West');

-- Time
INSERT INTO dim_time (date, day, month, year, quarter, weekday) VALUES
('2025-04-09', 9, 4, 2025, 2, 'Wednesday'),
('2025-04-10', 10, 4, 2025, 2, 'Thursday');

-- Sales
INSERT INTO fact_sales (product_id, customer_id, store_id, time_id, quantity, unit_price, total_amount) VALUES
(1, 1, 1, 1, 2, 999.99, 1999.98),
(2, 2, 2, 2, 1, 1299.50, 1299.50);

-- Total Sales by Product
SELECT 
    p.product_name,
    SUM(f.total_amount) AS total_sales
FROM fact_sales f
JOIN dim_products p ON f.product_id = p.product_id
GROUP BY p.product_name;

-- Monthly Sales Summary
SELECT 
    t.month,
    t.year,
    SUM(f.total_amount) AS monthly_sales
FROM fact_sales f
JOIN dim_time t ON f.time_id = t.time_id
GROUP BY t.month, t.year
ORDER BY t.year, t.month;

-- Sales by Region
SELECT 
    s.region,
    SUM(f.total_amount) AS region_sales
FROM fact_sales f
JOIN dim_stores s ON f.store_id = s.store_id
GROUP BY s.region;

-- Top 1 Selling Products by Revenue
SELECT 
    p.product_name,
    SUM(f.total_amount) AS total_revenue
FROM fact_sales f
JOIN dim_products p ON f.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC
LIMIT 1;

-- Top Customers by Spending
SELECT 
    c.full_name,
    SUM(f.total_amount) AS total_spent
FROM fact_sales f
JOIN dim_customers c ON f.customer_id = c.customer_id
GROUP BY c.full_name
ORDER BY total_spent DESC
LIMIT 1;

-- Sales Trend Over Time (Daily)
SELECT 
    t.date,
    SUM(f.total_amount) AS daily_sales
FROM fact_sales f
JOIN dim_time t ON f.time_id = t.time_id
GROUP BY t.date
ORDER BY t.date;

-- Sales by Product Category
SELECT 
    p.category,
    SUM(f.total_amount) AS category_sales
FROM fact_sales f
JOIN dim_products p ON f.product_id = p.product_id
GROUP BY p.category
ORDER BY category_sales DESC;

-- Store-wise Sales Breakdown
SELECT 
    s.store_name,
    s.region,
    SUM(f.total_amount) AS store_sales
FROM fact_sales f
JOIN dim_stores s ON f.store_id = s.store_id
GROUP BY s.store_name, s.region
ORDER BY store_sales DESC;

-- Quarterly Sales Overview
SELECT 
    t.year,
    t.quarter,
    SUM(f.total_amount) AS quarterly_sales
FROM fact_sales f
JOIN dim_time t ON f.time_id = t.time_id
GROUP BY t.year, t.quarter
ORDER BY t.year, t.quarter;

-- Average Order Value by Product
SELECT 
    p.product_name,
    AVG(f.total_amount) AS avg_order_value
FROM fact_sales f
JOIN dim_products p ON f.product_id = p.product_id
GROUP BY p.product_name
ORDER BY avg_order_value DESC;

-- Sales on Weekends vs Weekdays
SELECT 
    t.weekday,
    SUM(f.total_amount) AS total_sales
FROM fact_sales f
JOIN dim_time t ON f.time_id = t.time_id
GROUP BY t.weekday
ORDER BY total_sales DESC;

-- Growth in Monthly Sales (YOY % Change)
SELECT 
    t.month,
    t.year,
    SUM(f.total_amount) AS monthly_sales,
    LAG(SUM(f.total_amount)) OVER (PARTITION BY t.month ORDER BY t.year) AS last_year_sales,
    ROUND(
        (SUM(f.total_amount) - LAG(SUM(f.total_amount)) OVER (PARTITION BY t.month ORDER BY t.year)) 
        / NULLIF(LAG(SUM(f.total_amount)) OVER (PARTITION BY t.month ORDER BY t.year), 0) * 100, 2
    ) AS yoy_growth_percent
FROM fact_sales f
JOIN dim_time t ON f.time_id = t.time_id
GROUP BY t.month, t.year
ORDER BY t.year, t.month;

-- Customer Purchase Frequency
SELECT 
    c.full_name,
    COUNT(f.sales_id) AS total_purchases,
    SUM(f.total_amount) AS total_spent
FROM fact_sales f
JOIN dim_customers c ON f.customer_id = c.customer_id
GROUP BY c.full_name
ORDER BY total_purchases DESC;