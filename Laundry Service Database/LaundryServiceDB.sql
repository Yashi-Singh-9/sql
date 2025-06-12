-- Project In MariaDB 
-- Creating the database
CREATE DATABASE LaundryServiceDB;
USE LaundryServiceDB;

-- Customers Table
CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE,
    address TEXT
);

-- Orders Table
CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    pickup_date DATE,
    delivery_date DATE,
    total_price DECIMAL(10,2),
    status ENUM('Pending', 'In Progress', 'Completed', 'Cancelled') DEFAULT 'Pending',
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE CASCADE
);

-- Services Table
CREATE TABLE Services (
    service_id INT AUTO_INCREMENT PRIMARY KEY,
    service_name VARCHAR(100) NOT NULL UNIQUE,
    price_per_kg DECIMAL(5,2) NOT NULL
);

-- Order Details Table (Many-to-Many relationship between Orders & Services)
CREATE TABLE Order_Details (
    order_detail_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    service_id INT NOT NULL,
    weight_kg DECIMAL(5,2) NOT NULL,
    subtotal DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (service_id) REFERENCES Services(service_id) ON DELETE CASCADE
);

-- Employees Table
CREATE TABLE Employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    role ENUM('Washer', 'Ironing', 'Delivery') NOT NULL
);

-- Payments Table
CREATE TABLE Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    payment_date DATE NOT NULL,
    amount_paid DECIMAL(10,2) NOT NULL,
    payment_method ENUM('Cash', 'Card', 'UPI') NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE
);

-- Delivery Table
CREATE TABLE Delivery (
    delivery_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    employee_id INT NOT NULL,
    delivery_status ENUM('Pending', 'Delivered') DEFAULT 'Pending',
    delivery_date DATE,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id) ON DELETE CASCADE
);

-- Insert into Customers
INSERT INTO Customers (name, phone, email, address) VALUES
('John Doe', '1234567890', 'john@example.com', '123 Main St'),
('Jane Smith', '9876543210', 'jane@example.com', '456 Elm St'),
('Robert Brown', '5556667777', 'robert@example.com', '789 Oak St');

-- Insert into Services
INSERT INTO Services (service_name, price_per_kg) VALUES
('Dry Cleaning', 5.00),
('Wash & Fold', 3.00),
('Ironing', 2.50);

-- Insert into Employees
INSERT INTO Employees (name, phone, role) VALUES
('Mike Johnson', '1122334455', 'Washer'),
('Sarah Wilson', '2233445566', 'Ironing'),
('David Lee', '3344556677', 'Delivery');

-- Insert into Orders
INSERT INTO Orders (customer_id, order_date, pickup_date, delivery_date, total_price, status) VALUES
(1, '2025-02-01', '2025-02-02', NULL, 15.00, 'In Progress'),
(2, '2025-02-02', '2025-02-03', '2025-02-05', 25.00, 'Completed'),
(3, '2025-02-03', '2025-02-04', NULL, 30.00, 'Pending');

-- Insert into Order Details
INSERT INTO Order_Details (order_id, service_id, weight_kg, subtotal) VALUES
(1, 1, 2.0, 10.00),
(1, 2, 1.5, 4.50),
(2, 2, 3.0, 9.00),
(3, 3, 4.0, 10.00);

-- Insert into Payments
INSERT INTO Payments (order_id, payment_date, amount_paid, payment_method) VALUES
(2, '2025-02-05', 25.00, 'Card');

-- Insert into Delivery
INSERT INTO Delivery (order_id, employee_id, delivery_status, delivery_date) VALUES
(2, 3, 'Delivered', '2025-02-05');

-- Retrieve all customers who have placed at least one order.
SELECT DISTINCT c.customer_id, c.name, c.phone, c.email 
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id;

-- Find the total revenue generated from each service type.
SELECT s.service_name, SUM(od.subtotal) AS total_revenue
FROM Order_Details od
JOIN Services s ON od.service_id = s.service_id
GROUP BY s.service_name;

-- List all orders that have not been delivered yet.
SELECT o.order_id, c.name, o.status 
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
LEFT JOIN Delivery d ON o.order_id = d.order_id
WHERE d.delivery_status IS NULL OR d.delivery_status = 'Pending';

-- Find the top 2 customers who have spent the most.
SELECT c.customer_id, c.name, SUM(o.total_price) AS total_spent
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 2;

-- Get the most frequently used payment method.
SELECT payment_method, COUNT(*) AS usage_count
FROM Payments
GROUP BY payment_method
ORDER BY usage_count DESC
LIMIT 1;

