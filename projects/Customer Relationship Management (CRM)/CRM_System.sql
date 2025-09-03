-- Project In MariaDB 
-- Creating the database
CREATE DATABASE CRM_System;
USE CRM_System;

-- Customers Table  
CREATE TABLE customers (
  customer_id INT PRIMARY KEY AUTO_INCREMENT,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  email VARCHAR(100) UNIQUE,
  phone BIGINT,
  address VARCHAR(100),
  created_at DATETIME
);

-- Leads Table 
CREATE TABLE leads (
  lead_id INT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT,
  sources VARCHAR(50),
  status ENUM('New', 'Contacted', 'Converted', 'Lost'),
  created_at DATETIME,
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Sales_Reps Table 
CREATE table sales_reps (
  sales_rep_id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50),
  email VARCHAR(50) UNIQUE,
  phone BIGINT,
  hire_date DATE
);

-- Sales Table 
CREATE TABLE sales (
  sale_id INT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT,
  sales_rep_id INT,
  total_amount DECIMAL(10,2),
  sale_date DATE,
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  FOREIGN KEY (sales_rep_id) REFERENCES sales_reps(sales_rep_id)
);

-- Interactions Table  
CREATE TABLE interactions (
  interaction_id INT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT,
  interaction_type ENUM('Call', 'Email', 'Meeting', 'Chat'),
  interaction_date DATE,
  notes TEXT,
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Products Table  
CREATE TABLE products (
  product_id INT PRIMARY KEY AUTO_INCREMENT,
  product_name VARCHAR(50),
  price DECIMAL(10,2),
  category VARCHAR(50)
);

-- Orders Table  
CREATE TABLE orders (
  order_id INT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT,
  order_date DATE,
  status ENUM('Pending', 'Shipped', 'Delivered', 'Canceled'),
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Order Items Table 
CREATE TABLE order_items (
  order_item_id INT PRIMARY KEY AUTO_INCREMENT,
  order_id INT,
  product_id INT,
  quantity INT,
  price_at_time_of_order DECIMAL(10,2),
  FOREIGN KEY (order_id) REFERENCES orders(order_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Support Tickets Table 
CREATE TABLE support_tickets (
  ticket_id INT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT,
  issue_description TEXT,
  status ENUM('Open', 'In Progress', 'Resolved'),
  created_at DATE,
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);  

-- Insert Sample Customers
INSERT INTO customers (first_name, last_name, email, phone, address, created_at) VALUES
('John', 'Doe', 'john.doe@example.com', 9876543210, '123 Main St', NOW()),
('Jane', 'Smith', 'jane.smith@example.com', 8765432109, '456 Oak St', NOW()),
('Mike', 'Brown', 'mike.brown@example.com', 7654321098, '789 Pine St', NOW()),
('Emily', 'Davis', 'emily.davis@example.com', 6543210987, '321 Cedar St', NOW()),
('Chris', 'Wilson', 'chris.wilson@example.com', 5432109876, '555 Birch St', NOW());

-- Insert Sample Leads
INSERT INTO leads (customer_id, sources, status, created_at) VALUES
(1, 'Website', 'New', NOW()),
(2, 'Referral', 'Contacted', NOW()),
(3, 'Advertisement', 'Converted', NOW()),
(4, 'Cold Call', 'Lost', NOW()),
(5, 'Social Media', 'New', NOW());

-- Insert Sample Sales Reps
INSERT INTO sales_reps (name, email, phone, hire_date) VALUES
('Alice Johnson', 'alice.j@example.com', 9876543211, '2023-05-15'),
('Bob Anderson', 'bob.a@example.com', 8765432108, '2022-07-21'),
('Charlie White', 'charlie.w@example.com', 7654321097, '2021-09-30'),
('David Martinez', 'david.m@example.com', 6543210986, '2020-11-12'),
('Eve Taylor', 'eve.t@example.com', 5432109875, '2019-03-18');

-- Insert Sample Sales
INSERT INTO sales (customer_id, sales_rep_id, total_amount, sale_date) VALUES
(1, 1, 500.00, '2024-02-01'),
(2, 2, 750.50, '2024-02-05'),
(3, 1, 1200.00, '2024-02-10'),
(4, 3, 300.75, '2024-02-15'),
(5, 2, 950.20, '2024-02-20');

-- Insert Sample Interactions
INSERT INTO interactions (customer_id, interaction_type, interaction_date, notes) VALUES
(1, 'Call', '2024-01-10', 'Discussed product details'),
(2, 'Email', '2024-01-12', 'Sent quotation'),
(3, 'Meeting', '2024-01-15', 'Demo conducted'),
(4, 'Chat', '2024-01-18', 'Customer had general queries'),
(5, 'Call', '2024-01-20', 'Follow-up on interest');

-- Insert Sample Products
INSERT INTO products (product_name, price, category) VALUES
('Laptop', 1200.00, 'Electronics'),
('Smartphone', 800.00, 'Electronics'),
('Headphones', 150.00, 'Accessories'),
('Desk Chair', 300.00, 'Furniture'),
('Backpack', 75.00, 'Travel');

-- Insert Sample Orders
INSERT INTO orders (customer_id, order_date, status) VALUES
(1, '2024-02-02', 'Pending'),
(2, '2024-02-06', 'Shipped'),
(3, '2024-02-11', 'Delivered'),
(4, '2024-02-16', 'Canceled'),
(5, '2024-02-21', 'Pending');

-- Insert Sample Order Items
INSERT INTO order_items (order_id, product_id, quantity, price_at_time_of_order) VALUES
(1, 1, 1, 1200.00),
(2, 2, 2, 800.00),
(3, 3, 3, 150.00),
(4, 4, 1, 300.00),
(5, 5, 2, 75.00);

-- Insert Sample Support Tickets
INSERT INTO support_tickets (customer_id, issue_description, status, created_at) VALUES
(1, 'Issue with laptop performance', 'Open', '2024-02-03'),
(2, 'Smartphone battery draining fast', 'In Progress', '2024-02-07'),
(3, 'Headphones not connecting', 'Resolved', '2024-02-12'),
(4, 'Desk chair missing parts', 'Open', '2024-02-17'),
(5, 'Backpack strap issue', 'In Progress', '2024-02-22');

-- Find the top 5 sales representatives based on total sales.
SELECT s.sales_rep_id, sr.name, SUM(s.total_amount) AS total_sales
FROM sales s
JOIN sales_reps sr ON s.sales_rep_id = sr.sales_rep_id
GROUP BY s.sales_rep_id
ORDER BY total_sales DESC
LIMIT 5;

-- List all customers who have open support tickets.
SELECT DISTINCT c.* 
FROM customers c
JOIN support_tickets st ON c.customer_id = st.customer_id
WHERE st.status = 'Open';

-- Show the total sales amount for each sales representative.
SELECT sr.sales_rep_id, sr.name, COALESCE(SUM(s.total_amount), 0) AS total_sales
FROM sales_reps sr
LEFT JOIN sales s ON sr.sales_rep_id = s.sales_rep_id
GROUP BY sr.sales_rep_id;

-- Find the most frequently used interaction type with customers.
SELECT interaction_type, COUNT(*) AS count_usage
FROM interactions
GROUP BY interaction_type
ORDER BY count_usage DESC
LIMIT 1;

-- Show customers whose latest interaction was more than 6 months ago.
SELECT c.* 
FROM customers c
JOIN interactions i ON c.customer_id = i.customer_id
GROUP BY c.customer_id
HAVING MAX(i.interaction_date) < CURDATE() - INTERVAL 6 MONTH;

-- Find the total revenue generated from each product.
SELECT p.product_id, p.product_name, COALESCE(SUM(oi.quantity * oi.price_at_time_of_order), 0) AS total_revenue
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name;

-- Show the conversion rate of leads to actual customers.
SELECT 
    (COUNT(DISTINCT s.customer_id) * 100.0 / COUNT(DISTINCT l.customer_id)) AS conversion_rate
FROM leads l
LEFT JOIN sales s ON l.customer_id = s.customer_id;

-- Retrieve Customer Details Along with Their Total Orders
SELECT c.customer_id, c.first_name, c.last_name, COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_orders DESC;

-- List All Orders with Their Products and Quantities
SELECT o.order_id, c.first_name, c.last_name, p.product_name, oi.quantity, oi.price_at_time_of_order
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN customers c ON o.customer_id = c.customer_id
ORDER BY o.order_id;

-- Find the Most Popular Product Sold
SELECT p.product_id, p.product_name, SUM(oi.quantity) AS total_quantity_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_quantity_sold DESC
LIMIT 1;

-- Get the Monthly Sales Report
SELECT DATE_FORMAT(s.sale_date, '%Y-%m') AS month, SUM(s.total_amount) AS total_sales
FROM sales s
GROUP BY month
ORDER BY month DESC;

-- Find All Customers With Pending Orders
SELECT DISTINCT c.customer_id, c.first_name, c.last_name, c.email
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status = 'Pending';

-- Show the Average Sale Amount for Each Sales Rep
SELECT sr.sales_rep_id, sr.name, AVG(s.total_amount) AS avg_sale_amount
FROM sales_reps sr
LEFT JOIN sales s ON sr.sales_rep_id = s.sales_rep_id
GROUP BY sr.sales_rep_id, sr.name;
