-- Project in PostgreSQL 
-- Create Database
CREATE DATABASE HotelBookingDB;
\c HotelBookingDB;

-- Hotels Table  
CREATE TABLE hotels (
  hotel_id SERIAL PRIMARY KEY,
  hotel_name VARCHAR(100) NOT NULL,
  hotel_location VARCHAR(100) NOT NULL,
  rating DECIMAL(2,1)
);

-- Rooms Table 
CREATE TABLE rooms (
  room_id SERIAL PRIMARY KEY,
  hotel_id INT,
  room_type VARCHAR(100) NOT NULL,
  price_per_night DECIMAL(10,2) NOT NULL,
  availability BOOLEAN DEFAULT TRUE,
  FOREIGN KEY (hotel_id) REFERENCES hotels(hotel_id)
);

-- Customers Table 
CREATE TABLE customers (
  customer_id SERIAL PRIMARY KEY,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  phone_number BIGINT NOT NULL UNIQUE
);

-- Bookings Table 
CREATE TABLE bookings (
  booking_id SERIAL PRIMARY KEY,
  customer_id INT,
  room_id INT,
  check_in_date DATE NOT NULL,
  check_out_date DATE NOT NULL,
  total_price DECIMAL(10,2) NOT NULL,
  status VARCHAR(50) CHECK (status IN ('Confirmed', 'Cancelled', 'Checked Out')),
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  FOREIGN KEY (room_id) REFERENCES rooms(room_id)
);

-- Payments Table 
CREATE TABLE payments (
  payment_id SERIAL PRIMARY KEY,
  booking_id INT,
  payment_date DATE NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  payment_method VARCHAR(50) CHECK (payment_method IN ('Credit Card', 'Debit Card', 'Cash', 'Online')),
  FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
);

-- Insert into hotels table  
INSERT INTO hotels (hotel_name, hotel_location, rating) VALUES
('Grand Palace', 'New York', 4.5),
('Ocean View', 'Los Angeles', 4.0),
('Mountain Retreat', 'Denver', 4.2),
('City Lights Hotel', 'Chicago', 3.9),
('Sunset Inn', 'Miami', 4.3);

-- Insert into rooms table  
INSERT INTO rooms (hotel_id, room_type, price_per_night, availability) VALUES
(1, 'Deluxe Suite', 200.00, TRUE),
(2, 'Standard Room', 120.00, TRUE),
(3, 'Family Room', 150.00, FALSE),
(1, 'King Suite', 250.00, TRUE),
(4, 'Single Room', 80.00, TRUE);

-- Insert into customers table  
INSERT INTO customers (first_name, last_name, email, phone_number) VALUES
('John', 'Doe', 'john.doe@example.com', 9876543210),
('Jane', 'Smith', 'jane.smith@example.com', 8765432109),
('Robert', 'Brown', 'robert.brown@example.com', 7654321098),
('Emily', 'Davis', 'emily.davis@example.com', 6543210987),
('Michael', 'Johnson', 'michael.johnson@example.com', 5432109876);

-- Insert into bookings table  
INSERT INTO bookings (customer_id, room_id, check_in_date, check_out_date, total_price, status) VALUES
(1, 1, '2025-03-01', '2025-03-05', 800.00, 'Confirmed'),
(2, 3, '2025-03-10', '2025-03-15', 750.00, 'Checked Out'),
(3, 2, '2025-04-05', '2025-04-10', 600.00, 'Confirmed'),
(4, 4, '2025-04-12', '2025-04-15', 750.00, 'Cancelled'),
(5, 5, '2025-05-01', '2025-05-07', 560.00, 'Confirmed');

-- Insert into payments table  
INSERT INTO payments (booking_id, payment_date, amount, payment_method) VALUES
(1, '2025-03-01', 800.00, 'Credit Card'),
(2, '2025-03-10', 750.00, 'Cash'),
(3, '2025-04-05', 600.00, 'Online'),
(4, '2025-04-12', 750.00, 'Debit Card'),
(5, '2025-05-01', 560.00, 'Credit Card');

-- Retrieve all hotels with a rating of 4.5 or higher.
SELECT * 
FROM hotels 
WHERE rating >= 4.5;

-- Find all available rooms in a specific hotel.
SELECT * 
FROM rooms 
WHERE hotel_id = 1 AND availability = TRUE;

-- Get the total number of bookings made in the last 30 days.
SELECT COUNT(*) AS total_bookings 
FROM bookings 
WHERE check_in_date >= CURRENT_DATE - INTERVAL '30 days';

-- Retrieve the booking details for a specific customer by their email.
SELECT b.* 
FROM bookings b
JOIN customers c ON b.customer_id = c.customer_id
WHERE c.email = 'john.doe@example.com';

-- Find out how many rooms are available in a specific hotel.
SELECT COUNT(*) AS available_rooms
FROM rooms
WHERE hotel_id = 2 AND availability = TRUE;

-- Find the total revenue generated from bookings in the last 6 months.
SELECT SUM(total_price) AS total_revenue 
FROM bookings 
WHERE check_in_date >= CURRENT_DATE - INTERVAL '6 months';

-- Find the most frequently booked room type.
SELECT r.room_type, COUNT(b.booking_id) AS booking_count
FROM bookings b
JOIN rooms r ON b.room_id = r.room_id
GROUP BY r.room_type
ORDER BY booking_count DESC
LIMIT 1;

-- Get a list of customers who have upcoming bookings in the next 7 days.
SELECT DISTINCT c.customer_id, c.first_name, c.last_name, c.email 
FROM customers c
JOIN bookings b ON c.customer_id = b.customer_id
WHERE b.check_in_date BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '7 days';

-- Retrieve the hotel with the highest number of bookings
SELECT h.hotel_id, h.hotel_name, COUNT(b.booking_id) AS total_bookings
FROM bookings b
JOIN rooms r ON b.room_id = r.room_id
JOIN hotels h ON r.hotel_id = h.hotel_id
GROUP BY h.hotel_id, h.hotel_name
ORDER BY total_bookings DESC
LIMIT 1;

-- Find the customer who has spent the most on bookings
SELECT c.customer_id, c.first_name, c.last_name, SUM(b.total_price) AS total_spent
FROM customers c
JOIN bookings b ON c.customer_id = b.customer_id
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 1;

-- List all hotels and the number of rooms they have
SELECT h.hotel_id, h.hotel_name, COUNT(r.room_id) AS total_rooms
FROM hotels h
LEFT JOIN rooms r ON h.hotel_id = r.hotel_id
GROUP BY h.hotel_id, h.hotel_name
ORDER BY total_rooms DESC;

-- Get the average booking duration (in days)
SELECT AVG(check_out_date - check_in_date) AS avg_booking_duration
FROM bookings;
