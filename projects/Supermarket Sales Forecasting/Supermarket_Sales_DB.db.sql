-- Project in SQL Lite
sqlite3 Supermarket_Sales_DB.db

-- Customers Table  
CREATE TABLE customers (
  customer_id INTEGER PRIMARY KEY,
  customer_name VARCHAR(50),
  customer_email VARCHAR(50) UNIQUE,
  customer_phone BIGINT,
  customer_address VARCHAR(50),
  customer_type VARCHAR(7) CHECK (customer_type IN ('Regular', 'VIP'))
);

-- Product Categories Table
CREATE table product_categories (
  category_id INTEGER PRIMARY KEY,
  category_name VARCHAR(50)
);

-- Products Table 
CREATE TABLE products (
  product_id INTEGER PRIMARY KEY,
  product_name VARCHAR(50),
  category_id INTEGER,
  price DECIMAL(8,2),
  stock_quantity INTEGER,
  FOREIGN KEY (category_id) REFERENCES product_categories(category_id)
);

-- Sales Table 
CREATE TABLE sales (
  sale_id INTEGER PRIMARY KEY,
  customer_id INTEGER,
  store_id INTEGER,
  sale_date DATE,
  total_amount DECIMAL(8,2),
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  FOREIGN KEY (store_id) REFERENCES stores(store_id)
);

