-- Project In MariaDB 
-- Create database
CREATE DATABASE inventory_management;
USE inventory_management;

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10, 2),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE suppliers (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    contact_email VARCHAR(100),
    phone VARCHAR(20),
    address TEXT
);

CREATE TABLE inventory (
    inventory_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    quantity INT,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE purchases (
    purchase_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_id INT,
    product_id INT,
    quantity INT,
    purchase_price DECIMAL(10, 2),
    purchase_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE sales (
    sale_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    quantity INT,
    sale_price DECIMAL(10, 2),
    sale_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Products
INSERT INTO products (name, category, price, description) VALUES
('Laptop', 'Electronics', 1000.00, '14 inch i5 laptop'),
('Mouse', 'Electronics', 25.00, 'Wireless mouse'),
('Desk Chair', 'Furniture', 120.00, 'Ergonomic office chair');

-- Suppliers
INSERT INTO suppliers (name, contact_email, phone, address) VALUES
('Tech Supplies Co.', 'tech@supplies.com', '123-456-7890', '123 Tech Street'),
('Office World', 'contact@officeworld.com', '555-234-5678', '456 Office Ave');

-- Inventory
INSERT INTO inventory (product_id, quantity) VALUES
(1, 10), (2, 50), (3, 20);

-- Purchases
INSERT INTO purchases (supplier_id, product_id, quantity, purchase_price) VALUES
(1, 1, 10, 900.00),
(1, 2, 50, 20.00),
(2, 3, 20, 100.00);

-- Sales
INSERT INTO sales (product_id, quantity, sale_price) VALUES
(1, 2, 1100.00),
(2, 10, 30.00),
(3, 3, 140.00);

-- View current inventory levels
SELECT p.name, i.quantity
FROM inventory i
JOIN products p ON i.product_id = p.product_id;

-- Sales report by product
SELECT p.name, SUM(s.quantity) AS total_sold, SUM(s.quantity * s.sale_price) AS total_revenue
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.name;

-- Purchase report by supplier
SELECT sup.name AS supplier, p.name AS product, SUM(pur.quantity) AS total_purchased
FROM purchases pur
JOIN products p ON pur.product_id = p.product_id
JOIN suppliers sup ON pur.supplier_id = sup.supplier_id
GROUP BY sup.name, p.name;

-- Total profit by product
SELECT 
    p.name,
    SUM(s.quantity * s.sale_price) - COALESCE(SUM(pur.quantity * pur.purchase_price), 0) AS profit
FROM sales s
JOIN products p ON s.product_id = p.product_id
LEFT JOIN purchases pur ON pur.product_id = s.product_id
GROUP BY p.name;

-- Low stock alert (e.g., quantity < 20)
SELECT p.name, i.quantity
FROM inventory i
JOIN products p ON i.product_id = p.product_id
WHERE i.quantity < 20;

-- Sales made this month
SELECT p.name, s.quantity, s.sale_date
FROM sales s
JOIN products p ON s.product_id = p.product_id
WHERE MONTH(s.sale_date) = MONTH(CURRENT_DATE())
AND YEAR(s.sale_date) = YEAR(CURRENT_DATE());
