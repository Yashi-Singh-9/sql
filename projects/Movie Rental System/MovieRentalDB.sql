-- MS SQL Project 

CREATE DATABASE MovieRentalDB;
USE MovieRentalDB;

-- Customers Table  
CREATE TABLE customers (
  customer_id INT IDENTITY(1,1) PRIMARY KEY,
  first_name VARCHAR(20),
  last_name VARCHAR(20),
  email VARCHAR(50) UNIQUE,
  phone_number BIGINT,
  address VARCHAR(50)
);

-- Movies Table  
CREATE TABLE movies (
  movie_id INT IDENTITY(1,1) PRIMARY KEY,
  title VARCHAR(20),
  genre VARCHAR(20),
  release_year INT,
  rating INT,
  price_per_day DECIMAL(10,2),
  stock_quantity INT
);

-- Rentals Table 
CREATE TABLE rentals (
  rental_id INT IDENTITY(1,1) PRIMARY KEY,
  customer_id INT,
  movie_id INT,
  rental_date DATE,
  return_date DATE,
  total_price DECIMAL(10,2),
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  FOREIGN KEY (movie_id) REFERENCES movies(movie_id)
);

-- Payments Table  
CREATE TABLE payments (
  payment_id INT IDENTITY(1,1) PRIMARY KEY,
  rental_id INT,
  amount DECIMAL(10,2),
  payment_date DATE,
  payment_method VARCHAR(20),
  FOREIGN KEY (rental_id) REFERENCES rentals(rental_id)
);

-- Staff Table  
CREATE TABLE staff (
  staff_id INT IDENTITY(1,1) PRIMARY KEY,
  name VARCHAR(20),
  email VARCHAR(50) UNIQUE,
  phone_number BIGINT,
  role VARCHAR(20)
);

-- Stores Table  
CREATE TABLE stores (
  store_id INT IDENTITY(1,1) PRIMARY KEY,
  store_name VARCHAR(20),
  location VARCHAR(50)
);

-- Movie Stock Table 
CREATE TABLE movie_stock (
  stock_id INT IDENTITY(1,1) PRIMARY KEY,
  store_id INT,
  movie_id INT,
  quantity_available INT,
  FOREIGN KEY (store_id) REFERENCES stores(store_id),
  FOREIGN KEY (movie_id) REFERENCES movies(movie_id)
);

-- Insert sample data into customers table
INSERT INTO customers (first_name, last_name, email, phone_number, address) 
VALUES 
('John', 'Doe', 'john.doe@example.com', 9876543210, '123 Main St'),
('Jane', 'Smith', 'jane.smith@example.com', 9876543211, '456 Oak Ave'),
('Robert', 'Brown', 'robert.brown@example.com', 9876543212, '789 Pine Rd'),
('Emily', 'Davis', 'emily.davis@example.com', 9876543213, '101 Elm Blvd'),
('Michael', 'Johnson', 'michael.johnson@example.com', 9876543214, '202 Cedar St'),
('Sarah', 'Wilson', 'sarah.wilson@example.com', 9876543215, '303 Maple Ln'),
('David', 'Martinez', 'david.martinez@example.com', 9876543216, '404 Birch Ct');

-- Insert sample data into movies table
INSERT INTO movies (title, genre, release_year, rating, price_per_day, stock_quantity) 
VALUES 
('Inception', 'Sci-Fi', 2010, 9, 3.50, 10),
('Titanic', 'Romance', 1997, 8, 2.99, 5),
('The Matrix', 'Action', 1999, 9, 3.00, 8),
('Avengers', 'Superhero', 2012, 9, 4.00, 7),
('Joker', 'Thriller', 2019, 8, 3.75, 6),
('Toy Story', 'Animation', 1995, 8, 2.50, 9),
('Fast & Furious', 'Action', 2001, 7, 3.25, 12);

-- Insert sample data into stores table
INSERT INTO stores (store_name, location) 
VALUES 
('Downtown Movies', 'Downtown'),
('Cineplex 5', 'Westside'),
('Movie Hub', 'Eastside'),
('Big Screen Rentals', 'Northside'),
('Film Fanatics', 'Southside'),
('Blockbuster 2.0', 'Uptown'),
('Reel World', 'Midtown');