-- Sales Details Table 
CREATE TABLE sales_details (
  sale_detail_id INTEGER PRIMARY KEY,
  sale_id INTEGER,
  product_id INTEGER,
  quantity_sold INTEGER,
  unit_price INTEGER,
  subtotal DECIMAL(8,2),
  FOREIGN KEY (sale_id) REFERENCES sales(sale_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Stores Table  
CREATE TABLE stores (
  store_id INTEGER PRIMARY KEY,
  store_name VARCHAR(50),
  store_location VARCHAR(50),
  store_manager VARCHAR(50)
); 

-- Employees Table 
CREATE TABLE employees (
  employee_id INTEGER PRIMARY KEY,
  employee_name VARCHAR(50),
  store_id INTEGER,
  position VARCHAR(20),
  salary DECIMAL(8,2),
  FOREIGN KEY (store_id) REFERENCES stores(store_id)
);

-- Inventory Table  
CREATE TABLE inventory (
  inventory_id INTEGER PRIMARY KEY,
  product_id INTEGER,
  store_id INTEGER,
  quantity_in_stock INTEGER,
  last_updated DATE,
  FOREIGN KEY (product_id) REFERENCES products(product_id),
  FOREIGN KEY (store_id) REFERENCES stores(store_id)
);

-- Insert Data into Customers Table
INSERT INTO customers (customer_id, customer_name, customer_email, customer_phone, customer_address, customer_type) VALUES
(1, 'Alice Johnson', 'alice@example.com', 9876543210, '123 Maple St', 'Regular'),
(2, 'Bob Smith', 'bob@example.com', 8765432109, '456 Oak St', 'VIP'),
(3, 'Charlie Brown', 'charlie@example.com', 7654321098, '789 Pine St', 'Regular'),
(4, 'David Lee', 'david@example.com', 6543210987, '321 Cedar St', 'VIP'),
(5, 'Emma Wilson', 'emma@example.com', 5432109876, '567 Birch St', 'Regular'),
(6, 'Frank Thomas', 'frank@example.com', 4321098765, '678 Walnut St', 'VIP');

-- Insert Data into Product Categories Table
INSERT INTO product_categories (category_id, category_name) VALUES
(1, 'Beverages'),
(2, 'Snacks'),
(3, 'Dairy'),
(4, 'Bakery'),
(5, 'Fruits'),
(6, 'Vegetables');

-- Insert Data into Products Table
INSERT INTO products (product_id, product_name, category_id, price, stock_quantity) VALUES
(1, 'Coca-Cola', 1, 1.50, 100),
(2, 'Chips', 2, 2.00, 150),
(3, 'Milk', 3, 1.20, 200),
(4, 'Bread', 4, 1.00, 180),
(5, 'Apple', 5, 0.80, 250),
(6, 'Carrot', 6, 0.60, 300);

-- Insert Data into Stores Table
INSERT INTO stores (store_id, store_name, store_location, store_manager) VALUES
(1, 'Supermart A', 'Downtown', 'John Doe'),
(2, 'Supermart B', 'Uptown', 'Jane Smith'),
(3, 'Supermart C', 'Suburb', 'Richard Roe');

-- Insert Data into Sales Table
INSERT INTO sales (sale_id, customer_id, store_id, sale_date, total_amount) VALUES
(1, 1, 1, '2025-01-01', 20.00),
(2, 2, 2, '2025-01-02', 15.50),
(3, 3, 3, '2025-01-03', 18.75),
(4, 4, 1, '2025-01-04', 22.00),
(5, 5, 2, '2025-01-05', 10.50),
(6, 6, 3, '2025-01-06', 30.00);

-- Insert Data into Sales Details Table
INSERT INTO sales_details (sale_detail_id, sale_id, product_id, quantity_sold, unit_price, subtotal) VALUES
(1, 1, 1, 3, 1.50, 4.50),
(2, 2, 2, 5, 2.00, 10.00),
(3, 3, 3, 2, 1.20, 2.40),
(4, 4, 4, 4, 1.00, 4.00),
(5, 5, 5, 6, 0.80, 4.80),
(6, 6, 6, 3, 0.60, 1.80);

-- Insert Data into Employees Table
INSERT INTO employees (employee_id, employee_name, store_id, position, salary) VALUES
(1, 'Michael Scott', 1, 'Manager', 55000.00),
(2, 'Dwight Schrute', 1, 'Assistant Manager', 45000.00),
(3, 'Jim Halpert', 2, 'Cashier', 30000.00),
(4, 'Pam Beesly', 2, 'Clerk', 28000.00),
(5, 'Stanley Hudson', 3, 'Security', 35000.00),
(6, 'Kevin Malone', 3, 'Stock Manager', 32000.00);

-- Insert Data into Inventory Table
INSERT INTO inventory (inventory_id, product_id, store_id, quantity_in_stock, last_updated) VALUES
(1, 1, 1, 50, '2025-02-01'),
(2, 2, 2, 70, '2025-02-02'),
(3, 3, 3, 90, '2025-02-03'),
(4, 4, 1, 60, '2025-02-04'),
(5, 5, 2, 80, '2025-02-05'),
(6, 6, 3, 100, '2025-02-06');

-- Retrieve the total sales revenue for each store.
SELECT s.store_id, st.store_name, SUM(s.total_amount) AS total_sales
FROM sales s
JOIN stores st ON s.store_id = st.store_id
GROUP BY s.store_id, st.store_name;

-- Find the best-selling product in the last 3 months.
SELECT p.product_id, p.product_name, SUM(sd.quantity_sold) AS total_quantity_sold
FROM sales_details sd
JOIN sales s ON sd.sale_id = s.sale_id
JOIN products p ON sd.product_id = p.product_id
WHERE s.sale_date >= DATE('now', '-3 months')
GROUP BY p.product_id, p.product_name
ORDER BY total_quantity_sold DESC
LIMIT 1;

-- Identify the top 5 customers who made the highest purchases.
SELECT c.customer_id, c.customer_name, SUM(s.total_amount) AS total_spent
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC
LIMIT 5;

-- Get the number of items sold for each product category.
SELECT pc.category_id, pc.category_name, SUM(sd.quantity_sold) AS total_items_sold
FROM sales_details sd
JOIN products p ON sd.product_id = p.product_id
JOIN product_categories pc ON p.category_id = pc.category_id
GROUP BY pc.category_id, pc.category_name;

-- Find out which store has the highest total sales.
SELECT s.store_id, st.store_name, SUM(s.total_amount) AS total_sales
FROM sales s
JOIN stores st ON s.store_id = st.store_id
GROUP BY s.store_id, st.store_name
ORDER BY total_sales DESC
LIMIT 1;

-- List employees working in a specific store.
SELECT employee_id, employee_name, position, salary
FROM employees
WHERE store_id = 1;

-- Find the average sales per customer for a specific month.
SELECT AVG(s.total_amount) AS avg_sales_per_customer
FROM sales s
WHERE strftime('%Y-%m', s.sale_date) = '2025-01';

-- Identify products that are high in stock (more than 80 items remaining).
SELECT p.product_id, p.product_name, i.quantity_in_stock
FROM inventory i
JOIN products p ON i.product_id = p.product_id
WHERE i.quantity_in_stock > 80;

-- Retrieve the monthly sales trend for the last year.
SELECT strftime('%Y-%m', s.sale_date) AS month, SUM(s.total_amount) AS total_sales
FROM sales s
WHERE s.sale_date >= DATE('now', '-12 months')
GROUP BY month
ORDER BY month;

-- Calculate the total salary paid to employees at each store.
SELECT e.store_id, st.store_name, SUM(e.salary) AS total_salary
FROM employees e
JOIN stores st ON e.store_id = st.store_id
GROUP BY e.store_id, st.store_name;

-- Find the store with the most transactions (highest number of sales records) 
SELECT s.store_id, st.store_name, COUNT(s.sale_id) AS total_transactions
FROM sales s
JOIN stores st ON s.store_id = st.store_id
GROUP BY s.store_id, st.store_name
ORDER BY total_transactions DESC
LIMIT 1;

-- Get the highest revenue-generating product
SELECT p.product_id, p.product_name, SUM(sd.subtotal) AS total_revenue
FROM sales_details sd
JOIN products p ON sd.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_revenue DESC
LIMIT 1;

-- Retrieve the top-selling category based on revenue
SELECT pc.category_id, pc.category_name, SUM(sd.subtotal) AS category_revenue
FROM sales_details sd
JOIN products p ON sd.product_id = p.product_id
JOIN product_categories pc ON p.category_id = pc.category_id
GROUP BY pc.category_id, pc.category_name
ORDER BY category_revenue DESC
LIMIT 1;

-- Get the total number of customers for each customer type
SELECT customer_type, COUNT(*) AS total_customers
FROM customers
GROUP BY customer_type;

-- List the most loyal customers (customers with the highest number of purchases)
SELECT c.customer_id, c.customer_name, COUNT(s.sale_id) AS total_purchases
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_purchases DESC
LIMIT 4;

-- Get the highest-spending customer per store 
SELECT s.store_id, st.store_name, c.customer_id, c.customer_name, SUM(s.total_amount) AS total_spent
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
JOIN stores st ON s.store_id = st.store_id
GROUP BY s.store_id, st.store_name, c.customer_id, c.customer_name
ORDER BY total_spent DESC;

-- Find stores with the lowest stock levels overall
SELECT i.store_id, st.store_name, SUM(i.quantity_in_stock) AS total_stock
FROM inventory i
JOIN stores st ON i.store_id = st.store_id
GROUP BY i.store_id, st.store_name
ORDER BY total_stock ASC
LIMIT 1;

-- Get sales performance of each employee
SELECT e.employee_id, e.employee_name, e.store_id, COUNT(s.sale_id) AS total_sales_made
FROM employees e
JOIN sales s ON e.store_id = s.store_id
GROUP BY e.employee_id, e.employee_name, e.store_id
ORDER BY total_sales_made DESC;

-- Find the month with the highest sales revenue
SELECT strftime('%Y-%m', s.sale_date) AS month, SUM(s.total_amount) AS total_sales
FROM sales s
GROUP BY month
ORDER BY total_sales DESC
LIMIT 1;

-- Identify employees earning above the average salary
SELECT employee_id, employee_name, position, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- Find the most recent sale for each customer
SELECT s.customer_id, c.customer_name, MAX(s.sale_date) AS last_purchase_date
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
GROUP BY s.customer_id, c.customer_name;

-- Get the store with the highest average transaction value
SELECT s.store_id, st.store_name, AVG(s.total_amount) AS avg_transaction_value
FROM sales s
JOIN stores st ON s.store_id = st.store_id
GROUP BY s.store_id, st.store_name
ORDER BY avg_transaction_value DESC
LIMIT 1;
