-- Project In MariaDB 
-- Creating the database
CREATE DATABASE SmartTrafficDB;
USE SmartTrafficDB;

CREATE TABLE Owners (
    owner_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    contact_number VARCHAR(20),
    address TEXT
);

CREATE TABLE Vehicles (
    vehicle_id INT AUTO_INCREMENT PRIMARY KEY,
    plate_number VARCHAR(20) UNIQUE,
    vehicle_type VARCHAR(50),
    owner_id INT,
    FOREIGN KEY (owner_id) REFERENCES Owners(owner_id) ON DELETE CASCADE
);

CREATE TABLE Traffic_Signals (
    signal_id INT AUTO_INCREMENT PRIMARY KEY,
    location VARCHAR(255),
    status ENUM('Red', 'Yellow', 'Green'),
    last_update_time DATETIME
);

CREATE TABLE Cameras (
    camera_id INT AUTO_INCREMENT PRIMARY KEY,
    location VARCHAR(255),
    status ENUM('Active', 'Inactive')
);

CREATE TABLE Violations (
    violation_id INT AUTO_INCREMENT PRIMARY KEY,
    vehicle_id INT,
    violation_type VARCHAR(100),
    fine_amount DECIMAL(10,2),
    violation_time DATETIME,
    camera_id INT,
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id) ON DELETE CASCADE,
    FOREIGN KEY (camera_id) REFERENCES Cameras(camera_id) ON DELETE SET NULL
);

CREATE TABLE Traffic_Flow_Data (
    flow_id INT AUTO_INCREMENT PRIMARY KEY,
    signal_id INT,
    vehicle_count INT,
    average_speed DECIMAL(5,2),
    timestamp DATETIME,
    FOREIGN KEY (signal_id) REFERENCES Traffic_Signals(signal_id) ON DELETE CASCADE
);

CREATE TABLE Weather_Conditions (
    weather_id INT AUTO_INCREMENT PRIMARY KEY,
    location VARCHAR(255),
    temperature DECIMAL(5,2),
    visibility INT,
    timestamp DATETIME
);

CREATE TABLE Emergency_Vehicles (
    emergency_id INT AUTO_INCREMENT PRIMARY KEY,
    vehicle_id INT,
    type ENUM('Ambulance', 'Firetruck', 'Police'),
    priority_level INT,
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id) ON DELETE CASCADE
);

-- Insert into Owners
INSERT INTO Owners (name, contact_number, address) VALUES
('John Doe', '1234567890', '123 Main St'),
('Jane Smith', '0987654321', '456 Elm St'),
('Mike Johnson', '1122334455', '789 Pine St'),
('Sara Connor', '6677889900', '101 Oak St');

-- Insert into Vehicles
INSERT INTO Vehicles (plate_number, vehicle_type, owner_id) VALUES
('ABC123', 'Car', 1),
('XYZ789', 'Truck', 2),
('DEF456', 'Motorcycle', 3),
('GHI101', 'Bus', 4),
('JKL321', 'Car', 1);

-- Insert into Traffic Signals
INSERT INTO Traffic_Signals (location, status, last_update_time) VALUES
('Main St & 1st Ave', 'Red', '2025-02-28 08:30:00'),
('Elm St & 2nd Ave', 'Green', '2025-02-28 08:31:00'),
('Pine St & 3rd Ave', 'Yellow', '2025-02-28 08:32:00');

-- Insert into Cameras
INSERT INTO Cameras (location, status) VALUES
('Main St & 1st Ave', 'Active'),
('Elm St & 2nd Ave', 'Active'),
('Pine St & 3rd Ave', 'Inactive');

-- Insert into Violations
INSERT INTO Violations (vehicle_id, violation_type, fine_amount, violation_time, camera_id) VALUES
(1, 'Speeding', 100.00, '2025-02-28 09:00:00', 1),
(2, 'Red Light Jump', 200.00, '2025-02-28 09:05:00', 2),
(3, 'Wrong Lane', 150.00, '2025-02-28 09:10:00', 3),
(4, 'Over Speeding', 120.00, '2025-02-28 09:15:00', 1);

-- Insert into Traffic Flow Data
INSERT INTO Traffic_Flow_Data (signal_id, vehicle_count, average_speed, timestamp) VALUES
(1, 150, 45.5, '2025-02-28 10:00:00'),
(2, 120, 50.0, '2025-02-28 10:05:00'),
(3, 90, 40.5, '2025-02-28 10:10:00');

