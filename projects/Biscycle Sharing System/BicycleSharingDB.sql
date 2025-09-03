-- Project in PostgreSQL 
-- Create Database
CREATE DATABASE BicycleSharingDB;
\c BicycleSharingDB;

CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone_number VARCHAR(15),
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Stations (
    station_id SERIAL PRIMARY KEY,
    station_name VARCHAR(100),
    location VARCHAR(255)
);

CREATE TABLE Bicycles (
    bike_id SERIAL PRIMARY KEY,
    bike_type VARCHAR(50),
    status VARCHAR(50) CHECK (status IN ('Available', 'In Use', 'Under Maintenance')),
    current_station_id INT REFERENCES Stations(station_id) ON DELETE SET NULL
);

CREATE TABLE Trips (
    trip_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id) ON DELETE CASCADE,
    bike_id INT REFERENCES Bicycles(bike_id) ON DELETE CASCADE,
    start_station_id INT REFERENCES Stations(station_id) ON DELETE SET NULL,
    end_station_id INT REFERENCES Stations(station_id) ON DELETE SET NULL,
    start_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    end_time TIMESTAMP,
    fare DECIMAL(10,2)
);

CREATE TABLE Payments (
    payment_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id) ON DELETE CASCADE,
    trip_id INT REFERENCES Trips(trip_id) ON DELETE SET NULL,
    amount DECIMAL(10,2),
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method VARCHAR(50) CHECK (payment_method IN ('Card', 'Cash', 'Online'))
);

INSERT INTO Users (name, email, phone_number) VALUES
('Alice Johnson', 'alice@email.com', '1234567890'),
('Bob Smith', 'bob@email.com', '2345678901'),
('Charlie Brown', 'charlie@email.com', '3456789012'),
('David White', 'david@email.com', '4567890123'),
('Emma Wilson', 'emma@email.com', '5678901234');

INSERT INTO Stations (station_name, location) VALUES
('Central Park', 'NY, USA'),
('Downtown Hub', 'NY, USA'),
('Uptown Plaza', 'NY, USA'),
('City Hall Station', 'NY, USA'),
('East Side Station', 'NY, USA');

INSERT INTO Bicycles (bike_type, status, current_station_id) VALUES
('Standard', 'Available', 1),
('Electric', 'In Use', 2),
('Standard', 'Available', 3),
('Electric', 'Under Maintenance', 2),
('Standard', 'Available', 4);

INSERT INTO Trips (user_id, bike_id, start_station_id, end_station_id, start_time, end_time, fare) VALUES
(1, 2, 1, 2, '2024-02-20 08:00:00', '2024-02-20 08:30:00', 5.50),
(2, 3, 2, 3, '2024-02-21 09:15:00', '2024-02-21 09:45:00', 6.00),
(3, 1, 4, 1, '2024-02-22 07:30:00', '2024-02-22 08:00:00', 4.75),
(4, 2, 1, 5, '2024-02-23 06:45:00', '2024-02-23 07:20:00', 7.25),
(5, 5, 3, 4, '2024-02-24 10:10:00', '2024-02-24 10:40:00', 5.00);

INSERT INTO Payments (user_id, trip_id, amount, payment_method) VALUES
(1, 1, 5.50, 'Card'),
(2, 2, 6.00, 'Online'),
(3, 3, 4.75, 'Cash'),
(4, 4, 7.25, 'Card'),
(5, 5, 5.00, 'Online');

-- Find the total number of bicycles available at each station
SELECT s.station_name, COUNT(b.bike_id) AS available_bikes
FROM Stations s
LEFT JOIN Bicycles b ON s.station_id = b.current_station_id
WHERE b.status = 'Available'
GROUP BY s.station_name;

-- Retrieve all trips taken by a specific user 
SELECT t.trip_id, u.name, t.start_station_id, t.end_station_id, t.start_time, t.end_time, t.fare
FROM Trips t
JOIN Users u ON t.user_id = u.user_id
WHERE u.name = 'Alice Johnson';

