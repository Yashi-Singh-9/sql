CREATE DATABASE TourismDB;
USE TourismDB;

-- Users Table
CREATE TABLE users (
  user_id INT IDENTITY(1,1) PRIMARY KEY,
  name VARCHAR(20),
  email VARCHAR(50) UNIQUE,
  phone BIGINT,
  password TEXT,
  address TEXT
);

-- Tour Packages Table
CREATE TABLE tour_packages (
  package_id INT IDENTITY(1,1) PRIMARY KEY,
  package_name VARCHAR(50),
  destination VARCHAR(20),
  duration DATETIME,
  price DECIMAL(8,2),
  description TEXT
);

-- Bookings Table
CREATE TABLE bookings (
  booking_id INT IDENTITY(1,1) PRIMARY KEY,
  user_id INT,
  package_id INT,
  booking_date DATETIME,
  travel_date DATETIME,
  status VARCHAR(20) CHECK (status IN ('Pending', 'Confirmed', 'Cancelled')),
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (package_id) REFERENCES tour_packages(package_id)
);

-- Payments Table
CREATE TABLE payments (
  payment_id INT IDENTITY(1,1) PRIMARY KEY,
  booking_id INT,
  amount_paid DECIMAL(10,2),
  payment_date DATETIME,
  payment_status VARCHAR(10) CHECK (payment_status IN ('Paid', 'Pending', 'Failed')),
  FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
);

-- Reviews Table
CREATE TABLE reviews (
  review_id INT IDENTITY(1,1) PRIMARY KEY,
  user_id INT,
  package_id INT,
  rating INT CHECK (rating BETWEEN 1 AND 5),
  review_text TEXT,
  review_date DATETIME,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (package_id) REFERENCES tour_packages(package_id)
);

-- Admin Table
CREATE TABLE admin (
  admin_id INT IDENTITY(1,1) PRIMARY KEY,
  username VARCHAR(20) UNIQUE,
  password TEXT
);  

-- Insert Data into Users Table
INSERT INTO users (name, email, phone, password, address) VALUES
('Alice Johnson', 'alice@email.com', 9876543210, 'password123', '123 Main St, NY'),
('Bob Smith', 'bob@email.com', 9876543211, 'securePass', '456 Elm St, CA'),
('Charlie Brown', 'charlie@email.com', 9876543212, 'charliePass', '789 Oak St, TX'),
('David Williams', 'david@email.com', 9876543213, 'davidSecure', '101 Pine St, FL'),
('Emma Wilson', 'emma@email.com', 9876543214, 'emmaStrong', '202 Maple St, IL'),
('Frank White', 'frank@email.com', 9876543215, 'frankPass', '303 Birch St, WA'),
('Grace Hall', 'grace@email.com', 9876543216, 'grace123', '404 Cedar St, MA'),
('Henry Lee', 'henry@email.com', 9876543217, 'henrySecure', '505 Walnut St, NV');

-- Insert Data into Tour Packages Table
INSERT INTO tour_packages (package_name, destination, duration, price, description) VALUES
('Beach Paradise', 'Hawaii', '2025-06-01 08:00:00', 999.99, 'Enjoy a tropical beach vacation in Hawaii.'),
('Mountain Escape', 'Colorado', '2025-07-15 08:00:00', 799.99, 'Experience breathtaking mountains and hiking trails.'),
('City Explorer', 'New York', '2025-08-10 08:00:00', 499.99, 'Discover the vibrant city life of New York.'),
('Desert Adventure', 'Arizona', '2025-09-05 08:00:00', 699.99, 'Explore the beauty of the Arizona desert.'),
('European Getaway', 'Paris', '2025-10-20 08:00:00', 1199.99, 'Visit the romantic city of Paris.'),
('Safari Experience', 'Kenya', '2025-11-25 08:00:00', 1399.99, 'Enjoy a thrilling wildlife safari in Kenya.'),
('Tropical Retreat', 'Bali', '2025-12-15 08:00:00', 899.99, 'Relax in the paradise of Bali.'),
('Winter Wonderland', 'Switzerland', '2026-01-05 08:00:00', 1299.99, 'Experience the magical snowy landscapes of Switzerland.');

-- Insert Data into Bookings Table
INSERT INTO bookings (user_id, package_id, booking_date, travel_date, status) VALUES
(1, 2, '2025-05-01 12:00:00', '2025-07-15 08:00:00', 'Confirmed'),
(2, 4, '2025-06-10 14:00:00', '2025-09-05 08:00:00', 'Pending'),
(3, 1, '2025-03-20 10:00:00', '2025-06-01 08:00:00', 'Confirmed'),
(4, 5, '2025-04-15 16:00:00', '2025-10-20 08:00:00', 'Cancelled'),
(5, 3, '2025-07-01 09:00:00', '2025-08-10 08:00:00', 'Confirmed'),
(6, 6, '2025-08-12 11:00:00', '2025-11-25 08:00:00', 'Pending'),
(7, 7, '2025-09-25 13:00:00', '2025-12-15 08:00:00', 'Confirmed'),
(8, 8, '2025-10-30 15:00:00', '2026-01-05 08:00:00', 'Cancelled');

