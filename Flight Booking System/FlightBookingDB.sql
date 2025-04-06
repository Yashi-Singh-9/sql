CREATE DATABASE FlightBookingDB;
USE FlightBookingDB;

-- Users Table  
CREATE TABLE users (
  user_id INT IDENTITY(1,1) PRIMARY KEY,
  name VARCHAR(50),
  email VARCHAR(50) UNIQUE,
  phone VARCHAR(15),
  password VARCHAR(255),
  role VARCHAR(10) CHECK (role IN ('Passenger', 'Admin'))
);

-- Flights Table  
CREATE TABLE flights (
  flight_id INT IDENTITY(1,1) PRIMARY KEY,
  airline_name VARCHAR(20),
  source VARCHAR(20),
  destination VARCHAR(20),
  departure_time TIME,
  arrival_time TIME,
  total_seats INT,
  price INT
);

-- Airports Table  
CREATE TABLE airports (
  airport_id INT IDENTITY(1,1) PRIMARY KEY,
  airport_name VARCHAR(50),
  city VARCHAR(20),
  country VARCHAR(20)
);

-- Bookings Table  
CREATE TABLE bookings (
  booking_id INT IDENTITY(1,1) PRIMARY KEY,
  user_id INT,
  flight_id INT,
  booking_date DATETIME,
  status VARCHAR(10) CHECK (status IN ('Confirmed', 'Canceled', 'Pending')),
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (flight_id) REFERENCES flights(flight_id)
);

-- Passengers Table  
CREATE TABLE passengers (
  passenger_id INT IDENTITY(1,1) PRIMARY KEY,
  booking_id INT,
  name VARCHAR(50),
  age INT,
  passport_number VARCHAR(20),
  FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
);

-- Payments Table  
CREATE TABLE payments (
  payment_id INT IDENTITY(1,1) PRIMARY KEY,
  booking_id INT,
  amount INT,
  payment_status VARCHAR(10) CHECK (payment_status IN ('Success', 'Failed', 'Pending')),
  payment_date DATETIME,
  FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
);

-- Flight Schedule Table
CREATE TABLE flight_schedule (
  schedule_id INT IDENTITY(1,1) PRIMARY KEY,
  flight_id INT,
  airport_id INT,
  departure_date DATETIME,
  arrival_date DATETIME,
  FOREIGN KEY (airport_id) REFERENCES airports(airport_id),
  FOREIGN KEY (flight_id) REFERENCES flights(flight_id)
);

-- Users
INSERT INTO users (name, email, phone, password, role) VALUES
('John Doe', 'john.doe@example.com', '1234567890', 'pass123', 'Passenger'),
('Alice Smith', 'alice.smith@example.com', '9876543210', 'pass456', 'Admin'),
('Michael Brown', 'michael.b@example.com', '7412589630', 'pass789', 'Passenger'),
('Emily Davis', 'emily.d@example.com', '8529637410', 'pass012', 'Passenger'),
('Daniel Wilson', 'daniel.w@example.com', '9638527410', 'pass345', 'Passenger'),
('Sophia Martinez', 'sophia.m@example.com', '4561237890', 'pass678', 'Admin'),
('Olivia White', 'olivia.w@example.com', '7894561230', 'pass901', 'Passenger'),
('William Johnson', 'william.j@example.com', '3216549870', 'pass234', 'Passenger');

-- Flights
INSERT INTO flights (airline_name, source, destination, departure_time, arrival_time, total_seats, price) VALUES
('AirIndia', 'Delhi', 'Mumbai', '10:30', '12:30', 180, 5000),
('Indigo', 'Mumbai', 'Chennai', '14:00', '16:00', 200, 4500),
('SpiceJet', 'Bangalore', 'Kolkata', '18:00', '21:00', 150, 5500),
('Vistara', 'Hyderabad', 'Delhi', '06:00', '08:30', 220, 4800),
('GoAir', 'Pune', 'Jaipur', '09:15', '11:45', 170, 4600),
('Indigo', 'Kolkata', 'Bangalore', '19:30', '22:00', 200, 5100),
('AirAsia', 'Chennai', 'Hyderabad', '07:45', '09:30', 190, 4200),
('Vistara', 'Delhi', 'Goa', '13:00', '15:45', 160, 5300);

-- Airports
INSERT INTO airports (airport_name, city, country) VALUES
('Indira Gandhi International', 'Delhi', 'India'),
('Chhatrapati Shivaji International', 'Mumbai', 'India'),
('Kempegowda International', 'Bangalore', 'India'),
('Netaji Subhas Chandra Bose', 'Kolkata', 'India'),
('Rajiv Gandhi International', 'Hyderabad', 'India'),
('Pune Airport', 'Pune', 'India'),
('Chennai International', 'Chennai', 'India'),
('Jaipur International', 'Jaipur', 'India');

-- Bookings
INSERT INTO bookings (user_id, flight_id, booking_date, status) VALUES
(1, 2, '2024-02-10 15:00', 'Confirmed'),
(3, 1, '2024-02-12 10:30', 'Pending'),
(5, 4, '2024-02-11 08:15', 'Confirmed'),
(2, 3, '2024-02-13 18:45', 'Canceled'),
(6, 7, '2024-02-14 07:30', 'Confirmed'),
(4, 5, '2024-02-15 12:00', 'Pending'),
(8, 6, '2024-02-16 19:30', 'Confirmed'),
(7, 8, '2024-02-17 13:45', 'Canceled');

