-- MS SQL Project
CREATE DATABASE Traffic_Analysis;

-- Owners Table
create TABLE owners (
  owner_id INT IDENTITY(1,1) PRIMARY KEY,
  name VARCHAR(50),
  address TEXT,
  contact_number VARCHAR(15)
);

-- Vehicles Table
CREATE TABLE vehicles (
  vehicle_id INT IDENTITY(1,1) PRIMARY KEY,
  plate_number VARCHAR(15),
  vehicle_type VARCHAR(20) CHECK (vehicle_type IN ('Car', 'Bus', 'Truck', 'Bike', 'Van')),
  owner_id INT,
  FOREIGN KEY (owner_id) REFERENCES owners(owner_id)
);

-- Traffic Incidents Table
CREATE TABLE traffic_incidents (
  incident_id INT IDENTITY(1,1) PRIMARY KEY,
  incident_type VARCHAR(20) CHECK (incident_type IN ('Accident', 'Violation', 'Breakdown', 'Theft', 'Other')),
  vehicle_id INT,
  location_id INT,
  timestamp DATETIME,
  severity_level INT CHECK (severity_level BETWEEN 1 AND 5),
  FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id),
  FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

-- Locations Table 
CREATE TABLE locations (
  location_id INT IDENTITY(1,1) PRIMARY KEY,
  location_name VARCHAR(50),
  latitude DECIMAL(9,6) NOT NULL CHECK (latitude BETWEEN -90 AND 90),
  longitude DECIMAL(9,6) NOT NULL CHECK (longitude BETWEEN -180 AND 180)
);

-- Traffic Volume Table
create TABLE traffic_volume (
  traffic_id INT IDENTITY(1,1) PRIMARY KEY,
  location_id INT,
  vehicle_count INT,
  timestamp DATETIME,
  FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

-- Speed Violations Table
CREATE Table speed_violation (
  violation_id INT IDENTITY(1,1) PRIMARY KEY,
  vehicle_id INT, 
  location_id INT,
  speed_recorded DECIMAL(5,2) NOT NULL CHECK (speed_recorded > 0),
  speed_limit DECIMAL(5,2) NOT NULL CHECK (speed_limit > 0),
  FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id),
  FOREIGN Key (location_id) REFERENCES locations(location_id)
);

