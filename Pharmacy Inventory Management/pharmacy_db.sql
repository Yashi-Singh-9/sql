-- Create Database
CREATE DATABASE pharmacy_db;
USE pharmacy_db;

-- Categories Table 
CREATE TABLE categories (
  category_id INT PRIMARY KEY AUTO_INCREMENT,
  category_name VARCHAR(50)
);

-- Medicines Table 
CREATE TABLE medicines (
  medicine_id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50),
  description TEXT,
  manufacturer VARCHAR(100),
  category_id INT,
  price DECIMAL(5,2),
  quantity_in_stock INT,
  expiry_date DATE,
  FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- Suppliers Table 
CREATE TABLE suppliers (
  supplier_id INT PRIMARY KEY AUTO_INCREMENT,
  supplier_name VARCHAR(100),
  contact_person VARCHAR(100),
  phone BIGINT,
  email VARCHAR(100) UNIQUE,
  address VARCHAR(100)
);

-- Purchases Table 
CREATE TABLE purchases (
  purchase_id INT PRIMARY KEY AUTO_INCREMENT,
  supplier_id INT,
  purchase_date DATE,
  FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

-- Purchase Details Table 
CREATE TABLE purchase_details (
  purchase_detail_id INT PRIMARY KEY AUTO_INCREMENT,
  purchase_id INT,
  medicine_id INT,
  quantity INT,
  purchase_price DECIMAL(5,2),
  FOREIGN KEY (purchase_id) REFERENCES purchases(purchase_id),
  FOREIGN KEY (medicine_id) REFERENCES medicines(medicine_id)
);

-- Sales Table 
CREATE TABLE sales (
  sale_id INT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT,
  sale_date DATE,
  total_amount DECIMAL(5,2),
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Sale Details Table 
CREATE TABLE sale_details (
  sale_detail_id INT PRIMARY KEY AUTO_INCREMENT,
  sale_id INT,
  medicine_id INT,
  quantity INT,
  selling_price DECIMAL(5,2),
  FOREIGN KEY (sale_id) REFERENCES sales(sale_id),
  FOREIGN KEY (medicine_id) REFERENCES medicines(medicine_id)
);

-- Customers Table 
CREATE TABLE customers (
  customer_id INT PRIMARY KEY AUTO_INCREMENT,
  customer_name VARCHAR(50),
  phone BIGINT,
  email VARCHAR(50) UNIQUE,
  address VARCHAR(100)
);

-- Employees Table 
CREATE TABLE employees (
  employee_id INT PRIMARY KEY AUTO_INCREMENT,
  employee_name VARCHAR(50),
  phone BIGINT,
  email VARCHAR(50) UNIQUE,
  role VARCHAR(50),
  salary DECIMAL(10,2)
);

-- Orders Table 
CREATE TABLE orders (
  order_id INT PRIMARY KEY AUTO_INCREMENT,
  supplier_id INT,
  order_date DATE,
  statuss VARCHAR(50),
  FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

-- Order Details Table 
CREATE TABLE order_details (
  order_detail_id INT PRIMARY KEY AUTO_INCREMENT,
  order_id INT,
  medicine_id INT,
  quantity INT,
  price_per_unit DECIMAL(5,2),
  FOREIGN KEY (order_id) REFERENCES orders(order_id),
  FOREIGN KEY (medicine_id) REFERENCES medicines(medicine_id)
);  

-- Insert Categories
INSERT INTO categories (category_name) VALUES 
('Pain Relief'), 
('Antibiotics'), 
('Vitamins'), 
('Allergy'), 
('Cold & Flu'), 
('Digestive Health');

-- Insert Medicines
INSERT INTO medicines (name, description, manufacturer, category_id, price, quantity_in_stock, expiry_date) VALUES
('Paracetamol', 'Pain reliever', 'ABC Pharma', 1, 2.50, 150, '2026-05-15'),
('Amoxicillin', 'Antibiotic', 'XYZ Pharma', 2, 5.00, 80, '2025-07-10'),
('Vitamin C', 'Boosts immunity', 'HealthCorp', 3, 3.75, 120, '2027-01-05'),
('Cetirizine', 'Allergy relief', 'MediCare', 4, 4.50, 50, '2024-04-20'),
('Ibuprofen', 'Pain and inflammation relief', 'MediLife', 1, 3.25, 200, '2026-11-30'),
('Omeprazole', 'Acid reflux treatment', 'GastroHeal', 6, 6.00, 40, '2025-09-25');

-- Insert Suppliers
INSERT INTO suppliers (supplier_name, contact_person, phone, email, address) VALUES
('MediSupply Inc.', 'John Doe', 9876543210, 'medisupply@example.com', '123 Med St'),
('Health Distributors', 'Jane Smith', 9123456789, 'healthdist@example.com', '456 Wellness Ave'),
('Pharma Direct', 'Alice Brown', 9654321098, 'pharmadirect@example.com', '789 Care Blvd');

-- Insert Purchases
INSERT INTO purchases (supplier_id, purchase_date) VALUES
(1, '2024-02-10'),
(2, '2024-01-15'),
(1, '2024-02-20'),
(3, '2024-01-25'),
(2, '2024-02-05'),
(3, '2024-02-18');

-- Insert Purchase Details
INSERT INTO purchase_details (purchase_id, medicine_id, quantity, purchase_price) VALUES
(1, 1, 50, 2.00),
(2, 2, 40, 4.50),
(3, 3, 60, 3.50),
(4, 4, 30, 4.00),
(5, 5, 100, 3.00),
(6, 6, 20, 5.50);

-- Insert Customers
INSERT INTO customers (customer_name, phone, email, address) VALUES
('Michael Johnson', 9876543211, 'michaelj@example.com', '101 Main St'),
('Emily Davis', 9988776655, 'emilyd@example.com', '202 Park Ave'),
('Chris Brown', 9786543210, 'chrisb@example.com', '303 Oak Lane'),
('Sophia Wilson', 9678432100, 'sophiaw@example.com', '404 Elm St'),
('Daniel Martinez', 9123456788, 'danielm@example.com', '505 Pine Rd'),
('Emma Anderson', 9654321097, 'emmaa@example.com', '606 Maple Dr');

-- Insert Sales
INSERT INTO sales (customer_id, sale_date, total_amount) VALUES
(1, '2024-02-01', 15.00),
(2, '2024-01-28', 10.50),
(3, '2024-02-10', 25.75),
(4, '2024-02-15', 20.00),
(5, '2024-01-20', 30.00),
(6, '2024-02-05', 18.25);

-- Insert Sale Details
INSERT INTO sale_details (sale_id, medicine_id, quantity, selling_price) VALUES
(1, 1, 3, 2.50),
(2, 2, 2, 5.00),
(3, 3, 5, 3.75),
(4, 4, 4, 4.50),
(5, 5, 6, 3.25),
(6, 6, 2, 6.00);

-- Insert Employees
INSERT INTO employees (employee_name, phone, email, role, salary) VALUES
('David Clark', 9876543222, 'davidc@example.com', 'Pharmacist', 4500.00),
('Jessica White', 9988776644, 'jessicaw@example.com', 'Cashier', 3000.00),
('Robert Hall', 9786543209, 'roberth@example.com', 'Manager', 5500.00);

-- Insert Orders
INSERT INTO orders (supplier_id, order_date, statuss) VALUES
(1, '2024-02-05', 'Completed'),
(2, '2024-02-10', 'Pending'),
(1, '2024-01-25', 'Completed'),
(3, '2024-02-12', 'Shipped'),
(2, '2024-02-08', 'Completed'),
(3, '2024-01-30', 'Completed');

-- Insert Order Details
INSERT INTO order_details (order_id, medicine_id, quantity, price_per_unit) VALUES
(1, 1, 40, 2.00),
(2, 2, 50, 4.50),
(3, 3, 70, 3.50),
(4, 4, 20, 4.00),
(5, 5, 80, 3.00),
(6, 6, 30, 5.50);

-- Retrieve the top 3 medicines with the highest stock quantity.
SELECT name, quantity_in_stock 
FROM medicines 
ORDER BY quantity_in_stock DESC 
LIMIT 3;

-- Find expired medicines in the inventory.
SELECT name, expiry_date 
FROM medicines 
WHERE expiry_date < CURDATE();

-- Get the total revenue generated by the pharmacy this year.
SELECT SUM(total_amount) AS total_revenue 
FROM sales 
WHERE YEAR(sale_date) = YEAR(CURDATE());

-- Identify the supplier from whom the most stock is purchased.
SELECT s.supplier_name, SUM(pd.quantity) AS total_quantity 
FROM purchase_details pd
JOIN purchases p ON pd.purchase_id = p.purchase_id
JOIN suppliers s ON p.supplier_id = s.supplier_id
GROUP BY s.supplier_name
ORDER BY total_quantity DESC
LIMIT 1;

-- Show the most sold medicine category.
SELECT c.category_name, SUM(sd.quantity) AS total_sold 
FROM sale_details sd
JOIN medicines m ON sd.medicine_id = m.medicine_id
JOIN categories c ON m.category_id = c.category_id
GROUP BY c.category_name
ORDER BY total_sold DESC
LIMIT 1;

-- Get the customer who made the most purchases.
SELECT c.customer_name, COUNT(s.sale_id) AS purchase_count 
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY purchase_count DESC
LIMIT 1;

-- Find the employee with the highest sales transactions.
SELECT e.employee_name, COUNT(s.sale_id) AS total_sales 
FROM sales s
JOIN employees e ON s.customer_id = e.employee_id
GROUP BY e.employee_name
ORDER BY total_sales DESC
LIMIT 1;

-- Get the most recent stock purchase details for a particular medicine.
SELECT m.name, pd.quantity, pd.purchase_price, p.purchase_date 
FROM purchase_details pd
JOIN purchases p ON pd.purchase_id = p.purchase_id
JOIN medicines m ON pd.medicine_id = m.medicine_id
ORDER BY p.purchase_date DESC 
LIMIT 1;

-- Find medicines that are low in stock (below a threshold).
SELECT name, quantity_in_stock 
FROM medicines 
WHERE quantity_in_stock < 50;

-- List all medicines supplied by a particular supplier
SELECT m.name, s.supplier_name 
FROM purchase_details pd
JOIN purchases p ON pd.purchase_id = p.purchase_id
JOIN medicines m ON pd.medicine_id = m.medicine_id
JOIN suppliers s ON p.supplier_id = s.supplier_id
WHERE s.supplier_name = 'MediSupply Inc.';

-- Get the total number of medicines sold per category
SELECT c.category_name, SUM(sd.quantity) AS total_sold 
FROM sale_details sd
JOIN medicines m ON sd.medicine_id = m.medicine_id
JOIN categories c ON m.category_id = c.category_id
GROUP BY c.category_name
ORDER BY total_sold DESC;

-- Find the top 3 best-selling medicines
SELECT m.name, SUM(sd.quantity) AS total_sold 
FROM sale_details sd
JOIN medicines m ON sd.medicine_id = m.medicine_id
GROUP BY m.name
ORDER BY total_sold DESC
LIMIT 3;

-- Identify customers who bought a specific medicine
SELECT DISTINCT c.customer_name, c.phone, c.email 
FROM sales s
JOIN sale_details sd ON s.sale_id = sd.sale_id
JOIN customers c ON s.customer_id = c.customer_id
JOIN medicines m ON sd.medicine_id = m.medicine_id
WHERE m.name = 'Paracetamol';

-- Get the total purchase cost from each supplier
SELECT s.supplier_name, SUM(pd.quantity * pd.purchase_price) AS total_spent 
FROM purchase_details pd
JOIN purchases p ON pd.purchase_id = p.purchase_id
JOIN suppliers s ON p.supplier_id = s.supplier_id
GROUP BY s.supplier_name
ORDER BY total_spent DESC;

-- Identify the last 4 sales transactions
SELECT s.sale_id, c.customer_name, s.sale_date, s.total_amount 
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
ORDER BY s.sale_date DESC
LIMIT 4;

-- Calculate the reorder quantity for low-stock medicines
SELECT name, quantity_in_stock, 
       (50 - quantity_in_stock) AS reorder_quantity
FROM medicines 
WHERE quantity_in_stock < 50;

-- Find the most recent sale transaction
SELECT s.sale_id, c.customer_name, s.sale_date, s.total_amount 
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
ORDER BY s.sale_date DESC
LIMIT 1;