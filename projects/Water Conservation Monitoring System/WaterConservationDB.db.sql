-- SQL Lite Project
sqlite3 WaterConservationDB.db

-- Users Table 
CREATE TABLE users (
  user_id INTEGER PRIMARY KEY,
  name VARCHAR(20),
  email VARCHAR(20) UNIQUE,
  phone BIGINT,
  address TEXT,
  role VARCHAR(20) CHECK (role IN ('Admin', 'User', 'Government Official'))
);

-- Water Sources Table 
CREATE TABLE water_sources (
  source_id INTEGER PRIMARY KEY,
  name VARCHAR(20),
  location TEXT,
  capacity_in_litres DECIMAL(4,2),
  status VARCHAR(20) CHECK (status IN ('Active', 'Dry', 'Contaminated'))
);

-- Water Usage Table 
CREATE TABLE water_usage (
  usage_id INTEGER PRIMARY KEY,
  user_id INTEGER,
  date DATE,
  water_used_in_litres DECIMAL(4,2),
  source_id INTEGER,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (source_id) REFERENCES water_sources(source_id)
);

-- Water Quality Table 
CREATE TABLE water_quality (
  quality_id INTEGER PRIMARY KEY,
  source_id INTEGER,
  pH_level DECIMAL(4,2),
  contaminants_detected TEXT,
  date_tested DATE,
  FOREIGN KEY (source_id) REFERENCES water_sources(source_id)
);

-- Sensors Table  
CREATE TABLE sensors (
  sensor_id INTEGER PRIMARY KEY,
  source_id INTEGER,
  sensor_type VARCHAR(20) CHECK (sensor_type IN ('Flow Sensor', 'Quality Sensor')),
  status VARCHAR(30),
  last_maintenance_date DATE,
  FOREIGN KEY (source_id) REFERENCES water_sources(source_id)
);

-- Alerts Table 
CREATE TABLE alerts (
  alert_id INTEGER PRIMARY KEY,
  user_id INTEGER,
  source_id INTEGER,
  alert_type VARCHAR(18) CHECK (alert_type IN ('Overconsumption', 'Contamination')),
  description TEXT,
  date_issued DATE,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (source_id) REFERENCES water_sources(source_id)
);

-- Insert Sample Data into Users Table
INSERT INTO users (user_id, name, email, phone, address, role) VALUES
(1, 'Alice Johnson', 'alice@example.com', 9876543210, '123 Greenway Blvd', 'User'),
(2, 'Bob Smith', 'bob@example.com', 9876543211, '456 Blue St', 'Admin'),
(3, 'Charlie Davis', 'charlie@example.com', 9876543212, '789 River Rd', 'Government Official'),
(4, 'Daisy Evans', 'daisy@example.com', NULL, '321 Park Ave', 'User'),
(5, 'Ethan White', 'ethan@example.com', 9876543213, '654 Forest Ln', 'User'),
(6, 'Fiona Green', 'fiona@example.com', NULL, '987 Mountain Rd', 'User'),
(7, 'George Brown', 'george@example.com', 9876543214, '741 Desert Hwy', 'Admin'),
(8, 'Hannah Lee', 'hannah@example.com', 9876543215, '159 Ocean Dr', 'Government Official');

-- Insert Sample Data into Water Sources Table
INSERT INTO water_sources (source_id, name, location, capacity_in_litres, status) VALUES
(1, 'Lakeview Reservoir', 'Near Lakeview Park', 5000.50, 'Active'),
(2, 'Green River', 'Downtown District', 7000.75, 'Contaminated'),
(3, 'Sunset Well', 'Eastside Town', 3000.30, 'Active'),
(4, 'Highland Pond', 'Mountain Region', 2500.25, 'Dry'),
(5, 'Valley Spring', 'West Valley', 4500.45, 'Active'),
(6, 'Silver Stream', 'Northern Side', 6000.60, 'Contaminated'),
(7, 'City Water Plant', 'Central City', 8000.80, 'Active'),
(8, 'Meadowbrook Creek', 'South Suburbs', 3500.35, 'Dry');

-- Insert Sample Data into Water Usage Table
INSERT INTO water_usage (usage_id, user_id, date, water_used_in_litres, source_id) VALUES
(1, 1, '2024-02-10', 100.50, 1),
(2, 2, '2024-02-12', 200.75, 3),
(3, 3, '2024-02-15', 150.25, 5),
(4, 4, '2024-02-18', 175.40, NULL),
(5, 5, '2024-02-20', 120.30, 7),
(6, 6, '2024-02-22', NULL, 2),
(7, 7, '2024-02-25', 300.60, 4),
(8, 8, '2024-02-28', 180.90, 6);

-- Insert Sample Data into Water Quality Table
INSERT INTO water_quality (quality_id, source_id, pH_level, contaminants_detected, date_tested) VALUES
(1, 1, 7.2, 'None', '2024-01-05'),
(2, 2, 6.5, 'Lead, Mercury', '2024-01-08'),
(3, 3, 7.8, 'None', '2024-01-12'),
(4, 4, 5.9, 'Bacteria', '2024-01-15'),
(5, 5, 7.0, 'None', '2024-01-18'),
(6, 6, 6.2, 'Arsenic', '2024-01-22'),
(7, 7, 7.5, NULL, '2024-01-25'),
(8, 8, NULL, 'Pesticides', '2024-01-28');

