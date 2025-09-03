-- MS SQL Project
CREATE DATABASE EmergencyServiceDB;
USE EmergencyServiceDB;

-- Users Table 
CREATE TABLE users (
  user_id INT IDENTITY(1,1) PRIMARY KEY,
  name VARCHAR(50),
  phone_number BIGINT,
  address TEXT,
  email VARCHAR(50) UNIQUE
);

-- Emergency Requests Table 
CREATE TABLE emergency_requests (
  request_id INT IDENTITY(1,1) PRIMARY KEY,
  user_id INT,
  incident_type VARCHAR(50),
  incident_location VARCHAR(50),
  status VARCHAR(50),
  timestamp DATETIME,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);  

-- Responders Table  
CREATE TABLE responders (
  responder_id INT IDENTITY(1,1) PRIMARY KEY,
  name VARCHAR(20),
  role VARCHAR(20) CHECK (role IN ('Police', 'Firefighter', 'Paramedic')),
  phone_number BIGINT,
  status VARCHAR(20) CHECK (status IN ('Available', 'On Duty', 'Off Duty'))
);

-- Dispatch Table  
CREATE TABLE dispatch (
  dispatch_id INT IDENTITY(1,1) PRIMARY KEY,
  request_id INT,
  responder_id INT,
  dispatch_time TIME,
  response_time TIME,
  resolution_status VARCHAR(20),
  FOREIGN KEY (request_id) REFERENCES emergency_requests(request_id),
  FOREIGN KEY (responder_id) REFERENCES responders(responder_id)
);

-- Vehicles Table  
CREATE TABLE vehicles (
  vehicle_id INT IDENTITY(1,1) PRIMARY KEY,
  type VARCHAR(15) CHECK (type IN ('Ambulance', 'Fire Truck', 'Police Car')),
  license_plate TEXT,
  status VARCHAR(15) CHECK (status IN ('Available', 'In Use', 'Maintenance')),
);

-- Responder Vehicles Table  
CREATE TABLE responder_vehicles (
  assignment_id INT IDENTITY(1,1) PRIMARY KEY,
  responder_id INT,
  vehicle_id INT,
  assigned_date DATE,
  FOREIGN KEY (responder_id) REFERENCES responders(responder_id),
  FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id)
);

