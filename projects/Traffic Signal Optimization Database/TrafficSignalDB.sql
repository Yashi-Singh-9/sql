-- Project in PostgreSQL 
-- Create Database
CREATE DATABASE TrafficSignalDB;
\c TrafficSignalDB;

-- Intersections Table  
CREATE TABLE intersections (
    intersection_id SERIAL PRIMARY KEY,
    intersections_name VARCHAR(255) NOT NULL,
    latitude DECIMAL(9,6) NOT NULL,
    longitude DECIMAL(9,6) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL
);

-- Traffic Signals Table 
CREATE TABLE traffic_signals (
  signal_id SERIAL PRIMARY KEY,
  intersection_id INT NOT NULL,
  signal_type VARCHAR(15) CHECK (signal_type IN ('LED', 'Halogen', 'Incandescent', 'Fluorescent', 'Smart Signal')) NOT NULL,
  status  VARCHAR(10) CHECK (status IN ('Active', 'Inactive')) NOT NULL,
  installation_date DATE NOT NULL,
  FOREIGN KEY (intersection_id) REFERENCES intersections(intersection_id)
);

-- Signal Timings table
CREATE TABLE signal_timings (
    timing_id SERIAL PRIMARY KEY,
    signal_id INT NOT NULL,
    green_time INT CHECK (green_time > 0) NOT NULL,
    yellow_time INT CHECK (yellow_time > 0) NOT NULL,
    red_time INT CHECK (red_time > 0) NOT NULL,
    time_of_day VARCHAR(10) CHECK (time_of_day IN ('Morning', 'Afternoon', 'Night')) NOT NULL,
    FOREIGN KEY (signal_id) REFERENCES Traffic_Signals(signal_id) ON DELETE CASCADE
);

-- Traffic Flow Table
CREATE TABLE traffic_flow (
   flow_id SERIAL PRIMARY KEY,
    intersection_id INT NOT NULL,
    vehicle_count INT CHECK (vehicle_count >= 0) NOT NULL,
    average_speed DECIMAL(5,2) CHECK (average_speed >= 0) NOT NULL,
    timestamp TIMESTAMP DEFAULT NOW() NOT NULL,
    FOREIGN KEY (intersection_id) REFERENCES intersections(intersection_id) ON DELETE CASCADE
);

-- Incidents Table  
CREATE TABLE incidents (
    incident_id SERIAL PRIMARY KEY,
    intersection_id INT NOT NULL,
    incident_type VARCHAR(20) CHECK (incident_type IN ('Accident', 'Roadblock', 'Weather-related')),
    severity VARCHAR(10) CHECK (severity IN ('Minor', 'Moderate', 'Severe')),
    timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (intersection_id) REFERENCES intersections(intersection_id) ON DELETE CASCADE
);

-- Maintenance Table 
CREATE TABLE maintenance (
    maintenance_id SERIAL PRIMARY KEY,
    signal_id INT NOT NULL,
    last_maintenance_date DATE NOT NULL,
    next_maintenance_date DATE NOT NULL,
    maintenance_status VARCHAR(10) CHECK (maintenance_status IN ('Pending', 'Completed')),
    FOREIGN KEY (signal_id) REFERENCES traffic_signals(signal_id) ON DELETE CASCADE
);

-- Insert data into intersections table
INSERT INTO intersections (intersections_name, latitude, longitude, city, state) VALUES
('Main & 1st', 40.712776, -74.005974, 'New York', 'NY'),
('Broadway & 5th', 34.052235, -118.243683, 'Los Angeles', 'CA'),
('Market & 7th', 37.774929, -122.419418, 'San Francisco', 'CA'),
('Michigan & Wacker', 41.888115, -87.624421, 'Chicago', 'IL'),
('Peachtree & 10th', 33.781691, -84.388233, 'Atlanta', 'GA');

-- Insert data into traffic_signals table
INSERT INTO traffic_signals (intersection_id, signal_type, status, installation_date) VALUES
(1, 'LED', 'Active', '2020-05-15'),
(2, 'Smart Signal', 'Active', '2021-08-22'),
(3, 'Halogen', 'Inactive', '2018-12-10'),
(4, 'Incandescent', 'Active', '2019-06-30'),
(5, 'Fluorescent', 'Inactive', '2017-11-05');

-- Insert data into signal_timings table
INSERT INTO signal_timings (signal_id, green_time, yellow_time, red_time, time_of_day) VALUES
(1, 30, 5, 45, 'Morning'),
(2, 25, 4, 50, 'Afternoon'),
(3, 35, 6, 40, 'Night'),
(4, 20, 3, 55, 'Morning'),
(5, 40, 7, 35, 'Afternoon');

