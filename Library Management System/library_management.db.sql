sqlite3 library_management.db

-- Users Table 
CREATE TABLE users (
  user_id INTEGER PRIMARY KEY,
  name VARCHAR(50),
  email VARCHAR(50) UNIQUE,
  phone VARCHAR(15),
  address TEXT,
  user_type VARCHAR(20) CHECK (user_type IN ('Student', 'Teacher', 'Librarian'))
);

-- Books Table
CREATE TABLE books (
  book_id INTEGER PRIMARY KEY,
  title VARCHAR(50),
  author VARCHAR(50),
  publisher VARCHAR(50),
  published_year YEAR,
  genre VARCHAR(50),
  isbn VARCHAR(50) UNIQUE,
  total_copies INTEGER,
  available_copies INTEGER
);

-- Borrowed Books Table
CREATE TABLE borrowed_books (
  borrow_id INTEGER PRIMARY KEY,
  user_id INTEGER,
  book_id INTEGER,
  borrow_date DATE,
  due_date DATE,
  return_date DATE NULL,
  status VARCHAR(15) CHECK (status IN ('Borrowed', 'Returned', 'Overdue')),
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (book_id) REFERENCES books(book_id)
);

-- Reservations Table
CREATE TABLE reservations (
  reservation_id INTEGER PRIMARY KEY,
  user_id INTEGER,
  book_id INTEGER,
  reservation_date DATE,
  status VARCHAR(15) CHECK (status IN ('Pending', 'Completed', 'Canceled')),
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (book_id) REFERENCES books(book_id)
);

-- Fines Table
CREATE TABLE fines (
  fine_id INTEGER PRIMARY KEY,
  user_id INTEGER,
  borrow_id INTEGER,
  fine_amount DECIMAL(10,2),
  fine_status VARCHAR(10) CHECK (fine_status IN ('Unpaid', 'Paid')),
  payment_date DATE NULL,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (borrow_id) REFERENCES borrowed_books(borrow_id)
);

-- Categories Table 
CREATE TABLE categories (
  category_id INT PRIMARY KEY,
  category_name VARCHAR(50)
);  

-- Insert sample data into users table
INSERT INTO users (user_id, name, email, phone, address, user_type) VALUES
(1, 'Alice Johnson', 'alice@example.com', '1234567890', '123 Maple St', 'Student'),
(2, 'Bob Smith', 'bob@example.com', '2345678901', '456 Oak St', 'Teacher'),
(3, 'Charlie Brown', 'charlie@example.com', '3456789012', '789 Pine St', 'Librarian'),
(4, 'David Lee', 'david@example.com', '4567890123', '321 Birch St', 'Student'),
(5, 'Eva Green', 'eva@example.com', '5678901234', '654 Cedar St', 'Teacher'),
(6, 'Frank White', 'frank@example.com', '6789012345', '987 Walnut St', 'Student'),
(7, 'Grace Black', 'grace@example.com', '7890123456', '147 Elm St', 'Librarian');

-- Insert sample data into books table
INSERT INTO books (book_id, title, author, publisher, published_year, genre, isbn, total_copies, available_copies) VALUES
(1, 'The Great Gatsby', 'F. Scott Fitzgerald', 'Scribner', 1925, 'Fiction', '9780743273565', 5, 3),
(2, 'To Kill a Mockingbird', 'Harper Lee', 'J.B. Lippincott & Co.', 1960, 'Fiction', '9780061120084', 4, 2),
(3, '1984', 'George Orwell', 'Secker & Warburg', 1949, 'Dystopian', '9780451524935', 6, 4),
(4, 'Moby Dick', 'Herman Melville', 'Harper & Brothers', 1851, 'Adventure', '9781503280786', 3, 2),
(5, 'Pride and Prejudice', 'Jane Austen', 'T. Egerton', 1813, 'Romance', '9781503290563', 7, 5),
(6, 'War and Peace', 'Leo Tolstoy', 'The Russian Messenger', 1869, 'Historical', '9781400079988', 2, 1),
(7, 'The Catcher in the Rye', 'J.D. Salinger', 'Little, Brown and Company', 1951, 'Fiction', '9780316769488', 4, 3);

-- Insert sample data into borrowed_books table
INSERT INTO borrowed_books (borrow_id, user_id, book_id, borrow_date, due_date, return_date, status) VALUES
(1, 1, 2, '2025-02-01', '2025-02-15', NULL, 'Borrowed'),
(2, 2, 3, '2025-01-20', '2025-02-03', '2025-02-02', 'Returned'),
(3, 3, 5, '2025-02-05', '2025-02-19', NULL, 'Borrowed'),
(4, 4, 1, '2025-01-10', '2025-01-24', '2025-01-25', 'Returned'),
(5, 5, 6, '2025-01-28', '2025-02-11', NULL, 'Overdue'),
(6, 6, 7, '2025-02-07', '2025-02-21', NULL, 'Borrowed'),
(7, 7, 4, '2025-01-15', '2025-01-29', '2025-01-30', 'Returned');

