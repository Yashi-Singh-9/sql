-- MS SQL Project
CREATE DATABASE FleetManagementDB;
USE FleetManagementDB;

-- Vehicles Table 
CREATE TABLE vehicles (
  vehicle_id INT IDENTITY(1,1) PRIMARY KEY,
  registration_number VARCHAR(20) UNIQUE,
  make VARCHAR(50),
  model VARCHAR(50),
  year INT,
  capacity INT,
  status VARCHAR(20) CHECK (status IN ('Active', 'Inactive', 'Under Maintenance'))
);

-- Drivers Table 
CREATE TABLE drivers (
  driver_id INT IDENTITY(1,1) PRIMARY KEY,
  name VARCHAR(50),
  license_number VARCHAR(50) UNIQUE,
  contact BIGINT,
  assigned_vehicle_id INT NULL,
  FOREIGN KEY (assigned_vehicle_id) REFERENCES vehicles(vehicle_id)
);

-- Trips Table 
Create Table trips ( 
  trip_id INT IDENTITY(1,1) PRIMARY KEY,
  vehicle_id INT,
  driver_id INT,
  start_location VARCHAR(100),
  end_location VARCHAR(100),
  start_time DATETIME,
  end_time DATETIME NULL,
  status VARCHAR(15) CHECK (status IN ('Ongoing', 'Completed', 'Cancelled')),
  FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id),
  FOREIGN KEY (driver_id) REFERENCES drivers(driver_id)
);

-- Maintenance Table 
CREATE TABLE maintenance (
  maintenance_id INT IDENTITY(1,1) PRIMARY KEY,
  vehicle_id INT,
  maintenance_date DATE,
  description TEXT,
  cost DECIMAL(10,2),
  FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id)
);

-- Fuel Logs
CREATE TABLE fuel_logs (
  fuel_log_id INT IDENTITY(1,1) PRIMARY KEY,
  vehicle_id INT,
  date DATE,
  fuel_amount DECIMAL(5,2),
  cost DECIMAL(10,2),
  odometer_reading INT,
  FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id)
);

-- Insert sample data into Vehicles Table
INSERT INTO vehicles (registration_number, make, model, year, capacity, status) VALUES
('ABC123', 'Toyota', 'Hilux', 2020, 5, 'Active'),
('XYZ789', 'Ford', 'Transit', 2018, 12, 'Under Maintenance'),
('LMN456', 'Mercedes', 'Sprinter', 2019, 15, 'Active'),
('JKL321', 'Nissan', 'Navara', 2021, 5, 'Inactive'),
('QRS654', 'Isuzu', 'D-Max', 2022, 3, 'Active'),
('DEF987', 'Chevrolet', 'Silverado', 2017, 6, 'Active'),
('TUV159', 'Honda', 'Ridgeline', 2019, 5, 'Under Maintenance');

-- Insert sample data into Drivers Table
INSERT INTO drivers (name, license_number, contact, assigned_vehicle_id) VALUES
('John Doe', 'DL123456', 9876543210, 1),
('Jane Smith', 'DL789012', 8765432109, 3),
('Mike Johnson', 'DL345678', 7654321098, 2),
('Emily Davis', 'DL901234', 6543210987, NULL),
('Robert Brown', 'DL567890', 5432109876, 5),
('Sarah Wilson', 'DL678901', 4321098765, 6),
('David Miller', 'DL234567', 3210987654, 7);

-- Insert sample data into Trips Table
INSERT INTO trips (vehicle_id, driver_id, start_location, end_location, start_time, end_time, status) VALUES
(1, 1, 'New York', 'Los Angeles', '2024-02-10 08:00:00', '2024-02-12 18:00:00', 'Completed'),
(3, 2, 'Chicago', 'Houston', '2024-02-11 09:30:00', NULL, 'Ongoing'),
(2, 3, 'Miami', 'Orlando', '2024-02-12 07:15:00', '2024-02-12 12:00:00', 'Completed'),
(5, 5, 'San Francisco', 'Seattle', '2024-02-13 10:00:00', NULL, 'Ongoing'),
(1, 1, 'Boston', 'Philadelphia', '2024-02-14 06:45:00', '2024-02-14 11:30:00', 'Completed'),
(6, 6, 'Denver', 'Las Vegas', '2024-02-15 08:15:00', '2024-02-15 22:45:00', 'Completed'),
(7, 7, 'Atlanta', 'Dallas', '2024-02-16 07:30:00', NULL, 'Ongoing');

-- Insert sample data into Maintenance Table
INSERT INTO maintenance (vehicle_id, maintenance_date, description, cost) VALUES
(2, '2024-01-15', 'Engine oil change and tire rotation', 150.00),
(4, '2024-02-05', 'Brake pad replacement', 200.00),
(3, '2024-02-10', 'Transmission fluid change', 300.00),
(1, '2024-02-12', 'Battery replacement', 180.00),
(5, '2024-02-14', 'Wheel alignment and balancing', 120.00),
(6, '2024-02-16', 'Coolant flush and spark plug replacement', 250.00),
(7, '2024-02-17', 'Exhaust system repair', 320.00);

