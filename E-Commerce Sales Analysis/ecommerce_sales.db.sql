-- SQL Lite Project
sqlite3 ecommerce_sales.db

-- Customers Table  
CREATE TABLE customers (
  customer_id INTEGER PRIMARY KEY,
  name VARCHAR(20),
  email VARCHAR(20) UNIQUE,
  phone_number BIGINT,
  address TEXT,
  created_at DATETIME
);

-- Products Table  
CREATE TABLE products (
  product_id INTEGER PRIMARY KEY,
  name VARCHAR(20),
  category VARCHAR(20),
  price INTEGER,
  stock_quantity INTEGER,
  created_at DATETIME
);

-- Orders Table 
CREATE TABLE orders (
  order_id INTEGER PRIMARY KEY,
  customer_id INTEGER,
  order_date DATE,
  total_amount INTEGER,
  status VARCHAR(15),
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Order Items Table 
CREATE TABLE order_items (
  order_item_id INTEGER PRIMARY KEY,
  order_id INTEGER,
  product_id INTEGER,
  quantity INTEGER,
  subtotal INTEGER,
  FOREIGN KEY (order_id) REFERENCES orders(order_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Payments Table 
CREATE Table payments (
  payment_id INTEGER PRIMARY KEY,
  order_id INTEGER,
  payment_method VARCHAR(20),
  payment_status VARCHAR(20),
  payment_date DATETIME,
  FOREIGN KEY (order_id) REFERENCES orders(order_id)
);  

-- Shipping Table  
CREATE TABLE shipping (
  shipping_id INTEGER PRIMARY KEY,
  order_id INTEGER,
  shipping_date DATETIME,
  tracking_number BIGINT,
  delivery_status VARCHAR(20),
  FOREIGN KEY (order_id) REFERENCES orders(order_id)
);  

-- Insert sample customers
INSERT INTO customers (name, email, phone_number, address, created_at) VALUES
('John Doe', 'john@example.com', 1234567890, '123 Elm Street, NY', '2024-02-01 10:00:00'),
('Jane Smith', 'jane@example.com', 2345678901, '456 Oak Street, CA', '2024-02-02 11:15:00'),
('Alice Johnson', 'alice@example.com', 3456789012, '789 Pine Street, TX', '2024-02-03 12:30:00');

-- Insert sample products
INSERT INTO products (name, category, price, stock_quantity, created_at) VALUES
('Laptop', 'Electronics', 1200, 10, '2024-01-20 09:00:00'),
('Phone', 'Electronics', 800, 15, '2024-01-21 09:30:00'),
('Headphones', 'Accessories', 150, 20, '2024-01-22 10:00:00');

-- Insert sample orders
INSERT INTO orders (customer_id, order_date, total_amount, status) VALUES
(1, '2024-02-05', 1950, 'Shipped'),
(2, '2024-02-06', 800, 'Processing'),
(3, '2024-02-07', 1350, 'Delivered');

-- Insert sample order items
INSERT INTO order_items (order_id, product_id, quantity, subtotal) VALUES
(1, 1, 1, 1200),
(1, 3, 5, 750),
(2, 2, 1, 800),
(3, 1, 1, 1200),
(3, 3, 1, 150);

-- Insert sample payments
INSERT INTO payments (order_id, payment_method, payment_status, payment_date) VALUES
(1, 'Credit Card', 'Completed', '2024-02-05 14:00:00'),
(2, 'PayPal', 'Pending', '2024-02-06 15:30:00'),
(3, 'Debit Card', 'Completed', '2024-02-07 16:45:00');

-- Insert sample shipping details
INSERT INTO shipping (order_id, shipping_date, tracking_number, delivery_status) VALUES
(1, '2024-02-06 08:00:00', 9876543210, 'Shipped'),
(2, '2024-02-07 09:15:00', 8765432109, 'Processing'),
(3, '2024-02-08 10:30:00', 7654321098, 'Delivered');

-- Retrieve the total number of orders placed by each customer.
SELECT c.customer_id, c.name, COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;

-- Find the top 5 best-selling products based on total quantity sold.
SELECT p.product_id, p.name, SUM(oi.quantity) AS total_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_id, p.name
ORDER BY total_sold DESC
LIMIT 5;

-- Calculate the total revenue generated in the last 3 months.
SELECT SUM(total_amount) AS total_revenue
FROM orders
WHERE order_date >= DATE('now', '-3 months');

-- List all customers who have placed orders worth more than $500.
SELECT c.customer_id, c.name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
HAVING total_spent > 500;

-- Find the most frequently used payment method.
SELECT payment_method, COUNT(payment_id) AS usage_count
FROM payments
GROUP BY payment_method
ORDER BY usage_count DESC
LIMIT 1;

-- Identify orders that took more than 7 days to be shipped.
SELECT o.order_id, o.order_date, s.shipping_date, 
       (JULIANDAY(s.shipping_date) - JULIANDAY(o.order_date)) AS days_to_ship
FROM orders o
JOIN shipping s ON o.order_id = s.order_id
WHERE days_to_ship > 7;

-- Show the number of orders placed per month for the last year.
SELECT strftime('%Y-%m', order_date) AS order_month, COUNT(order_id) AS total_orders
FROM orders
WHERE order_date >= DATE('now', '-12 months')
GROUP BY order_month
ORDER BY order_month DESC;

-- Find products that have less than 10 stock left.
SELECT product_id, name, stock_quantity
FROM products
WHERE stock_quantity < 10;

-- Retrieve the top 2 customers who spent the most.
SELECT c.customer_id, c.name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC
LIMIT 2;

-- Calculate the average order value for each month.
SELECT strftime('%Y-%m', order_date) AS order_month, 
       AVG(total_amount) AS average_order_value
FROM orders
GROUP BY order_month
ORDER BY order_month DESC;

-- Identify orders where payment was not successful.
SELECT o.order_id, p.payment_status
FROM orders o
LEFT JOIN payments p ON o.order_id = p.order_id
WHERE p.payment_status NOT IN ('Completed') OR p.payment_status IS NULL;

-- Find the total revenue generated by each product category.
SELECT p.category, SUM(oi.subtotal) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;

-- List customers who have placed at least 3 orders.
SELECT c.customer_id, c.name, COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
HAVING total_orders >= 3;

-- Show orders that have been pending for more than 10 days.
SELECT order_id, order_date, status
FROM orders
WHERE status = 'Pending' AND order_date <= DATE('now', '-10 days');

-- Retrieve the last order placed by each customer.
SELECT o.customer_id, c.name, o.order_id, o.order_date, o.total_amount
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_date = (SELECT MAX(order_date) FROM orders WHERE customer_id = o.customer_id);
