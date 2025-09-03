-- MS SQL Project 
CREATE DATABASE IoT_Sensor_DB;
USE IoT_Sensor_DB;

-- Devices Table
CREATE TABLE devices (
  device_id INT IDENTITY(1,1) PRIMARY KEY,
  device_name VARCHAR(50),
  location VARCHAR(50),
  status VARCHAR(8) CHECK (status IN ('active', 'inactive')),
  created_at DATETIME
);

-- Sensors Table
CREATE TABLE sensors (
  sensor_id INT IDENTITY(1,1) PRIMARY KEY,
  device_id INT,
  sensor_type VARCHAR(15) CHECK (sensor_type IN ('temperature', 'humidity', 'motion')),
  unit VARCHAR(30),
  created_at DATETIME,
  FOREIGN KEY (device_id) REFERENCES devices(device_id)
);

-- Sensor Data Table
CREATE TABLE sensor_data (
  data_id INT IDENTITY(1,1) PRIMARY KEY,
  sensor_id INT,
  value FLOAT,
  timestamp DATETIME,
  FOREIGN KEY (sensor_id) REFERENCES sensors(sensor_id)
);

-- Alerts Table
CREATE TABLE alerts (
  alert_id INT IDENTITY(1,1) PRIMARY KEY,
  sensor_id INT,
  threshold_value FLOAT,
  current_value FLOAT,
  alert_message TEXT,
  triggered_at DATETIME,
  FOREIGN KEY (sensor_id) REFERENCES sensors(sensor_id)
);

-- Users Table
CREATE TABLE users (
  user_id INT IDENTITY(1,1) PRIMARY KEY,
  name VARCHAR(50),
  email VARCHAR(50) UNIQUE,
  password TEXT,
  role VARCHAR(5) CHECK (role IN ('admin', 'user')),
  created_at DATETIME
);

-- Device Assignments Table 
CREATE TABLE device_assignments (
  assignment_id INT IDENTITY(1,1) PRIMARY KEY,
  user_id INT,
  device_id INT,
  assigned_at DATETIME,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (device_id) REFERENCES devices(device_id)
);

-- Insert into Devices Table 
INSERT INTO devices (device_name, location, status, created_at) VALUES
('Temperature Sensor Hub', 'Warehouse A', 'active', GETDATE()),
('Humidity Monitor', 'Office B', 'active', GETDATE()),
('Motion Detector', 'Entrance', 'inactive', GETDATE()),
('Temperature Sensor Hub', 'Warehouse C', 'active', GETDATE()),
('Motion Detector', 'Hallway', 'active', GETDATE()),
('Humidity Monitor', 'Server Room', 'inactive', GETDATE()),
('Temperature Sensor Hub', 'Lab A', 'active', GETDATE()),
('Motion Detector', 'Garage', 'active', GETDATE());

-- Insert into Sensors Table
INSERT INTO sensors (device_id, sensor_type, unit, created_at) VALUES
(1, 'temperature', 'Celsius', GETDATE()),
(2, 'humidity', 'Percentage', GETDATE()),
(3, 'motion', 'Boolean', GETDATE()),
(4, 'temperature', 'Celsius', GETDATE()),
(5, 'motion', 'Boolean', GETDATE()),
(6, 'humidity', 'Percentage', GETDATE()),
(7, 'temperature', 'Celsius', GETDATE()),
(8, 'motion', 'Boolean', GETDATE());

-- Insert into Sensor Data Table 
INSERT INTO sensor_data (sensor_id, value, timestamp) VALUES
(1, 25.4, DATEADD(MINUTE, -10, GETDATE())),
(2, 60.2, DATEADD(MINUTE, -20, GETDATE())),
(3, 1, DATEADD(MINUTE, -30, GETDATE())),
(4, 27.8, DATEADD(MINUTE, -40, GETDATE())),
(5, 0, DATEADD(MINUTE, -50, GETDATE())),
(6, 45.6, DATEADD(MINUTE, -60, GETDATE())),
(7, 22.3, DATEADD(MINUTE, -70, GETDATE())),
(8, 1, DATEADD(MINUTE, -80, GETDATE()));

-- Insert into Alerts Table 
INSERT INTO alerts (sensor_id, threshold_value, current_value, alert_message, triggered_at) VALUES
(1, 30.0, 25.4, 'Temperature is normal', GETDATE()),
(2, 70.0, 60.2, 'Humidity is below threshold', GETDATE()),
(3, 1.0, 1.0, 'Motion detected!', GETDATE()),
(4, 28.0, 27.8, 'Temperature nearing limit', GETDATE()),
(5, 1.0, 0.0, 'No motion detected', GETDATE()),
(6, 50.0, 45.6, 'Humidity level within range', GETDATE()),
(7, 26.0, 22.3, 'Temperature slightly low', GETDATE()),
(8, 1.0, 1.0, 'Movement detected in garage!', GETDATE());

-- Insert into Users Table 
INSERT INTO users (name, email, password, role, created_at) VALUES
('Alice Johnson', 'alice@example.com', 'pass123', 'admin', GETDATE()),
('Bob Smith', 'bob@example.com', 'pass456', 'user', GETDATE()),
('Charlie Brown', 'charlie@example.com', 'pass789', 'user', GETDATE()),
('David White', 'david@example.com', 'pass321', 'admin', GETDATE()),
('Eve Black', 'eve@example.com', 'pass654', 'user', GETDATE()),
('Frank Green', 'frank@example.com', 'pass987', 'user', GETDATE()),
('Grace Miller', 'grace@example.com', 'pass159', 'admin', GETDATE()),
('Henry Clark', 'henry@example.com', 'pass753', 'user', GETDATE());

