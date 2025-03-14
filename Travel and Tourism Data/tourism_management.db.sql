-- Database Creation 
sqlite3 tourism_management.db

-- Use of current database 
USE tourism_management;

PRAGMA foreign_keys = ON;

-- Tourists Table 
CREATE table tourists (
  tourist_id INTEGER PRIMARY KEY,
  first_name VARCHAR,
  last_name VARCHAR,
  email VARCHAR,
  phone INTEGER, 
  nationality VARCHAR,
  passport_number VARCHAR
);  

INSERT into tourists
(first_name, last_name, email, phone, nationality, passport_number)
VALUES
('John', 'Doe', 'john.doe@example.com', '+1 555 1234', 'USA', 'A1234567'),
('Maria', 'Gonzalez', 'maria.gonzalez@example.com', '+34 600 5678', 'Spain', 'B9876543'),
('Ahmed', 'Ali', 'ahmed.ali@example.com', '+971 50 1234', 'UAE', 'C4567890'),
('Li', 'Wei', 'li.wei@example.com', '+86 138 2468', 'China', 'D2345678'),
('Emily', 'Smith', 'emily.smith@example.com', '+44 7911 1234', 'UK', 'E1239876'),
('Hiroshi', 'Takahashi', 'hiroshil.takahashi@example.com', '+81 90 345689', 'Japan', 'F1122334'),
('Laura', 'Johnson', 'laura.johnson@example.com', '+1 555 9875', 'Canada', 'G2233445'),
('Carlos', 'Martinez', 'carlos.martinez@example.com', '+52 55 7654', 'Mexico', 'H4567891'),
('Ravi', 'Kumar', 'ravi.kumar@example.com', '+91 98754 85236', 'India', 'I9876543'),
('Priya', 'Sharma', 'priya.sharma@example.com', NULL, 'India', 'J1234567'),
('Fatima', 'Hassan', 'fatima.hassan@example.com', NULL, 'UAE', 'K6543210'),
('John', 'Doe', 'john.doe@example.com', NULL, 'USA', 'L78901234');

-- Find all tourists from "India" who have booked a tour in the last 6 months.
SELECT t.tourist_id, t.first_name, t.last_name, t.email, t.phone, t.nationality
FROM tourists t
JOIN bookings b ON t.tourist_id = b.tourist_id
WHERE t.nationality = 'India'
AND b.booking_date >= DATE('now', '-6 month');

-- List tourists who have not provided their phone number.
SELECT first_name, last_name
FROM tourists
WHERE phone Is NULL;

-- Get the number of tourists who are traveling from the USA.
SELECT COUNT(*) AS total_tourists 
FROM tourists 
WHERE nationality = 'USA';

-- Retrieve details of tourists whose last name starts with "S".
SELECT first_name, last_name
FROM tourists
WHERE last_name like 'S%';

-- Tours Table 
CREATE TABLE tours (
  tour_id INTEGER PRIMARY KEY,
  tour_name VARCHAR,
  destination VARCHAR,
  duration_in_days INTEGER,
  price_in_usd INTEGER,
  available_seats INTEGER
);

INSERT Into tours 
(tour_name, destination, duration_in_days, price_in_usd, available_seats)
VALUES
('Grand Europe Tour', 'France, Italy, Spain', 14, 2500, 10),
('Majestic USA', 'USA (NY, LA, Vegas)', 10, 3200, 15),
('Wonders of India', 'India (Delhi, Agra, Jaipur)', 7, 1200, 20),
('Best of Japan', 'Japan (Tokyo, Kyoto, Osaka)', 9, 2800, 12),
('Dubai Luxury Escape', 'UAE (Dubai, Abu Dhabi)', 5, 1800, 25),
('African Safari', 'Kenya, Tanzania', 8, 3500, 8),
('Amazing Thailand', 'Thailand (Bangkok, Phuket)', 6, 1500, 18),
('Greek Island Hopper', 'Greece (Santorini, Mykonos)', 7, 2700, 10),
('Brazilian Adventure', 'Brazil (Rio, Amazon)', 10, 2900, 14),
('Arctic Expedition', 'Norway, Iceland', 12, 5000, 6);

-- List all tours with a price greater than $2000.
SELECT * 
from tours
WHERE price_in_usd > 2000;

--  Find the most popular destination by the number of bookings (join with the bookings table). 
SELECT t.destination, COUNT(b.booking_id) AS total_bookings
FROM bookings b
JOIN tours t ON b.tour_id = t.tour_id
GROUP BY t.destination
ORDER BY total_bookings DESC
LIMIT 1;

-- Retrieve all tours that last for 7 days or more.
SELECT * 
FROM tours
WHERE duration_in_days >= 7;

-- Get all tours with 10 available seats left.
SELECT * 
from tours
WHERE available_seats = 10;

