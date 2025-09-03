--SQL Lite Project
-- Create Database
sqlite3 AdventureSportsDB.db

-- Users Table 
CREATE TABLE users (
  user_id INT PRIMARY KEY,
  name VARCHAR(20),
  email Varchar(20) UNIQUE,
  phone BIGINT,
  address VARCHAR(50)
);

-- Sports Table  
CREATE TABLE sports (
  sport_id INT PRIMARY KEY,
  sport_name VARCHAR(20),
  location VARCHAR(50),
  duration_in_hours INT,
  price DECIMAL(4,2)
);

-- Bookings Table 
CREATE TABLE bookings (
  booking_id INT PRIMARY KEY,
  user_id INT,
  sport_id INT,
  booking_date DATETIME,
  status VARCHAR(15) CHECK (status IN ('Pending', 'Confirmed', 'Cancelled')),
  payment_status VARCHAR(10) CHECK (payment_status IN ('Paid', 'Unpaid')),
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (sport_id) REFERENCES sports(sport_id)
);

-- Payments Table  
CREATE TABLE payments (
  payment_id INT PRIMARY KEY,
  booking_id INT,
  amount DECIMAL(4,2),
  payment_date DATETIME,
  payment_method VARCHAR(14) CHECK (payment_method IN ('Credit Card', 'PayPal', 'Debit Card')),
  status VARCHAR(10) CHECK (status IN ('Successful', 'Failed')),
  FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
);

-- Instructors Table 
CREATE TABLE instructors (
  instructor_id INT PRIMARY KEY,
  name VARCHAR(20),
  email VARCHAR(50) UNIQUE,
  phone BIGINT,
  experience_in_years YEAR
);

-- Sport Instructors Table 
CREATE TABLE sport_instructors (
  sport_id INT,
  instructor_id INT,
  assigned_date DATETIME,
  FOREIGN KEY (sport_id) REFERENCES sports(sport_id),
  FOREIGN KEY (instructor_id) REFERENCES instructors(instructor_id)
);

-- Insert into users table
INSERT INTO users (user_id, name, email, phone, address) VALUES
(1, 'Alice Johnson', 'alice@example.com', 1234567890, '123 Elm Street'),
(2, 'Bob Smith', 'bob@example.com', 2345678901, '456 Oak Avenue'),
(3, 'Charlie Brown', 'charlie@example.com', 3456789012, '789 Pine Road'),
(4, 'David Williams', 'david@example.com', 4567890123, '101 Maple Blvd'),
(5, 'Emma Davis', 'emma@example.com', 5678901234, '202 Birch Lane'),
(6, 'Frank Miller', 'frank@example.com', 6789012345, '303 Cedar Way'),
(7, 'Grace Wilson', 'grace@example.com', 7890123456, '404 Redwood Dr'),
(8, 'Hannah Moore', 'hannah@example.com', 8901234567, '505 Spruce St');

-- Insert into sports table
INSERT INTO sports (sport_id, sport_name, location, duration_in_hours, price) VALUES
(1, 'Rock Climbing', 'Mountain Base', 3, 50.00),
(2, 'Kayaking', 'River Rapids', 2, 40.00),
(3, 'Skydiving', 'Airfield Zone', 1, 200.00),
(4, 'Scuba Diving', 'Coral Reef', 4, 150.00),
(5, 'Hiking', 'Green Trail', 5, 30.00),
(6, 'Paragliding', 'Hilltop', 1, 120.00),
(7, 'Bungee Jumping', 'Cliff Edge', 1, 100.00),
(8, 'Skiing', 'Snowy Peaks', 3, 80.00);

-- Insert into bookings table
INSERT INTO bookings (booking_id, user_id, sport_id, booking_date, status, payment_status) VALUES
(1, 1, 2, '2024-02-01 10:00:00', 'Confirmed', 'Paid'),
(2, 2, 5, '2024-02-02 12:00:00', 'Pending', 'Unpaid'),
(3, 3, 3, '2024-02-03 09:30:00', 'Confirmed', 'Paid'),
(4, 4, 6, '2024-02-04 11:00:00', 'Cancelled', 'Unpaid'),
(5, 5, 1, '2024-02-05 15:00:00', 'Confirmed', 'Paid'),
(6, 6, 7, '2024-02-06 14:00:00', 'Pending', 'Unpaid'),
(7, 7, 4, '2024-02-07 08:00:00', 'Confirmed', 'Paid'),
(8, 8, 8, '2024-02-08 10:30:00', 'Pending', 'Unpaid');

