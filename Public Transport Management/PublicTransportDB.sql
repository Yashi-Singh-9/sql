-- Project in PostgreSQL 
-- Create Database
CREATE DATABASE PublicTransportDB;
\c PublicTransportDB;

-- Bus Table  
CREATE TABLE bus (
  bus_id SERIAL PRIMARY KEY,
  bus_number BIGINT,
  capacity INT,
  type VARCHAR(9) CHECK (type IN ('AC', 'Non-AC', 'Electric')),
  status VARCHAR(18) CHECK (status IN ('Active', 'Inactive', 'Under Maintenance'))
);

-- Route Table 
CREATE TABLE route (
  route_id SERIAL PRIMARY KEY,
  route_name VARCHAR(100),
  start_point VARCHAR(100),
  end_point VARCHAR(100),
  distance FLOAT
);

-- Bus Route Table 
CREATE TABLE bus_route (
  bus_route_id SERIAL PRIMARY KEY,
  bus_id INT,
  route_id INT,
  timing TIME,
  FOREIGN KEY (bus_id) REFERENCES bus(bus_id),
  FOREIGN KEY (route_id) REFERENCES route(route_id)
);

-- Driver Table  
CREATE TABLE driver (
  driver_id SERIAL PRIMARY KEY,
  driver_name VARCHAR(50),
  license_number VARCHAR(100) UNIQUE,
  phone BIGINT,
  experience_years INT 
);

-- Bus Assignment Table
CREATE TABLE bus_assignment (
  assignment_id SERIAL PRIMARY KEY,
  bus_id INT,
  driver_id INT,
  assigned_date DATE,
  shift VARCHAR(8) CHECK (shift IN ('Morning', 'Evening', 'Night')),
  FOREIGN KEY (bus_id) REFERENCES bus(bus_id),
  FOREIGN KEY (driver_id) REFERENCES driver(driver_id)
);

-- Passenger Table 
CREATE TABLE passenger (
  passenger_id SERIAL PRIMARY KEY,
  passenger_name VARCHAR(50),
  phone BIGINT UNIQUE,
  email VARCHAR(100) UNIQUE
);

-- Ticket Table 
CREATE TABLE ticket (
  ticket_id SERIAL PRIMARY KEY,
  passenger_id INT,
  bus_id INT,
  route_id INT,
  fare DECIMAL(4,2),
  booking_date DATE,
  FOREIGN KEY (passenger_id) REFERENCES passenger(passenger_id),
  FOREIGN KEY (bus_id) REFERENCES bus(bus_id),
  FOREIGN KEY (route_id) REFERENCES route(route_id)
);

-- Payment Table 
CREATE TABLE payments (
  payment_id SERIAL PRIMARY KEY,
  ticket_id INT,
  payment_method VARCHAR(6) CHECK (payment_method IN ('Cash', 'Card', 'Online')),
  amount DECIMAL(4,2),
  payment_status VARCHAR(8) CHECK (payment_status IN ('Paid', 'Pending')),
  FOREIGN KEY (ticket_id) REFERENCES ticket(ticket_id)
);  

-- Insert sample data into bus table
INSERT INTO bus (bus_number, capacity, type, status) VALUES
(101, 50, 'AC', 'Active'),
(102, 40, 'Non-AC', 'Inactive'),
(103, 45, 'Electric', 'Active'),
(104, 55, 'AC', 'Under Maintenance'),
(105, 60, 'Non-AC', 'Active');

-- Insert sample data into route table
INSERT INTO route (route_name, start_point, end_point, distance) VALUES
('Route A', 'Station X', 'Station Y', 12.5),
('Route B', 'Station Y', 'Station Z', 18.0),
('Route C', 'Station Z', 'Station W', 25.3),
('Route D', 'Station W', 'Station X', 30.2),
('Route E', 'Station X', 'Station Z', 22.7);

-- Insert sample data into bus_route table
INSERT INTO bus_route (bus_id, route_id, timing) VALUES
(1, 2, '08:30:00'),
(3, 1, '09:45:00'),
(5, 4, '11:00:00'),
(2, 3, '12:15:00'),
(4, 5, '14:30:00');

-- Insert sample data into driver table
INSERT INTO driver (driver_name, license_number, phone, experience_years) VALUES
('John Doe', 'LIC12345', 9876543210, 5),
('Jane Smith', 'LIC67890', 9876543221, 8),
('Michael Johnson', 'LIC11121', 9876543232, 10),
('Emily Davis', 'LIC31415', 9876543243, 6),
('Robert Brown', 'LIC16171', 9876543254, 7);

