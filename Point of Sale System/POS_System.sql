-- Project in PostgreSQL 
-- Create the database
CREATE DATABASE POS_System;
\c POS_System; 

-- Create Users Table
CREATE TABLE users (
  user_id SERIAL PRIMARY KEY,
  username VARCHAR(50) NOT NULL,
  passwords TEXT NOT NULL,
  roles VARCHAR(15) CHECK (roles IN ('Admin', 'Cashier', 'Manager', 'Supervisor', 'Stock Keeper', 'Accountant', 'HR')) NOT NULL
);

-- Create Customers Table
CREATE TABLE customers (
  customer_id SERIAL PRIMARY KEY,
  customer_name VARCHAR(50) NOT NULL,
  phone BIGINT UNIQUE NOT NULL,
  email VARCHAR(50) UNIQUE NOT NULL,
  address TEXT
);

-- Create Categories Table
CREATE TABLE categories (
  category_id SERIAL PRIMARY KEY,
  category_name VARCHAR(50) NOT NULL
);

-- Create Products Table
CREATE TABLE products (
  product_id SERIAL PRIMARY KEY,
  products_name VARCHAR(50) NOT NULL,
  description TEXT,
  price DECIMAL(10,2) NOT NULL,
  stock_quantity INT NOT NULL CHECK (stock_quantity >= 0),
  category_id INT REFERENCES categories(category_id) ON DELETE SET NULL
);

-- Create Orders Table
CREATE TABLE orders (
  order_id SERIAL PRIMARY KEY,
  customer_id INT REFERENCES customers(customer_id) ON DELETE CASCADE,
  user_id INT REFERENCES users(user_id) ON DELETE SET NULL,
  order_date DATE DEFAULT CURRENT_DATE,
  total_amount DECIMAL(10,2) NOT NULL CHECK (total_amount >= 0)
);

-- Create Order Items Table
CREATE TABLE order_items (
  order_item_id SERIAL PRIMARY KEY,
  order_id INT REFERENCES orders(order_id) ON DELETE CASCADE,
  product_id INT REFERENCES products(product_id) ON DELETE CASCADE,
  quantity INT NOT NULL CHECK (quantity > 0),
  subtotal DECIMAL(10,2) NOT NULL CHECK (subtotal >= 0)
);

-- Create Payments Table
CREATE TABLE payments (
  payment_id SERIAL PRIMARY KEY,
  order_id INT REFERENCES orders(order_id) ON DELETE CASCADE,
  payment_method VARCHAR(20) NOT NULL,
  amount_paid DECIMAL(10,2) NOT NULL CHECK (amount_paid >= 0),
  payment_date DATE DEFAULT CURRENT_DATE
);

