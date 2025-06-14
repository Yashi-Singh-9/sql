-- Project In MariaDB 
-- Creating the database
CREATE DATABASE CoffeeShopPOS;
USE CoffeeShopPOS;

-- Users Table
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('Admin', 'Cashier', 'Manager') NOT NULL
);

-- Customers Table
CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE
);

-- Categories Table
CREATE TABLE Categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL
);

-- Products Table
CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category_id INT,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT NOT NULL,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

-- Orders Table
CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NULL,
    user_id INT NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Order Details Table
CREATE TABLE Order_Details (
    order_detail_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Payments Table
CREATE TABLE Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    payment_method ENUM('Cash', 'Card', 'Online') NOT NULL,
    payment_status ENUM('Paid', 'Pending', 'Failed') NOT NULL,
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- Inventory Table
CREATE TABLE Inventory (
    inventory_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    stock_added INT NOT NULL,
    stock_removed INT NOT NULL DEFAULT 0,
    date_updated DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Suppliers Table
CREATE TABLE Suppliers (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    contact VARCHAR(20) NOT NULL
);

-- Supplier Orders Table
CREATE TABLE Supplier_Orders (
    supplier_order_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_id INT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_cost DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id)
);

-- Insert into Users
INSERT INTO Users (name, email, password, role) VALUES
('Alice Johnson', 'alice@coffeeshop.com', 'pass123', 'Admin'),
('Bob Smith', 'bob@coffeeshop.com', 'pass123', 'Cashier'),
('Charlie Brown', 'charlie@coffeeshop.com', 'pass123', 'Manager'),
('David Green', 'david@coffeeshop.com', 'pass123', 'Cashier'),
('Emma White', 'emma@coffeeshop.com', 'pass123', 'Cashier');

-- Insert into Customers
INSERT INTO Customers (name, phone, email) VALUES
('John Doe', '1234567890', 'johndoe@gmail.com'),
('Jane Smith', '0987654321', 'janesmith@gmail.com'),
('Michael Lee', '1122334455', NULL),
('Sarah Brown', '2233445566', 'sarahb@gmail.com'),
('Tom Hanks', '3344556677', NULL);

-- Insert into Categories
INSERT INTO Categories (category_name) VALUES
('Coffee'),
('Tea'),
('Bakery'),
('Cold Drinks'),
('Snacks');

-- Insert into Products
INSERT INTO Products (name, category_id, price, stock_quantity) VALUES
('Espresso', 1, 2.50, 50),
('Cappuccino', 1, 3.50, 40),
('Green Tea', 2, 2.00, 30),
('Croissant', 3, 1.80, 25),
('Latte', 1, 4.00, 35);

-- Insert into Orders
INSERT INTO Orders (customer_id, user_id, total_amount) VALUES
(1, 2, 5.50),
(2, 3, 7.00),
(3, 1, 6.30),
(4, 2, 4.00),
(5, 3, 8.50);

-- Insert into Order_Details
INSERT INTO Order_Details (order_id, product_id, quantity, subtotal) VALUES
(1, 1, 2, 5.00),
(2, 2, 1, 3.50),
(3, 3, 3, 6.00),
(4, 4, 2, 3.60),
(5, 5, 2, 8.00);

-- Insert into Payments
INSERT INTO Payments (order_id, payment_method, payment_status) VALUES
(1, 'Cash', 'Paid'),
(2, 'Card', 'Paid'),
(3, 'Online', 'Pending'),
(4, 'Cash', 'Paid'),
(5, 'Card', 'Failed');

-- Insert into Inventory
INSERT INTO Inventory (product_id, stock_added, stock_removed) VALUES
(1, 50, 10),
(2, 40, 8),
(3, 30, 6),
(4, 25, 5),
(5, 35, 7);

-- Insert into Suppliers
INSERT INTO Suppliers (supplier_name, contact) VALUES
('ABC Coffee Beans', '555-1234'),
('XYZ Bakery', '555-5678'),
('Best Dairy', '555-9876'),
('Green Tea Inc.', '555-4321'),
('Fresh Snacks Ltd.', '555-8765');

-- Insert into Supplier Orders
INSERT INTO Supplier_Orders (supplier_id, total_cost) VALUES
(1, 500.00),
(2, 200.00),
(3, 300.00),
(4, 150.00),
(5, 250.00);

-- Retrieve all orders made by a specific customer
SELECT * 
FROM Orders
WHERE customer_id = 1;

-- Find total sales made in the last 30 days
SELECT SUM(total_amount) AS total_sales FROM Orders 
WHERE order_date >= NOW() - INTERVAL 30 DAY;

-- Get the top 5 best-selling products
SELECT p.name, SUM(od.quantity) AS total_sold 
FROM Order_Details od 
JOIN Products p ON od.product_id = p.product_id 
GROUP BY p.name 
ORDER BY total_sold DESC 
LIMIT 5;

-- Retrieve all pending payments
SELECT * 
FROM Payments 
WHERE payment_status = 'Pending';

-- Find total revenue grouped by payment method 
SELECT payment_method, SUM(total_amount) AS total_revenue 
FROM Orders o
JOIN Payments p ON o.order_id = p.order_id
WHERE p.payment_status = 'Paid'
GROUP BY payment_method;

-- Find the most frequent customer (customer with the highest number of orders)
SELECT c.customer_id, c.name, COUNT(o.order_id) AS total_orders 
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_orders DESC 
LIMIT 1;

-- Get all orders placed by a specific employee 
SELECT o.order_id, c.name AS customer_name, o.total_amount, o.order_date
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
WHERE o.user_id = 2;

-- Find the average order amount per customer
SELECT c.customer_id, c.name, AVG(o.total_amount) AS avg_order_amount 
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;

-- Retrieve the details of the most recent order
SELECT o.order_id, c.name AS customer_name, u.name AS cashier_name, o.total_amount, o.order_date
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Users u ON o.user_id = u.user_id
ORDER BY o.order_date DESC 
LIMIT 1;

-- Find the total quantity of each product sold
SELECT p.name, SUM(od.quantity) AS total_quantity_sold
FROM Order_Details od
JOIN Products p ON od.product_id = p.product_id
GROUP BY p.name
ORDER BY total_quantity_sold DESC;

-- Show the current inventory levels for all products
SELECT p.name, p.stock_quantity 
FROM Products p;

-- Get the details of failed payments
SELECT p.payment_id, o.order_id, c.name AS customer_name, p.payment_method, p.payment_status, p.payment_date
FROM Payments p
JOIN Orders o ON p.order_id = o.order_id
JOIN Customers c ON o.customer_id = c.customer_id
WHERE p.payment_status = 'Failed';

-- Find the employees who have processed the most orders
SELECT u.user_id, u.name, COUNT(o.order_id) AS total_orders_processed
FROM Users u
JOIN Orders o ON u.user_id = o.user_id
GROUP BY u.user_id, u.name
ORDER BY total_orders_processed DESC 
LIMIT 2;