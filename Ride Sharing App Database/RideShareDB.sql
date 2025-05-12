-- Project in PostgreSQL 
-- Create Database
CREATE DATABASE RideShareDB;
\c RideShareDB;

-- Users Table (Stores both passengers and drivers)
CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(20) UNIQUE NOT NULL,
    user_type VARCHAR(10) CHECK (user_type IN ('driver', 'passenger')) NOT NULL,
    rating DECIMAL(3,2) DEFAULT 5.0 CHECK (rating BETWEEN 1.0 AND 5.0)
);

-- Vehicles Table
CREATE TABLE Vehicles (
    vehicle_id SERIAL PRIMARY KEY,
    driver_id INT UNIQUE, -- One vehicle per driver
    vehicle_type VARCHAR(50) NOT NULL,
    plate_number VARCHAR(20) UNIQUE NOT NULL,
    FOREIGN KEY (driver_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Drivers Table (Extends Users)
CREATE TABLE Drivers (
    driver_id INT PRIMARY KEY,
    license_number VARCHAR(50) UNIQUE NOT NULL,
    vehicle_id INT UNIQUE,
    total_rides INT DEFAULT 0,
    FOREIGN KEY (driver_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id) ON DELETE SET NULL
);

-- Rides Table
CREATE TABLE Rides (
    ride_id SERIAL PRIMARY KEY,
    passenger_id INT NOT NULL,
    driver_id INT NOT NULL,
    pickup_location VARCHAR(255) NOT NULL,
    dropoff_location VARCHAR(255) NOT NULL,
    fare DECIMAL(10,2) NOT NULL CHECK (fare >= 0),
    ride_status VARCHAR(20) CHECK (ride_status IN ('requested', 'ongoing', 'completed', 'canceled')) NOT NULL DEFAULT 'requested',
    timestamp TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (passenger_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (driver_id) REFERENCES Drivers(driver_id) ON DELETE CASCADE
);

-- Payments Table
CREATE TABLE Payments (
    payment_id SERIAL PRIMARY KEY,
    ride_id INT NOT NULL,
    user_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL CHECK (amount >= 0),
    payment_method VARCHAR(10) CHECK (payment_method IN ('card', 'cash', 'wallet')) NOT NULL,
    status VARCHAR(10) CHECK (status IN ('pending', 'completed', 'failed')) NOT NULL DEFAULT 'pending',
    timestamp TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (ride_id) REFERENCES Rides(ride_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Ride Requests Table
CREATE TABLE Ride_Requests (
    request_id SERIAL PRIMARY KEY,
    passenger_id INT NOT NULL,
    pickup_location VARCHAR(255) NOT NULL,
    dropoff_location VARCHAR(255) NOT NULL,
    status VARCHAR(10) CHECK (status IN ('pending', 'accepted', 'canceled')) NOT NULL DEFAULT 'pending',
    timestamp TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (passenger_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Ratings & Reviews Table
CREATE TABLE Ratings (
    review_id SERIAL PRIMARY KEY,
    ride_id INT NOT NULL,
    reviewer_id INT NOT NULL,
    reviewee_id INT NOT NULL,
    rating DECIMAL(3,2) CHECK (rating BETWEEN 1.0 AND 5.0),
    comments TEXT,
    timestamp TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (ride_id) REFERENCES Rides(ride_id) ON DELETE CASCADE,
    FOREIGN KEY (reviewer_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (reviewee_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

INSERT INTO Users (name, email, phone_number, user_type, rating) VALUES
('Alice', 'alice@example.com', '1234567890', 'passenger', 4.5),
('Bob', 'bob@example.com', '1234567891', 'driver', 4.8),
('Charlie', 'charlie@example.com', '1234567892', 'passenger', 4.2),
('Dave', 'dave@example.com', '1234567893', 'driver', 4.6);

-- Insert data into Vehicles table
INSERT INTO Vehicles (driver_id, vehicle_type, plate_number) VALUES
(2, 'Sedan', 'XYZ1234'),
(4, 'SUV', 'ABC5678');

-- Insert data into Drivers table
INSERT INTO Drivers (driver_id, license_number, vehicle_id, total_rides) VALUES
(2, 'DL12345', 1, 50),
(4, 'DL67890', 2, 30);

-- Insert data into Rides table
INSERT INTO Rides (passenger_id, driver_id, pickup_location, dropoff_location, fare, ride_status, timestamp) VALUES
(1, 2, 'Location A', 'Location B', 15.00, 'completed', NOW()),
(3, 4, 'Location C', 'Location D', 20.50, 'ongoing', NOW());

-- Insert data into Payments table
INSERT INTO Payments (ride_id, user_id, amount, payment_method, status, timestamp) VALUES
(1, 1, 15.00, 'card', 'completed', NOW()),
(2, 3, 20.50, 'cash', 'pending', NOW());

-- Insert data into Ride Requests table
INSERT INTO Ride_Requests (passenger_id, pickup_location, dropoff_location, status, timestamp) VALUES
(1, 'Location A', 'Location B', 'pending', NOW()),
(3, 'Location C', 'Location D', 'accepted', NOW());

-- Insert data into Ratings table
INSERT INTO Ratings (ride_id, reviewer_id, reviewee_id, rating, comments, timestamp) VALUES
(1, 1, 2, 4.5, 'Great ride!', NOW()),
(2, 3, 4, 4.8, 'Smooth and safe journey.', NOW());

-- Find all completed rides for a given passenger.
SELECT * 
FROM Rides 
WHERE passenger_id = 1 AND ride_status = 'completed';

-- List the top 5 highest-rated drivers.
SELECT user_id, name, rating 
FROM Users 
WHERE user_type = 'driver' 
ORDER BY rating DESC 
LIMIT 5;

-- Get the total earnings of a driver in the last month.
SELECT d.driver_id, u.name AS driver_name, COALESCE(SUM(p.amount), 0) AS total_earnings
FROM Drivers d
JOIN Users u ON d.driver_id = u.user_id
JOIN Rides r ON d.driver_id = r.driver_id
JOIN Payments p ON r.ride_id = p.ride_id
WHERE p.status = 'completed' AND p.timestamp >= NOW() - INTERVAL '1 month'
AND d.driver_id = 2
GROUP BY d.driver_id, u.name;

-- Show the most common pickup locations.
SELECT pickup_location, COUNT(*) AS ride_count
FROM Rides
GROUP BY pickup_location
ORDER BY ride_count DESC
LIMIT 5;

-- Retrieve pending ride requests for a specific passenger.
SELECT * 
FROM Ride_Requests 
WHERE passenger_id = 1 AND status = 'pending';

-- Find the average fare of completed rides per month.
SELECT DATE_TRUNC('month', timestamp) AS month, AVG(fare) AS avg_fare
FROM Rides
WHERE ride_status = 'completed'
GROUP BY month
ORDER BY month DESC;

-- Get the total number of rides taken by each passenger.
SELECT u.user_id, u.name, COUNT(r.ride_id) AS total_rides
FROM Users u
JOIN Rides r ON u.user_id = r.passenger_id
GROUP BY u.user_id, u.name
ORDER BY total_rides DESC;

-- Retrieve a list of drivers who have completed more than 30 rides.
SELECT d.driver_id, u.name, d.total_rides
FROM Drivers d
JOIN Users u ON d.driver_id = u.user_id
WHERE d.total_rides > 30
ORDER BY d.total_rides DESC;

-- Find the most frequently used payment method.
SELECT payment_method, COUNT(*) AS usage_count
FROM Payments
GROUP BY payment_method
ORDER BY usage_count DESC
LIMIT 1;

-- Find the total number of rides completed by each driver
SELECT d.driver_id, u.name AS driver_name, COUNT(r.ride_id) AS completed_rides
FROM Drivers d
JOIN Users u ON d.driver_id = u.user_id
JOIN Rides r ON d.driver_id = r.driver_id
WHERE r.ride_status = 'completed'
GROUP BY d.driver_id, u.name
ORDER BY completed_rides DESC;

-- Get the average rating of each driver
SELECT u.user_id AS driver_id, u.name AS driver_name, AVG(rt.rating) AS avg_rating
FROM Users u
JOIN Ratings rt ON u.user_id = rt.reviewee_id
WHERE u.user_type = 'driver'
GROUP BY u.user_id, u.name
ORDER BY avg_rating DESC;

-- Retrieve the drivers who have received the most reviews
SELECT u.user_id AS driver_id, u.name AS driver_name, COUNT(rt.review_id) AS total_reviews
FROM Users u
JOIN Ratings rt ON u.user_id = rt.reviewee_id
WHERE u.user_type = 'driver'
GROUP BY u.user_id, u.name
ORDER BY total_reviews DESC
LIMIT 5;

-- Show the top 5 highest-paying passengers (based on total amount spent)
SELECT u.user_id AS passenger_id, u.name AS passenger_name, COALESCE(SUM(p.amount), 0) AS total_spent
FROM Users u
JOIN Payments p ON u.user_id = p.user_id
WHERE p.status = 'completed'
GROUP BY u.user_id, u.name
ORDER BY total_spent DESC
LIMIT 5;