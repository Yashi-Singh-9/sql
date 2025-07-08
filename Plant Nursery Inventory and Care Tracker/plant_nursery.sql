-- Project in PostgreSQL 
-- Create the database
CREATE DATABASE plant_nursery;
\c plant_nursery;

-- Table: Plants
CREATE TABLE plants (
    plant_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    species VARCHAR(100),
    price NUMERIC(8,2),
    stock_quantity INT,
    date_added DATE DEFAULT CURRENT_DATE
);

-- Table: Suppliers
CREATE TABLE suppliers (
    supplier_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    contact_email VARCHAR(100),
    phone VARCHAR(20),
    location TEXT
);

-- Table: Plant Supplies
CREATE TABLE plant_supplies (
    supply_id SERIAL PRIMARY KEY,
    plant_id INT REFERENCES plants(plant_id),
    supplier_id INT REFERENCES suppliers(supplier_id),
    quantity_supplied INT,
    supply_date DATE DEFAULT CURRENT_DATE
);

-- Table: Care Instructions
CREATE TABLE care_instructions (
    care_id SERIAL PRIMARY KEY,
    plant_id INT REFERENCES plants(plant_id),
    sunlight_requirements VARCHAR(100),
    watering_frequency VARCHAR(50),
    fertilizing_schedule VARCHAR(100),
    pruning_notes TEXT
);

-- Table: Plant Care Logs
CREATE TABLE care_logs (
    log_id SERIAL PRIMARY KEY,
    plant_id INT REFERENCES plants(plant_id),
    care_type VARCHAR(50), -- e.g., watering, fertilizing, pruning
    care_date DATE DEFAULT CURRENT_DATE,
    notes TEXT
);

-- Table: Sales
CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    plant_id INT REFERENCES plants(plant_id),
    quantity_sold INT,
    sale_price NUMERIC(8,2),
    sold_to VARCHAR(100),
    sale_date DATE DEFAULT CURRENT_DATE
);

-- Suppliers
INSERT INTO suppliers (name, contact_email, phone, location) VALUES
('Green Leaf Suppliers', 'contact@greenleaf.com', '555-1010', 'California'),
('Botanic World', 'sales@botanicworld.com', '555-2020', 'Oregon');

-- Plants
INSERT INTO plants (name, species, price, stock_quantity) VALUES
('Snake Plant', 'Sansevieria', 12.99, 30),
('Peace Lily', 'Spathiphyllum', 15.50, 20),
('Areca Palm', 'Dypsis lutescens', 25.00, 15);

-- Plant Supplies
INSERT INTO plant_supplies (plant_id, supplier_id, quantity_supplied) VALUES
(1, 1, 50),
(2, 2, 40),
(3, 1, 25);

-- Care Instructions
INSERT INTO care_instructions (plant_id, sunlight_requirements, watering_frequency, fertilizing_schedule, pruning_notes) VALUES
(1, 'Indirect light', 'Once every 2 weeks', 'Monthly', 'Remove dead leaves'),
(2, 'Partial shade', 'Twice a week', 'Every 6 weeks', 'Trim tips if brown'),
(3, 'Bright indirect', 'Every 5 days', 'Bi-weekly', 'Cut brown fronds');

-- Care Logs
INSERT INTO care_logs (plant_id, care_type, notes) VALUES
(1, 'watering', 'Watered thoroughly'),
(2, 'pruning', 'Removed yellow leaves'),
(3, 'fertilizing', 'Used liquid fertilizer');

-- Sales
INSERT INTO sales (plant_id, quantity_sold, sale_price, sold_to) VALUES
(1, 2, 25.98, 'Emily Rose'),
(3, 1, 25.00, 'Garden Club Inc.');

-- Plants that need pruning notes
SELECT p.name, c.pruning_notes
FROM care_instructions c
JOIN plants p ON c.plant_id = p.plant_id
WHERE c.pruning_notes IS NOT NULL;

-- Total stock remaining
SELECT name, stock_quantity 
FROM plants 
ORDER BY stock_quantity DESC;

-- View recent plant care logs
SELECT p.name, l.care_type, l.care_date, l.notes
FROM care_logs l
JOIN plants p ON l.plant_id = p.plant_id
ORDER BY l.care_date DESC;

-- Total revenue from sales
SELECT SUM(sale_price) AS total_revenue 
FROM sales;

-- Supplier-wise quantity supplied
SELECT s.name, SUM(ps.quantity_supplied) AS total_supplied
FROM plant_supplies ps
JOIN suppliers s ON ps.supplier_id = s.supplier_id
GROUP BY s.name;

-- Best-Selling Plants (By Quantity)
SELECT p.name, SUM(s.quantity_sold) AS total_sold
FROM sales s
JOIN plants p ON s.plant_id = p.plant_id
GROUP BY p.name
ORDER BY total_sold DESC;

-- Low Stock Alert (Threshold = 16 units)
SELECT name, stock_quantity
FROM plants
WHERE stock_quantity < 16
ORDER BY stock_quantity ASC;

-- Monthly Sales Report
SELECT 
    TO_CHAR(sale_date, 'YYYY-MM') AS sale_month,
    COUNT(*) AS total_sales,
    SUM(sale_price) AS total_revenue
FROM sales
GROUP BY sale_month
ORDER BY sale_month DESC;

-- Detailed Sale Record with Plant and Customer Info
SELECT 
    s.sale_date,
    p.name AS plant_name,
    s.quantity_sold,
    s.sale_price,
    s.sold_to
FROM sales s
JOIN plants p ON s.plant_id = p.plant_id
ORDER BY s.sale_date DESC;

-- Find Plants Matching Specific Sunlight Needs
SELECT p.name, c.sunlight_requirements
FROM care_instructions c
JOIN plants p ON c.plant_id = p.plant_id
WHERE c.sunlight_requirements ILIKE '%indirect%';

-- Total Supplied vs Sold Quantity for Each Plant
SELECT 
    p.name,
    COALESCE(SUM(ps.quantity_supplied), 0) AS total_supplied,
    COALESCE(SUM(s.quantity_sold), 0) AS total_sold,
    COALESCE(SUM(ps.quantity_supplied), 0) - COALESCE(SUM(s.quantity_sold), 0) AS balance
FROM plants p
LEFT JOIN plant_supplies ps ON p.plant_id = ps.plant_id
LEFT JOIN sales s ON p.plant_id = s.plant_id
GROUP BY p.name
ORDER BY balance ASC;

-- Most Frequently Performed Care Activities
SELECT care_type, COUNT(*) AS frequency
FROM care_logs
GROUP BY care_type
ORDER BY frequency DESC;

-- Supplier Activity – Recent Supplies
SELECT 
    s.name AS supplier,
    p.name AS plant,
    ps.quantity_supplied,
    ps.supply_date
FROM plant_supplies ps
JOIN suppliers s ON ps.supplier_id = s.supplier_id
JOIN plants p ON ps.plant_id = p.plant_id
ORDER BY ps.supply_date DESC;

-- Top Revenue-Generating Plants
SELECT 
    p.name,
    SUM(s.sale_price) AS total_revenue
FROM sales s
JOIN plants p ON s.plant_id = p.plant_id
GROUP BY p.name
ORDER BY total_revenue DESC;