-- Show the average weight of laundry processed per order.
SELECT AVG(weight_kg) AS avg_weight_per_order 
FROM Order_Details;

-- List employees who have completed the most deliveries.
SELECT e.employee_id, e.name, COUNT(d.delivery_id) AS completed_deliveries
FROM Employees e
JOIN Delivery d ON e.employee_id = d.employee_id
WHERE d.delivery_status = 'Delivered'
GROUP BY e.employee_id
ORDER BY completed_deliveries DESC;

-- Find the most commonly used laundry service.
SELECT s.service_name, COUNT(od.service_id) AS usage_count
FROM Order_Details od
JOIN Services s ON od.service_id = s.service_id
GROUP BY s.service_id
ORDER BY usage_count DESC
LIMIT 1;

-- Retrieve all completed orders with customer details.
SELECT o.order_id, c.name, o.total_price, o.status 
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
WHERE o.status = 'Completed';

-- Find the total number of orders placed each month.
SELECT MONTH(order_date) AS month, YEAR(order_date) AS year, COUNT(order_id) AS total_orders
FROM Orders
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY year DESC, month DESC;

-- Show the total earnings from each customer.
SELECT c.customer_id, c.name, SUM(o.total_price) AS total_earnings
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY total_earnings DESC;

-- Retrieve all customers along with the number of orders they have placed.
SELECT c.customer_id, c.name, COUNT(o.order_id) AS order_count
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id;

-- Find the most recent order placed by each customer.
SELECT c.customer_id, c.name, MAX(o.order_date) AS last_order_date
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id;

-- Get the total weight of laundry processed by each service type.
SELECT s.service_name, SUM(od.weight_kg) AS total_weight
FROM Order_Details od
JOIN Services s ON od.service_id = s.service_id
GROUP BY s.service_name;

-- Retrieve orders that have been picked up but not yet delivered.
SELECT o.order_id, c.name, o.pickup_date, o.status
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
LEFT JOIN Delivery d ON o.order_id = d.order_id
WHERE o.pickup_date IS NOT NULL AND (d.delivery_status IS NULL OR d.delivery_status = 'Pending');

-- List all employees and their assigned orders for delivery.
SELECT e.employee_id, e.name, COUNT(d.order_id) AS assigned_orders
FROM Employees e
LEFT JOIN Delivery d ON e.employee_id = d.employee_id
GROUP BY e.employee_id;

-- Retrieve the highest spending customer.
SELECT c.customer_id, c.name, SUM(o.total_price) AS total_spent
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 1;

-- Find orders that have not been paid for yet.
SELECT o.order_id, c.name, o.total_price
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
LEFT JOIN Payments p ON o.order_id = p.order_id
WHERE p.order_id IS NULL;

-- Get a list of services used by a specific customer (replace '1' with a customer ID).
SELECT DISTINCT s.service_name
FROM Order_Details od
JOIN Services s ON od.service_id = s.service_id
JOIN Orders o ON od.order_id = o.order_id
WHERE o.customer_id = 1;

-- Find the employee who has made the most deliveries.
SELECT e.employee_id, e.name, COUNT(d.delivery_id) AS total_deliveries
FROM Employees e
JOIN Delivery d ON e.employee_id = d.employee_id
WHERE d.delivery_status = 'Delivered'
GROUP BY e.employee_id
ORDER BY total_deliveries DESC
LIMIT 1;

-- Show the average amount spent per order.
SELECT AVG(total_price) AS avg_order_price FROM Orders;

-- Get the total number of orders for each order status.
SELECT status, COUNT(order_id) AS total_orders
FROM Orders
GROUP BY status;

-- List customers who have placed orders in the last 30 days.
SELECT DISTINCT c.customer_id, c.name, o.order_date
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.order_date >= CURDATE() - INTERVAL 30 DAY
ORDER BY o.order_date DESC;

-- Find the customer who has placed the maximum number of orders.
SELECT c.customer_id, c.name, COUNT(o.order_id) AS total_orders
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY total_orders DESC
LIMIT 1;

-- Retrieve all orders along with the total weight of laundry processed.
SELECT o.order_id, c.name, SUM(od.weight_kg) AS total_weight
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Order_Details od ON o.order_id = od.order_id
GROUP BY o.order_id;

-- Find the orders where the total price is higher than the average order price.
SELECT order_id, total_price
FROM Orders
WHERE total_price > (SELECT AVG(total_price) FROM Orders);

-- Get a report of daily earnings.
SELECT order_date, SUM(total_price) AS daily_earnings
FROM Orders
GROUP BY order_date
ORDER BY order_date DESC;
