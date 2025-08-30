-- Maria DB Project
-- Create Database
CREATE DATABASE BookAnalysisDB;
USE BookAnalysisDB;

-- Genres Table 
CREATE TABLE genres (
  genre_id INT PRIMARY KEY AUTO_INCREMENT,
  genre_name VARCHAR(50) NOT NULL
);

-- Authors Table 
CREATE TABLE author (
  author_id INT PRIMARY KEY AUTO_INCREMENT,
  author_name VARCHAR(50) NOT NULL,
  country VARCHAR(50) NOT NULL
);

-- Books Table 
CREATE TABLE books (
  book_id INT PRIMARY KEY AUTO_INCREMENT,
  title VARCHAR(50) NOT NULL,
  genre_id INT,
  author_id INT,
  published_year INT,
  total_sales INT DEFAULT 0,
  FOREIGN KEY (genre_id) REFERENCES genres(genre_id),
  FOREIGN KEY (author_id) REFERENCES author(author_id)
);

-- Users Table 
CREATE TABLE users (
  user_id INT PRIMARY KEY AUTO_INCREMENT,
  user_name VARCHAR(50) NOT NULL,
  age INT CHECK (age >= 0),
  location VARCHAR(50)
);

-- Ratings Table 
CREATE TABLE ratings (
  rating_id INT PRIMARY KEY AUTO_INCREMENT,
  book_id INT,
  user_id INT,
  rating INT CHECK (rating BETWEEN 1 AND 5),
  review_text TEXT,
  rating_date DATE DEFAULT CURDATE(),
  FOREIGN KEY (book_id) REFERENCES books(book_id),
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Purchases Table 
CREATE TABLE purchases (
  purchase_id INT PRIMARY KEY AUTO_INCREMENT,
  book_id INT,
  user_id INT,
  purchase_date DATE DEFAULT CURDATE(),
  price DECIMAL(6,2) CHECK (price > 0),
  FOREIGN KEY (book_id) REFERENCES books(book_id),
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Insert into genres
INSERT INTO genres (genre_name) VALUES
('Fiction'), ('Non-Fiction'), ('Science Fiction'), ('Mystery'),
('Biography'), ('Fantasy'), ('History'), ('Horror');

-- Insert into authors
INSERT INTO author (author_name, country) VALUES
('J.K. Rowling', 'UK'), ('George Orwell', 'UK'), ('Agatha Christie', 'UK'),
('J.R.R. Tolkien', 'UK'), ('Stephen King', 'USA'), ('Isaac Asimov', 'USA'),
('Ernest Hemingway', 'USA'), ('Mark Twain', 'USA');

-- Insert into books 
INSERT INTO books (title, genre_id, author_id, published_year, total_sales) VALUES
('Harry Potter', 6, 1, 1997, 1200000),
('1984', 1, 2, 1949, 1500000),
('Murder on the Orient Express', 4, 3, 1934, 1000000),
('The Hobbit', 6, 4, 1937, 1400000),
('The Shining', 8, 5, 1977, 1100000),
('Foundation', 3, 6, 1951, 900000),
('The Old Man and the Sea', 5, 7, 1952, 950000),
('Adventures of Huckleberry Finn', 1, 8, 1885, 1300000);

-- Insert into users
INSERT INTO users (user_name, age, location) VALUES
('Alice', 25, 'New York'), ('Bob', 30, 'Los Angeles'), ('Charlie', 22, 'Chicago'),
('David', 35, 'Houston'), ('Emma', 28, 'Phoenix'), ('Frank', 40, 'Philadelphia'),
('Grace', 33, 'San Antonio'), ('Hannah', 27, 'San Diego');

-- Insert into ratings 
INSERT INTO ratings (book_id, user_id, rating, review_text, rating_date) VALUES
(1, 1, 5, 'Amazing book!', '2024-01-01'),
(2, 2, 4, 'Very interesting.', '2024-01-05'),
(3, 3, 5, 'A classic mystery.', '2024-01-10'),
(4, 1, 4, 'Enjoyed it a lot.', '2024-01-15'),
(5, 4, 3, 'A bit scary for me.', '2024-01-20'),
(6, 5, 4, 'Great sci-fi novel.', '2024-01-25'),
(7, 6, 5, 'Loved the storytelling.', '2024-01-30'),
(8, 7, 4, 'A must-read.', '2024-02-01');

-- Insert into purchases
INSERT INTO purchases (book_id, user_id, purchase_date, price) VALUES
(1, 1, '2024-02-01', 12.99), (2, 2, '2024-02-02', 10.99),
(3, 3, '2024-02-03', 15.99), (4, 1, '2024-02-04', 14.99),
(5, 4, '2024-02-05', 11.99), (6, 5, '2024-02-06', 9.99),
(7, 6, '2024-02-07', 13.99), (8, 7, '2024-02-08', 16.99);

-- Find the top 5 most popular genres based on book sales.
SELECT g.genre_name, SUM(b.total_sales) AS total_sales
FROM books b
JOIN genres g ON b.genre_id = g.genre_id
GROUP BY g.genre_id
ORDER BY total_sales DESC
LIMIT 5;

-- List the top 4 highest-rated books along with their average ratings.
SELECT b.title, AVG(r.rating) AS avg_rating
FROM ratings r
JOIN books b ON r.book_id = b.book_id
GROUP BY r.book_id
ORDER BY avg_rating DESC
LIMIT 4;

-- Identify the most popular book genre among users aged 18-25.
SELECT g.genre_name, COUNT(*) AS total_purchases
FROM purchases p
JOIN books b ON p.book_id = b.book_id
JOIN genres g ON b.genre_id = g.genre_id
JOIN users u ON p.user_id = u.user_id
WHERE u.age BETWEEN 18 AND 25
GROUP BY g.genre_id
ORDER BY total_purchases DESC
LIMIT 1;

-- Get the total sales for each genre and rank them.
SELECT g.genre_name, SUM(b.total_sales) AS total_sales,
       RANK() OVER (ORDER BY SUM(b.total_sales) DESC) AS sales_rank
FROM books b
JOIN genres g ON b.genre_id = g.genre_id
GROUP BY g.genre_id
ORDER BY total_sales DESC;

-- Find the author whose books have the highest average rating.
SELECT a.author_name, AVG(r.rating) AS avg_rating
FROM books b
JOIN author a ON b.author_id = a.author_id
JOIN ratings r ON b.book_id = r.book_id
GROUP BY a.author_id
ORDER BY avg_rating DESC
LIMIT 1;

-- Get the top 3 users who purchased the most books.
SELECT u.user_name, COUNT(p.purchase_id) AS total_purchases
FROM purchases p
JOIN users u ON p.user_id = u.user_id
GROUP BY u.user_id
ORDER BY total_purchases DESC
LIMIT 3;

-- Find the books that are most frequently purchased together (by the same user).
SELECT p1.book_id AS book1, p2.book_id AS book2, COUNT(*) AS times_purchased_together
FROM purchases p1
JOIN purchases p2 ON p1.user_id = p2.user_id AND p1.book_id < p2.book_id
GROUP BY p1.book_id, p2.book_id
ORDER BY times_purchased_together DESC
LIMIT 5;

-- Find the Most Active Users (Users Who Have Given the Most Ratings)
SELECT u.user_name, COUNT(r.rating_id) AS total_ratings
FROM ratings r
JOIN users u ON r.user_id = u.user_id
GROUP BY u.user_id
ORDER BY total_ratings DESC
LIMIT 3;

-- Find the Oldest Books That Are Still Being Purchased
SELECT b.title, b.published_year, COUNT(p.purchase_id) AS total_purchases
FROM books b
JOIN purchases p ON b.book_id = p.book_id
GROUP BY b.book_id
ORDER BY b.published_year ASC, total_purchases DESC
LIMIT 5;

-- Find Users Who Have Purchased and Rated the Same Book
SELECT u.user_name, b.title, p.purchase_date, r.rating
FROM purchases p
JOIN ratings r ON p.book_id = r.book_id AND p.user_id = r.user_id
JOIN books b ON p.book_id = b.book_id
JOIN users u ON p.user_id = u.user_id
ORDER BY u.user_name, p.purchase_date;

-- Identify the Best-Selling Author
SELECT a.author_name, SUM(b.total_sales) AS total_sales
FROM books b
JOIN author a ON b.author_id = a.author_id
GROUP BY a.author_id
ORDER BY total_sales DESC
LIMIT 1;

-- Find the Most Expensive Books Purchased 
SELECT b.title, MAX(p.price) AS highest_price
FROM purchases p
JOIN books b ON p.book_id = b.book_id
GROUP BY b.book_id
ORDER BY highest_price DESC
LIMIT 5;

-- Find the Most Popular Books Based on Total Purchases
SELECT b.title, COUNT(p.purchase_id) AS total_purchases
FROM purchases p
JOIN books b ON p.book_id = b.book_id
GROUP BY b.book_id
ORDER BY total_purchases DESC
LIMIT 4;

-- Find Users Who Only Buy Books in a Specific Genre
SELECT u.user_name, g.genre_name, COUNT(p.purchase_id) AS total_purchases
FROM purchases p
JOIN books b ON p.book_id = b.book_id
JOIN genres g ON b.genre_id = g.genre_id
JOIN users u ON p.user_id = u.user_id
GROUP BY u.user_id, g.genre_id
HAVING COUNT(DISTINCT g.genre_id) = 1
ORDER BY total_purchases DESC;