-- Create Inventory Table
CREATE TABLE inventory (
  inventory_id SERIAL PRIMARY KEY,
  product_id INT REFERENCES products(product_id) ON DELETE CASCADE,
  stock_in INT DEFAULT 0 CHECK (stock_in >= 0),
  stock_out INT DEFAULT 0 CHECK (stock_out >= 0),
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data into users table
INSERT INTO users (username, passwords, roles) VALUES
('admin1', 'pass123', 'Admin'),
('cashier1', 'cash123', 'Cashier'),
('manager1', 'man123', 'Manager'),
('supervisor1', 'sup123', 'Supervisor'),
('stockkeeper1', 'stock123', 'Stock Keeper'),
('accountant1', 'acc123', 'Accountant'),
('hr1', 'hr123', 'HR');

-- Insert sample data into customers table
INSERT INTO customers (customer_name, phone, email, address) VALUES
('John Doe', 9876543210, 'john@example.com', '123 Main St'),
('Jane Smith', 9876543211, 'jane@example.com', '456 Elm St'),
('Michael Brown', 9876543212, 'michael@example.com', '789 Oak St'),
('Emily Johnson', 9876543213, 'emily@example.com', '101 Pine St'),
('Chris Wilson', 9876543214, 'chris@example.com', '202 Maple St'),
('Sarah Lee', 9876543215, 'sarah@example.com', '303 Birch St'),
('David Miller', 9876543216, 'david@example.com', '404 Cedar St');

-- Insert sample data into categories table
INSERT INTO categories (category_name) VALUES
('Electronics'),
('Clothing'),
('Furniture'),
('Books'),
('Groceries'),
('Toys'),
('Beauty & Health');

-- Insert sample data into products table
INSERT INTO products (products_name, description, price, stock_quantity, category_id) VALUES
('Laptop', '15-inch gaming laptop', 999.99, 10, 1),
('T-Shirt', 'Cotton t-shirt size M', 19.99, 50, 2),
('Sofa', 'Comfortable 3-seater sofa', 499.99, 5, 3),
('Novel', 'Bestselling fiction book', 14.99, 30, 4),
('Apples', 'Fresh organic apples per kg', 2.99, 100, 5),
('Action Figure', 'Superhero action figure', 24.99, 20, 6),
('Shampoo', 'Herbal shampoo 500ml', 7.99, 25, 7);

-- Insert sample data into orders table
INSERT INTO orders (customer_id, user_id, order_date, total_amount) VALUES
(1, 2, '2024-02-01', 1019.98),
(2, 3, '2024-02-02', 19.99),
(3, 4, '2024-02-03', 514.98),
(4, 5, '2024-02-04', 14.99),
(5, 6, '2024-02-05', 5.98),
(6, 7, '2024-02-06', 24.99),
(7, 1, '2024-02-07', 7.99);

-- Insert sample data into order_items table
INSERT INTO order_items (order_id, product_id, quantity, subtotal) VALUES
(1, 1, 1, 999.99),
(1, 2, 1, 19.99),
(2, 2, 1, 19.99),
(3, 3, 1, 499.99),
(3, 4, 1, 14.99),
(4, 4, 1, 14.99),
(5, 5, 2, 5.98);

-- Insert sample data into payments table
INSERT INTO payments (order_id, payment_method, amount_paid, payment_date) VALUES
(1, 'Credit Card', 1019.98, '2024-02-01'),
(2, 'Cash', 19.99, '2024-02-02'),
(3, 'Debit Card', 514.98, '2024-02-03'),
(4, 'UPI', 14.99, '2024-02-04'),
(5, 'Cash', 5.98, '2024-02-05'),
(6, 'Credit Card', 24.99, '2024-02-06'),
(7, 'UPI', 7.99, '2024-02-07');

-- Insert sample data into inventory table
INSERT INTO inventory (product_id, stock_in, stock_out, updated_at) VALUES
(1, 10, 1, '2024-02-07 12:00:00'),
(2, 50, 2, '2024-02-07 12:05:00'),
(3, 5, 1, '2024-02-07 12:10:00'),
(4, 30, 2, '2024-02-07 12:15:00'),
(5, 100, 2, '2024-02-07 12:20:00'),
(6, 20, 1, '2024-02-07 12:25:00'),
(7, 25, 1, '2024-02-07 12:30:00');

-- Retrieve all orders placed by a specific customer.
SELECT * 
FROM orders 
WHERE customer_id = 5;

-- Show the top 3 best-selling products.
SELECT p.products_name, SUM(oi.quantity) AS total_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.products_name
ORDER BY total_sold DESC
LIMIT 3;

-- Calculate total revenue for a given time period.
SELECT SUM(total_amount) AS total_revenue
FROM orders
WHERE order_date BETWEEN '2024-02-01' AND '2024-02-07';

-- List all orders along with the cashier (user) who processed them.
SELECT o.order_id, o.order_date, o.total_amount, u.username AS cashier
FROM orders o
JOIN users u ON o.user_id = u.user_id
WHERE u.roles = 'Cashier';

-- Show all products that have never been ordered.
SELECT p.*
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;

-- Find the total number of items sold in a particular category.
SELECT c.category_name, SUM(oi.quantity) AS total_items_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
WHERE c.category_id = 3
GROUP BY c.category_name;

-- Get the last 4 transactions processed.
SELECT * 
FROM payments
ORDER BY payment_date DESC
LIMIT 4;

-- Show the daily sales summary.
SELECT order_date, SUM(total_amount) AS daily_sales, COUNT(order_id) AS total_orders
FROM orders
GROUP BY order_date
ORDER BY order_date DESC;

-- Retrieve all orders placed by a specific customer
SELECT o.order_id, o.order_date, o.total_amount, c.customer_name
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.customer_id = 6;

-- Show the top 3 best-selling products
SELECT p.products_name, SUM(oi.quantity) AS total_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.products_name
ORDER BY total_sold DESC
LIMIT 3;

-- Calculate total revenue for a given time period 
SELECT SUM(total_amount) AS total_revenue
FROM orders
WHERE order_date BETWEEN '2024-02-01' AND '2024-02-07';

-- List all orders along with the cashier (user) who processed them
SELECT o.order_id, o.order_date, o.total_amount, u.username AS cashier
FROM orders o
JOIN users u ON o.user_id = u.user_id
WHERE u.roles = 'Cashier';
