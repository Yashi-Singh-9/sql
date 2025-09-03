-- Project in PostgreSQL 
-- Create the database
CREATE DATABASE WarehouseDB;
\c WarehouseDB; 

-- Warehouses Table  
CREATE TABLE warehouse (
  warehouse_id SERIAL PRIMARY KEY,
  warehouse_name VARCHAR(100),
  locations VARCHAR(100),
  capacity DECIMAL(5,2)
);

-- Products Table  
CREATE TABLE products (
  product_id SERIAL PRIMARY KEY,
  products_name VARCHAR(100),
  description TEXT,
  category VARCHAR(50),
  price DECIMAL(5,2)
);

-- Suppliers Table 
CREATE TABLE suppliers (
  supplier_id SERIAL PRIMARY KEY,
  supplier_name VARCHAR(100),
  contact_info BIGINT,
  address VARCHAR(100)
);

-- Customers Table  
CREATE TABLE customers (
  customer_id SERIAL PRIMARY KEY,
  customer_name VARCHAR(100),
  email VARCHAR(100) UNIQUE,
  phone_number BIGINT
);

-- Stock Table 
CREATE TABLE stocks (
  stock_id SERIAL PRIMARY KEY,
  warehouse_id INT,
  product_id INT,
  quantity INT,
  FOREIGN KEY (warehouse_id) REFERENCES warehouse(warehouse_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Orders Table 
CREATE TABLE orders (
  order_id SERIAL PRIMARY KEY,
  customer_id INT,
  order_date DATE,
  status VARCHAR(50),
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Order Details Table
CREATE TABLE order_details (
  order_detail_id SERIAL PRIMARY KEY,
  order_id INT,
  product_id INT,
  quantity INT,
  total_price DECIMAL(10,2),
  FOREIGN KEY (order_id) REFERENCES orders(order_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Shipments Table 
CREATE TABLE shipments (
  shipment_id SERIAL PRIMARY KEY,
  order_id INT,
  warehouse_id INT,
  shipment_date DATE,
  status VARCHAR(50),
  FOREIGN KEY (order_id) REFERENCES orders(order_id),
  FOREIGN KEY (warehouse_id) REFERENCES warehouse(warehouse_id)
);

-- Purchases Table 
CREATE TABLE purchases (
  purchase_id SERIAL PRIMARY KEY,
  supplier_id INT,
  product_id INT,
  quantity INT,
  purchase_date DATE,
  FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);  

-- Insert data into warehouse table
INSERT INTO warehouse (warehouse_name, locations, capacity) VALUES
('Central Warehouse', 'New York', 500.00),
('East Warehouse', 'Boston', 450.00),
('West Warehouse', 'Los Angeles', 600.00),
('South Warehouse', 'Miami', 550.00),
('North Warehouse', 'Chicago', 480.00),
('Midwest Warehouse', 'Dallas', 520.00);

-- Insert data into products table
INSERT INTO products (products_name, description, category, price) VALUES
('Laptop', '15-inch screen, 512GB SSD, 16GB RAM', 'Electronics', 999.99),
('Smartphone', '6.5-inch display, 128GB storage, 5G enabled', 'Electronics', 699.99),
('Office Chair', 'Ergonomic chair with lumbar support', 'Furniture', 199.99),
('Coffee Maker', '12-cup coffee maker with timer function', 'Appliances', 79.99),
('Desk', 'Wooden office desk with drawers', 'Furniture', 249.99),
('Headphones', 'Noise-canceling wireless headphones', 'Electronics', 149.99);

-- Insert data into suppliers table
INSERT INTO suppliers (supplier_name, contact_info, address) VALUES
('TechSupply Inc.', 1234567890, '100 Tech Street, NY'),
('Gadget Distributors', 9876543210, '500 Market Ave, LA'),
('Furniture World', 1122334455, '75 Oak Lane, Chicago'),
('Home Essentials', 9988776655, '300 Maple Road, Miami'),
('Digital World', 6677889900, '450 Silicon Blvd, Boston'),
('Sound Masters', 5544332211, '120 Harmony Lane, Dallas');

-- Insert data into customers table
INSERT INTO customers (customer_name, email, phone_number) VALUES
('Alice Johnson', 'alice@example.com', 1231231234),
('Bob Smith', 'bob@example.com', 4564564567),
('Charlie Brown', 'charlie@example.com', 7897897890),
('David White', 'david@example.com', 3213213210),
('Emma Green', 'emma@example.com', 6546546543),
('Frank Harris', 'frank@example.com', 9879879876);

-- Insert data into stocks table
INSERT INTO stocks (warehouse_id, product_id, quantity) VALUES
(1, 1, 50),
(2, 2, 40),
(3, 3, 30),
(4, 4, 20),
(5, 5, 25),
(6, 6, 35);

-- Insert data into orders table
INSERT INTO orders (customer_id, order_date, status) VALUES
(1, '2024-02-10', 'Processing'),
(2, '2024-02-11', 'Shipped'),
(3, '2024-02-12', 'Delivered'),
(4, '2024-02-13', 'Processing'),
(5, '2024-02-14', 'Cancelled'),
(6, '2024-02-15', 'Shipped');

-- Insert data into order_details table
INSERT INTO order_details (order_id, product_id, quantity, total_price) VALUES
(1, 1, 2, 1999.98),
(2, 2, 1, 699.99),
(3, 3, 4, 799.96),
(4, 4, 3, 239.97),
(5, 5, 1, 249.99),
(6, 6, 2, 299.98);

-- Insert data into shipments table
INSERT INTO shipments (order_id, warehouse_id, shipment_date, status) VALUES
(1, 1, '2024-02-12', 'Dispatched'),
(2, 2, '2024-02-13', 'In Transit'),
(3, 3, '2024-02-14', 'Delivered'),
(4, 4, '2024-02-15', 'Processing'),
(5, 5, '2024-02-16', 'Cancelled'),
(6, 6, '2024-02-17', 'Shipped');

-- Insert data into purchases table
INSERT INTO purchases (supplier_id, product_id, quantity, purchase_date) VALUES
(1, 1, 100, '2024-01-10'),
(2, 2, 80, '2024-01-11'),
(3, 3, 60, '2024-01-12'),
(4, 4, 50, '2024-01-13'),
(5, 5, 70, '2024-01-14'),
(6, 6, 90, '2024-01-15');

-- Get a list of all orders that haven't been shipped yet.
SELECT o.order_id, o.customer_id, o.order_date, o.status
FROM orders o
LEFT JOIN shipments s ON o.order_id = s.order_id
WHERE s.order_id IS NULL OR s.status NOT IN ('Shipped', 'Delivered');

-- Find the top 4 most popular products based on order count.
SELECT p.product_id, p.products_name, COUNT(od.order_id) AS order_count
FROM order_details od
JOIN products p ON od.product_id = p.product_id
GROUP BY p.product_id, p.products_name
ORDER BY order_count DESC
LIMIT 4;

-- Get total sales per customer.
SELECT o.customer_id, c.customer_name, SUM(od.total_price) AS total_spent
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_details od ON o.order_id = od.order_id
GROUP BY o.customer_id, c.customer_name
ORDER BY total_spent DESC;

-- Find which warehouse holds the most number of products.
SELECT w.warehouse_id, w.warehouse_name, SUM(s.quantity) AS total_stock
FROM stocks s
JOIN warehouse w ON s.warehouse_id = w.warehouse_id
GROUP BY w.warehouse_id, w.warehouse_name
ORDER BY total_stock DESC
LIMIT 1;

-- Retrieve all orders along with customer details and product names.
SELECT o.order_id, c.customer_name, c.email, p.products_name, od.quantity, od.total_price
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
ORDER BY o.order_id;

-- List the customers who have placed the most orders.
SELECT c.customer_id, c.customer_name, COUNT(o.order_id) AS order_count
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY order_count DESC
LIMIT 4;

-- Find the average order value for each customer.
SELECT o.customer_id, c.customer_name, AVG(od.total_price) AS avg_order_value
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_details od ON o.order_id = od.order_id
GROUP BY o.customer_id, c.customer_name
ORDER BY avg_order_value DESC;

-- Find the total number of products available in each warehouse
SELECT w.warehouse_id, w.warehouse_name, SUM(s.quantity) AS total_products
FROM stocks s
JOIN warehouse w ON s.warehouse_id = w.warehouse_id
GROUP BY w.warehouse_id, w.warehouse_name
ORDER BY total_products DESC;

-- Retrieve details of the most expensive product
SELECT * FROM products
ORDER BY price DESC
LIMIT 1;

-- Get the most recent orders placed by customers
SELECT o.order_id, c.customer_name, o.order_date, o.status
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
ORDER BY o.order_date DESC
LIMIT 4;

-- Find the number of orders placed per month
SELECT DATE_TRUNC('month', order_date) AS order_month, COUNT(order_id) AS total_orders
FROM orders
GROUP BY order_month
ORDER BY order_month DESC;

-- Get the suppliers who have supplied the highest quantity of products
SELECT s.supplier_id, s.supplier_name, SUM(pur.quantity) AS total_supplied
FROM purchases pur
JOIN suppliers s ON pur.supplier_id = s.supplier_id
GROUP BY s.supplier_id, s.supplier_name
ORDER BY total_supplied DESC
LIMIT 4;

-- Find warehouses that store products belonging to a specific category (e.g., 'Electronics')
SELECT DISTINCT w.warehouse_id, w.warehouse_name
FROM stocks s
JOIN warehouse w ON s.warehouse_id = w.warehouse_id
JOIN products p ON s.product_id = p.product_id
WHERE p.category = 'Electronics';

-- Retrieve the top 5 customers based on total spending
SELECT c.customer_id, c.customer_name, SUM(od.total_price) AS total_spent
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_details od ON o.order_id = od.order_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC
LIMIT 5;

-- Find the warehouse with the highest total stock value
SELECT w.warehouse_id, w.warehouse_name, SUM(s.quantity * p.price) AS total_value
FROM stocks s
JOIN warehouse w ON s.warehouse_id = w.warehouse_id
JOIN products p ON s.product_id = p.product_id
GROUP BY w.warehouse_id, w.warehouse_name
ORDER BY total_value DESC
LIMIT 1;

-- Count the total number of customers who have placed at least one order
SELECT COUNT(DISTINCT o.customer_id) AS total_customers
FROM orders o;