-- Insert into Weather Conditions
INSERT INTO Weather_Conditions (location, temperature, visibility, timestamp) VALUES
('Main St', 28.5, 100, '2025-02-28 07:00:00'),
('Elm St', 25.0, 80, '2025-02-28 07:05:00'),
('Pine St', 22.5, 50, '2025-02-28 07:10:00');

-- Insert into Emergency Vehicles
INSERT INTO Emergency_Vehicles (vehicle_id, type, priority_level) VALUES
(1, 'Ambulance', 1),
(2, 'Firetruck', 2),
(3, 'Police', 3);

-- Retrieve the details of the owner whose vehicle was fined the highest amount.
SELECT o.owner_id, o.name, o.contact_number, o.address, SUM(vi.fine_amount) AS total_fine
FROM Owners o
JOIN Vehicles v ON o.owner_id = v.owner_id
JOIN Violations vi ON v.vehicle_id = vi.vehicle_id
GROUP BY o.owner_id, o.name, o.contact_number, o.address
ORDER BY total_fine DESC
LIMIT 1;

-- List all locations where the traffic signal was red for more than 5 minutes in the last hour.
SELECT location, TIMESTAMPDIFF(MINUTE, last_update_time, NOW()) AS red_duration
FROM Traffic_Signals
WHERE status = 'Red' 
AND TIMESTAMPDIFF(MINUTE, last_update_time, NOW()) > 5;

-- Identify all emergency vehicles and their priority levels.
SELECT v.plate_number, ev.type, ev.priority_level
FROM Emergency_Vehicles ev
JOIN Vehicles v ON ev.vehicle_id = v.vehicle_id;

-- Check which cameras have detected more than 1 violations in the last day.
SELECT c.camera_id, c.location, COUNT(v.violation_id) AS violation_count
FROM Cameras c
JOIN Violations v ON c.camera_id = v.camera_id
WHERE v.violation_time >= NOW() - INTERVAL 1 DAY
GROUP BY c.camera_id, c.location
HAVING COUNT(v.violation_id) > 1;

-- Retrieve the average speed of vehicles at each traffic signal in the past 12 hours.
SELECT ts.location, AVG(tf.average_speed) AS avg_speed
FROM Traffic_Signals ts
JOIN Traffic_Flow_Data tf ON ts.signal_id = tf.signal_id
WHERE tf.timestamp >= NOW() - INTERVAL 12 HOUR
GROUP BY ts.location;

-- Find the most common type of traffic violation.
SELECT violation_type, COUNT(*) AS violation_count
FROM Violations
GROUP BY violation_type
ORDER BY violation_count DESC
LIMIT 1;

-- Find all locations where the average speed of vehicles is higher than 45 km/h.
SELECT ts.location, AVG(tf.average_speed) AS avg_speed
FROM Traffic_Signals ts
JOIN Traffic_Flow_Data tf ON ts.signal_id = tf.signal_id
GROUP BY ts.location
HAVING avg_speed > 45;

-- Get the number of violations recorded by each camera.
SELECT c.camera_id, c.location, COUNT(v.violation_id) AS total_violations
FROM Cameras c
LEFT JOIN Violations v ON c.camera_id = v.camera_id
GROUP BY c.camera_id, c.location;

-- Get the busiest time of the day based on vehicle count.
SELECT HOUR(timestamp) AS hour_of_day, SUM(vehicle_count) AS total_vehicles
FROM Traffic_Flow_Data
GROUP BY hour_of_day
ORDER BY total_vehicles DESC
LIMIT 1;

-- Find the owners whose vehicles have not committed any violations.
SELECT o.owner_id, o.name, o.contact_number, o.address
FROM Owners o
LEFT JOIN Vehicles v ON o.owner_id = v.owner_id
LEFT JOIN Violations vi ON v.vehicle_id = vi.vehicle_id
WHERE vi.violation_id IS NULL;

-- Identify locations where the number of vehicles exceeded 100 in any hour.
SELECT ts.location, tf.timestamp, tf.vehicle_count
FROM Traffic_Signals ts
JOIN Traffic_Flow_Data tf ON ts.signal_id = tf.signal_id
WHERE tf.vehicle_count > 100;

-- Get a list of all cameras that have been inactive for more than 24 hours.
SELECT camera_id, location, status
FROM Cameras
WHERE status = 'Inactive';

-- Get a list of all vehicles involved in violations along with their owner details.
SELECT v.plate_number, v.vehicle_type, o.name AS owner_name, o.contact_number, COUNT(vi.violation_id) AS total_violations
FROM Vehicles v
JOIN Owners o ON v.owner_id = o.owner_id
JOIN Violations vi ON v.vehicle_id = vi.vehicle_id
GROUP BY v.plate_number, v.vehicle_type, o.name, o.contact_number;