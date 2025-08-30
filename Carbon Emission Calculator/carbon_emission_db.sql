-- MS SQL Project
CREATE TABLE carbon_emission_db;

-- Users Table 
CREATE TABLE users (
  user_id INT IDENTITY(1,1) PRIMARY KEY,
  name VARCHAR(20),
  email VARCHAR(20),
  location text
); 

-- Emission Sources Table 
CREATE TABLE emission_sources (
  source_id INT IDENTITY(1,1) PRIMARY KEY,
  source_name VARCHAR(20) CHECK (source_name IN ('Electricity', 'Transport', 'Industry')),
  category VARCHAR(20) CHECK (category IN ('Fuel', 'Energy', 'Waste'))
);

-- Emission Factors Table 
CREATE TABLE emission_factors (
  factor_id INT IDENTITY(1,1) PRIMARY KEY,
  source_id INT,
  unit VARCHAR(50),
  co2_emission_per_unit DECIMAL(10,6),
  FOREIGN KEY (source_id) REFERENCES emission_sources(source_id)
);

-- User Activities Table 
CREATE TABLE user_activities (
  activity_id INT IDENTITY(1,1) PRIMARY KEY,
  user_id INT,
  source_id INT,
  quantity DECIMAL(10,2),
  date_logged DATETIME,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (source_id) REFERENCES emission_sources(source_id)
);

-- Emissions Calculations Table 
CREATE TABLE emission_calculations (
  calculation_id INT IDENTITY(1,1) PRIMARY KEY,
  activity_id INT,
  calculated_emission DECIMAL(12,6),
  calculation_date DATETIME,
  FOREIGN KEY (activity_id) REFERENCES user_activities(activity_id)
);

