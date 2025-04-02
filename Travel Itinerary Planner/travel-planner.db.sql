CREATE DATABASE travel_planner;

-- Users Table 
CREATE TABLE users (
  user_id INT IDENTITY(1,1) PRIMARY KEY,
  name VARCHAR(20),
  email VARCHAR(20) UNIQUE,
  phone BIGINT
);

 -- Trips Table 
 CREATE TABLE trips (
   trip_id INT IDENTITY(1,1) PRIMARY KEY,
   user_id INT,
   trip_name VARCHAR(20),
   start_date DATETIME,
   end_date DATETIME,
   destination VARCHAR(20),
   FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Destinations Table 
CREATE TABLE destinations (
  destination_id INT IDENTITY(1,1) PRIMARY KEY,
  trip_id INT,
  location_name VARCHAR(20),
  country VARCHAR(20),
  latitude DECIMAL(10, 8),
  longitude DECIMAL(11, 8),  
  FOREIGN KEY (trip_id) REFERENCES trips(trip_id)
);

-- Activities Table  
CREATE TABLE activities (
  activity_id INT IDENTITY(1,1) PRIMARY KEY,
  destination_id INT,
  activity_name VARCHAR(20),
  activity_type VARCHAR(20),
  date_time DATETIME,
  FOREIGN KEY (destination_id) REFERENCES destinations(destination_id)
);

-- Accommodations Table 
CREATE TABLE accommodations (
  accommodation_id INT IDENTITY(1,1) PRIMARY KEY,
  trip_id INT,
  hotel_name VARCHAR(20),
  check_in_date DATE,
  check_out_date DATE,
  FOREIGN KEY (trip_id) REFERENCES trips(trip_id)
);

-- Transport Table  
CREATE TABLE transport (
  transport_id INT IDENTITY(1,1) PRIMARY KEY,
  trip_id INT,
  mode_of_transport VARCHAR(10),
  departure_time TIME,
  arrival_time TIME,
  source_location VARCHAR(20),
  destination_location VARCHAR(20),
  FOREIGN KEY (trip_id) REFERENCES trips(trip_id)
);

-- Expenses Table  
CREATE TABLE expenses (
  expense_id INT IDENTITY(1,1) PRIMARY KEY,
  trip_id INT,
  expense_type VARCHAR(20),
  amount INT,
  date DATE,
  FOREIGN KEY (trip_id) REFERENCES trips(trip_id)
);  

-- Insert sample users
INSERT INTO users (name, email, phone) 
VALUES 
('Alice Johnson', 'alice@example.com', 1234567890),
('Bob Smith', 'bob@example.com', 2345678901),
('Charlie Brown', 'charlie@example.com', 3456789012);

-- Insert sample trips
INSERT INTO trips (user_id, trip_name, start_date, end_date, destination) 
VALUES 
(1, 'Paris Vacation', '2024-06-01 10:00:00', '2024-06-10 22:00:00', 'Paris'),
(2, 'Tokyo Adventure', '2024-07-05 08:00:00', '2024-07-15 23:59:00', 'Tokyo'),
(3, 'NYC Getaway', '2024-08-10 12:00:00', '2024-08-18 20:00:00', 'New York');

-- Insert sample destinations
INSERT INTO destinations (trip_id, location_name, country, latitude, longitude) 
VALUES 
(1, 'Eiffel Tower', 'France', 48.8584, 2.2945),
(1, 'Louvre Museum', 'France', 48.8606, 2.3376),
(2, 'Shibuya Crossing', 'Japan', 35.6595, 139.7005),
(3, 'Central Park', 'USA', 40.7851, -73.9683);

-- Insert sample activities
INSERT INTO activities (destination_id, activity_name, activity_type, date_time) 
VALUES 
(1, 'Sightseeing', 'Tour', '2024-06-02 14:00:00'),
(2, 'Art Tour', 'Museum Visit', '2024-06-03 11:00:00'),
(3, 'Street Exploration', 'Walking', '2024-07-06 17:00:00'),
(4, 'Picnic', 'Outdoor', '2024-08-12 13:00:00');

-- Insert sample accommodations
INSERT INTO accommodations (trip_id, hotel_name, check_in_date, check_out_date) 
VALUES 
(1, 'Hotel Paris', '2024-06-01', '2024-06-10'),
(2, 'Tokyo Inn', '2024-07-05', '2024-07-15'),
(3, 'NY Grand', '2024-08-10', '2024-08-18');

-- Insert sample transport
INSERT INTO transport (trip_id, mode_of_transport, departure_time, arrival_time, source_location, destination_location) 
VALUES 
(1, 'Flight', '06:00:00', '10:00:00', 'New York', 'Paris'),
(2, 'Train', '09:30:00', '11:30:00', 'Osaka', 'Tokyo'),
(3, 'Flight', '07:00:00', '11:00:00', 'Los Angeles', 'New York');

-- Insert sample expenses
INSERT INTO expenses (trip_id, expense_type, amount, date) 
VALUES 
(1, 'Food', 200, '2024-06-02'),
(1, 'Tickets', 150, '2024-06-03'),
(2, 'Transport', 300, '2024-07-06'),
(3, 'Accommodation', 1200, '2024-08-10');

-- Retrieve all trips along with the user details who planned them.
SELECT t.trip_id, t.trip_name, t.start_date, t.end_date, t.destination, 
       u.user_id, u.name, u.email, u.phone
FROM trips t
JOIN users u ON t.user_id = u.user_id;

-- List all destinations for a given trip.
SELECT d.destination_id, d.location_name, d.country, d.latitude, d.longitude
FROM destinations d
WHERE d.trip_id = 2;

-- Find all activities scheduled for a specific destination.
SELECT a.activity_id, a.activity_name, a.activity_type, a.date_time
FROM activities a
WHERE a.destination_id = 1;

-- Get all accommodations for a trip with their check-in and check-out dates.
SELECT a.accommodation_id, a.hotel_name, a.check_in_date, a.check_out_date
FROM accommodations a
WHERE a.trip_id = 3;

-- Show all transport modes used in a specific trip along with their departure and arrival times.
SELECT t.transport_id, t.mode_of_transport, t.departure_time, t.arrival_time, 
       t.source_location, t.destination_location
FROM transport t
WHERE t.trip_id = 2;

-- Retrieve the total expense for a specific trip.
SELECT SUM(e.amount) AS total_expense
FROM expenses e
WHERE e.trip_id = 3;

-- Find the most popular destination based on the number of trips.
SELECT TOP 1 d.location_name, d.country, COUNT(t.trip_id) AS trip_count
FROM destinations d
JOIN trips t ON d.trip_id = t.trip_id
GROUP BY d.location_name, d.country
ORDER BY trip_count DESC;

-- List all users who have planned more than 3 trips.
SELECT u.user_id, u.name, COUNT(t.trip_id) AS trip_count
FROM users u
JOIN trips t ON u.user_id = t.user_id
GROUP BY u.user_id, u.name
HAVING COUNT(t.trip_id) > 3;

-- Get the upcoming activities for a given trip sorted by date.
SELECT a.activity_id, a.activity_name, a.activity_type, a.date_time
FROM activities a
JOIN destinations d ON a.destination_id = d.destination_id
WHERE d.trip_id = 1
AND a.date_time >= GETDATE() 
ORDER BY a.date_time ASC;

-- Find the average expense per trip for a user.
SELECT u.user_id, u.name, AVG(total_expense) AS avg_expense_per_trip
FROM users u
JOIN (
    SELECT t.user_id, t.trip_id, SUM(e.amount) AS total_expense
    FROM trips t
    JOIN expenses e ON t.trip_id = e.trip_id
    GROUP BY t.user_id, t.trip_id
) trip_expenses ON u.user_id = trip_expenses.user_id
WHERE u.user_id = 3
GROUP BY u.user_id, u.name;