-- Insert data into traffic_flow table
INSERT INTO traffic_flow (intersection_id, vehicle_count, average_speed, timestamp) VALUES
(1, 120, 35.5, NOW()),
(2, 150, 40.2, NOW()),
(3, 80, 30.8, NOW()),
(4, 200, 42.7, NOW()),
(5, 95, 28.6, NOW());

-- Insert data into incidents table
INSERT INTO incidents (intersection_id, incident_type, severity, timestamp) VALUES
(1, 'Accident', 'Severe', NOW()),
(2, 'Roadblock', 'Moderate', NOW()),
(3, 'Weather-related', 'Minor', NOW()),
(4, 'Accident', 'Moderate', NOW()),
(5, 'Roadblock', 'Severe', NOW());

-- Insert data into maintenance table
INSERT INTO maintenance (signal_id, last_maintenance_date, next_maintenance_date, maintenance_status) VALUES
(1, '2023-01-10', '2024-01-10', 'Completed'),
(2, '2023-06-15', '2024-06-15', 'Pending'),
(3, '2022-09-20', '2023-09-20', 'Completed'),
(4, '2023-04-05', '2024-04-05', 'Pending'),
(5, '2023-08-12', '2024-08-12', 'Completed');

-- Find intersections with the highest traffic flow.
SELECT i.intersections_name, i.city, i.state, tf.vehicle_count
FROM traffic_flow tf
JOIN intersections i ON tf.intersection_id = i.intersection_id
ORDER BY tf.vehicle_count DESC
LIMIT 1;

-- Retrieve signal timing for a specific intersection.
SELECT st.signal_id, st.green_time, st.yellow_time, st.red_time, st.time_of_day
FROM signal_timings st
JOIN traffic_signals ts ON st.signal_id = ts.signal_id
WHERE ts.intersection_id = 2;

-- List all inactive traffic signals.
SELECT ts.signal_id, ts.intersection_id, i.intersections_name, ts.signal_type
FROM traffic_signals ts
JOIN intersections i ON ts.intersection_id = i.intersection_id
WHERE ts.status = 'Inactive';

-- Identify intersections with the most incidents.
SELECT i.intersections_name, i.city, i.state, COUNT(inc.incident_id) AS incident_count
FROM incidents inc
JOIN intersections i ON inc.intersection_id = i.intersection_id
GROUP BY i.intersection_id
ORDER BY incident_count DESC
LIMIT 1;

-- Find the average green light duration per intersection.
SELECT i.intersections_name, i.city, i.state, AVG(st.green_time) AS avg_green_time
FROM signal_timings st
JOIN traffic_signals ts ON st.signal_id = ts.signal_id
JOIN intersections i ON ts.intersection_id = i.intersection_id
GROUP BY i.intersection_id;

-- Retrieve maintenance history for a given signal.
SELECT m.maintenance_id, m.signal_id, m.last_maintenance_date, m.next_maintenance_date, m.maintenance_status
FROM maintenance m
WHERE m.signal_id = 4;

-- List signals that have exceeded their next maintenance date.
SELECT m.signal_id, i.intersections_name, m.next_maintenance_date
FROM maintenance m
JOIN traffic_signals ts ON m.signal_id = ts.signal_id
JOIN intersections i ON ts.intersection_id = i.intersection_id
WHERE m.next_maintenance_date < CURRENT_DATE;

-- Calculate the total red light time at an intersection in a day.
SELECT i.intersections_name, SUM(st.red_time) AS total_red_time_per_day
FROM signal_timings st
JOIN traffic_signals ts ON st.signal_id = ts.signal_id
JOIN intersections i ON ts.intersection_id = i.intersection_id
WHERE i.intersection_id = 1
GROUP BY i.intersection_id;

-- Find intersections with an average speed lower than a given threshold.
SELECT i.intersections_name, i.city, i.state, tf.average_speed
FROM traffic_flow tf
JOIN intersections i ON tf.intersection_id = i.intersection_id
WHERE tf.average_speed < 35;

-- Identify signals that need optimization based on traffic flow patterns.
SELECT i.intersections_name, ts.signal_id, tf.vehicle_count, AVG(st.green_time) AS avg_green_time
FROM traffic_flow tf
JOIN intersections i ON tf.intersection_id = i.intersection_id
JOIN traffic_signals ts ON i.intersection_id = ts.intersection_id
JOIN signal_timings st ON ts.signal_id = st.signal_id
GROUP BY i.intersection_id, ts.signal_id, tf.vehicle_count
HAVING tf.vehicle_count > 100 AND AVG(st.green_time) < 30;