-- Emergency Contacts Table 
CREATE TABLE emergency_contacts (
  contact_id INT IDENTITY(1,1) PRIMARY KEY,
  user_id INT,
  contact_name VARCHAR(20),
  relationship VARCHAR(20),
  phone_number BIGINT,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Insert Sample Data into Users Table
INSERT INTO users (name, phone_number, address, email) VALUES
('John Doe', 1234567890, '123 Elm Street', 'johndoe@example.com'),
('Jane Smith', 9876543210, '456 Oak Street', 'janesmith@example.com'),
('Michael Brown', 5678901234, '789 Pine Avenue', 'michaelbrown@example.com'),
('Emily Johnson', 6789012345, '321 Birch Lane', 'emilyjohnson@example.com'),
('David White', 2345678901, '654 Maple Road', 'davidwhite@example.com'),
('Sarah Davis', 8901234567, '987 Cedar Drive', 'sarahdavis@example.com'),
('Robert Wilson', 3456789012, '741 Spruce Court', 'robertwilson@example.com'),
('Olivia Martin', 4567890123, '852 Willow Street', 'oliviamartin@example.com');

-- Insert Sample Data into Emergency Requests Table
INSERT INTO emergency_requests (user_id, incident_type, incident_location, status, timestamp) VALUES
(1, 'Fire', '123 Elm Street', 'Pending', '2025-02-20 08:30:00'),
(2, 'Medical', '456 Oak Street', 'In Progress', '2025-02-20 09:00:00'),
(3, 'Burglary', '789 Pine Avenue', 'Resolved', '2025-02-20 10:15:00'),
(4, 'Accident', '321 Birch Lane', 'Pending', '2025-02-20 11:45:00'),
(5, 'Fire', '654 Maple Road', 'In Progress', '2025-02-20 12:30:00'),
(6, 'Medical', '987 Cedar Drive', 'Resolved', '2025-02-20 14:00:00'),
(7, 'Burglary', '741 Spruce Court', 'Pending', '2025-02-20 15:30:00'),
(8, 'Accident', '852 Willow Street', 'In Progress', '2025-02-20 16:45:00');

-- Insert Sample Data into Responders Table
INSERT INTO responders (name, role, phone_number, status) VALUES
('James Miller', 'Police', 1122334455, 'Available'),
('Laura Taylor', 'Firefighter', 2233445566, 'On Duty'),
('Brian Anderson', 'Paramedic', 3344556677, 'Available'),
('Emma Thomas', 'Police', 4455667788, 'Off Duty'),
('Daniel Harris', 'Firefighter', 5566778899, 'Available'),
('Sophia Moore', 'Paramedic', 6677889900, 'On Duty'),
('Ethan Walker', 'Police', 7788990011, 'Available'),
('Ava Hall', 'Firefighter', 8899001122, 'On Duty');

-- Insert Sample Data into Dispatch Table
INSERT INTO dispatch (request_id, responder_id, dispatch_time, response_time, resolution_status) VALUES
(1, 2, '08:35:00', '08:50:00', 'Resolved'),
(2, 3, '09:05:00', '09:20:00', 'Resolved'),
(3, 1, '10:20:00', '10:30:00', 'Resolved'),
(4, 4, '11:50:00', '12:10:00', 'Pending'),
(5, 5, '12:35:00', '12:50:00', 'In Progress'),
(6, 6, '14:05:00', '14:25:00', 'Resolved'),
(7, 7, '15:35:00', '15:50:00', 'Pending'),
(8, 8, '16:50:00', '17:10:00', 'In Progress');

-- Insert Sample Data into Vehicles Table
INSERT INTO vehicles (type, license_plate, status) VALUES
('Police Car', 'ABC-1234', 'Available'),
('Fire Truck', 'XYZ-5678', 'In Use'),
('Ambulance', 'LMN-9101', 'Available'),
('Police Car', 'DEF-2345', 'Maintenance'),
('Fire Truck', 'GHI-3456', 'Available'),
('Ambulance', 'JKL-4567', 'In Use'),
('Police Car', 'MNO-5678', 'Available'),
('Fire Truck', 'PQR-6789', 'Maintenance');

-- Insert Sample Data into Responder Vehicles Table
INSERT INTO responder_vehicles (responder_id, vehicle_id, assigned_date) VALUES
(1, 1, '2025-02-01'),
(2, 2, '2025-02-02'),
(3, 3, '2025-02-03'),
(4, 4, '2025-02-04'),
(5, 5, '2025-02-05'),
(6, 6, '2025-02-06'),
(7, 7, '2025-02-07'),
(8, 8, '2025-02-08');

-- Insert Sample Data into Emergency Contacts Table
INSERT INTO emergency_contacts (user_id, contact_name, relationship, phone_number) VALUES
(1, 'Alice Doe', 'Spouse', 1112223333),
(2, 'Bob Smith', 'Sibling', 2223334444),
(3, 'Charlie Brown', 'Parent', 3334445555),
(4, 'Diana Johnson', 'Friend', 4445556666),
(5, 'Edward White', 'Spouse', 5556667777),
(6, 'Fiona Davis', 'Sibling', 6667778888),
(7, 'George Wilson', 'Parent', 7778889999),
(8, 'Hannah Martin', 'Friend', 8889990000);

-- Get the number of emergencies handled by each responder.
SELECT r.responder_id, r.name, COUNT(d.dispatch_id) AS total_emergencies
FROM responders r
LEFT JOIN dispatch d ON r.responder_id = d.responder_id
GROUP BY r.responder_id, r.name;

-- Retrieve all available responders for a given role.
SELECT * 
FROM responders 
WHERE status = 'Available' AND role = 'Police';

-- Find the response time for each emergency request.
SELECT request_id, DATEDIFF(MINUTE, dispatch_time, response_time) AS response_time_minutes
FROM dispatch;

-- List all emergency requests along with responder details.
SELECT er.*, r.name AS responder_name, r.role 
FROM emergency_requests er
LEFT JOIN dispatch d ON er.request_id = d.request_id
LEFT JOIN responders r ON d.responder_id = r.responder_id;

-- Get the details of users who have made the most emergency calls.
SELECT TOP 4 u.user_id, u.name, COUNT(er.request_id) AS total_requests
FROM users u
JOIN emergency_requests er ON u.user_id = er.user_id
GROUP BY u.user_id, u.name
ORDER BY total_requests DESC;

-- Show the average response time for different types of incidents.
SELECT er.incident_type, AVG(DATEDIFF(MINUTE, d.dispatch_time, d.response_time)) AS avg_response_time
FROM emergency_requests er
JOIN dispatch d ON er.request_id = d.request_id
GROUP BY er.incident_type;

-- Retrieve the most common emergency types.
SELECT incident_type, COUNT(*) AS occurrence_count
FROM emergency_requests
GROUP BY incident_type
ORDER BY occurrence_count DESC;

-- Retrieve the latest five emergency incidents along with their assigned responders.
SELECT TOP 3 er.*, r.name AS responder_name, r.role
FROM emergency_requests er
LEFT JOIN dispatch d ON er.request_id = d.request_id
LEFT JOIN responders r ON d.responder_id = r.responder_id
ORDER BY er.timestamp DESC;

-- Get a list of responders who were assigned an emergency but did not mark it as resolved.
SELECT r.*
FROM responders r
JOIN dispatch d ON r.responder_id = d.responder_id
WHERE d.resolution_status NOT IN ('Resolved');

-- Retrieve a list of vehicles currently in use along with their assigned responders.
SELECT v.*, r.name AS assigned_responder
FROM vehicles v
JOIN responder_vehicles rv ON v.vehicle_id = rv.vehicle_id
JOIN responders r ON rv.responder_id = r.responder_id
WHERE v.status = 'In Use';

-- Find the busiest time of day for emergency requests.
SELECT DATEPART(HOUR, timestamp) AS hour_of_day, COUNT(*) AS total_requests
FROM emergency_requests
GROUP BY DATEPART(HOUR, timestamp)
ORDER BY total_requests DESC;

-- Show the percentage of emergency cases successfully resolved within 30 minutes.
SELECT 
    (COUNT(*) * 100.0) / (SELECT COUNT(*) FROM dispatch) AS resolved_within_30_percent
FROM dispatch
WHERE DATEDIFF(MINUTE, dispatch_time, response_time) <= 30;

-- Retrieve the top three most frequently occurring emergency incidents.
SELECT TOP 3 incident_type, COUNT(*) AS occurrence_count
FROM emergency_requests
GROUP BY incident_type
ORDER BY occurrence_count DESC;

-- List all emergency requests that had a response time greater than 15 minutes.
SELECT er.*, d.response_time, DATEDIFF(MINUTE, d.dispatch_time, d.response_time) AS response_duration
FROM emergency_requests er
JOIN dispatch d ON er.request_id = d.request_id
WHERE DATEDIFF(MINUTE, d.dispatch_time, d.response_time) > 15;

-- Find the responder with the fastest average response time.
SELECT TOP 1 r.responder_id, r.name, AVG(DATEDIFF(MINUTE, d.dispatch_time, d.response_time)) AS avg_response_time
FROM responders r
JOIN dispatch d ON r.responder_id = d.responder_id
GROUP BY r.responder_id, r.name
ORDER BY avg_response_time ASC;

-- Retrieve the total number of emergency requests handled per month.
SELECT DATEPART(YEAR, timestamp) AS year, DATEPART(MONTH, timestamp) AS month, COUNT(*) AS total_requests
FROM emergency_requests
GROUP BY DATEPART(YEAR, timestamp), DATEPART(MONTH, timestamp)
ORDER BY year DESC, month DESC;

-- Find the top 5 most frequent emergency callers.
SELECT TOP 5 u.user_id, u.name, COUNT(er.request_id) AS total_requests
FROM users u
JOIN emergency_requests er ON u.user_id = er.user_id
GROUP BY u.user_id, u.name
ORDER BY total_requests DESC;

-- Find responders who have been assigned to the highest number of emergency requests.
SELECT TOP 5 r.responder_id, r.name, COUNT(d.dispatch_id) AS total_assigned_requests
FROM responders r
JOIN dispatch d ON r.responder_id = d.responder_id
GROUP BY r.responder_id, r.name
ORDER BY total_assigned_requests DESC;

-- Get a list of responders currently available for new dispatches.
SELECT * 
FROM responders 
WHERE status = 'Available';

-- Identify which vehicles are currently in maintenance or unavailable.
SELECT * 
FROM vehicles 
WHERE status IN ('Maintenance', 'In Use');

-- Find out which type of emergency occurs most frequently in a given city/area.
SELECT incident_location, incident_type, COUNT(*) AS count
FROM emergency_requests
GROUP BY incident_location, incident_type
ORDER BY count DESC;

-- Get a summary of dispatches that resulted in unresolved or pending statuses.
SELECT * 
FROM dispatch 
WHERE resolution_status IN ('Pending', 'Unresolved');