-- Insert Data into Payments Table
INSERT INTO payments (booking_id, amount_paid, payment_date, payment_status) VALUES
(1, 799.99, '2025-05-02 09:00:00', 'Paid'),
(2, 699.99, '2025-06-11 10:00:00', 'Pending'),
(3, 999.99, '2025-03-21 11:00:00', 'Paid'),
(4, 1199.99, '2025-04-16 12:00:00', 'Failed'),
(5, 499.99, '2025-07-02 14:00:00', 'Paid'),
(6, 1399.99, '2025-08-13 16:00:00', 'Pending'),
(7, 899.99, '2025-09-26 17:00:00', 'Paid'),
(8, 1299.99, '2025-10-31 18:00:00', 'Failed');

-- Insert Data into Reviews Table
INSERT INTO reviews (user_id, package_id, rating, review_text, review_date) VALUES
(1, 2, 5, 'Amazing experience! The views were stunning.', '2025-07-20 10:00:00'),
(2, 4, 4, 'Desert tour was thrilling but very hot!', '2025-09-10 14:00:00'),
(3, 1, 5, 'Hawaii was a dream come true!', '2025-06-10 08:00:00'),
(4, 5, 3, 'Paris was beautiful, but the package was expensive.', '2025-10-25 12:00:00'),
(5, 3, 4, 'Loved exploring New York!', '2025-08-15 09:00:00'),
(6, 6, 5, 'Safari was the best adventure of my life!', '2025-11-30 16:00:00'),
(7, 7, 4, 'Bali was so relaxing, great trip!', '2025-12-20 11:00:00'),
(8, 8, 5, 'Switzerland in winter is pure magic!', '2026-01-10 15:00:00');

-- Insert Data into Admin Table
INSERT INTO admin (username, password) VALUES
('admin1', 'adminPass1'),
('admin2', 'adminPass2'),
('admin3', 'adminPass3'),
('admin4', 'adminPass4'),
('admin5', 'adminPass5'),
('admin6', 'adminPass6'),
('admin7', 'adminPass7'),
('admin8', 'adminPass8');

-- Retrieve all bookings made by a specific user (given their email).
SELECT b.*, u.name, u.email, t.package_name, t.destination 
FROM bookings b
JOIN users u ON b.user_id = u.user_id
JOIN tour_packages t ON b.package_id = t.package_id
WHERE u.email = 'charlie@email.com';

-- Find the top 3 most booked tour packages.
SELECT TOP 3 t.package_name, t.destination, COUNT(b.package_id) AS booking_count
FROM bookings b
JOIN tour_packages t ON b.package_id = t.package_id
GROUP BY t.package_name, t.destination
ORDER BY booking_count DESC;

-- Get the total revenue generated from confirmed bookings.
SELECT SUM(p.amount_paid) AS total_revenue
FROM payments p
JOIN bookings b ON p.booking_id = b.booking_id
WHERE b.status = 'Confirmed' AND p.payment_status = 'Paid';

-- List all users who have not made any bookings.
SELECT u.*
FROM users u
LEFT JOIN bookings b ON u.user_id = b.user_id
WHERE b.user_id IS NULL;

-- Find all payments that have failed.
SELECT p.*, u.name, u.email, t.package_name
FROM payments p
JOIN bookings b ON p.booking_id = b.booking_id
JOIN users u ON b.user_id = u.user_id
JOIN tour_packages t ON b.package_id = t.package_id
WHERE p.payment_status = 'Failed';

-- Get the average rating for each tour package.
SELECT t.package_name, t.destination, AVG(r.rating) AS avg_rating
FROM reviews r
JOIN tour_packages t ON r.package_id = t.package_id
GROUP BY t.package_name, t.destination;

-- Retrieve all bookings along with user details and package information.
SELECT b.*, u.name, u.email, u.phone, t.package_name, t.destination, t.price
FROM bookings b
JOIN users u ON b.user_id = u.user_id
JOIN tour_packages t ON b.package_id = t.package_id;

-- List all users who have booked a package but have not yet paid.
SELECT DISTINCT u.user_id, u.name, u.email, u.phone 
FROM users u
JOIN bookings b ON u.user_id = b.user_id
LEFT JOIN payments p ON b.booking_id = p.booking_id
WHERE p.payment_id IS NULL OR p.payment_status = 'Pending';

-- Find the most popular travel destination based on the number of bookings.
SELECT TOP 1 t.destination, COUNT(b.package_id) AS total_bookings
FROM bookings b
JOIN tour_packages t ON b.package_id = t.package_id
GROUP BY t.destination
ORDER BY total_bookings DESC;

-- Retrieve all reviews for a specific package along with user details.
SELECT r.*, u.name, u.email, t.package_name, t.destination
FROM reviews r
JOIN users u ON r.user_id = u.user_id
JOIN tour_packages t ON r.package_id = t.package_id
WHERE t.package_id = 3;
