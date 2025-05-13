-- Creating the database
CREATE DATABASE Railway_Reservation;
USE Railway_Reservation;

-- Passengers Table
CREATE TABLE Passengers (
    passenger_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    phone_number VARCHAR(15) UNIQUE,
    email VARCHAR(100) UNIQUE,
    address TEXT
);

-- Trains Table
CREATE TABLE Trains (
    train_id INT AUTO_INCREMENT PRIMARY KEY,
    train_name VARCHAR(100) NOT NULL,
    source_station VARCHAR(100) NOT NULL,
    destination_station VARCHAR(100) NOT NULL,
    departure_time TIME NOT NULL,
    arrival_time TIME NOT NULL,
    train_type ENUM('Express', 'Superfast', 'Local') NOT NULL,
    total_seats INT NOT NULL,
    available_seats INT NOT NULL
);

-- Stations Table
CREATE TABLE Stations (
    station_id INT AUTO_INCREMENT PRIMARY KEY,
    station_name VARCHAR(100) NOT NULL UNIQUE,
    location VARCHAR(255) NOT NULL
);

-- Train Routes Table (Mapping Trains to Stations)
CREATE TABLE Train_Routes (
    route_id INT AUTO_INCREMENT PRIMARY KEY,
    train_id INT,
    station_id INT,
    arrival_time TIME NOT NULL,
    departure_time TIME NOT NULL,
    FOREIGN KEY (train_id) REFERENCES Trains(train_id) ON DELETE CASCADE,
    FOREIGN KEY (station_id) REFERENCES Stations(station_id) ON DELETE CASCADE
);

-- Seats Table (Train-wise Seat Allocation)
CREATE TABLE Seats (
    seat_id INT AUTO_INCREMENT PRIMARY KEY,
    train_id INT,
    coach_number VARCHAR(10) NOT NULL,
    seat_number VARCHAR(10) NOT NULL,
    class ENUM('General', 'Sleeper', 'AC') NOT NULL,
    status ENUM('Available', 'Booked') DEFAULT 'Available',
    FOREIGN KEY (train_id) REFERENCES Trains(train_id) ON DELETE CASCADE
);

-- Bookings Table (Ticket Reservations)
CREATE TABLE Bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    passenger_id INT,
    train_id INT,
    seat_id INT,
    journey_date DATE NOT NULL,
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_status ENUM('Paid', 'Pending', 'Canceled') DEFAULT 'Pending',
    ticket_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id) ON DELETE CASCADE,
    FOREIGN KEY (train_id) REFERENCES Trains(train_id) ON DELETE CASCADE,
    FOREIGN KEY (seat_id) REFERENCES Seats(seat_id) ON DELETE SET NULL
);

-- Payments Table
CREATE TABLE Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT,
    payment_mode ENUM('Credit Card', 'Debit Card', 'UPI', 'Net Banking', 'Cash') NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_status ENUM('Success', 'Failed', 'Pending') DEFAULT 'Pending',
    FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id) ON DELETE CASCADE
);

-- Users Table (For Admins and Clerks)
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('Admin', 'Clerk') NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

-- Insert data into Passengers table
INSERT INTO Passengers (name, age, gender, phone_number, email, address) VALUES
('Rahul Sharma', 28, 'Male', '9876543210', 'rahul@gmail.com', 'Mumbai, India'),
('Priya Verma', 24, 'Female', '9876543211', 'priya@gmail.com', 'Delhi, India'),
('Amit Patel', 35, 'Male', '9876543212', 'amit@gmail.com', 'Ahmedabad, India'),
('Sneha Kapoor', 30, 'Female', '9876543213', 'sneha@gmail.com', 'Pune, India'),
('Vikram Singh', 40, 'Male', '9876543214', 'vikram@gmail.com', 'Jaipur, India');

-- Insert data into Trains table
INSERT INTO Trains (train_name, source_station, destination_station, departure_time, arrival_time, train_type, total_seats, available_seats) VALUES
('Rajdhani Express', 'Mumbai', 'Delhi', '18:00:00', '10:00:00', 'Express', 500, 450),
('Shatabdi Express', 'Delhi', 'Chandigarh', '06:00:00', '09:30:00', 'Express', 400, 370),
('Duronto Express', 'Kolkata', 'Mumbai', '20:00:00', '12:00:00', 'Superfast', 600, 580),
('Garib Rath', 'Chennai', 'Hyderabad', '22:00:00', '07:00:00', 'Express', 450, 420),
('Intercity Express', 'Bangalore', 'Mysore', '07:30:00', '10:00:00', 'Local', 300, 250);

-- Insert data into Stations table
INSERT INTO Stations (station_name, location) VALUES
('Mumbai Central', 'Mumbai'),
('New Delhi', 'Delhi'),
('Howrah Junction', 'Kolkata'),
('Chennai Central', 'Chennai'),
('Bangalore City', 'Bangalore');

-- Insert data into Train_Routes table
INSERT INTO Train_Routes (train_id, station_id, arrival_time, departure_time) VALUES
(1, 1, '17:50:00', '18:00:00'),
(1, 2, '09:50:00', '10:00:00'),
(2, 2, '05:50:00', '06:00:00'),
(2, 3, '09:20:00', '09:30:00'),
(3, 3, '19:50:00', '20:00:00');

-- Insert data into Seats table
INSERT INTO Seats (train_id, coach_number, seat_number, class, status) VALUES
(1, 'A1', '21', 'AC', 'Available'),
(1, 'A1', '22', 'AC', 'Booked'),
(2, 'S1', '45', 'Sleeper', 'Available'),
(3, 'G2', '11', 'General', 'Booked'),
(4, 'A2', '34', 'AC', 'Available');

