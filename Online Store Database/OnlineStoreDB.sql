-- Create Database
CREATE DATABASE OnlineStoreDB;

-- Users Table 
CREATE TABLE users (
  user_id INT IDENTITY(1,1) PRIMARY KEY,
  name VARCHAR(20),
  email VARCHAR(20),
  password VARCHAR(20),
  phone VARCHAR(20),
  address TEXT,
  user_type VARCHAR(20) CHECK (user_type IN ('Customer', 'Admin'))
);

-- Categories Table 
CREATE TABLE categories (
  category_id INT PRIMARY KEY,
  category_name VARCHAR(20),
);  

-- Products Table 
CREATE TABLE products (
  product_id INT IDENTITY(1,1) PRIMARY KEY,
  name VARCHAR(20),
  description TEXT,
  price INT,
  stock_quantity INT,
  category_id INT,
  FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- Orders Table  
CREATE TABLE orders (
  order_id INT IDENTITY(1,1) PRIMARY KEY,
  user_id INT,
  order_date DATE,
  total_amount INT,
  status VARCHAR(15) CHECK (status IN ('Pending', 'Completed', 'Canceled')),
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Order Items Table 
CREATE TABLE order_items (
  order_item_id INT IDENTITY(1,1) PRIMARY KEY,
  order_id INT,
  product_id INT,
  quantity INT,
  price INT,
  FOREIGN KEY (order_id) REFERENCES orders(order_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Payments Table 
CREATE TABLE payments (
  payment_id INT IDENTITY(1,1) PRIMARY KEY,
  order_id INT,
  payment_date DATE,
  payment_method VARCHAR(10) CHECK (payment_method IN ('Card', 'PayPal', 'Cash')),
  status VARCHAR(10) CHECK (status IN ('Success', 'Failed')),
  FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- Reviews Table 
CREATE TABLE reviews (
  review_id INT IDENTITY(1,1) PRIMARY KEY,
  user_id INT,
  product_id INT, 
  rating TINYINT CHECK ( rating BETWEEN 1 AND 5),
  review_text TEXT,
  review_date DATE,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Cart Table 
CREATE TABLE cart (
  cart_id INT IDENTITY(1,1) PRIMARY KEY,
  user_id INT,
  product_id INT,
  quantity INT,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);  

-- Insert sample data into users table
INSERT INTO users (name, email, password, phone, address, user_type) VALUES
('Alice Johnson', 'alice@example.com', 'pass123', '1234567890', '123 Elm St, NY', 'Customer'),
('Bob Smith', 'bob@example.com', 'pass456', '9876543210', '456 Oak St, CA', 'Admin'),
('Charlie Brown', 'charlie@example.com', 'pass789', '5647382910', '789 Pine St, TX', 'Customer'),
('David Lee', 'david@example.com', 'pass234', '1231231234', '101 Maple St, FL', 'Customer'),
('Emma Watson', 'emma@example.com', 'pass567', '7897897890', '303 Birch St, NV', 'Admin');

-- Insert sample data into categories table
INSERT INTO categories (category_id, category_name) VALUES
(1, 'Electronics'),
(2, 'Clothing'),
(3, 'Books'),
(4, 'Home & Kitchen');

-- Insert sample data into products table
INSERT INTO products (name, description, price, stock_quantity, category_id) VALUES
('Laptop', 'High performance laptop', 1000, 10, 1),
('Smartphone', 'Latest model smartphone', 700, 15, 1),
('T-Shirt', 'Cotton round-neck t-shirt', 20, 50, 2),
('Jeans', 'Blue denim jeans', 40, 30, 2),
('Cookware Set', 'Non-stick cookware set', 80, 20, 4),
('Fiction Book', 'Bestselling novel', 15, 40, 3),
('Tablet', 'Lightweight tablet device', 500, 12, 1),
('Sneakers', 'Comfortable running shoes', 60, 25, 2);

-- Insert sample data into orders table
INSERT INTO orders (user_id, order_date, total_amount, status) VALUES
(1, '2024-02-01', 1020, 'Completed'),
(2, '2024-02-05', 750, 'Pending'),
(3, '2024-02-10', 60, 'Completed'),
(4, '2024-02-15', 500, 'Canceled'),
(1, '2024-02-18', 100, 'Completed');

-- Insert sample data into order_items table
INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
(1, 1, 1, 1000),
(1, 3, 1, 20),
(2, 2, 1, 700),
(3, 8, 1, 60),
(4, 7, 1, 500),
(5, 5, 1, 80),
(5, 6, 2, 30);

-- Insert sample data into payments table
INSERT INTO payments (order_id, payment_date, payment_method, status) VALUES
(1, '2024-02-02', 'Card', 'Success'),
(2, '2024-02-06', 'PayPal', 'Failed'),
(3, '2024-02-11', 'Cash', 'Success'),
(4, '2024-02-16', 'Card', 'Success'),
(5, '2024-02-19', 'PayPal', 'Success');

-- Insert sample data into reviews table
INSERT INTO reviews (user_id, product_id, rating, review_text, review_date) VALUES
(1, 1, 5, 'Great laptop, very fast!', '2024-02-03'),
(2, 3, 4, 'Nice t-shirt, good quality.', '2024-02-07'),
(3, 8, 5, 'Super comfortable sneakers!', '2024-02-12'),
(4, 7, 3, 'Decent tablet but battery life could be better.', '2024-02-17');

-- Insert sample data into cart table
INSERT INTO cart (user_id, product_id, quantity) VALUES
(1, 2, 1),
(2, 4, 2),
(3, 5, 1),
(4, 6, 3),
(1, 7, 1),
(2, 8, 2);

-- Retrieve the top 5 most ordered products.
SELECT TOP 5 p.product_id, p.name, SUM(oi.quantity) AS total_ordered
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_id, p.name
ORDER BY total_ordered DESC;

-- List all orders placed by a specific user (user_id=3).
SELECT * 
FROM orders
WHERE user_id = 3;

-- Find out-of-stock products (stock_quantity = 0).
SELECT * 
FROM products
WHERE stock_quantity = 0;

-- Get the total revenue generated from completed orders.
SELECT SUM(total_amount) AS total_revenue 
FROM orders 
WHERE status = 'Completed';

-- Find the average rating of each product.
SELECT product_id, AVG(rating) AS average_rating 
FROM reviews
GROUP BY product_id;

-- Show users who have never placed an order.
SELECT * 
FROM users 
WHERE user_id NOT IN (
  SELECT DISTINCT user_id
  FROM orders
);

-- Retrieve orders that have not been paid yet.
SELECT * 
FROM orders
WHERE order_id NOT IN (
  SELECT DISTINCT order_id 
  FROM payments
);

-- List products with at least 10 reviews and an average rating above 4.5.
SELECT r.product_id, p.name, COUNT(r.review_id) AS review_count, AVG(r.rating) AS average_rating
FROM reviews r
JOIN products p ON r.product_id = p.product_id
GROUP BY r.product_id, p.name
HAVING COUNT(r.review_id) >= 10 AND AVG(r.rating) > 4.5;

-- Find the most popular category (category with the most sold items).
SELECT TOP 1 c.category_id, c.category_name, SUM(oi.quantity) AS total_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_id, c.category_name
ORDER BY total_sold DESC;

-- Retrieve users who have spent more than $500 in total.
SELECT o.user_id, u.name, SUM(o.total_amount) AS total_spent
FROM orders o
JOIN users u ON o.user_id = u.user_id
WHERE o.status = 'Completed'
GROUP BY o.user_id, u.name
HAVING SUM(o.total_amount) > 500;
