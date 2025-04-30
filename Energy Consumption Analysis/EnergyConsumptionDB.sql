-- Project in Maria Database 
CREATE DATABASE EnergyConsumptionDB;
USE EnergyConsumptionDB;

-- Customers Table 
CREATE TABLE customers (
  customer_id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50),
  address VARCHAR(155),
  contact_number BIGINT,
  email VARCHAR(50) UNIQUE
);

-- Energy Meters Table
CREATE TABLE energy_meters (
  meter_id INT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT,
  installation_date DATE,
  statuss ENUM('Active', 'Inactive'),
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Energy Consumption Table 
CREATE TABLE energy_consumption (
  consumption_id INT PRIMARY KEY AUTO_INCREMENT,
  meter_id INT,
  reading_date DATE,
  consumption_kwh DECIMAL(5,2),
  billing_amount DECIMAL(5,2),
  FOREIGN KEY (meter_id) REFERENCES energy_meters(meter_id)
);

-- Billing Table 
CREATE TABLE billing (
  bill_id INT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT,
  billing_month VARCHAR(20),
  total_amount DECIMAL(5,2),
  payment_status ENUM('Paid', 'Pending'),
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Tariffs Table 
CREATE TABLE tariffs (
  tariff_id INT PRIMARY KEY AUTO_INCREMENT,
  rate_per_kwh DECIMAL(5,2),
  valid_from DATETIME,
  valid_to DATETIME
);

-- Outages Table 
CREATE TABLE outages (
  outage_id INT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT,
  outage_start DATETIME,
  outage_end DATETIME,
  reason TEXT,
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Insert Sample Data into Customers Table
INSERT INTO customers (name, address, contact_number, email) VALUES
('John Doe', '123 Green St, New York', 1234567890, 'john.doe@example.com'),
('Jane Smith', '456 Blue Ave, Los Angeles', 9876543210, 'jane.smith@example.com'),
('Alice Johnson', '789 Yellow Rd, Chicago', 5647382910, 'alice.johnson@example.com'),
('Bob Brown', '321 Red Ln, Houston', 6789054321, 'bob.brown@example.com'),
('Charlie White', '654 Purple Dr, Phoenix', 7890123456, 'charlie.white@example.com'),
('Emma Black', '987 Orange Blvd, Miami', 8901234567, 'emma.black@example.com');

-- Insert Sample Data into Energy Meters Table
INSERT INTO energy_meters (customer_id, installation_date, statuss) VALUES
(1, '2023-01-15', 'Active'),
(2, '2023-02-10', 'Inactive'),
(3, '2023-03-05', 'Active'),
(4, '2023-04-20', 'Active'),
(5, '2023-05-25', 'Inactive'),
(6, '2023-06-30', 'Active');

-- Insert Sample Data into Energy Consumption Table
INSERT INTO energy_consumption (meter_id, reading_date, consumption_kwh, billing_amount) VALUES
(1, '2024-01-01', 250.75, 50.15),
(2, '2024-01-02', 310.50, 65.75),
(3, '2024-01-03', 220.00, 45.30),
(4, '2024-01-04', 275.25, 55.10),
(5, '2024-01-05', 290.80, 58.20),
(6, '2024-01-06', 305.60, 62.40);

-- Insert Sample Data into Billing Table
INSERT INTO billing (customer_id, billing_month, total_amount, payment_status) VALUES
(1, 'January 2024', 50.15, 'Paid'),
(2, 'January 2024', 65.75, 'Pending'),
(3, 'January 2024', 45.30, 'Paid'),
(4, 'January 2024', 55.10, 'Pending'),
(5, 'January 2024', 58.20, 'Paid'),
(6, 'January 2024', 62.40, 'Pending');

-- Insert Sample Data into Tariffs Table
INSERT INTO tariffs (rate_per_kwh, valid_from, valid_to) VALUES
(0.20, '2023-01-01 00:00:00', '2023-06-30 23:59:59'),
(0.22, '2023-07-01 00:00:00', '2023-12-31 23:59:59'),
(0.25, '2024-01-01 00:00:00', '2024-06-30 23:59:59'),
(0.27, '2024-07-01 00:00:00', '2024-12-31 23:59:59'),
(0.30, '2025-01-01 00:00:00', '2025-06-30 23:59:59'),
(0.32, '2025-07-01 00:00:00', '2025-12-31 23:59:59');

-- Insert Sample Data into Outages Table
INSERT INTO outages (customer_id, outage_start, outage_end, reason) VALUES
(1, '2024-02-01 10:00:00', '2024-02-01 12:30:00', 'Scheduled Maintenance'),
(2, '2024-02-02 14:15:00', '2024-02-02 15:45:00', 'Storm Damage'),
(3, '2024-02-03 08:00:00', '2024-02-03 10:15:00', 'Equipment Failure'),
(4, '2024-02-04 20:00:00', '2024-02-05 00:00:00', 'Power Grid Failure'),
(5, '2024-02-05 16:30:00', '2024-02-05 19:00:00', 'Transformer Overload'),
(6, '2024-02-06 09:45:00', '2024-02-06 12:00:00', 'Planned Upgrade');

-- Find the total energy consumption for each customer in a given month.
SELECT c.customer_id, c.name, SUM(ec.consumption_kwh) AS total_consumption, 
       DATE_FORMAT(ec.reading_date, '%Y-%m') AS month
FROM energy_consumption ec
JOIN energy_meters em ON ec.meter_id = em.meter_id
JOIN customers c ON em.customer_id = c.customer_id
WHERE DATE_FORMAT(ec.reading_date, '%Y-%m') = '2024-01'
GROUP BY c.customer_id, c.name, month;

-- Calculate the average daily energy consumption for a given meter.
SELECT meter_id, 
       AVG(consumption_kwh) AS avg_daily_consumption
FROM energy_consumption
WHERE meter_id = 3
GROUP BY meter_id;

-- Retrieve monthly revenue generated from electricity consumption.
SELECT DATE_FORMAT(ec.reading_date, '%Y-%m') AS month, 
       SUM(ec.billing_amount) AS total_revenue
FROM energy_consumption ec
GROUP BY month
ORDER BY month DESC;

-- Find customers whose energy consumption exceeds a threshold in any month.
SELECT c.customer_id, c.name, DATE_FORMAT(ec.reading_date, '%Y-%m') AS month, 
       SUM(ec.consumption_kwh) AS total_consumption
FROM energy_consumption ec
JOIN energy_meters em ON ec.meter_id = em.meter_id
JOIN customers c ON em.customer_id = c.customer_id
GROUP BY c.customer_id, c.name, month
HAVING total_consumption > 300; 

-- Identify meters that have been inactive for more than a year.
SELECT meter_id, customer_id, installation_date, statuss
FROM energy_meters
WHERE statuss = 'Inactive' 
  AND installation_date < DATE_SUB(CURDATE(), INTERVAL 1 YEAR);

-- Find the total number of active and inactive meters
SELECT statuss, COUNT(*) AS total_meters
FROM energy_meters
GROUP BY statuss;

-- Identify customers who haven't had any energy consumption recorded in the last three months
SELECT c.customer_id, c.name
FROM customers c
LEFT JOIN energy_meters em ON c.customer_id = em.customer_id
LEFT JOIN energy_consumption ec ON em.meter_id = ec.meter_id
      AND ec.reading_date >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
WHERE ec.meter_id IS NULL;

-- Identify the meter that has recorded the highest total energy consumption
SELECT meter_id, SUM(consumption_kwh) AS total_consumption
FROM energy_consumption
GROUP BY meter_id
ORDER BY total_consumption DESC
LIMIT 1;

-- Identify the month with the highest total energy consumption
SELECT DATE_FORMAT(reading_date, '%Y-%m') AS month, 
       SUM(consumption_kwh) AS total_consumption
FROM energy_consumption
GROUP BY month
ORDER BY total_consumption DESC
LIMIT 1;