-- Bookings Table 
CREATE TABLE bookings (
  booking_id INTEGER PRIMARY Key, 
  tourist_id INTEGER,
  tour_id INTEGER,
  booking_date DATE,
  number_of_people INTEGER,
  total_cost_in_usd INTEGER,
  FOREIGN KEY (tourist_id) REFERENCES tourists(tourist_id),
  FOREIGN KEY (tour_id) REFERENCES tours(tour_id)
);

INSERT INTO bookings 
(tourist_id, tour_id, booking_date, number_of_people, total_cost_in_usd)
VALUES
(1, 3, '2024-02-01', 2, 2400),
(2, 5, '2024-02-05', 1, 1800),
(3, 7, '2024-02-07', 3, 4500),
(4, 1, '2024-02-10', 2, 5000),
(5, 6, '2024-02-12', 1, 3500),
(6, 9, '2024-02-15', 4, 11600),
(7, 2, '2024-02-18', 2, 6400),
(8, 4, '2024-02-20', 1, 2800),
(9, 8, '2024-02-22', 3, 8100),
(10, 10, '2024-02-25', 1, 5000),
(5, 2, '2024-06-06', 6, 12000),
(10, 8, '2024-08-18', 8, 18000),
(11, 4, '2024-01-05', 5, 45000),
(6, 5, '2024-05-23', 4, 2000),
(7, 2, '2024-06-18', 7, 5000),
(12, 9, '2024-10-10', 7, 4000);

-- Retrieve all bookings that were made in the last 10 month.
SELECT * 
FROM bookings 
WHERE booking_date >= DATE('now', '-10 month');

-- Find the total revenue generated from bookings for a specific tour.
SELECT tour_id, SUM(total_cost_in_usd) AS total_revenue
FROM bookings
WHERE tour_id = 2
GROUP BY tour_id;

-- Get the average number of people per booking for each tou
SELECT tour_id, AVG(number_of_people) AS avg_people_per_booking
FROM bookings
GROUP BY tour_id;

-- Find all tourists who have booked more than 1 tours.
SELECT tourist_id, COUNT(tour_id) AS total_tours_booked
FROM bookings
GROUP BY tourist_id
HAVING COUNT(tour_id) > 1;

-- Guide Table 
CREATE TABLE guides ( 
  guide_id INTEGER PRIMARY KEY,
  first_name VARCHAR,
  last_name VARCHAR,
  languages_spoken VARCHAR,
  rating DECIMAL(2,1),
  tour_id INTEGER,
  FOREIGN Key (tour_id) REFERENCES tours(tour_id)
);  

INSERT into guides
(first_name, last_name, languages_spoken, rating, tour_id)
VALUES
('Michael', 'Brown', 'English, Spanish', 4.8, 1),
('Sofia', 'Martinez', 'Spanish, English', 4.7, 2),
('Ahmed', 'Ali - Farsi', 'Arabic, English', 4.9, 3),
('Chan', 'Urian', 'Chinese, English', 4.6, 4),
('Somchai', 'Wong', 'English, French', 4.5, 5),
('Kenji', 'Tanaka', 'Japanese, English', 4.8, 6),
('Lily', 'Jeany', 'English, French', 4.7, 7),
('Joao', 'Silva', 'Spanish, Portuguese', 4.6, 8),
('Raj', 'Sharma', 'Hindi, English', 4.9, 9),
('Arjun', 'Kumar', 'Hindi, English', 4.8, NULL),
('Rani', 'Patel', 'Hindi, Gujarti, English', 4.7, 10),
('Zoya', 'Ahmed', 'Arabic, English', 4.6, NULL),
('Ali', 'Khan', 'Arabic, French', 4.5, 6),
('Su', 'Li', 'Chinese, Japenese', 4.6, NULL),
('Michael', 'Brown', 'English, Spanish', 4.8, 1),
('Sofia', 'Martinez', 'Spanish, English', 4.7, 2),
('Ahmed', 'Ali - Farsi', 'Arabic, English', 4.9, 3),
('Raj', 'Sharma', 'Hindi, English', 4.9, 10);

-- List all guides who speak English and Spanish.
SELECT * 
FROM guides 
WHERE languages_spoken LIKE '%English%' 
AND languages_spoken LIKE '%Spanish%';

-- Retrieve guides with a rating greater than 4.5.
SELECT *
FROM guides
WHERE rating > 4.5;

-- Find the guide who was assigned the most number of tours.
SELECT g.first_name, g.last_name, COUNT(g.tour_id) AS total_tours
FROM guides g
WHERE g.tour_id IS NOT NULL
GROUP BY g.first_name, g.last_name
ORDER BY total_tours DESC
LIMIT 3;