-- Insert data into Bookings table
INSERT INTO Bookings (passenger_id, train_id, seat_id, journey_date, payment_status, ticket_price) VALUES
(1, 1, 2, '2025-03-10', 'Paid', 2500.00),
(2, 2, 3, '2025-03-15', 'Pending', 1500.00),
(3, 3, 4, '2025-03-12', 'Paid', 3200.00),
(4, 4, 5, '2025-03-20', 'Canceled', 1800.00),
(5, 5, NULL, '2025-03-25', 'Pending', 900.00);

-- Insert data into Payments table
INSERT INTO Payments (booking_id, payment_mode, amount, payment_status) VALUES
(1, 'Credit Card', 2500.00, 'Success'),
(2, 'UPI', 1500.00, 'Pending'),
(3, 'Debit Card', 3200.00, 'Success'),
(4, 'Net Banking', 1800.00, 'Failed'),
(5, 'Cash', 900.00, 'Pending');

-- Insert data into Users table
INSERT INTO Users (username, password, role, email) VALUES
('admin1', 'admin123', 'Admin', 'admin1@railway.com'),
('admin2', 'admin456', 'Admin', 'admin2@railway.com'),
('clerk1', 'clerk123', 'Clerk', 'clerk1@railway.com'),
('clerk2', 'clerk456', 'Clerk', 'clerk2@railway.com'),
('clerk3', 'clerk789', 'Clerk', 'clerk3@railway.com');

-- Find the names of all passengers who have booked a ticket on a specific train.
SELECT p.name, p.phone_number, p.email, b.journey_date
FROM Passengers p
JOIN Bookings b ON p.passenger_id = b.passenger_id
JOIN Trains t ON b.train_id = t.train_id
WHERE t.train_name = 'Rajdhani Express';

-- Find the total revenue generated from ticket bookings for a given train on a specific date.
SELECT t.train_name, SUM(b.ticket_price) AS total_revenue
FROM Bookings b
JOIN Trains t ON b.train_id = t.train_id
WHERE t.train_name = 'Rajdhani Express' 
AND b.journey_date = '2025-03-10';

-- Check the number of available seats in a particular train for a given date.
SELECT COUNT(*) AS available_seats
FROM Seats s
JOIN Trains t ON s.train_id = t.train_id
WHERE t.train_name = 'Rajdhani Express'
AND s.status = 'Available';

-- List all trains stopping at a particular station.
SELECT t.train_name, tr.arrival_time, tr.departure_time
FROM Train_Routes tr
JOIN Trains t ON tr.train_id = t.train_id
JOIN Stations s ON tr.station_id = s.station_id
WHERE s.station_name = 'New Delhi';

-- Find all passengers who booked a ticket but haven't made the payment yet.
SELECT p.name, p.phone_number, p.email, b.booking_id
FROM Passengers p
JOIN Bookings b ON p.passenger_id = b.passenger_id
LEFT JOIN Payments pay ON b.booking_id = pay.booking_id
WHERE b.payment_status = 'Pending' OR pay.payment_status = 'Pending';

-- Get the details of all bookings made by a specific passenger.
SELECT b.booking_id, t.train_name, b.journey_date, b.ticket_price, b.payment_status
FROM Bookings b
JOIN Trains t ON b.train_id = t.train_id
JOIN Passengers p ON b.passenger_id = p.passenger_id
WHERE p.name = 'Rahul Sharma';

-- Show a list of all stations covered by a particular train along with arrival and departure times.
SELECT s.station_name, tr.arrival_time, tr.departure_time
FROM Train_Routes tr
JOIN Stations s ON tr.station_id = s.station_id
JOIN Trains t ON tr.train_id = t.train_id
WHERE t.train_name = 'Rajdhani Express'
ORDER BY tr.arrival_time;

-- Find out which trains have the maximum number of available seats for a given route.
SELECT t.train_name, COUNT(s.seat_id) AS available_seats
FROM Seats s
JOIN Trains t ON s.train_id = t.train_id
WHERE s.status = 'Available'
GROUP BY t.train_name
ORDER BY available_seats DESC
LIMIT 1;

-- Generate a report of total bookings and revenue per train.
SELECT t.train_name, COUNT(b.booking_id) AS total_bookings, SUM(b.ticket_price) AS total_revenue
FROM Bookings b
JOIN Trains t ON b.train_id = t.train_id
GROUP BY t.train_name
ORDER BY total_revenue DESC;

-- Find the Most Popular Train (Most Bookings)
SELECT t.train_name, COUNT(b.booking_id) AS total_bookings
FROM Bookings b
JOIN Trains t ON b.train_id = t.train_id
GROUP BY t.train_name
ORDER BY total_bookings DESC
LIMIT 1;

-- Get the Total Number of Bookings Per Passenger
SELECT p.name, COUNT(b.booking_id) AS total_bookings
FROM Passengers p
LEFT JOIN Bookings b ON p.passenger_id = b.passenger_id
GROUP BY p.name
ORDER BY total_bookings DESC;

-- Find the Average Ticket Price for Each Train 
SELECT t.train_name, AVG(b.ticket_price) AS avg_ticket_price
FROM Bookings b
JOIN Trains t ON b.train_id = t.train_id
GROUP BY t.train_name
ORDER BY avg_ticket_price DESC;

-- Find the Passengers Who Have Traveled the Most (Frequent Travelers)
SELECT p.name, COUNT(b.booking_id) AS total_trips
FROM Passengers p
JOIN Bookings b ON p.passenger_id = b.passenger_id
GROUP BY p.name
ORDER BY total_trips DESC
LIMIT 5;