-- Insert into payments table
INSERT INTO payments (payment_id, booking_id, amount, payment_date, payment_method, status) VALUES
(1, 1, 40.00, '2024-02-01 10:05:00', 'Credit Card', 'Successful'),
(2, 3, 200.00, '2024-02-03 09:35:00', 'PayPal', 'Successful'),
(3, 5, 50.00, '2024-02-05 15:10:00', 'Debit Card', 'Successful'),
(4, 7, 150.00, '2024-02-07 08:05:00', 'Credit Card', 'Successful');

-- Insert into instructors table
INSERT INTO instructors (instructor_id, name, email, phone, experience_in_years) VALUES
(1, 'Mike Adams', 'mike@example.com', 9876543210, 5),
(2, 'Sara Lee', 'sara@example.com', 8765432109, 7),
(3, 'Tom Hardy', 'tom@example.com', 7654321098, 10),
(4, 'Lisa Ray', 'lisa@example.com', 6543210987, 6),
(5, 'Ethan Hunt', 'ethan@example.com', 5432109876, 8),
(6, 'Olivia Green', 'olivia@example.com', 4321098765, 9),
(7, 'Ryan Gosling', 'ryan@example.com', 3210987654, 4),
(8, 'Sophia White', 'sophia@example.com', 2109876543, 3);

-- Insert into sport_instructors table
INSERT INTO sport_instructors (sport_id, instructor_id, assigned_date) VALUES
(1, 3, '2024-01-15 08:00:00'),
(2, 1, '2024-01-16 09:00:00'),
(3, 5, '2024-01-17 10:00:00'),
(4, 6, '2024-01-18 11:00:00'),
(5, 2, '2024-01-19 12:00:00'),
(6, 4, '2024-01-20 13:00:00'),
(7, 7, '2024-01-21 14:00:00'),
(8, 8, '2024-01-22 15:00:00');

-- Retrieve all bookings made by a specific user.
SELECT * 
FROM bookings 
WHERE user_id = 5;

-- Get all sports available at a specific location.
SELECT * 
FROM sports 
WHERE location = 'Mountain Base';

-- Find the total revenue generated from bookings.
SELECT SUM(amount) AS total_revenue 
FROM payments 
WHERE status = 'Successful';

-- List all instructors assigned to a specific sport.
SELECT i.instructor_id, i.name, i.email, i.phone, i.experience_in_years
FROM instructors i
JOIN sport_instructors si ON i.instructor_id = si.instructor_id
WHERE si.sport_id = 3;

-- Show users who have never booked any adventure sport.
SELECT u.user_id, u.name, u.email 
FROM users u
LEFT JOIN bookings b ON u.user_id = b.user_id
WHERE b.user_id IS NULL;

-- Display the most booked sport.
SELECT s.sport_id, s.sport_name, COUNT(b.booking_id) AS total_bookings
FROM bookings b
JOIN sports s ON b.sport_id = s.sport_id
GROUP BY s.sport_id, s.sport_name
ORDER BY total_bookings DESC
LIMIT 1;

-- Retrieve the pending payments along with user details.
SELECT u.user_id, u.name, u.email, u.phone, p.payment_id, p.amount, p.payment_date, p.status
FROM users u
JOIN bookings b ON u.user_id = b.user_id
JOIN payments p ON b.booking_id = p.booking_id
WHERE p.status = 'Failed' OR b.payment_status = 'Unpaid';

-- Find instructors with more than 5 years of experience.
SELECT * 
FROM instructors 
WHERE experience_in_years > 5;

-- Show all bookings made in the last 30 days.
SELECT * 
FROM bookings 
WHERE booking_date >= DATE('now', '-30 days');

-- Find the most popular payment method used.
SELECT payment_method, COUNT(payment_id) AS usage_count
FROM payments
WHERE status = 'Successful'
GROUP BY payment_method
ORDER BY usage_count DESC
LIMIT 1;