-- Get all guides who have not been assigned to any tour.
SELECT *
from guides
WHERE tour_id Is NULL;

-- Destinations Table 
CREATE TABLE destinations (
  destination_id INTEGER PRIMARY KEY,
  destination_name VARCHAR,
  country VARCHAR,
  continent VARCHAR,
  description VARCHAR
);

INSERT INTO destinations
(destination_name, country, continent, description)
VALUES
('Paris', 'France', 'Europe', 'The city of love, famous for the Eiffel Tower and Louvre.'),
('New York City', 'USA', 'North America', 'A bustling metropolis known for Times Square and Central Park.'),
('Agra', 'India', 'Asia', 'Home to the iconic Taj Mahal, a symbol of love and heritage.'),
('Jaipur', 'India', 'Asia', 'Known as the "Pink City", Jaipur is the capital of Rajasthan, India. It is famous for its royal palaces, historic forts, and vibrant markets.'),
('Tokyo', 'Japan', 'Asia', 'A futuristic city blending modern tech with ancient traditions.'),
('Dubai', 'UAE', 'Asia', 'A luxurious city known for Burj Khalifa and desert safaris.'),
('Cape Town', 'South Africa', 'Africa', 'A coastal city with stunning Table Mountain views.'),
('Bangkok', 'Thailand', 'Asia', 'A vibrant city famous for street food and the Grand Palace.'),
('Santorini', 'Greece', 'Europe', 'A beautiful island with white-washed buildings and blue domes.'),
('Rio de Janeiro', 'Brazil', 'South America', 'Known for Christ the Redeemer and Copacabana Beach.'),
('Reykjavik', 'Iceland', 'Europe', 'A gateway to the Northern Lights and stunning landscapes.'),
('Toronto', 'Canada', 'North America', 'A multicultural city with the iconic CN Tower and beautiful waterfront.'),
('Moscow', 'Russia', 'Europe', 'The capital of Russia, known for Red Square and the Kremlin.'),
('Saint Petersburg', 'Russia', 'Europe', ' Often called the "Cultural Capital of Russia", this city is famous for the Hermitage Museum, the Winter Palace, and stunning canals.'),
('Sochi', 'Russia', 'Europe', 'A popular Black Sea resort city, Sochi gained international fame after hosting the 2014 Winter Olympics.');

-- List all destinations in Asia.
SELECT * 
from destinations
where continent = 'Asia';

-- Retrieve destinations that have "beach" in their description.
SELECT * 
FROM destinations
WHERE description like '%beach%';

-- Find all countries with more than 1 destinations listed.
SELECT country, COUNT(*) AS destination_count
FROM destinations
GROUP BY country
HAVING COUNT(*) > 1;

-- Retrieve destinations that are in the same country as a specific destination 
SELECT destination_name, country  
FROM destinations  
WHERE country = (  
    SELECT country FROM destinations WHERE destination_name = 'Moscow'  
)  
AND destination_name <> 'Moscow';  

-- Payments Table
CREATE TABLE payments (
  payment_id INTEGER PRIMARY KEY,
  booking_id INTEGER,
  payment_date DATE,
  payment_amount INTEGER,
  payment_method VARCHAR,
  FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
);  

INSERT INTO payments 
(payment_id, booking_id, payment_date, payment_amount, payment_method) 
VALUES 
(1, 3, '2024-02-08', 4500, 'Credit Card'),
(2, 7, '2024-02-19', 6400, 'PayPal'),
(3, 12, '2024-08-19', 0, 'Bank Transfer'),
(4, 1, '2024-02-02', 2400, 'Debit Card'),
(5, 5, '2024-02-13', 0, 'Cash'),
(6, 10, '2024-02-26', 5000, 'Credit Card'),
(7, 6, '2024-02-16', 11600, 'PayPal'),
(8, 8, '2024-02-21', 2800, 'Credit Card'),
(9, 15, '2024-06-19', 5000, 'Debit Card'),
(10, 9, '2024-02-23', 8100, 'Bank Transfer'),
(11, 4, '2024-02-11', 5000, 'PayPal'),
(12, 14, '2024-05-24', 0, 'Cash'),
(13, 11, '2024-06-07', 12000, 'Credit Card'),
(14, 13, '2024-01-06', 45000, 'Bank Transfer'),
(15, 16, '2024-10-11', 4000, 'PayPal'),
(16, 2, '2024-02-06', 1800, 'Credit Card');

-- Find all payments made via "credit card".
SELECT *
FROM payments
where payment_method = 'Credit Card';

-- Retrieve bookings where the payment has not been made
SELECT *
from payments
WHERE payment_amount = 0;

-- Get the total amount paid for a specific booking.
SELECT booking_id, SUM(payment_amount) AS total_paid
FROM payments
WHERE booking_id = 4
GROUP BY booking_id;
