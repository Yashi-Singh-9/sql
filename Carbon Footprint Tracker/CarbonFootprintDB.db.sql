sqlite3 CarbonFootprintDB.db

-- Users Table  
CREATE Table users (
  user_id INT PRIMARY KEY,
  name VARCHAR(20),
  email VARCHAR(20) UNIQUE,
  password TEXT,
  location VARCHAR(50),
  created_at DATETIME
);

-- Activities Table  
CREATE TABLE activities (
  activity_id INT PRIMARY KEY,
  user_id INT,
  activity_type VARCHAR(20) CHECK (activity_type IN ('Transport', 'Energy', 'Diet', 'Waste', 'Water Usage', 'Shopping', 'Other')),
  carbon_emission DECIMAL(10,2),
  date DATE,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Transport Table  
CREATE TABLE transport (
  transport_id INT PRIMARY KEY,
  user_id INT,
  modes VARCHAR(20) CHECK (modes IN ('Bus', 'Car', 'Bike', 'Cab', 'Metro')),
  distance_km DECIMAL(10,2),
  carbon_emission DECIMAL(10,2),
  date DATE,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Energy Usage Table 
CREATE TABLE energy_usages (
  energy_id INT PRIMARY KEY,
  user_id INT,
  energy_type VARCHAR(15) CHECK (energy_type IN ('Electricity', 'Gas', 'Solar', 'Other')),
  consumption_kwh DECIMAL(10,2),
  carbon_emission DECIMAL(10,2),
  date DATE,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Diet Table  
CREATE TABLE diet (
  diet_id INT PRIMARY KEY,
  user_id INT,
  diet_type VARCHAR(15) CHECK (diet_type IN ('Vegan', 'Vegetarian', 'Meat-heavy', 'Pescatarian', 'Other')),
  carbon_emission DECIMAL(10,2),
  date DATE,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Offset Actions Table 
CREATE TABLE offset_actions (
  offset_id INT PRIMARY KEY,
  user_id INT, 
  action_type VARCHAR(20) CHECK (action_type IN ('Tree Planting', 'Renewable Energy Use', 'Carbon Credits', 'Recycling Initiatives', 'Other')),
  carbon_offset DECIMAL(10,2),
  date DATE,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

INSERT INTO users (user_id, name, email, password, location, created_at) VALUES
(1, 'Alice Johnson', 'alice@example.com', 'password123', 'New York', '2025-01-01 09:00:00'),
(2, 'Bob Smith', 'bob@example.com', 'password456', 'Los Angeles', '2025-01-05 14:00:00'),
(3, 'Charlie Davis', 'charlie@example.com', 'password789', 'Chicago', '2025-01-08 11:00:00'),
(4, 'David Brown', 'david@example.com', 'password000', 'San Francisco', '2025-01-10 15:00:00'),
(5, 'Emma Wilson', 'emma@example.com', 'password111', 'Houston', '2025-01-12 17:00:00'),
(6, 'Frank Miller', 'frank@example.com', 'password222', 'Seattle', '2025-01-14 10:00:00'),
(7, 'Grace Lee', 'grace@example.com', 'password333', 'Austin', '2025-01-17 12:00:00'),
(8, 'Hank Moore', 'hank@example.com', 'password444', 'Denver', '2025-01-19 08:00:00');

INSERT INTO activities (activity_id, user_id, activity_type, carbon_emission, date) VALUES
(1, 1, 'Transport', 15.50, '2025-02-01'),
(2, 1, 'Energy', 10.30, '2025-02-02'),
(3, 2, 'Diet', 8.20, '2025-02-03'),
(4, 3, 'Waste', 2.50, '2025-02-04'),
(5, 3, 'Energy', 6.00, '2025-02-05'),
(6, 4, 'Transport', 25.00, '2025-02-06'),
(7, 4, 'Water Usage', 3.40, '2025-02-07'),
(8, 5, 'Diet', 12.60, '2025-02-08');

INSERT INTO transport (transport_id, user_id, modes, distance_km, carbon_emission, date) VALUES
(1, 1, 'Bus', 15.00, 5.50, '2025-02-01'),
(2, 1, 'Car', 20.00, 10.00, '2025-02-02'),
(3, 2, 'Bike', 5.00, 1.00, '2025-02-03'),
(4, 3, 'Cab', 10.00, 8.00, '2025-02-04'),
(5, 4, 'Metro', 25.00, 5.00, '2025-02-06'),
(6, 5, 'Car', 30.00, 15.00, '2025-02-08'),
(7, 6, 'Bus', 20.00, 7.00, '2025-02-10'),
(8, 7, 'Bike', 12.00, 2.50, '2025-02-12');

INSERT INTO energy_usages (energy_id, user_id, energy_type, consumption_kwh, carbon_emission, date) VALUES
(1, 1, 'Electricity', 120.00, 10.00, '2025-02-01'),
(2, 2, 'Gas', 100.00, 8.00, '2025-02-02'),
(3, 3, 'Electricity', 150.00, 12.00, '2025-02-03'),
(4, 4, 'Gas', 130.00, 10.40, '2025-02-04'),
(5, 5, 'Solar', 50.00, 0.00, '2025-02-05'),
(6, 6, 'Electricity', 140.00, 11.00, '2025-02-06'),
(7, 7, 'Gas', 90.00, 7.20, '2025-02-07'),
(8, 8, 'Solar', 60.00, 0.00, '2025-02-08');

INSERT INTO diet (diet_id, user_id, diet_type, carbon_emission, date) VALUES
(1, 1, 'Vegetarian', 6.00, '2025-02-01'),
(2, 2, 'Meat-heavy', 12.00, '2025-02-02'),
(3, 3, 'Vegan', 3.00, '2025-02-03'),
(4, 4, 'Pescatarian', 8.50, '2025-02-04'),
(5, 5, 'Vegetarian', 7.00, '2025-02-05'),
(6, 6, 'Meat-heavy', 10.00, '2025-02-06'),
(7, 7, 'Vegan', 2.00, '2025-02-07'),
(8, 8, 'Pescatarian', 9.00, '2025-02-08');

INSERT INTO offset_actions (offset_id, user_id, action_type, carbon_offset, date) VALUES
(1, 1, 'Tree Planting', 5.00, '2025-02-01'),
(2, 2, 'Carbon Credits', 8.00, '2025-02-02'),
(3, 3, 'Recycling Initiatives', 2.00, '2025-02-03'),
(4, 4, 'Renewable Energy Use', 6.00, '2025-02-04'),
(5, 5, 'Tree Planting', 4.00, '2025-02-05'),
(6, 6, 'Carbon Credits', 7.00, '2025-02-06'),
(7, 7, 'Recycling Initiatives', 3.00, '2025-02-07'),
(8, 8, 'Renewable Energy Use', 5.00, '2025-02-08');

-- Find the total carbon footprint of a user for the last month.
SELECT user_id, SUM(carbon_emission) AS total_carbon_footprint
FROM activities
WHERE date >= DATE('now', '-1 month')
GROUP BY user_id;

-- Get the top 5 users with the highest carbon footprint.
SELECT user_id, SUM(carbon_emission) AS total_carbon_footprint
FROM activities
GROUP BY user_id
ORDER BY total_carbon_footprint DESC
LIMIT 5;

-- Find the most common mode of transport used by users.
SELECT modes, COUNT(*) AS usage_count
FROM transport
GROUP BY modes
ORDER BY usage_count DESC
LIMIT 1;

-- Retrieve the monthly average carbon footprint from energy consumption.
SELECT strftime('%Y-%m', date) AS month, 
       AVG(carbon_emission) AS avg_monthly_energy_footprint
FROM energy_usages
GROUP BY month
ORDER BY month DESC;

-- Identify users who have reduced their carbon footprint over the last 3 months.
WITH monthly_emissions AS (
    SELECT user_id, 
           strftime('%Y-%m', date) AS month, 
           SUM(carbon_emission) AS total_emission
    FROM activities
    WHERE date >= DATE('now', '-3 months')
    GROUP BY user_id, month
)
SELECT user_id
FROM monthly_emissions
GROUP BY user_id
HAVING COUNT(DISTINCT month) = 3 
AND MAX(total_emission) < MIN(total_emission);

-- Find the total carbon offset achieved by each user.
SELECT user_id, SUM(carbon_offset) AS total_carbon_offset
FROM offset_actions
GROUP BY user_id;

-- List users who have not logged any activities in the last 30 days.
SELECT u.user_id, u.name
FROM users u
LEFT JOIN activities a ON u.user_id = a.user_id 
    AND a.date >= DATE('now', '-30 days')
WHERE a.user_id IS NULL;

-- Compare the average carbon footprint of different diet types.
SELECT diet_type, AVG(carbon_emission) AS avg_carbon_footprint
FROM diet
GROUP BY diet_type
ORDER BY avg_carbon_footprint DESC;

-- Find the total emissions from transport for each mode (e.g., car, bike, etc.).
SELECT modes, SUM(carbon_emission) AS total_emissions
FROM transport
GROUP BY modes
ORDER BY total_emissions DESC;

-- Identify users who have the highest emissions but have not taken any offset actions.
SELECT a.user_id, SUM(a.carbon_emission) AS total_emission
FROM activities a
LEFT JOIN offset_actions o ON a.user_id = o.user_id
WHERE o.user_id IS NULL
GROUP BY a.user_id
ORDER BY total_emission DESC;