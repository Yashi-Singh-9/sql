-- MS SQL Project
CREATE DATABASE WasteManagementDB;
USE WasteManagementDB;

-- Users Table  
CREATE TABLE users (
  user_id INT IDENTITY(1,1) PRIMARY KEY,
  name VARCHAR(20),
  email VARCHAR(50) UNIQUE,
  phone BIGINT,
  address TEXT,
  user_type VARCHAR(10) CHECK (user_type IN ('Admin', 'Collector', 'Resident'))
);

-- Waste Categories Table 
CREATE TABLE waste_categories (
  category_id INT IDENTITY(1,1) PRIMARY KEY,
  category_name VARCHAR(20) UNIQUE,
  description TEXT
);

-- Waste Collection Request Table 
CREATE TABLE waste_collection_request (
  request_id INT IDENTITY(1,1) PRIMARY KEY,
  user_id INT,
  category_id INT,
  status VARCHAR(10) CHECK (status IN ('Pending', 'Collected', 'Rejected')),
  request_date DATETIME,
  collection_date DATETIME,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (category_id) REFERENCES waste_categories(category_id)
);

-- Collection Centers Table 
CREATE TABLE collection_centers (
  center_id INT IDENTITY(1,1) PRIMARY KEY,
  center_name VARCHAR(10),
  location TEXT
);

-- Waste Collection Table 
CREATE TABLE waste_collection (
  collection_id INT IDENTITY(1,1) PRIMARY KEY,
  collector_id INT,
  center_id INT,
  request_id INT,
  waste_weight DECIMAL(10,2),
  collection_date DATETIME,
  FOREIGN KEY (collector_id) REFERENCES users(user_id),
  FOREIGN KEY (center_id) REFERENCES collection_centers(center_id),
  FOREIGN KEY (request_id) REFERENCES waste_collection_request(request_id)
);

-- Recycling Centers Table
CREATE TABLE recycling_centers (
  recycle_center_id INT IDENTITY(1,1) PRIMARY KEY,
  center_name VARCHAR(20),
  location TEXT
);

-- Recycled Waste Table 
CREATE TABLE recycled_waste (
  recycle_id INT IDENTITY(1,1) PRIMARY KEY,
  waste_id INT,
  recycle_center_id INT,
  recycled_weight DECIMAL(10,2),
  recycle_date DATETIME,
  FOREIGN KEY (waste_id) REFERENCES waste_collection(collection_id),
  FOREIGN KEY (recycle_center_id) REFERENCES recycling_centers(recycle_center_id)
);

