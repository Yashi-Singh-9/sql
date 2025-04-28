-- Project in Maria Database 
CREATE DATABASE AlcoholConsumptionDB;
USE AlcoholConsumptionDB;

-- Locations Table 
CREATE TABLE locations (
  location_id INT PRIMARY KEY AUTO_INCREMENT,
  city VARCHAR(50),
  country VARCHAR(50)
);

-- Users Table  
CREATE TABLE users (
  user_id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50),
  age INT,
  gender ENUM('Male', 'Female', 'Others'),
  location_id INT,
  FOREIGN KEY (location_id) REFERENCES locations(location_id)
);  

-- Alcohol Types Table 
CREATE TABLE alcohol_types (
  alcohol_id INT PRIMARY KEY AUTO_INCREMENT,
  alcohol_name VARCHAR(50),
  category ENUM('Beer', 'Wine', 'Whiskey')
);

-- Consumption Records Table
CREATE TABLE consumption_records (
  record_id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT,
  alcohol_id INT,
  quantity_ml DECIMAL(5,2),
  date_time DATETIME,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (alcohol_id) REFERENCES alcohol_types(alcohol_id)
);

-- Health Impacts Table 
CREATE TABLE health_impacts (
  impact_id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT,
  description TEXT,
  severity ENUM('Mild', 'Moderate', 'Severe'),
  date_reported DATE,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Insert sample locations
INSERT INTO locations (city, country) VALUES 
('New York', 'USA'),
('Los Angeles', 'USA'),
('London', 'UK'),
('Berlin', 'Germany'),
('Tokyo', 'Japan'),
('Paris', 'France');

-- Insert sample users with repeated location_id
INSERT INTO users (name, age, gender, location_id) VALUES 
('Alice Johnson', 25, 'Female', 1),
('Bob Smith', 30, 'Male', 2),
('Charlie Brown', 28, 'Male', 3),
('Diana Prince', 32, 'Female', 1),
('Ethan Hunt', 27, 'Male', 2),
('Fiona Davis', 29, 'Female', 3);

-- Insert sample alcohol types
INSERT INTO alcohol_types (alcohol_name, category) VALUES 
('Budweiser', 'Beer'),
('Heineken', 'Beer'),
('Chardonnay', 'Wine'),
('Merlot', 'Wine'),
('Jack Daniels', 'Whiskey'),
('Jameson', 'Whiskey');

-- Insert sample consumption records with repeated user_id and alcohol_id
INSERT INTO consumption_records (user_id, alcohol_id, quantity_ml, date_time) VALUES 
(1, 1, 500.00, '2024-02-15 18:30:00'),
(2, 3, 250.00, '2024-02-16 20:00:00'),
(3, 5, 60.00, '2024-02-17 22:15:00'),
(1, 2, 330.00, '2024-02-18 19:45:00'),
(2, 4, 200.00, '2024-02-19 21:10:00'),
(3, 6, 90.00, '2024-02-20 23:00:00');

-- Insert sample health impacts with repeated user_id
INSERT INTO health_impacts (user_id, description, severity, date_reported) VALUES 
(1, 'Mild headache after drinking beer', 'Mild', '2024-02-16'),
(2, 'Dehydration due to alcohol', 'Moderate', '2024-02-17'),
(3, 'Severe hangover symptoms', 'Severe', '2024-02-18'),
(1, 'Stomach ache after whiskey', 'Mild', '2024-02-19'),
(2, 'Dizziness after wine', 'Moderate', '2024-02-20'),
(3, 'Fatigue and nausea', 'Severe', '2024-02-21');

-- Retrieve the total alcohol consumption (in mL) per user.
SELECT u.user_id, u.name, SUM(c.quantity_ml) AS total_consumption_ml
FROM users u
JOIN consumption_records c ON u.user_id = c.user_id
GROUP BY u.user_id, u.name
ORDER BY total_consumption_ml DESC;

-- Find the top 2 users who consumed the most alcohol.
SELECT u.user_id, u.name, SUM(c.quantity_ml) AS total_consumption_ml
FROM users u
JOIN consumption_records c ON u.user_id = c.user_id
GROUP BY u.user_id, u.name
ORDER BY total_consumption_ml DESC
LIMIT 2;

-- List the most consumed alcohol type per country.
SELECT l.country, a.alcohol_name, SUM(c.quantity_ml) AS total_consumed
FROM consumption_records c
JOIN users u ON c.user_id = u.user_id
JOIN locations l ON u.location_id = l.location_id
JOIN alcohol_types a ON c.alcohol_id = a.alcohol_id
GROUP BY l.country, a.alcohol_name
ORDER BY l.country, total_consumed DESC;

-- Determine the average alcohol consumption per age group.
SELECT 
  CASE 
    WHEN age BETWEEN 18 AND 24 THEN '18-24'
    WHEN age BETWEEN 25 AND 34 THEN '25-34'
    WHEN age BETWEEN 35 AND 44 THEN '35-44'
    ELSE '45+'
  END AS age_group,
  AVG(c.quantity_ml) AS avg_consumption_ml
FROM users u
JOIN consumption_records c ON u.user_id = c.user_id
GROUP BY age_group
ORDER BY age_group;

-- Identify users who reported severe health impacts.
SELECT DISTINCT u.user_id, u.name, h.description, h.date_reported
FROM users u
JOIN health_impacts h ON u.user_id = h.user_id
WHERE h.severity = 'Severe'
ORDER BY h.date_reported DESC;

-- List locations with the highest average alcohol consumption per user.
SELECT l.city, l.country, AVG(c.quantity_ml) AS avg_consumption_per_user
FROM locations l
JOIN users u ON l.location_id = u.location_id
JOIN consumption_records c ON u.user_id = c.user_id
GROUP BY l.city, l.country
ORDER BY avg_consumption_per_user DESC;

-- Find correlations between alcohol consumption and reported health impacts.
SELECT u.user_id, u.name, SUM(c.quantity_ml) AS total_consumption_ml, COUNT(h.impact_id) AS health_issues
FROM users u
LEFT JOIN consumption_records c ON u.user_id = c.user_id
LEFT JOIN health_impacts h ON u.user_id = h.user_id
GROUP BY u.user_id, u.name
ORDER BY health_issues DESC, total_consumption_ml DESC;

-- Identify which gender consumes more alcohol on average.
SELECT u.gender, AVG(c.quantity_ml) AS avg_consumption_ml
FROM users u
JOIN consumption_records c ON u.user_id = c.user_id
GROUP BY u.gender
ORDER BY avg_consumption_ml DESC;

-- Find the most popular alcohol type overall
SELECT a.alcohol_name, a.category, SUM(c.quantity_ml) AS total_consumed
FROM alcohol_types a
JOIN consumption_records c ON a.alcohol_id = c.alcohol_id
GROUP BY a.alcohol_name, a.category
ORDER BY total_consumed DESC
LIMIT 1;

-- Find users who consume only one type of alcohol
SELECT u.user_id, u.name, COUNT(DISTINCT a.category) AS alcohol_varieties
FROM users u
JOIN consumption_records c ON u.user_id = c.user_id
JOIN alcohol_types a ON c.alcohol_id = a.alcohol_id
GROUP BY u.user_id, u.name
HAVING alcohol_varieties = 1;

-- Find the day of the week with the highest alcohol consumption
SELECT DAYNAME(date_time) AS day_of_week, SUM(quantity_ml) AS total_consumed
FROM consumption_records
GROUP BY day_of_week
ORDER BY total_consumed DESC
LIMIT 1;

-- Find the peak drinking hours
SELECT HOUR(date_time) AS hour_of_day, SUM(quantity_ml) AS total_consumed
FROM consumption_records
GROUP BY hour_of_day
ORDER BY total_consumed DESC
LIMIT 1;

-- Find the oldest drinkers
SELECT name, age FROM users
ORDER BY age DESC
LIMIT 1;

-- Find the youngest drinkers
SELECT name, age FROM users
ORDER BY age ASC
LIMIT 1;

-- Find the top 3 users who drink the most whiskey
SELECT u.user_id, u.name, SUM(c.quantity_ml) AS total_whiskey_consumed
FROM users u
JOIN consumption_records c ON u.user_id = c.user_id
JOIN alcohol_types a ON c.alcohol_id = a.alcohol_id
WHERE a.category = 'Whiskey'
GROUP BY u.user_id, u.name
ORDER BY total_whiskey_consumed DESC
LIMIT 3;