-- Insert sample data into bus_assignment table
INSERT INTO bus_assignment (bus_id, driver_id, assigned_date, shift) VALUES
(1, 2, '2025-02-20', 'Morning'),
(3, 4, '2025-02-21', 'Evening'),
(5, 1, '2025-02-22', 'Night'),
(2, 5, '2025-02-23', 'Morning'),
(4, 3, '2025-02-24', 'Evening');

-- Insert sample data into passenger table
INSERT INTO passenger (passenger_name, phone, email) VALUES
('Alice White', 9123456789, 'alice@example.com'),
('Bob Green', 9234567890, 'bob@example.com'),
('Charlie Black', 9345678901, 'charlie@example.com'),
('David Blue', 9456789012, 'david@example.com'),
('Emma Red', 9567890123, 'emma@example.com');

-- Insert sample data into ticket table
INSERT INTO ticket (passenger_id, bus_id, route_id, fare, booking_date) VALUES
(1, 3, 2, 15.50, '2025-02-15'),
(2, 1, 4, 12.75, '2025-02-16'),
(3, 5, 1, 18.00, '2025-02-17'),
(4, 2, 3, 20.25, '2025-02-18'),
(5, 4, 5, 22.50, '2025-02-19');

-- Insert sample data into payments table
INSERT INTO payments (ticket_id, payment_method, amount, payment_status) VALUES
(1, 'Cash', 15.50, 'Paid'),
(2, 'Card', 12.75, 'Pending'),
(3, 'Online', 18.00, 'Paid'),
(4, 'Cash', 20.25, 'Paid'),
(5, 'Card', 22.50, 'Pending');

-- Find all buses that have a capacity greater than 50.
SELECT * FROM bus WHERE capacity > 50;

-- List the routes with the longest distance.
SELECT * FROM route ORDER BY distance DESC LIMIT 1;

-- Find the total number of passengers who booked a ticket for a specific bus.
SELECT COUNT(*) AS total_passengers 
FROM ticket 
WHERE bus_id = 4;

-- Retrieve all drivers assigned to buses in the morning shift.
SELECT d.*
FROM driver d
JOIN bus_assignment ba ON d.driver_id = ba.driver_id
WHERE ba.shift = 'Morning';

-- Get details of buses that are currently under maintenance.
SELECT * FROM bus WHERE status = 'Under Maintenance';

-- Find the total revenue collected for a specific route.
SELECT SUM(fare) AS total_revenue 
FROM ticket 
WHERE route_id = 3;

-- Find all buses that operate on a particular route.
SELECT DISTINCT b.*
FROM bus b
JOIN bus_route br ON b.bus_id = br.bus_id
WHERE br.route_id = 5;

-- Retrieve the details of the last 3 payments made.
SELECT * FROM payments ORDER BY payment_id DESC LIMIT 3;

-- Get a count of buses assigned to each driver.
SELECT d.driver_id, d.driver_name, COUNT(ba.bus_id) AS total_buses
FROM driver d
LEFT JOIN bus_assignment ba ON d.driver_id = ba.driver_id
GROUP BY d.driver_id, d.driver_name;

-- List all tickets booked on a particular date.
SELECT * FROM ticket WHERE booking_date = '2025-02-17';

-- Find the bus and route details for a specific passenger’s ticket.
SELECT t.ticket_id, b.bus_number, r.route_name, r.start_point, r.end_point, t.fare, t.booking_date
FROM ticket t
JOIN bus b ON t.bus_id = b.bus_id
JOIN route r ON t.route_id = r.route_id
WHERE t.passenger_id = 5;

-- Get the total number of active buses in the system.
SELECT COUNT(*) AS active_buses 
FROM bus 
WHERE status = 'Active';

-- Find all drivers with more than 6 years of experience.
SELECT * FROM driver WHERE experience_years > 6;

-- Retrieve all unpaid tickets.
SELECT t.*
FROM ticket t
JOIN payments p ON t.ticket_id = p.ticket_id
WHERE p.payment_status = 'Pending';

-- Find the most frequently assigned driver (who has been assigned the most buses)
SELECT d.driver_id, d.driver_name, COUNT(ba.bus_id) AS total_assignments
FROM driver d
JOIN bus_assignment ba ON d.driver_id = ba.driver_id
GROUP BY d.driver_id, d.driver_name
ORDER BY total_assignments DESC
LIMIT 1;

-- Retrieve the details of passengers who have made online payments.
SELECT DISTINCT p.passenger_id, p.passenger_name, p.phone, p.email
FROM passenger p
JOIN ticket t ON p.passenger_id = t.passenger_id
JOIN payments pay ON t.ticket_id = pay.ticket_id
WHERE pay.payment_method = 'Online';