-- Fines Table 
CREATE TABLE fines (
  fine_id INT IDENTITY(1,1) PRIMARY KEY,
  user_id INT,
  reason TEXT,
  amount DECIMAL(10,2),
  status VARCHAR(8) CHECK (status IN ('Unpaid', 'Paid')),
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Insert into users
INSERT INTO users (name, email, phone, address, user_type) VALUES
('Alice Johnson', 'alice@email.com', 9876543210, '123 Green Street', 'Resident'),
('Bob Smith', 'bob@email.com', 9876543211, '456 Blue Avenue', 'Collector'),
('Charlie Brown', 'charlie@email.com', 9876543212, '789 Red Lane', 'Resident'),
('Diana Prince', 'diana@email.com', 9876543213, '321 Yellow Road', 'Collector'),
('Edward Stark', 'edward@email.com', 9876543214, '654 White Blvd', 'Resident'),
('Fiona Adams', 'fiona@email.com', 9876543215, '987 Orange Path', 'Admin'),
('George Clark', 'george@email.com', 9876543216, '741 Black Drive', 'Resident'),
('Helen Miller', 'helen@email.com', 9876543217, '852 Silver Lane', 'Collector');

-- Insert into waste_categories
INSERT INTO waste_categories (category_name, description) VALUES
('Plastic', 'Plastic waste materials'),
('Organic', 'Food and garden waste'),
('Metal', 'Metal scraps and items'),
('Paper', 'Paper and cardboard waste'),
('Glass', 'Glass bottles and fragments'),
('E-Waste', 'Electronic waste materials'),
('Textiles', 'Fabric and clothing waste'),
('Medical', 'Medical and hazardous waste');

-- Insert into waste_collection_request
INSERT INTO waste_collection_request (user_id, category_id, status, request_date, collection_date) VALUES
(1, 2, 'Pending', '2025-02-01 10:00:00', NULL),
(3, 5, 'Collected', '2025-02-02 12:00:00', '2025-02-03 14:00:00'),
(5, 1, 'Rejected', '2025-02-04 08:00:00', NULL),
(7, 3, 'Pending', '2025-02-05 15:30:00', NULL),
(1, 4, 'Collected', '2025-02-06 09:00:00', '2025-02-07 11:00:00'),
(3, 6, 'Pending', '2025-02-07 13:20:00', NULL),
(5, 7, 'Collected', '2025-02-08 16:45:00', '2025-02-09 10:30:00'),
(7, 8, 'Rejected', '2025-02-09 18:00:00', NULL);

-- Insert into collection_centers
INSERT INTO collection_centers (center_name, location) VALUES
('Center A', 'Downtown'),
('Center B', 'Uptown'),
('Center C', 'Midtown'),
('Center D', 'Suburbs'),
('Center E', 'Industrial Area'),
('Center F', 'Harbor Side'),
('Center G', 'Tech Park'),
('Center H', 'Rural Zone');

-- Insert into waste_collection
INSERT INTO waste_collection (collector_id, center_id, request_id, waste_weight, collection_date) VALUES
(2, 1, 2, 15.5, '2025-02-03 14:30:00'),
(4, 3, 5, 10.2, '2025-02-07 11:45:00'),
(8, 5, 7, 20.0, '2025-02-09 10:45:00'),
(2, 2, 2, 12.8, '2025-02-03 15:00:00'),
(4, 4, 5, 9.7, '2025-02-07 12:30:00'),
(8, 6, 7, 18.5, '2025-02-09 11:00:00'),
(2, 7, 2, 14.3, '2025-02-03 16:00:00'),
(4, 8, 5, 11.9, '2025-02-07 13:00:00');

-- Insert into recycling_centers
INSERT INTO recycling_centers (center_name, location) VALUES
('Recycle A', 'West End'),
('Recycle B', 'East End'),
('Recycle C', 'North Side'),
('Recycle D', 'South Side'),
('Recycle E', 'Green Zone'),
('Recycle F', 'Industrial Park'),
('Recycle G', 'Urban Core'),
('Recycle H', 'Rural Outskirts');

-- Insert into recycled_waste
INSERT INTO recycled_waste (waste_id, recycle_center_id, recycled_weight, recycle_date) VALUES
(1, 1, 14.0, '2025-02-04 09:00:00'),
(2, 3, 9.5, '2025-02-08 10:30:00'),
(3, 5, 18.3, '2025-02-10 14:00:00'),
(4, 7, 10.0, '2025-02-12 12:00:00'),
(5, 2, 15.2, '2025-02-15 08:30:00'),
(6, 4, 12.7, '2025-02-18 16:45:00'),
(7, 6, 19.8, '2025-02-20 11:00:00'),
(8, 8, 13.4, '2025-02-22 14:30:00');

-- Insert into fines
INSERT INTO fines (user_id, reason, amount, status) VALUES
(1, 'Unauthorized dumping', 50.00, 'Unpaid'),
(3, 'Missed collection', 25.00, 'Paid'),
(5, 'Illegal waste disposal', 75.00, 'Unpaid'),
(7, 'Late payment', 30.00, 'Paid'),
(1, 'Exceeding waste limit', 40.00, 'Unpaid'),
(3, 'Non-compliance with sorting', 35.00, 'Paid'),
(5, 'Hazardous waste violation', 80.00, 'Unpaid'),
(7, 'Unapproved waste disposal', 60.00, 'Paid');

-- Retrieve all pending waste collection requests with user details.
SELECT wcr.request_id, u.name, u.email, u.phone, u.address, wcr.request_date
FROM waste_collection_request wcr
JOIN users u ON wcr.user_id = u.user_id
WHERE wcr.status = 'Pending';

-- Get the total amount of waste collected in a specific month.
SELECT MONTH(collection_date) AS month, YEAR(collection_date) AS year, SUM(waste_weight) AS total_waste
FROM waste_collection
WHERE MONTH(collection_date) = 02 AND YEAR(collection_date) = 2025
GROUP BY MONTH(collection_date), YEAR(collection_date);

-- Find the top 3 users who requested waste collection most frequently.
SELECT TOP 3 u.user_id, u.name, COUNT(wcr.request_id) AS request_count
FROM waste_collection_request wcr
JOIN users u ON wcr.user_id = u.user_id
GROUP BY u.user_id, u.name
ORDER BY request_count DESC;

-- List all waste categories and the total waste collected for each.
SELECT wc.category_id, wc.category_name, SUM(wc2.waste_weight) AS total_collected
FROM waste_categories wc
LEFT JOIN waste_collection_request wcr ON wc.category_id = wcr.category_id
LEFT JOIN waste_collection wc2 ON wcr.request_id = wc2.request_id
GROUP BY wc.category_id, wc.category_name;

-- Retrieve the details of users who have unpaid fines.
SELECT u.user_id, u.name, u.email, u.phone, f.amount, f.reason
FROM fines f
JOIN users u ON f.user_id = u.user_id
WHERE f.status = 'Unpaid';

-- Find the collection center that has received the most waste.
SELECT TOP 1 cc.center_id, cc.center_name, SUM(wc.waste_weight) AS total_waste_received
FROM collection_centers cc
JOIN waste_collection wc ON cc.center_id = wc.center_id
GROUP BY cc.center_id, cc.center_name
ORDER BY total_waste_received DESC;

-- Get the list of collectors who have completed the most collections.
SELECT u.user_id, u.name, COUNT(wc.collection_id) AS collections_completed
FROM users u
JOIN waste_collection wc ON u.user_id = wc.collector_id
GROUP BY u.user_id, u.name
ORDER BY collections_completed DESC;

-- Find all waste collection requests that have not been collected within 7 days.
SELECT request_id, user_id, category_id, request_date, status
FROM waste_collection_request
WHERE status = 'Pending' AND DATEDIFF(DAY, request_date, GETDATE()) > 7;

-- Retrieve the total weight of waste recycled per month.
SELECT MONTH(recycle_date) AS month, YEAR(recycle_date) AS year, SUM(recycled_weight) AS total_recycled
FROM recycled_waste
GROUP BY MONTH(recycle_date), YEAR(recycle_date)
ORDER BY year, month;

-- Find the user who has paid the highest amount in fines.
SELECT TOP 1 u.user_id, u.name, SUM(f.amount) AS total_paid
FROM fines f
JOIN users u ON f.user_id = u.user_id
WHERE f.status = 'Paid'
GROUP BY u.user_id, u.name
ORDER BY total_paid DESC;
