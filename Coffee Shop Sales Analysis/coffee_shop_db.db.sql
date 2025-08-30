-- SQL Lite Project
sqlite3 coffee_shop_db.db

-- Customers Table  
CREATE TABLE customers (
  customer_id INTEGER Primary Key,
  first_name VARCHAR(20),
  last_name VARCHAR(20),
  email VARCHAR(20) UNIQUE,
  phone_number BIGINT,
  registration_date DATE
);

-- Products Table 
CREATE TABLE products (
  product_id INTEGER PRIMARY KEY,
  product_name VARCHAR(20),
  category VARCHAR(10) CHECK (category IN ('Coffee', 'Pastry', 'Sandwich')),
  price INT,
  stock_quantity INT
);

-- Orders Table 
CREATE TABLE orders (
  order_id INTEGER Primary Key,
  customer_id INTEGER,
  order_date DATE,
  total_amount INT,
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Order Items 
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
CREATE TABLE payments (
  payment_id INTEGER PRIMARY KEY,
  order_id INTEGER,
  payment_date DATE,
  payment_method VARCHAR(10) CHECK (payment_method IN ('Cash', 'Credit Card', 'Debit Card', 'PayPal', 'Bank Transfer')),
  amount_paid DECIMAL(10,2),
  FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- Employees Table 
CREATE TABLE employees (
  employee_id INTEGER PRIMARY KEY,
  first_name VARCHAR(20),
  last_name VARCHAR(20),
  position VARCHAR(15) CHECK (position IN ('Barista', 'Manager', 'Cashier')),
  salary DECIMAL(10,2) NOT NULL CHECK (salary >= 0)
);

-- Shifts Table  
CREATE TABLE shifts (
  shift_id INTEGER PRIMARY KEY,
  employee_id INTEGER,
  shift_date DATE,
  start_time TIME,
  end_time TIME,
  FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

-- Insert sample data into customers table
INSERT INTO customers (customer_id, first_name, last_name, email, phone_number, registration_date) VALUES
(1, 'John', 'Doe', 'john.doe@email.com', 1234567890, '2023-01-10'),
(2, 'Jane', 'Smith', 'jane.smith@email.com', 2345678901, '2023-02-15'),
(3, 'Alice', 'Johnson', 'alice.j@email.com', 3456789012, '2023-03-20'),
(4, 'Bob', 'Brown', 'bob.brown@email.com', 4567890123, '2023-04-25'),
(5, 'Charlie', 'Davis', 'charlie.d@email.com', 5678901234, '2023-05-30'),
(6, 'David', 'Miller', 'david.m@email.com', 6789012345, '2023-06-10'),
(7, 'Emma', 'Wilson', 'emma.w@email.com', 7890123456, '2023-07-15'),
(8, 'Frank', 'Thomas', 'frank.t@email.com', 8901234567, '2023-08-20');

-- Insert sample data into products table
INSERT INTO products (product_id, product_name, category, price, stock_quantity) VALUES
(1, 'Espresso', 'Coffee', 3, 50),
(2, 'Latte', 'Coffee', 4, 40),
(3, 'Cappuccino', 'Coffee', 4, 45),
(4, 'Croissant', 'Pastry', 2, 30),
(5, 'Muffin', 'Pastry', 3, 25),
(6, 'Bagel', 'Pastry', 2, 35),
(7, 'Turkey Sandwich', 'Sandwich', 6, 20),
(8, 'Veggie Sandwich', 'Sandwich', 5, 22);

-- Insert sample data into orders table
INSERT INTO orders (order_id, customer_id, order_date, total_amount) VALUES
(1, 1, '2024-02-01', 10),
(2, 2, '2024-02-02', 12),
(3, 3, '2024-02-03', 8),
(4, 4, '2024-02-04', 15),
(5, 5, '2024-02-05', 9),
(6, 6, '2024-02-06', 14),
(7, 7, '2024-02-07', 7),
(8, 8, '2024-02-08', 11);

-- Insert sample data into order_items table
INSERT INTO order_items (order_item_id, order_id, product_id, quantity, subtotal) VALUES
(1, 1, 1, 2, 6),
(2, 1, 4, 2, 4),
(3, 2, 2, 3, 12),
(4, 3, 3, 2, 8),
(5, 4, 7, 2, 12),
(6, 4, 5, 1, 3),
(7, 5, 6, 3, 6),
(8, 6, 8, 2, 10);

-- Insert sample data into payments table
INSERT INTO payments (payment_id, order_id, payment_date, payment_method, amount_paid) VALUES
(1, 1, '2024-02-01', 'Cash', 10.00),
(2, 2, '2024-02-02', 'Credit Card', 12.00),
(3, 3, '2024-02-03', 'Debit Card', 8.00),
(4, 4, '2024-02-04', 'PayPal', 15.00),
(5, 5, '2024-02-05', 'Cash', 9.00),
(6, 6, '2024-02-06', 'Credit Card', 14.00),
(7, 7, '2024-02-07', 'Bank Transfer', 7.00),
(8, 8, '2024-02-08', 'Debit Card', 11.00);

-- Insert sample data into employees table
INSERT INTO employees (employee_id, first_name, last_name, position, salary) VALUES
(1, 'Mike', 'Johnson', 'Barista', 2500.00),
(2, 'Sarah', 'Parker', 'Manager', 4000.00),
(3, 'James', 'Brown', 'Cashier', 2300.00),
(4, 'Olivia', 'White', 'Barista', 2600.00),
(5, 'Liam', 'Davis', 'Cashier', 2200.00),
(6, 'Sophia', 'Wilson', 'Manager', 4100.00),
(7, 'Ethan', 'Taylor', 'Barista', 2550.00),
(8, 'Ava', 'Anderson', 'Cashier', 2250.00);

-- Insert sample data into shifts table
INSERT INTO shifts (shift_id, employee_id, shift_date, start_time, end_time) VALUES
(1, 1, '2024-02-01', '08:00', '14:00'),
(2, 2, '2024-02-01', '09:00', '17:00'),
(3, 3, '2024-02-02', '10:00', '16:00'),
(4, 4, '2024-02-02', '07:00', '13:00'),
(5, 5, '2024-02-03', '08:00', '14:00'),
(6, 6, '2024-02-03', '09:00', '17:00'),
(7, 7, '2024-02-04', '10:00', '16:00'),
(8, 8, '2024-02-04', '07:00', '13:00');

-- Total Sales for Each Month
SELECT strftime('%Y-%m', order_date) AS month, SUM(total_amount) AS total_sales
FROM orders
GROUP BY month;

-- Find the Best-Selling Product
SELECT p.product_name, SUM(oi.quantity) AS total_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC
LIMIT 1;

-- Find Customers Who Have Spent More Than $100
SELECT c.customer_id, c.first_name, c.last_name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
HAVING total_spent > 100;

-- Calculate Total Revenue for Each Payment Method
SELECT payment_method, SUM(amount_paid) AS total_revenue
FROM payments
GROUP BY payment_method;

-- Find Employees Who Worked More Than 40 Hours in a Week
SELECT e.employee_id, e.first_name, e.last_name, SUM(julianday(end_time) - julianday(start_time)) * 24 AS total_hours
FROM shifts s
JOIN employees e ON s.employee_id = e.employee_id
WHERE shift_date >= date('now', '-7 days')
GROUP BY e.employee_id
HAVING total_hours > 40;

-- Find the Customer Who Placed the Most Orders
SELECT c.customer_id, c.first_name, c.last_name, COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
ORDER BY total_orders DESC
LIMIT 1;

-- Find the Product Category That Generates the Most Revenue
SELECT p.category, SUM(oi.subtotal) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY total_revenue DESC
LIMIT 1;

-- Identify Orders That Were Paid in Cash
SELECT * FROM orders o
JOIN payments p ON o.order_id = p.order_id
WHERE p.payment_method = 'Cash';

-- Calculate the Average Order Value
SELECT AVG(total_amount) AS average_order_value
FROM orders;

-- Find the Day of the Week With the Highest Sales
SELECT strftime('%w', order_date) AS day_of_week, SUM(total_amount) AS total_sales
FROM orders
GROUP BY day_of_week
ORDER BY total_sales DESC
LIMIT 1;

-- Get the Total Number of Orders for Each Customer
SELECT c.customer_id, c.first_name, c.last_name, COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id;

-- Determine the Peak Hours of Sales
SELECT strftime('%H', order_date) AS hour, COUNT(order_id) AS total_orders
FROM orders
GROUP BY hour
ORDER BY total_orders DESC;

-- Find Employees Who Haven't Worked a Shift in the Last 30 Days
SELECT e.employee_id, e.first_name, e.last_name
FROM employees e
LEFT JOIN shifts s ON e.employee_id = s.employee_id AND s.shift_date >= date('now', '-30 days')
WHERE s.employee_id IS NULL;