-- Insert Sample Data into Sensors Table
INSERT INTO sensors (sensor_id, source_id, sensor_type, status, last_maintenance_date) VALUES
(1, 1, 'Flow Sensor', 'Operational', '2024-01-01'),
(2, 2, 'Quality Sensor', 'Needs Maintenance', '2024-01-03'),
(3, 3, 'Flow Sensor', 'Operational', '2024-01-05'),
(4, NULL, 'Quality Sensor', 'Inactive', '2024-01-07'),
(5, 5, 'Flow Sensor', 'Operational', '2024-01-09'),
(6, 6, 'Quality Sensor', 'Needs Repair', '2024-01-11'),
(7, 7, 'Flow Sensor', 'Operational', '2024-01-13'),
(8, 8, 'Quality Sensor', NULL, '2024-01-15');

-- Insert Sample Data into Alerts Table
INSERT INTO alerts (alert_id, user_id, source_id, alert_type, description, date_issued) VALUES
(1, 1, 2, 'Contamination', 'High lead levels detected.', '2024-02-01'),
(2, 2, 4, 'Overconsumption', 'Excessive water usage detected.', '2024-02-03'),
(3, 3, NULL, 'Contamination', 'Water contamination reported.', '2024-02-05'),
(4, NULL, 6, 'Contamination', 'Arsenic levels above safe limit.', '2024-02-07'),
(5, 5, 1, 'Overconsumption', 'Daily usage exceeds limit.', '2024-02-09'),
(6, 6, NULL, 'Overconsumption', 'Unusual water usage detected.', '2024-02-11'),
(7, 7, 7, 'Contamination', 'Potential bacteria contamination.', '2024-02-13'),
(8, 8, 8, 'Overconsumption', 'High water consumption alert.', '2024-02-15');

-- Find users who consumed more than 160 liters of water in a single day.
SELECT u.user_id, u.name, wu.date, wu.water_used_in_litres 
FROM water_usage wu
JOIN users u ON wu.user_id = u.user_id
WHERE wu.water_used_in_litres > 160;

-- List water sources that have a pH level below 6.5 (acidic water).
SELECT ws.source_id, ws.name, wq.pH_level 
FROM water_quality wq
JOIN water_sources ws ON wq.source_id = ws.source_id
WHERE wq.pH_level < 6.5;

-- Find the top 5 users who have consumed the most water in the last month.
SELECT u.user_id, u.name, SUM(wu.water_used_in_litres) AS total_consumption
FROM water_usage wu
JOIN users u ON wu.user_id = u.user_id
WHERE wu.date >= DATE('now', '-1 month')
GROUP BY u.user_id
ORDER BY total_consumption DESC
LIMIT 5;

-- Retrieve all water quality reports for a specific water source.
SELECT * FROM water_quality 
WHERE source_id = 3;

-- Find sensors that haven't been maintained in the last 6 months.
SELECT * FROM sensors
WHERE last_maintenance_date <= DATE('now', '-6 months');

-- Find water sources that have contamination alerts in the last 30 days.
SELECT DISTINCT ws.source_id, ws.name
FROM alerts a
JOIN water_sources ws ON a.source_id = ws.source_id
WHERE a.alert_type = 'Contamination' 
AND a.date_issued >= DATE('now', '-30 days');

-- Get the average water consumption per user for the last 3 months.
SELECT u.user_id, u.name, AVG(wu.water_used_in_litres) AS avg_consumption
FROM water_usage wu
JOIN users u ON wu.user_id = u.user_id
WHERE wu.date >= DATE('now', '-12 months')
GROUP BY u.user_id;

-- Find all alerts issued for a specific user.
SELECT * FROM alerts 
WHERE user_id = 8;

-- Retrieve the number of water sources that are currently dry.
SELECT COUNT(*) AS dry_sources_count 
FROM water_sources 
WHERE status = 'Dry';

-- List the top 3 most frequently contaminated water sources based on the number of alerts.
SELECT ws.source_id, ws.name, COUNT(a.alert_id) AS contamination_count
FROM alerts a
JOIN water_sources ws ON a.source_id = ws.source_id
WHERE a.alert_type = 'Contamination'
GROUP BY ws.source_id, ws.name
ORDER BY contamination_count DESC
LIMIT 3;

-- Find the percentage of active vs. inactive sensors in the system.
SELECT 
  (SUM(CASE WHEN status = 'Operational' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS active_percentage,
  (SUM(CASE WHEN status != 'Operational' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS inactive_percentage
FROM sensors;

-- Retrieve the users who haven't logged any water usage in the last 3 months.
SELECT u.user_id, u.name
FROM users u
LEFT JOIN water_usage wu ON u.user_id = wu.user_id 
AND wu.date >= DATE('now', '-3 months')
WHERE wu.usage_id IS NULL;
