-- Project in PostgreSQL 
-- Create the database
CREATE DATABASE airline_reservation_system;
\c airline_reservation_system;

CREATE TABLE airports (
    airport_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(100),
    country VARCHAR(100),
    code VARCHAR(10) UNIQUE -- e.g., JFK, LAX
);

CREATE TABLE flights (
    flight_id SERIAL PRIMARY KEY,
    flight_number VARCHAR(10) UNIQUE,
    departure_airport INT REFERENCES airports(airport_id),
    arrival_airport INT REFERENCES airports(airport_id),
    departure_time TIMESTAMP,
    arrival_time TIMESTAMP,
    total_seats INT,
    available_seats INT,
    price DECIMAL(10,2)
);

CREATE TABLE passengers (
    passenger_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    passport_number VARCHAR(50) UNIQUE
);

CREATE TABLE bookings (
    booking_id SERIAL PRIMARY KEY,
    passenger_id INT REFERENCES passengers(passenger_id),
    flight_id INT REFERENCES flights(flight_id),
    seat_number VARCHAR(10),
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'Confirmed' -- Canceled, Pending, etc.
);

CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    booking_id INT REFERENCES bookings(booking_id),
    amount DECIMAL(10,2),
    payment_method VARCHAR(50), -- Credit Card, UPI, etc.
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'Completed' -- Failed, Pending
);

INSERT INTO airports (name, city, country, code) VALUES
('John F. Kennedy International Airport', 'New York', 'USA', 'JFK'),
('Los Angeles International Airport', 'Los Angeles', 'USA', 'LAX'),
('Heathrow Airport', 'London', 'UK', 'LHR'),
('Chhatrapati Shivaji Maharaj International Airport', 'Mumbai', 'India', 'BOM');

INSERT INTO flights (flight_number, departure_airport, arrival_airport, departure_time, arrival_time, total_seats, available_seats, price) VALUES
('AI101', 1, 3, '2025-04-10 08:00:00', '2025-04-10 20:00:00', 200, 195, 500.00),
('BA202', 3, 2, '2025-04-12 10:30:00', '2025-04-12 14:00:00', 180, 170, 450.00),
('DL303', 2, 4, '2025-04-15 15:00:00', '2025-04-16 05:00:00', 220, 210, 600.00);

INSERT INTO passengers (full_name, email, phone, passport_number) VALUES
('Alice Smith', 'alice@travel.com', '555-0001', 'P1234567'),
('Bob Johnson', 'bob@travel.com', '555-0002', 'P2345678'),
('Charlie Ray', 'charlie@travel.com', '555-0003', 'P3456789');

INSERT INTO bookings (passenger_id, flight_id, seat_number) VALUES
(1, 1, '12A'),
(2, 2, '8C'),
(3, 3, '5B');

INSERT INTO payments (booking_id, amount, payment_method) VALUES
(1, 500.00, 'Credit Card'),
(2, 450.00, 'UPI'),
(3, 600.00, 'Debit Card');

-- Available flights between two cities
SELECT f.flight_number, a1.city AS from_city, a2.city AS to_city, f.departure_time, f.price
FROM flights f
JOIN airports a1 ON f.departure_airport = a1.airport_id
JOIN airports a2 ON f.arrival_airport = a2.airport_id
WHERE a1.city = 'New York' AND a2.city = 'London';

-- Passenger's booking history
SELECT p.full_name, f.flight_number, b.seat_number, b.booking_date, b.status
FROM bookings b
JOIN passengers p ON b.passenger_id = p.passenger_id
JOIN flights f ON b.flight_id = f.flight_id
WHERE p.email = 'alice@travel.com';

-- Revenue generated per flight
SELECT f.flight_number, SUM(pay.amount) AS total_revenue
FROM payments pay
JOIN bookings b ON pay.booking_id = b.booking_id
JOIN flights f ON b.flight_id = f.flight_id
GROUP BY f.flight_number;

-- Check Seat Availability for All Flights
SELECT flight_number, total_seats, available_seats, 
       (total_seats - available_seats) AS booked_seats
FROM flights
ORDER BY departure_time;

-- Upcoming Flights for a Passenger
SELECT f.flight_number, a1.city AS from_city, a2.city AS to_city, f.departure_time, b.seat_number
FROM bookings b
JOIN flights f ON b.flight_id = f.flight_id
JOIN passengers p ON b.passenger_id = p.passenger_id
JOIN airports a1 ON f.departure_airport = a1.airport_id
JOIN airports a2 ON f.arrival_airport = a2.airport_id
WHERE p.email = 'alice@travel.com'
  AND f.departure_time > CURRENT_TIMESTAMP
  AND b.status = 'Confirmed'
ORDER BY f.departure_time;

-- Daily Revenue Summary
SELECT DATE(payment_date) AS date, SUM(amount) AS daily_revenue
FROM payments
WHERE status = 'Completed'
GROUP BY DATE(payment_date)
ORDER BY date DESC;

-- Payment Method Breakdown
SELECT payment_method, COUNT(*) AS total_transactions, SUM(amount) AS total_amount
FROM payments
WHERE status = 'Completed'
GROUP BY payment_method;

-- Most Popular Routes (by bookings)
SELECT a1.city AS origin, a2.city AS destination, COUNT(*) AS total_bookings
FROM bookings b
JOIN flights f ON b.flight_id = f.flight_id
JOIN airports a1 ON f.departure_airport = a1.airport_id
JOIN airports a2 ON f.arrival_airport = a2.airport_id
GROUP BY origin, destination
ORDER BY total_bookings DESC;

-- Flight Schedule for a Specific Airport
SELECT flight_number, 
       a1.city AS departure_city, 
       a2.city AS arrival_city, 
       departure_time, arrival_time
FROM flights f
JOIN airports a1 ON f.departure_airport = a1.airport_id
JOIN airports a2 ON f.arrival_airport = a2.airport_id
WHERE a1.code = 'LAX' OR a2.code = 'LAX'
ORDER BY departure_time;

-- Passengers List per Flight
SELECT f.flight_number, p.full_name, b.seat_number
FROM bookings b
JOIN flights f ON b.flight_id = f.flight_id
JOIN passengers p ON b.passenger_id = p.passenger_id
WHERE f.flight_number = 'AI101'
ORDER BY b.seat_number;

-- Passenger Manifest with Contact Info
SELECT f.flight_number, p.full_name, p.email, p.phone, b.seat_number
FROM bookings b
JOIN passengers p ON b.passenger_id = p.passenger_id
JOIN flights f ON b.flight_id = f.flight_id
WHERE f.flight_number = 'DL303';
