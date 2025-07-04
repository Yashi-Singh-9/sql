-- Project in PostgreSQL 
-- Create the database
CREATE DATABASE farmer_market;
\c farmer_market;

CREATE TABLE vendors (
    vendor_id SERIAL PRIMARY KEY,
    vendor_name VARCHAR(100),
    contact_email VARCHAR(100),
    phone_number VARCHAR(20),
    location TEXT,
    registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE product_categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) UNIQUE
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    vendor_id INT REFERENCES vendors(vendor_id),
    category_id INT REFERENCES product_categories(category_id),
    product_name VARCHAR(100),
    unit_price NUMERIC(8, 2),
    unit_measurement VARCHAR(20), -- e.g., "kg", "bunch", "dozen"
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE inventory (
    inventory_id SERIAL PRIMARY KEY,
    product_id INT REFERENCES products(product_id),
    quantity_available NUMERIC(10, 2), -- e.g., 20.5 kg
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    product_id INT REFERENCES products(product_id),
    quantity_sold NUMERIC(10, 2),
    total_amount NUMERIC(10, 2),
    sold_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO vendors (vendor_name, contact_email, phone_number, location) VALUES
('Green Valley Farm', 'contact@greenvalley.com', '555-1010', 'North Market'),
('Sunny Acres', 'info@sunnyacres.com', '555-2020', 'East Market'),
('Bloom Organics', 'hello@bloomorganics.com', '555-3030', 'Downtown');

INSERT INTO product_categories (category_name) VALUES
('Vegetables'),
('Fruits'),
('Dairy'),
('Baked Goods'),
('Herbs');

INSERT INTO products (vendor_id, category_id, product_name, unit_price, unit_measurement) VALUES
(1, 1, 'Carrots', 2.50, 'kg'),
(2, 2, 'Apples', 3.00, 'kg'),
(3, 3, 'Goat Milk', 4.00, 'liter'),
(1, 4, 'Whole Wheat Bread', 5.00, 'loaf'),
(2, 5, 'Basil', 1.50, 'bunch');

INSERT INTO inventory (product_id, quantity_available) VALUES
(1, 50),
(2, 30),
(3, 20),
(4, 15),
(5, 40);

INSERT INTO sales (product_id, quantity_sold, total_amount) VALUES
(1, 5, 12.50),
(2, 3, 9.00),
(4, 2, 10.00),
(5, 10, 15.00);

-- Show current stock levels
SELECT p.product_name, i.quantity_available, p.unit_measurement
FROM inventory i
JOIN products p ON i.product_id = p.product_id
ORDER BY i.quantity_available DESC;

-- Top selling products by quantity
SELECT p.product_name, SUM(s.quantity_sold) AS total_sold
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC;

-- Total revenue per vendor
SELECT v.vendor_name, SUM(s.total_amount) AS revenue
FROM sales s
JOIN products p ON s.product_id = p.product_id
JOIN vendors v ON p.vendor_id = v.vendor_id
GROUP BY v.vendor_name
ORDER BY revenue DESC;

-- Total Revenue by Product Category
SELECT 
    c.category_name,
    SUM(s.total_amount) AS total_revenue
FROM sales s
JOIN products p ON s.product_id = p.product_id
JOIN product_categories c ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY total_revenue DESC;

-- Recent Sales (Last 7 Days)
SELECT 
    p.product_name,
    s.quantity_sold,
    s.total_amount,
    s.sold_at
FROM sales s
JOIN products p ON s.product_id = p.product_id
WHERE s.sold_at >= NOW() - INTERVAL '7 days'
ORDER BY s.sold_at DESC;

-- Sales Summary per Vendor
SELECT 
    v.vendor_name,
    COUNT(s.sale_id) AS total_transactions,
    SUM(s.quantity_sold) AS total_quantity,
    SUM(s.total_amount) AS total_revenue
FROM sales s
JOIN products p ON s.product_id = p.product_id
JOIN vendors v ON p.vendor_id = v.vendor_id
GROUP BY v.vendor_name
ORDER BY total_revenue DESC;

-- Inventory Valuation
SELECT 
    p.product_name,
    i.quantity_available,
    p.unit_price,
    ROUND(i.quantity_available * p.unit_price, 2) AS inventory_value
FROM inventory i
JOIN products p ON i.product_id = p.product_id
ORDER BY inventory_value DESC;

-- Daily Sales Summary
SELECT 
    DATE(s.sold_at) AS sale_date,
    COUNT(*) AS transactions,
    SUM(s.quantity_sold) AS total_quantity,
    SUM(s.total_amount) AS total_revenue
FROM sales s
GROUP BY sale_date
ORDER BY sale_date DESC;

-- Best-Selling Product per Vendor
SELECT 
    v.vendor_name,
    p.product_name,
    SUM(s.quantity_sold) AS total_sold
FROM vendors v
JOIN products p ON v.vendor_id = p.vendor_id
JOIN sales s ON p.product_id = s.product_id
GROUP BY v.vendor_name, p.product_name
ORDER BY v.vendor_name, total_sold DESC;

-- Average Sales Price per Product
SELECT 
    p.product_name,
    ROUND(AVG(s.total_amount / s.quantity_sold), 2) AS avg_unit_price
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.product_name;

-- Product List with Vendor and Category
SELECT 
    p.product_name,
    v.vendor_name,
    c.category_name,
    p.unit_price,
    p.unit_measurement
FROM products p
JOIN vendors v ON p.vendor_id = v.vendor_id
JOIN product_categories c ON p.category_id = c.category_id
ORDER BY v.vendor_name;

-- Products Never Sold
SELECT 
    p.product_name,
    v.vendor_name
FROM products p
JOIN vendors v ON p.vendor_id = v.vendor_id
LEFT JOIN sales s ON p.product_id = s.product_id
WHERE s.sale_id IS NULL;