-- Insert sample data into reservations table
INSERT INTO reservations (reservation_id, user_id, book_id, reservation_date, status) VALUES
(1, 1, 3, '2025-02-01', 'Pending'),
(2, 2, 5, '2025-01-18', 'Completed'),
(3, 3, 7, '2025-02-04', 'Canceled'),
(4, 4, 2, '2025-01-30', 'Pending'),
(5, 5, 1, '2025-02-06', 'Completed'),
(6, 6, 6, '2025-02-08', 'Pending'),
(7, 7, 4, '2025-01-20', 'Canceled');

-- Insert sample data into fines table
INSERT INTO fines (fine_id, user_id, borrow_id, fine_amount, fine_status, payment_date) VALUES
(1, 1, 1, 10.00, 'Unpaid', NULL),
(2, 2, 2, 5.00, 'Paid', '2025-02-03'),
(3, 5, 5, 15.00, 'Unpaid', NULL),
(4, 4, 4, 7.50, 'Paid', '2025-01-26'),
(5, 7, 7, 12.00, 'Unpaid', NULL);

-- Insert sample data into categories table
INSERT INTO categories (category_id, category_name) VALUES
(1, 'Fiction'),
(2, 'Non-Fiction'),
(3, 'Science Fiction'),
(4, 'Romance'),
(5, 'Adventure'),
(6, 'Dystopian'),
(7, 'Historical');

-- Retrieve all overdue books along with user details.
SELECT bb.borrow_id, u.user_id, u.name, u.email, u.phone, b.book_id, b.title, bb.due_date
FROM borrowed_books bb
JOIN users u ON bb.user_id = u.user_id
JOIN books b ON bb.book_id = b.book_id
WHERE bb.status = 'Overdue';

-- Find the most borrowed book in the last 6 months.
SELECT b.book_id, b.title, COUNT(bb.book_id) AS borrow_count
FROM borrowed_books bb
JOIN books b ON bb.book_id = b.book_id
WHERE bb.borrow_date >= DATE('now', '-6 months')
GROUP BY b.book_id
ORDER BY borrow_count DESC
LIMIT 1;

-- List users who have unpaid fines greater than $10.
SELECT u.user_id, u.name, u.email, SUM(f.fine_amount) AS total_fine
FROM fines f
JOIN users u ON f.user_id = u.user_id
WHERE f.fine_status = 'Unpaid'
GROUP BY u.user_id
HAVING total_fine > 10;

-- Find users who have borrowed more than 5 books in the last month.
SELECT u.user_id, u.name, COUNT(bb.book_id) AS borrow_count
FROM borrowed_books bb
JOIN users u ON bb.user_id = u.user_id
WHERE bb.borrow_date >= DATE('now', '-1 month')
GROUP BY u.user_id
HAVING borrow_count > 5;

-- Check which books have zero available copies.
SELECT book_id, title
FROM books
WHERE available_copies = 0;

-- Retrieve books that have been reserved but not borrowed yet.
SELECT r.book_id, b.title, r.user_id, u.name, r.status
FROM reservations r
JOIN books b ON r.book_id = b.book_id
JOIN users u ON r.user_id = u.user_id
LEFT JOIN borrowed_books bb ON r.book_id = bb.book_id AND r.user_id = bb.user_id
WHERE r.status = 'Pending' AND bb.book_id IS NULL;

-- Find the total fine collected in the last year.
SELECT SUM(fine_amount) AS total_fine_collected
FROM fines
WHERE fine_status = 'Paid' AND payment_date >= DATE('now', '-1 year');

-- Identify books that have never been borrowed.
SELECT b.book_id, b.title
FROM books b
LEFT JOIN borrowed_books bb ON b.book_id = bb.book_id
WHERE bb.book_id IS NULL;

-- List students who have overdue books for more than 10 days.
SELECT u.user_id, u.name, u.email, bb.book_id, b.title, bb.due_date
FROM borrowed_books bb
JOIN users u ON bb.user_id = u.user_id
JOIN books b ON bb.book_id = b.book_id
WHERE bb.status = 'Overdue' AND u.user_type = 'Student' AND DATE('now') > DATE(bb.due_date, '+10 days');

-- Find the average number of books borrowed by each user type.
SELECT u.user_type, AVG(borrow_count) AS avg_books_borrowed
FROM (
  SELECT user_id, COUNT(book_id) AS borrow_count
  FROM borrowed_books
  GROUP BY user_id
) AS user_borrow_counts
JOIN users u ON user_borrow_counts.user_id = u.user_id
GROUP BY u.user_type;