-- Insert sample data into movie_stock table
INSERT INTO movie_stock (store_id, movie_id, quantity_available) 
VALUES 
(1, 1, 5),
(2, 2, 2),
(3, 3, 4),
(4, 4, 3),
(5, 5, 6),
(6, 6, 7),
(7, 7, 8);

-- Insert sample data into rentals table
INSERT INTO rentals (customer_id, movie_id, rental_date, return_date, total_price) 
VALUES 
(1, 1, '2024-02-10', '2024-02-12', 7.00),
(2, 3, '2024-02-11', '2024-02-13', 6.00),
(3, 5, '2024-02-12', '2024-02-14', 7.50),
(4, 2, '2024-02-13', '2024-02-15', 5.98),
(5, 6, '2024-02-14', '2024-02-16', 5.00),
(6, 4, '2024-02-15', '2024-02-17', 8.00),
(7, 7, '2024-02-16', '2024-02-18', 6.50);

-- Insert sample data into payments table
INSERT INTO payments (rental_id, amount, payment_date, payment_method) 
VALUES 
(1, 7.00, '2024-02-12', 'Credit Card'),
(2, 6.00, '2024-02-13', 'Cash'),
(3, 7.50, '2024-02-14', 'Debit Card'),
(4, 5.98, '2024-02-15', 'PayPal'),
(5, 5.00, '2024-02-16', 'Credit Card'),
(6, 8.00, '2024-02-17', 'Cash'),
(7, 6.50, '2024-02-18', 'Debit Card');

-- Insert sample data into staff table
INSERT INTO staff (name, email, phone_number, role) 
VALUES 
('Alice Green', 'alice.green@example.com', 9876543220, 'Manager'),
('Bob White', 'bob.white@example.com', 9876543221, 'Cashier'),
('Charlie Black', 'charlie.black@example.com', 9876543222, 'Clerk'),
('Diana Gray', 'diana.gray@example.com', 9876543223, 'Manager'),
('Ethan Blue', 'ethan.blue@example.com', 9876543224, 'Cashier'),
('Fiona Red', 'fiona.red@example.com', 9876543225, 'Clerk'),
('George Brown', 'george.brown@example.com', 9876543226, 'Manager');

-- Retrieve the most rented movies along with their rental count.
SELECT m.movie_id, m.title, COUNT(r.rental_id) AS rental_count
FROM rentals r
JOIN movies m ON r.movie_id = m.movie_id
GROUP BY m.movie_id, m.title
ORDER BY rental_count DESC;

-- Identify overdue rentals (movies not returned on time).
SELECT r.rental_id, c.first_name, c.last_name, m.title, r.rental_date, r.return_date
FROM rentals r
JOIN customers c ON r.customer_id = c.customer_id
JOIN movies m ON r.movie_id = m.movie_id
WHERE r.return_date < GETDATE();

-- Find which genre of movies is rented the most.
SELECT TOP 1 m.genre, COUNT(r.rental_id) AS rental_count
FROM rentals r
JOIN movies m ON r.movie_id = m.movie_id
GROUP BY m.genre
ORDER BY rental_count DESC;

-- Find out which customer has spent the most money on rentals.
SELECT TOP 1 c.customer_id, c.first_name, c.last_name, SUM(p.amount) AS total_spent
FROM payments p
JOIN rentals r ON p.rental_id = r.rental_id
JOIN customers c ON r.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC;

-- Determine the most popular payment method used by customers.
SELECT TOP 1 p.payment_method, COUNT(p.payment_id) AS usage_count
FROM payments p
GROUP BY p.payment_method
ORDER BY usage_count DESC;

-- Identify the top 3 customers based on total rentals.
SELECT TOP 3 c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS rental_count
FROM rentals r
JOIN customers c ON r.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY rental_count DESC;

-- Find the average number of rentals per customer.
SELECT AVG(rental_count) AS avg_rentals_per_customer
FROM (
    SELECT customer_id, COUNT(rental_id) AS rental_count
    FROM rentals
    GROUP BY customer_id
) AS customer_rentals;

-- Retrieve customer details along with the total number of movies they have rented.
SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS total_rentals
FROM customers c
LEFT JOIN rentals r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

-- Find the least rented movies.
SELECT TOP 3 m.movie_id, m.title, COUNT(r.rental_id) AS rental_count
FROM movies m
LEFT JOIN rentals r ON m.movie_id = r.movie_id
GROUP BY m.movie_id, m.title
ORDER BY rental_count ASC;