-- Passengers
INSERT INTO passengers (booking_id, name, age, passport_number) VALUES
(1, 'John Doe', 30, 'A1234567'),
(2, 'Michael Brown', 25, 'B9876543'),
(3, 'Daniel Wilson', 28, 'C7412589'),
(4, 'Alice Smith', 32, 'D8529637'),
(5, 'Sophia Martinez', 29, 'E9638527'),
(6, 'Olivia White', 26, 'F4561237'),
(7, 'Emily Davis', 31, 'G7894561'),
(8, 'William Johnson', 27, 'H3216549');

-- Payments
INSERT INTO payments (booking_id, amount, payment_status, payment_date) VALUES
(1, 4500, 'Success', '2024-02-10 16:00'),
(2, 5000, 'Pending', '2024-02-12 11:00'),
(3, 4800, 'Success', '2024-02-11 09:00'),
(4, 5500, 'Failed', '2024-02-13 19:00'),
(5, 5300, 'Success', '2024-02-14 08:00'),
(6, 4600, 'Pending', '2024-02-15 13:00'),
(7, 5100, 'Success', '2024-02-16 20:00'),
(8, 4200, 'Failed', '2024-02-17 14:30');

-- Flight Schedule
INSERT INTO flight_schedule (flight_id, airport_id, departure_date, arrival_date) VALUES
(1, 2, '2024-02-10 10:30', '2024-02-10 12:30'),
(3, 4, '2024-02-12 18:00', '2024-02-12 21:00'),
(5, 6, '2024-02-11 09:15', '2024-02-11 11:45'),
(2, 3, '2024-02-13 14:00', '2024-02-13 16:00');

-- Find all flights from a specific source to a destination on a given date.
SELECT f.flight_id, f.airline_name, f.source, f.destination, fs.departure_date, f.departure_time, f.arrival_time, f.price 
FROM flights f
JOIN flight_schedule fs ON f.flight_id = fs.flight_id
WHERE f.source = 'Delhi' AND f.destination = 'Mumbai' AND CAST(fs.departure_date AS DATE) = '2024-02-10';

-- List all bookings made by a specific user.
SELECT b.booking_id, u.name AS user_name, f.airline_name, f.source, f.destination, b.booking_date, b.status 
FROM bookings b
JOIN users u ON b.user_id = u.user_id
JOIN flights f ON b.flight_id = f.flight_id
WHERE u.email = 'john.doe@example.com';

-- Find the total revenue generated from flight bookings.
SELECT SUM(p.amount) AS total_revenue
FROM payments p
WHERE p.payment_status = 'Success';

-- Get all passengers for a specific flight.
SELECT p.passenger_id, p.name, p.age, p.passport_number, b.booking_id, f.flight_id, f.airline_name
FROM passengers p
JOIN bookings b ON p.booking_id = b.booking_id
JOIN flights f ON b.flight_id = f.flight_id
WHERE f.flight_id = 2; 

-- Check seat availability for a specific flight before booking.
SELECT f.flight_id, f.total_seats, 
       (f.total_seats - COALESCE(SUM(CASE WHEN b.status = 'Confirmed' THEN 1 ELSE 0 END), 0)) AS available_seats
FROM flights f
LEFT JOIN bookings b ON f.flight_id = b.flight_id
WHERE f.flight_id = 3 -- Replace 3 with the actual flight ID
GROUP BY f.flight_id, f.total_seats;

-- Get the busiest airport based on the number of flights arriving or departing.
SELECT TOP 1 a.airport_name, a.city, 
       (SELECT COUNT(*) FROM flight_schedule fs WHERE fs.airport_id = a.airport_id) AS total_flights
FROM airports a
ORDER BY total_flights DESC;

-- Find all canceled bookings along with user details.
SELECT b.booking_id, u.name, u.email, u.phone, f.airline_name, f.source, f.destination, b.booking_date 
FROM bookings b
JOIN users u ON b.user_id = u.user_id
JOIN flights f ON b.flight_id = f.flight_id
WHERE b.status = 'Canceled';

-- List all flights that have more than 80% seats booked.
SELECT f.flight_id, f.airline_name, f.source, f.destination, f.total_seats, 
       COUNT(b.booking_id) AS booked_seats, 
       (COUNT(b.booking_id) * 100.0 / f.total_seats) AS booking_percentage
FROM flights f
JOIN bookings b ON f.flight_id = b.flight_id
WHERE b.status = 'Confirmed'
GROUP BY f.flight_id, f.airline_name, f.source, f.destination, f.total_seats
HAVING (COUNT(b.booking_id) * 100.0 / f.total_seats) > 80;

-- Find the most popular destination based on bookings.
SELECT  TOP 1 f.destination, COUNT(b.booking_id) AS total_bookings
FROM bookings b
JOIN flights f ON b.flight_id = f.flight_id
WHERE b.status = 'Confirmed'
GROUP BY f.destination
ORDER BY total_bookings DESC;

-- Retrieve payment details for a specific booking ID.
SELECT p.payment_id, p.booking_id, p.amount, p.payment_status, p.payment_date 
FROM payments p
WHERE p.booking_id = 5;