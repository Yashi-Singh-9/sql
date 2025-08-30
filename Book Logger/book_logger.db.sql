-- MS SQL Project
CREATE DATABASE book_logger;

-- Users Table 
CREATE TABLE users (
  user_id INT IDENTITY(1,1) PRIMARY KEY,
  username VARCHAR(30),
  email VARCHAR(30),
  password VARCHAR(30),
  created_at TIMESTAMP,
);

-- Books Table
CREATE TABLE books (
  book_id INT IDENTITY(1,1) PRIMARY KEY,
  title VARCHAR(30),
  author VARCHAR(30),
  isbn VARCHAR(20) UNIQUE,
  genre VARCHAR(20),
  published_year DATE
);

-- Logs Table 
Create TABLE logs (
  log_id INT IDENTITY(1,1) PRIMARY Key,
  user_id INT NOT NULL,
  book_id INT NOT NULL,
  status VARCHAR(20) CHECK (status IN ('Reading', 'Completed', 'Dropped')) NOT NULL,
  started_at DATETIME NOT NULL,
  finished_at DATETIME NULL,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (book_id) REFERENCES books(book_id)
);

-- Reviews Table 
CREATE TABLE reviews (
  review_id INT IDENTITY(1,1) PRIMARY KEY,
  user_id INT,
  book_id INT,
  rating INT CHECK (rating BETWEEN 1 AND 5),
  review_text TEXT,
  review_date DATE,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (book_id) REFERENCES books(book_id)
);

-- Authors Table 
CREATE TABLE authors (
  author_id INT IDENTITY(1,1) PRIMARY KEY,
  name VARCHAR(20),
  bio TEXT
);

-- Insert sample users
INSERT INTO users (username, email, password, created_at) VALUES
('john_doe', 'john@example.com', 'pass123', DEFAULT),
('jane_smith', 'jane@example.com', 'pass456', DEFAULT),
('mike_jones', 'mike@example.com', 'pass789', DEFAULT),
('susan_lee', 'susan@example.com', 'pass321', DEFAULT),
('alex_wong', 'alex@example.com', 'pass654', DEFAULT),
('emma_clark', 'emma@example.com', 'pass987', DEFAULT),
('david_kim', 'david@example.com', 'pass111', DEFAULT),
('lisa_moore', 'lisa@example.com', 'pass222', DEFAULT);

-- Insert sample authors
INSERT INTO authors (name, bio) VALUES
('J.K. Rowling', 'British author, best known for Harry Potter.'),
('George Orwell', 'English novelist and critic, famous for 1984.'),
('J.R.R. Tolkien', 'Author of The Lord of the Rings.'),
('Agatha Christie', 'British writer known for detective novels.'),
('Stephen King', 'American author of horror and suspense.'),
('Isaac Asimov', 'Science fiction writer and biochemist.'),
('Mark Twain', 'Famous for Adventures of Huckleberry Finn.'),
('Ernest Hemingway', 'Known for The Old Man and the Sea.');

-- Insert sample books
INSERT INTO books (title, author, isbn, genre, published_year) VALUES
('Harry Potter', 'J.K. Rowling', '1234567890', 'Fantasy', '1997-06-26'),
('1984', 'George Orwell', '1234567891', 'Dystopian', '1949-06-08'),
('The Hobbit', 'J.R.R. Tolkien', '1234567892', 'Fantasy', '1937-09-21'),
('Murder on the Orient Express', 'Agatha Christie', '1234567893', 'Mystery', '1934-01-01'),
('It', 'Stephen King', '1234567894', 'Horror', '1986-09-15'),
('Foundation', 'Isaac Asimov', '1234567895', 'Science Fiction', '1951-05-01'),
('Huckleberry Finn', 'Mark Twain', '1234567896', 'Adventure', '1884-12-10'),
('The Old Man and the Sea', 'Ernest Hemingway', '1234567897', 'Classic', '1952-09-01');

-- Insert sample logs (random user-book assignment)
INSERT INTO logs (user_id, book_id, status, started_at, finished_at) VALUES
(1, 2, 'Reading', '2024-01-01', NULL),
(2, 3, 'Completed', '2023-12-10', '2023-12-20'),
(3, 1, 'Dropped', '2024-01-05', NULL),
(4, 5, 'Reading', '2024-01-08', NULL),
(5, 6, 'Completed', '2023-11-15', '2023-11-30'),
(6, 7, 'Completed', '2023-10-10', '2023-10-20'),
(7, 4, 'Reading', '2024-02-01', NULL),
(8, 8, 'Completed', '2023-09-01', '2023-09-10');

-- Insert sample reviews (random user-book assignment)
INSERT INTO reviews (user_id, book_id, rating, review_text, review_date) VALUES
(1, 2, 5, 'Amazing book! A must-read.', '2024-01-15'),
(2, 3, 4, 'Enjoyed the adventure!', '2023-12-25'),
(3, 1, 3, 'It was okay, a bit slow.', '2024-01-10'),
(4, 5, 5, 'Stephen King never disappoints.', '2024-01-20'),
(5, 6, 4, 'Great sci-fi classic.', '2023-12-01'),
(6, 7, 5, 'Mark Twain’s humor is unmatched.', '2023-10-25'),
(7, 4, 3, 'Interesting mystery, but not my favorite.', '2024-02-05'),
(8, 8, 4, 'Simple but powerful story.', '2023-09-15');

-- Find all books logged by a specific user.
SELECT b.*
FROM books b
JOIN logs l ON b.book_id = l.book_id
WHERE l.user_id = 3;

-- Find the top-rated books based on user reviews.
SELECT b.title, AVG(r.rating) AS avg_rating
FROM books b
JOIN reviews r ON b.book_id = r.book_id
GROUP BY b.title
ORDER BY avg_rating DESC;

-- List all books a user has completed reading.
SELECT b.*
FROM books b
JOIN logs l ON b.book_id = l.book_id
WHERE l.user_id = 2 AND l.status = 'Completed';

-- Find the most active users (who logged the most books).
SELECT u.username, COUNT(l.log_id) AS books_logged
FROM users u
JOIN logs l ON u.user_id = l.user_id
GROUP BY u.username
ORDER BY books_logged DESC;

-- List books that have been started but never finished.
SELECT b.*
FROM books b
JOIN logs l ON b.book_id = l.book_id
WHERE l.finished_at IS NULL;

-- Find the most reviewed books.
SELECT b.title, COUNT(r.review_id) AS review_count
FROM books b
JOIN reviews r ON b.book_id = r.book_id
GROUP BY b.title
ORDER BY review_count DESC;

-- Get the average rating for each book.
SELECT b.title, AVG(r.rating) AS avg_rating
FROM books b
LEFT JOIN reviews r ON b.book_id = r.book_id
GROUP BY b.title
ORDER BY avg_rating DESC;

-- Find the books read by most users.
SELECT b.title, COUNT(DISTINCT l.user_id) AS user_count
FROM books b
JOIN logs l ON b.book_id = l.book_id
GROUP BY b.title
ORDER BY user_count DESC;

-- Find books that no user has logged yet.
SELECT b.*
FROM books b
LEFT JOIN logs l ON b.book_id = l.book_id
WHERE l.book_id IS NULL;

-- Find users who have logged books in multiple genres.
SELECT u.username, COUNT(DISTINCT b.genre) AS genre_count
FROM users u
JOIN logs l ON u.user_id = l.user_id
JOIN books b ON l.book_id = b.book_id
GROUP BY u.username
HAVING COUNT(DISTINCT b.genre) > 1;