-- Road Conditions Table
create TABLE road_condition (
  condition_id INT IDENTITY(1,1) PRIMARY KEY,
  location_id INT,
  weather_condition VARCHAR(20) CHECK ( weather_condition IN ('Rainy', 'Foggy', 'Clear', 'Snowy', 'Windy', 'Stormy')),
  road_type VARCHAR(20) CHECK (road_type IN ('Highway', 'Local Road', 'Main Road', 'Residential Street', 'Rural Road')),
  timestamp DATETIME,
  FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

-- CCTV Cameras Table
create TABLE cctv_camera (
  camera_id INT IDENTITY(1,1) PRIMARY KEY,
  location_id INT,
  camera_status VARCHAR(10) CHECK (camera_status IN ('Active', 'Inactive')),
  FOREIGN KEY (location_id) REFERENCES locations(location_id)
);  

INSERT INTO owners (name, address, contact_number) VALUES
('John Doe', '123 Elm Street, Springfield, IL', '555-123-4567'),
('Jane Smith', '456 Oak Avenue, Boston, MA', '555-987-6543'),
('Michael Johnson', '789 Pine Road, Denver, CO', '555-321-7890'),
('Emily Davis', '321 Maple Lane, Seattle, WA', '555-654-3210'),
('David Wilson', '555 Birch Blvd, Austin, TX', '555-888-9999'),
('Sarah Brown', '111 Cedar Street, Miami, FL', '555-222-3333'),
('James Anderson', '222 Walnut Drive, Chicago, IL', '555-444-5555'),
('Laura Martinez', '333 Magnolia Ave, Phoenix, AZ', '555-666-7777'),
('Robert Thomas', '444 Palm Court, San Diego, CA', '555-111-2222'),
('Sophia White', '777 Redwood St, Portland, OR', '555-999-0000');

INSERT INTO vehicles (plate_number, vehicle_type, owner_id) VALUES
('ABC123', 'Car', 1),
('XYZ987', 'Truck', 3),
('LMN456', 'Bike', 2),
('PQR789', 'Bus', 4),
('DEF321', 'Van', 5),
('GHI654', 'Car', 1),
('JKL852', 'Truck', 2),
('MNO963', 'Bike', 3),
('QRS741', 'Bus', 4),
('TUV159', 'Van', 5),
('WXZ753', 'Car', 2),
('YUI369', 'Truck', 3),
('OPA258', 'Bike', 1),
('LKO741', 'Bus', 4),
('ZXC159', 'Van', 5);

INSERT INTO traffic_incidents (incident_type, vehicle_id, location_id, timestamp, severity_level) VALUES
('Accident', 1, 3, '2024-02-01 08:30:00', 4),
('Violation', 2, 5, '2024-02-02 14:15:00', 2),
('Breakdown', 3, 7, '2024-02-03 18:45:00', 3),
('Theft', 4, 1, '2024-02-04 02:10:00', 5),
('Other', 5, 6, '2024-02-05 09:25:00', 1),
('Accident', 6, 8, '2024-02-06 16:00:00', 3),
('Violation', 7, 2, '2024-02-07 11:50:00', 2),
('Breakdown', 8, 4, '2024-02-08 20:05:00', 4),
('Theft', 9, 10, '2024-02-09 03:30:00', 5),
('Other', 10, 9, '2024-02-10 07:45:00', 1);

INSERT INTO locations (location_name, latitude, longitude) VALUES
('Central Park, NY', 40.785091, -73.968285),
('Golden Gate Bridge, CA', 37.819929, -122.478255),
('Eiffel Tower, Paris', 48.858844, 2.294351),
('Sydney Opera House, Australia', -33.856784, 151.215297),
('Tokyo Tower, Japan', 35.658581, 139.745438),
('Great Wall, China', 40.431908, 116.570374),
('Christ the Redeemer, Brazil', -22.951916, -43.210487),
('Colosseum, Italy', 41.890251, 12.492373),
('Taj Mahal, India', 27.175015, 78.042155),
('Machu Picchu, Peru', -13.163141, -72.544963);

INSERT INTO traffic_volume (location_id, vehicle_count, timestamp) VALUES
(1, 150, '2024-02-01 08:00:00'),
(2, 200, '2024-02-01 09:00:00'),
(3, 120, '2024-02-01 10:00:00'),
(4, 175, '2024-02-01 11:00:00'),
(5, 95, '2024-02-01 12:00:00'),
(6, 250, '2024-02-01 13:00:00'),
(7, 300, '2024-02-01 14:00:00'),
(8, 80, '2024-02-01 15:00:00'),
(9, 220, '2024-02-01 16:00:00'),
(10, 180, '2024-02-01 17:00:00');

INSERT INTO speed_violation (vehicle_id, location_id, speed_recorded, speed_limit) VALUES
(1, 3, 80.50, 65.00),
(2, 5, 100.75, 80.00),
(3, 7, 55.60, 50.00),
(4, 1, 90.25, 70.00),
(5, 6, 120.90, 100.00),
(6, 8, 65.40, 55.00),
(7, 2, 75.80, 60.00),
(8, 4, 110.35, 90.00),
(9, 10, 85.60, 70.00),
(10, 9, 95.20, 80.00);

INSERT INTO road_condition (location_id, weather_condition, road_type, timestamp) VALUES
(1, 'Rainy', 'Highway', '2024-02-01 08:00:00'),
(2, 'Foggy', 'Local Road', '2024-02-02 09:30:00'),
(3, 'Clear', 'Main Road', '2024-02-03 10:45:00'),
(4, 'Snowy', 'Residential Street', '2024-02-04 12:15:00'),
(5, 'Windy', 'Rural Road', '2024-02-05 14:20:00'),
(6, 'Stormy', 'Highway', '2024-02-06 16:05:00'),
(7, 'Rainy', 'Local Road', '2024-02-07 18:50:00'),
(8, 'Clear', 'Main Road', '2024-02-08 20:10:00'),
(9, 'Foggy', 'Residential Street', '2024-02-09 21:30:00'),
(10, 'Snowy', 'Rural Road', '2024-02-10 23:45:00');

INSERT INTO cctv_camera (location_id, camera_status) VALUES
(1, 'Active'),
(2, 'Inactive'),
(3, 'Active'),
(1, 'Active'),  
(5, 'Inactive'),
(2, 'Active'),  
(7, 'Active'),
(3, 'Inactive'), 
(9, 'Active'),
(10, 'Active'),
(4, 'Active'),
(6, 'Inactive'),
(8, 'Active'),
(5, 'Active'), 
(7, 'Inactive');

-- Find the busiest locations based on traffic volume.
SELECT l.location_id, l.location_name, SUM(tv.vehicle_count) AS total_traffic
FROM traffic_volume tv
JOIN locations l ON tv.location_id = l.location_id
GROUP BY l.location_id, l.location_name
ORDER BY total_traffic DESC;

-- List all vehicles that have committed speed violations more than 3 times.
SELECT v.vehicle_id, v.plate_number, COUNT(sv.violation_id) AS violation_count
FROM speed_violation sv
JOIN vehicles v ON sv.vehicle_id = v.vehicle_id
GROUP BY v.vehicle_id, v.plate_number
HAVING COUNT(sv.violation_id) > 3
ORDER BY violation_count DESC;

-- Find the average speed recorded in a specific location.
SELECT location_id, AVG(speed_recorded) AS avg_speed
FROM speed_violation
WHERE location_id = 5
GROUP BY location_id;

-- Identify which vehicle types are most involved in traffic violations.
SELECT v.vehicle_type, COUNT(sv.violation_id) AS violation_count
FROM speed_violation sv
JOIN vehicles v ON sv.vehicle_id = v.vehicle_id
GROUP BY v.vehicle_type
ORDER BY violation_count DESC;

-- Find the owners of vehicles that have been involved in incidents.
SELECT DISTINCT o.owner_id, o.name, o.contact_number, v.vehicle_id, v.plate_number
FROM traffic_incidents ti
JOIN vehicles v ON ti.vehicle_id = v.vehicle_id
JOIN owners o ON v.owner_id = o.owner_id
ORDER BY o.name;

-- List all locations where CCTV cameras are inactive.
SELECT DISTINCT l.location_id, l.location_name
FROM cctv_camera c
JOIN locations l ON c.location_id = l.location_id
WHERE c.camera_status = 'Inactive'
ORDER BY l.location_name;

-- Determine the most common types of incidents occurring in a particular area.
SELECT ti.incident_type, COUNT(ti.incident_id) AS incident_count
FROM traffic_incidents ti
WHERE ti.location_id = 3
GROUP BY ti.incident_type
ORDER BY incident_count DESC;