-- List all movies rented by a specific customer.
SELECT m.movie_id, m.title, r.rental_date
FROM rentals r
JOIN movies m ON r.movie_id = m.movie_id
WHERE r.customer_id = 3;

-- Find out which movie has generated the most revenue.
SELECT TOP 1 m.movie_id, m.title, SUM(p.amount) AS total_revenue
FROM payments p
JOIN rentals r ON p.rental_id = r.rental_id
JOIN movies m ON r.movie_id = m.movie_id
GROUP BY m.movie_id, m.title
ORDER BY total_revenue DESC;

-- Find the most rented movie for each store.
SELECT ms.store_id, s.store_name, m.movie_id, m.title, COUNT(r.rental_id) AS rental_count
FROM rentals r
JOIN movies m ON r.movie_id = m.movie_id
JOIN movie_stock ms ON r.movie_id = ms.movie_id
JOIN stores s ON ms.store_id = s.store_id
GROUP BY ms.store_id, s.store_name, m.movie_id, m.title
ORDER BY rental_count DESC;

-- Retrieve movies with stock availability less than 5 in any store.
SELECT ms.store_id, s.store_name, m.movie_id, m.title, ms.quantity_available
FROM movie_stock ms
JOIN movies m ON ms.movie_id = m.movie_id
JOIN stores s ON ms.store_id = s.store_id
WHERE ms.quantity_available < 5;

-- Find the total revenue generated from all rentals.
SELECT SUM(amount) AS total_revenue 
FROM payments;

-- Calculate the average rental duration of movies.
SELECT AVG(DATEDIFF(DAY, rental_date, return_date)) AS avg_rental_duration 
FROM rentals;

-- Find the total rental income per store.
SELECT s.store_id, s.store_name, SUM(p.amount) AS total_income
FROM payments p
JOIN rentals r ON p.rental_id = r.rental_id
JOIN movie_stock ms ON r.movie_id = ms.movie_id
JOIN stores s ON ms.store_id = s.store_id
GROUP BY s.store_id, s.store_name;

-- List all rentals that have been paid for in cash.
SELECT * 
FROM payments 
WHERE payment_method = 'Cash';

-- Calculate the total amount paid by each customer.
SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount) AS total_paid
FROM payments p
JOIN rentals r ON p.rental_id = r.rental_id
JOIN customers c ON r.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

-- List all rental transactions sorted by payment amount.
SELECT * 
FROM payments 
ORDER BY amount DESC;

-- Find the payment method used most frequently.
SELECT TOP 1 payment_method, COUNT(*) AS usage_count
FROM payments
GROUP BY payment_method
ORDER BY usage_count DESC;

-- Retrieve the details of the largest single rental transaction.
SELECT TOP 1 * 
FROM payments 
ORDER BY amount DESC;

-- Find the store with the most available stock for a specific movie.
SELECT TOP 1 s.store_id, s.store_name, ms.quantity_available
FROM movie_stock ms
JOIN stores s ON ms.store_id = s.store_id
WHERE ms.movie_id = 2
ORDER BY ms.quantity_available DESC;

-- Retrieve the store locations where the most number of movies are rented.
SELECT TOP 1 s.store_id, s.store_name, COUNT(r.rental_id) AS total_rentals
FROM rentals r
JOIN movie_stock ms ON r.movie_id = ms.movie_id
JOIN stores s ON ms.store_id = s.store_id
GROUP BY s.store_id, s.store_name
ORDER BY total_rentals DESC;

-- List all stores along with their total number of rentals.
SELECT s.store_id, s.store_name, COUNT(r.rental_id) AS total_rentals
FROM stores s
LEFT JOIN movie_stock ms ON s.store_id = ms.store_id
LEFT JOIN rentals r ON ms.movie_id = r.movie_id
GROUP BY s.store_id, s.store_name;

-- Find which store has the highest customer retention rate.
SELECT TOP 1 s.store_id, s.store_name, COUNT(DISTINCT r.customer_id) AS unique_customers
FROM stores s
JOIN movie_stock ms ON s.store_id = ms.store_id
JOIN rentals r ON ms.movie_id = r.movie_id
GROUP BY s.store_id, s.store_name
ORDER BY unique_customers DESC;