-- Find the most popular station based on the number of trips started
SELECT s.station_name, COUNT(t.trip_id) AS trip_count
FROM Trips t
JOIN Stations s ON t.start_station_id = s.station_id
GROUP BY s.station_name
ORDER BY trip_count DESC
LIMIT 1;

-- Find the total revenue generated in the last 30 days
SELECT SUM(amount) AS total_revenue
FROM Payments
WHERE payment_date >= NOW() - INTERVAL '30 days';

-- Find the busiest hour for bike rentals
SELECT EXTRACT(HOUR FROM start_time) AS rental_hour, COUNT(*) AS trip_count
FROM Trips
GROUP BY rental_hour
ORDER BY trip_count DESC
LIMIT 1;

-- Find the average trip fare
SELECT ROUND(AVG(fare), 2) AS average_fare
FROM Trips;

-- Find the top 3 users who have taken the most trips
SELECT u.user_id, u.name, COUNT(t.trip_id) AS total_trips
FROM Users u
JOIN Trips t ON u.user_id = t.user_id
GROUP BY u.user_id
ORDER BY total_trips DESC
LIMIT 3;

-- Find bicycles that have been used more than 1 times
SELECT b.bike_id, b.bike_type, COUNT(t.trip_id) AS trip_count
FROM Bicycles b
JOIN Trips t ON b.bike_id = t.bike_id
GROUP BY b.bike_id
HAVING COUNT(t.trip_id) > 1;

-- Find stations that currently have no available bicycles
SELECT s.station_id, s.station_name
FROM Stations s
LEFT JOIN Bicycles b ON s.station_id = b.current_station_id AND b.status = 'Available'
WHERE b.bike_id IS NULL;

-- Find all users who have paid more than $6 in total
SELECT u.user_id, u.name, SUM(p.amount) AS total_spent
FROM Users u
JOIN Payments p ON u.user_id = p.user_id
GROUP BY u.user_id
HAVING SUM(p.amount) > 6;

-- Find the user who has taken the longest trip (in minutes)
SELECT u.user_id, u.name, t.trip_id, 
       EXTRACT(EPOCH FROM (t.end_time - t.start_time)) / 60 AS trip_duration_minutes
FROM Users u
JOIN Trips t ON u.user_id = t.user_id
ORDER BY trip_duration_minutes DESC
LIMIT 1;

-- Find the most commonly used bicycle type
SELECT b.bike_type, COUNT(t.trip_id) AS usage_count
FROM Bicycles b
JOIN Trips t ON b.bike_id = t.bike_id
GROUP BY b.bike_type
ORDER BY usage_count DESC
LIMIT 1;

-- Find the most common payment method used
SELECT payment_method, COUNT(*) AS usage_count
FROM Payments
GROUP BY payment_method
ORDER BY usage_count DESC
LIMIT 1;

-- Find bicycles that have never been used in any trip
SELECT b.bike_id, b.bike_type, b.status
FROM Bicycles b
LEFT JOIN Trips t ON b.bike_id = t.bike_id
WHERE t.trip_id IS NULL;

-- Find the longest trip duration in minutes
SELECT trip_id, user_id, bike_id, 
       ROUND(EXTRACT(EPOCH FROM (end_time - start_time)) / 60) AS duration_minutes
FROM Trips
ORDER BY duration_minutes DESC
LIMIT 1;

-- Find the last trip taken by each user
SELECT DISTINCT ON (t.user_id) t.user_id, u.name, t.trip_id, t.start_time, t.end_time
FROM Trips t
JOIN Users u ON t.user_id = u.user_id
ORDER BY t.user_id, t.start_time DESC;

-- Find the user who has spent the most money
SELECT u.user_id, u.name, SUM(p.amount) AS total_spent
FROM Users u
JOIN Payments p ON u.user_id = p.user_id
GROUP BY u.user_id
ORDER BY total_spent DESC
LIMIT 1;