-- Insert sample data into Fuel Logs Table
INSERT INTO fuel_logs (vehicle_id, date, fuel_amount, cost, odometer_reading) VALUES
(1, '2024-02-10', 50.00, 150.00, 50000),
(3, '2024-02-11', 40.00, 120.00, 35000),
(2, '2024-02-12', 55.00, 165.00, 42000),
(5, '2024-02-13', 60.00, 180.00, 28000),
(1, '2024-02-14', 45.00, 135.00, 51000),
(6, '2024-02-15', 52.00, 156.00, 60000),
(7, '2024-02-16', 48.00, 144.00, 55000);

-- Retrieve all vehicles along with their current status.
SELECT vehicle_id, registration_number, make, model, year, status 
FROM vehicles;

-- Get the total number of drivers assigned to vehicles.
SELECT COUNT(*) AS total_assigned_drivers 
FROM drivers 
WHERE assigned_vehicle_id IS NOT NULL;

-- Fetch details of all ongoing trips.
SELECT * 
FROM trips 
WHERE status = 'Ongoing';

-- Retrieve maintenance history for a specific vehicle.
SELECT * 
FROM maintenance 
WHERE vehicle_id = 2 
ORDER BY maintenance_date DESC;

-- List all fuel logs for a particular vehicle in the last 30 days.
SELECT * 
FROM fuel_logs 
WHERE vehicle_id = 3 
AND date >= DATEADD(DAY, -30, GETDATE()) 
ORDER BY date DESC;

-- Find the total fuel cost for each vehicle in the last month.
SELECT vehicle_id, SUM(cost) AS total_fuel_cost 
FROM fuel_logs 
WHERE date >= DATEADD(MONTH, -1, GETDATE()) 
GROUP BY vehicle_id;

-- Identify vehicles that have not had maintenance in the past 6 months.
SELECT v.vehicle_id, v.registration_number, v.make, v.model 
FROM vehicles v
LEFT JOIN maintenance m ON v.vehicle_id = m.vehicle_id 
AND m.maintenance_date >= DATEADD(MONTH, -6, GETDATE()) 
WHERE m.vehicle_id IS NULL;

-- Get the average trip duration for completed trips.
SELECT AVG(DATEDIFF(HOUR, start_time, end_time)) AS avg_trip_duration_hours 
FROM trips 
WHERE status = 'Completed';

-- Show the top 5 most frequently used vehicles based on trip count.
SELECT TOP 5 vehicle_id, COUNT(*) AS trip_count 
FROM trips 
GROUP BY vehicle_id 
ORDER BY trip_count DESC;

-- Find the driver who has completed the most trips.
SELECT TOP 1 driver_id, COUNT(*) AS completed_trips 
FROM trips 
WHERE status = 'Completed' 
GROUP BY driver_id 
ORDER BY completed_trips DESC;

-- Retrieve vehicles that have the highest maintenance costs over the past year.
SELECT v.vehicle_id, v.registration_number, SUM(m.cost) AS total_maintenance_cost 
FROM vehicles v
JOIN maintenance m ON v.vehicle_id = m.vehicle_id 
WHERE m.maintenance_date >= DATEADD(YEAR, -1, GETDATE()) 
GROUP BY v.vehicle_id, v.registration_number 
ORDER BY total_maintenance_cost DESC;

-- Determine the most fuel-efficient vehicle based on fuel logs and odometer readings.
SELECT TOP 1 vehicle_id, 
       SUM(odometer_reading) / SUM(fuel_amount) AS fuel_efficiency 
FROM fuel_logs 
GROUP BY vehicle_id 
ORDER BY fuel_efficiency DESC;

-- Identify the busiest driver based on trip hours.
SELECT TOP 1 driver_id, 
       SUM(DATEDIFF(HOUR, start_time, end_time)) AS total_trip_hours 
FROM trips 
WHERE status = 'Completed' 
GROUP BY driver_id 
ORDER BY total_trip_hours DESC;

-- Get the list of drivers who have never been assigned a trip.
SELECT d.driver_id, d.name 
FROM drivers d
LEFT JOIN trips t ON d.driver_id = t.driver_id 
WHERE t.driver_id IS NULL;

-- Find vehicles that have been inactive for more than 3 months.
SELECT vehicle_id, registration_number, make, model, status 
FROM vehicles 
WHERE status = 'Inactive' 
AND vehicle_id NOT IN (
    SELECT DISTINCT vehicle_id 
    FROM trips 
    WHERE start_time >= DATEADD(MONTH, -3, GETDATE())
);