-- Transport Emission Table 
CREATE TABLE transport_emission (
  transport_id INT IDENTITY(1,1) PRIMARY KEY,
  user_id INT,
  vehicle_type VARCHAR(10) CHECK (vehicle_type IN ('Car', 'Bus', 'Bike')),
  distance_traveled DECIMAL(10,2),
  fuel_type VARCHAR(50),
  co2_emission DECIMAL(12,6),
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Energy Consumption Table 
CREATE TABLE energu_consumption (
  energy_id INT IDENTITY(1,1) PRIMARY KEY,
  user_id INT,
  source_id INT,
  energy_used DECIMAL(12,2),
  co2_emission DECIMAL(12,6),
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (source_id) REFERENCES emission_sources(source_id)
);

-- Users Table
INSERT INTO users (name, email, location) VALUES
('Alice', 'alice@example.com', 'New York'),
('Bob', 'bob@example.com', 'London'),
('Charlie', 'charlie@example.com', 'Tokyo'),
('David', 'david@example.com', 'Sydney'),
('Eve', 'eve@example.com', 'Berlin');

-- Emission Sources Table
INSERT INTO emission_sources (source_name, category) VALUES
('Electricity', 'Energy'),
('Transport', 'Fuel'),
('Industry', 'Waste');

-- Emission Factors Table
INSERT INTO emission_factors (source_id, unit, co2_emission_per_unit) VALUES
(1, 'kWh', 0.233),
(2, 'Liter of Gasoline', 2.31),
(3, 'Ton of Waste', 1.55);

-- User Activities Table
INSERT INTO user_activities (user_id, source_id, quantity, date_logged) VALUES
(1, 1, 100.5, '2024-02-01 10:00:00'),
(2, 2, 50.3, '2024-02-02 11:30:00'),
(3, 3, 75.8, '2024-02-03 09:15:00'),
(4, 1, 120.0, '2024-02-04 14:20:00'),
(5, 2, 60.2, '2024-02-05 16:45:00');

-- Emissions Calculations Table
INSERT INTO emission_calculations (activity_id, calculated_emission, calculation_date) VALUES
(1, 23.41, '2024-02-01 12:00:00'),
(2, 116.19, '2024-02-02 13:30:00'),
(3, 117.49, '2024-02-03 10:15:00'),
(4, 27.96, '2024-02-04 15:20:00'),
(5, 138.06, '2024-02-05 17:45:00');

-- Transport Emission Table
INSERT INTO transport_emission (user_id, vehicle_type, distance_traveled, fuel_type, co2_emission) VALUES
(1, 'Car', 200.5, 'Gasoline', 462.16),
(2, 'Bus', 150.0, 'Diesel', 345.78),
(3, 'Bike', 50.0, 'Electric', 0.0),
(4, 'Car', 180.2, 'Gasoline', 414.66),
(5, 'Bus', 120.5, 'Diesel', 277.15);

-- Energy Consumption Table
INSERT INTO energu_consumption (user_id, source_id, energy_used, co2_emission) VALUES
(1, 1, 500.0, 116.5),
(2, 1, 600.0, 139.8),
(3, 2, 450.5, 103.5),
(4, 3, 700.2, 162.54),
(5, 1, 550.0, 127.95);

-- Find the total emissions of a specific user in a given month.
SELECT user_id, SUM(calculated_emission) AS total_emission
FROM emission_calculations ec
JOIN user_activities ua ON ec.activity_id = ua.activity_id
WHERE user_id = 1 AND MONTH(calculation_date) = 2 AND YEAR(calculation_date) = 2024
GROUP BY user_id;

-- Retrieve the top 2 emission sources contributing to total emissions.
SELECT TOP 2 es.source_name, SUM(ec.calculated_emission) AS total_emission
FROM emission_calculations ec
JOIN user_activities ua ON ec.activity_id = ua.activity_id
JOIN emission_sources es ON ua.source_id = es.source_id
GROUP BY es.source_name
ORDER BY total_emission DESC;

-- List all users who have an average monthly emission above a given threshold.
SELECT user_id, AVG(total_emission) AS avg_monthly_emission
FROM (
    SELECT user_id, SUM(calculated_emission) AS total_emission, 
           MONTH(calculation_date) AS month, YEAR(calculation_date) AS year
    FROM emission_calculations ec
    JOIN user_activities ua ON ec.activity_id = ua.activity_id
    GROUP BY user_id, YEAR(calculation_date), MONTH(calculation_date)
) AS monthly_emissions
GROUP BY user_id
HAVING AVG(total_emission) > 30;

-- Find the user with the highest transportation-related emissions.
SELECT TOP 1 user_id, SUM(co2_emission) AS total_transport_emission
FROM transport_emission
GROUP BY user_id
ORDER BY total_transport_emission DESC;

-- Calculate total emissions for each emission category (Transport, Energy, etc.).
SELECT es.category, SUM(ec.calculated_emission) AS total_emission
FROM emission_calculations ec
JOIN user_activities ua ON ec.activity_id = ua.activity_id
JOIN emission_sources es ON ua.source_id = es.source_id
GROUP BY es.category;

-- Find the emissions per unit for each source and sort them in descending order.
SELECT es.source_name, ef.unit, ef.co2_emission_per_unit
FROM emission_factors ef
JOIN emission_sources es ON ef.source_id = es.source_id
ORDER BY ef.co2_emission_per_unit DESC;

-- List all activities that exceed a certain CO2 emission threshold.
SELECT ua.*
FROM user_activities ua
JOIN emission_calculations ec ON ua.activity_id = ec.activity_id
WHERE ec.calculated_emission > 40;

-- Get the total emissions for all users grouped by month and year.
SELECT YEAR(calculation_date) AS year, MONTH(calculation_date) AS month, SUM(calculated_emission) AS total_emission
FROM emission_calculations
GROUP BY YEAR(calculation_date), MONTH(calculation_date)
ORDER BY year DESC, month DESC;

-- Find the most common emission source logged by users.
SELECT TOP 1 es.source_name, COUNT(*) AS count
FROM user_activities ua
JOIN emission_sources es ON ua.source_id = es.source_id
GROUP BY es.source_name
ORDER BY count DESC;

-- Compare emissions from electricity usage vs. fuel usage for each user.
SELECT ua.user_id,
    SUM(CASE WHEN es.category = 'Energy' THEN ec.calculated_emission ELSE 0 END) AS electricity_emission,
    SUM(CASE WHEN es.category = 'Fuel' THEN ec.calculated_emission ELSE 0 END) AS fuel_emission
FROM user_activities ua
JOIN emission_calculations ec ON ua.activity_id = ec.activity_id
JOIN emission_sources es ON ua.source_id = es.source_id
GROUP BY ua.user_id;