-- Insert into Device Assignments Table 
INSERT INTO device_assignments (user_id, device_id, assigned_at) VALUES
(1, 1, GETDATE()),
(2, 2, GETDATE()),
(3, 3, GETDATE()),
(4, 4, GETDATE()),
(5, 5, GETDATE()),
(6, 6, GETDATE()),
(7, 1, GETDATE()),
(8, 3, GETDATE()); 

-- List all sensors and their last recorded value
SELECT s.sensor_id, s.sensor_type, s.unit, s.device_id, sd.value, sd.timestamp
FROM sensors s
LEFT JOIN sensor_data sd ON s.sensor_id = sd.sensor_id
WHERE sd.timestamp = (
    SELECT MAX(timestamp) FROM sensor_data WHERE sensor_id = s.sensor_id
);

-- Detect alerts triggered in the past week
SELECT * 
FROM alerts 
WHERE triggered_at >= DATEADD(DAY, -7, GETDATE());

-- Show users and their assigned devices
SELECT u.user_id, u.name, u.email, u.role, d.device_id, d.device_name, d.location
FROM users u
JOIN device_assignments da ON u.user_id = da.user_id
JOIN devices d ON da.device_id = d.device_id;

-- Count the number of active devices per location
SELECT location, COUNT(device_id) AS active_device_count
FROM devices
WHERE status = 'active'
GROUP BY location;

-- Find the highest recorded temperature for each device in the last 7 days
SELECT s.device_id, d.device_name, MAX(sd.value) AS max_temperature
FROM sensors s
JOIN sensor_data sd ON s.sensor_id = sd.sensor_id
JOIN devices d ON s.device_id = d.device_id
WHERE s.sensor_type = 'temperature'
AND sd.timestamp >= DATEADD(DAY, -7, GETDATE())
GROUP BY s.device_id, d.device_name;

-- Retrieve the latest recorded value for each sensor
SELECT s.sensor_id, s.sensor_type, s.device_id, sd.value, sd.timestamp
FROM sensors s
JOIN sensor_data sd ON s.sensor_id = sd.sensor_id
WHERE sd.timestamp = (
    SELECT MAX(timestamp) FROM sensor_data WHERE sensor_id = s.sensor_id
);

-- Count the number of alerts triggered for each sensor in the past month
SELECT s.sensor_id, s.sensor_type, COUNT(a.alert_id) AS alert_count
FROM sensors s
LEFT JOIN alerts a ON s.sensor_id = a.sensor_id
WHERE a.triggered_at >= DATEADD(MONTH, -1, GETDATE())
GROUP BY s.sensor_id, s.sensor_type;

-- Retrieve the top 5 devices with the most sensor readings recorded in the past 30 days
SELECT TOP 5 s.device_id, d.device_name, COUNT(sd.data_id) AS reading_count
FROM sensors s
JOIN sensor_data sd ON s.sensor_id = sd.sensor_id
JOIN devices d ON s.device_id = d.device_id
WHERE sd.timestamp >= DATEADD(DAY, -30, GETDATE())
GROUP BY s.device_id, d.device_name
ORDER BY reading_count DESC;

-- Retrieve the 3 most recent sensor readings for each sensor
SELECT sd.sensor_id, sd.value, sd.timestamp
FROM sensor_data sd
WHERE sd.timestamp IN (
    SELECT TOP 3 timestamp
    FROM sensor_data sd2
    WHERE sd2.sensor_id = sd.sensor_id
    ORDER BY timestamp DESC
);

-- Find the highest, lowest, and average recorded humidity in the past 30 days
SELECT 
    MAX(sd.value) AS max_humidity,
    MIN(sd.value) AS min_humidity,
    AVG(sd.value) AS avg_humidity
FROM sensors s
JOIN sensor_data sd ON s.sensor_id = sd.sensor_id
WHERE s.sensor_type = 'humidity'
AND sd.timestamp >= DATEADD(DAY, -30, GETDATE());

-- List all motion sensors that have detected motion in the last 48 hours
SELECT s.sensor_id, s.device_id, sd.value, sd.timestamp
FROM sensors s
JOIN sensor_data sd ON s.sensor_id = sd.sensor_id
WHERE s.sensor_type = 'motion'
AND sd.value = 1
AND sd.timestamp >= DATEADD(HOUR, -48, GETDATE());

-- List all devices with their latest status update
SELECT d.device_id, d.device_name, d.status, MAX(sd.timestamp) AS last_update_time
FROM devices d
LEFT JOIN sensors s ON d.device_id = s.device_id
LEFT JOIN sensor_data sd ON s.sensor_id = sd.sensor_id
GROUP BY d.device_id, d.device_name, d.status;

-- Get the percentage of active vs inactive devices
SELECT status, COUNT(*) AS device_count,
       (COUNT(*) * 100.0) / (SELECT COUNT(*) FROM devices) AS percentage
FROM devices
GROUP BY status;