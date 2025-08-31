-- MS SQL Project
CREATE DATABASE LibraryDB;
USE LibraryDB;

-- Users Table  
CREATE TABLE users (
  user_id INT IDENTITY(1,1) PRIMARY KEY,
  name VARCHAR(20),
  email VARCHAR(50) UNIQUE,
  phone_number BIGINT,
  address TEXT,
  user_type VARCHAR(11) CHECK (user_type IN ('Member', 'Librarian'))
);

INSERT INTO users (name, email, phone_number, address, user_type) VALUES
('Alice Johnson', 'alice.johnson@example.com', 9876543210, '123 Main St, NY', 'Member'),
('Bob Smith', 'bob.smith@example.com', 8765432109, '456 Elm St, CA', 'Librarian'),
('Charlie Brown', 'charlie.brown@example.com', 7654321098, '789 Oak St, TX', 'Member'),
('David Wilson', 'david.wilson@example.com', 6543210987, '321 Pine St, FL', 'Member'),
('Emma Davis', 'emma.davis@example.com', 5432109876, '567 Cedar St, IL', 'Librarian'),
('Frank Thomas', 'frank.thomas@example.com', 4321098765, '890 Birch St, WA', 'Member');

-- Categories Table  
CREATE TABLE categories (
  category_id INT IDENTITY(1,1) PRIMARY KEY,
  category_name VARCHAR(50) UNIQUE
);  

INSERT INTO categories (category_name) VALUES
('Fiction'),
('Non-Fiction'),
('Science'),
('History'),
('Biography'),
('Technology');

-- Books Table  
CREATE TABLE books (
  book_id INT IDENTITY(1,1) PRIMARY KEY,
  title VARCHAR(20),
  author VARCHAR(20),
  isbn VARCHAR(20) UNIQUE NOT NULL,
  publisher VARCHAR(30),
  year_published INT,
  category_id INT,
  total_copies INT CHECK (total_copies >= 0),
  available_copies INT CHECK (available_copies >= 0),
  FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

INSERT INTO books (title, author, isbn, publisher, year_published, category_id, total_copies, available_copies) VALUES
('The Alchemist', 'Paulo Coelho', '9780061122415', 'HarperOne', 1993, 1, 10, 7),
('Sapiens', 'Yuval Noah Harari', '9780062316097', 'Harper', 2011, 2, 8, 5),
('A Brief History', 'Stephen Hawking', '9780553380163', 'Bantam', 1988, 3, 12, 9),
('The Wright Brothers', 'David McCullough', '9781476728759', 'Simon & Schuster', 2015, 4, 6, 4),
('Steve Jobs', 'Walter Isaacson', '9781451648539', 'Simon & Schuster', 2011, 5, 15, 10),
('Clean Code', 'Robert C. Martin', '9780132350884', 'Prentice Hall', 2008, 6, 5, 2);

-- Borrowing Table  
CREATE TABLE borrowing (
  borrow_id INT IDENTITY(1,1) PRIMARY KEY,
  user_id INT,
  book_id INT,
  borrow_date DATE,
  due_date DATE,
  return_date DATE NULL,
  status VARCHAR(10) CHECK (status IN ('Borrowed', 'Returned', 'Overdue')),
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (book_id) REFERENCES books(book_id)
);

INSERT INTO borrowing (user_id, book_id, borrow_date, due_date, return_date, status) VALUES
(1, 3, '2024-02-01', '2024-02-15', NULL, 'Borrowed'),
(2, 5, '2024-01-20', '2024-02-03', '2024-02-02', 'Returned'),
(3, 2, '2024-02-05', '2024-02-19', NULL, 'Borrowed'),
(4, 1, '2024-01-10', '2024-01-24', '2024-01-25', 'Returned'),
(5, 6, '2024-01-28', '2024-02-11', NULL, 'Overdue'),
(6, 4, '2024-02-03', '2024-02-17', NULL, 'Borrowed');

-- Reservations Table  
CREATE TABLE reservations (
  reservation_id INT IDENTITY(1,1) PRIMARY KEY,
  user_id INT,
  book_id INT,
  reservation_date DATE,
  status VARCHAR(15) CHECK (status IN ('Pending', 'Completed', 'Canceled')),
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (book_id) REFERENCES books(book_id)
);

INSERT INTO reservations (user_id, book_id, reservation_date, status) VALUES
(1, 2, '2024-02-10', 'Pending'),
(2, 3, '2024-01-25', 'Completed'),
(3, 1, '2024-02-05', 'Pending'),
(4, 5, '2024-01-30', 'Canceled'),
(5, 6, '2024-02-08', 'Pending'),
(6, 4, '2024-02-02', 'Completed');

-- Fines Table  
CREATE TABLE fines (
  fine_id INT IDENTITY(1,1) PRIMARY KEY,
  user_id INT,
  borrow_id INT,
  fine_amount DECIMAL(8,2),
  fine_status VARCHAR(8) CHECK (fine_status IN ('Pending', 'Paid')),
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (borrow_id) REFERENCES borrowing(borrow_id)
);

INSERT INTO fines (user_id, borrow_id, fine_amount, fine_status) VALUES
(1, 5, 10.00, 'Pending'),
(2, 2, 5.00, 'Paid'),
(3, 3, 7.50, 'Pending'),
(4, 4, 0.00, 'Paid'),
(5, 5, 12.00, 'Pending'),
(6, 6, 3.00, 'Paid');

-- Librarians Table  
CREATE TABLE librarians (
  librarian_id INT IDENTITY(1,1) PRIMARY KEY,
  user_id INT,
  hire_date DATE,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

INSERT INTO librarians (user_id, hire_date) VALUES
(2, '2020-06-15'),
(5, '2018-09-10'),
(6, '2022-03-25');

-- Retrieve the details of all books that have been borrowed at least once.
SELECT DISTINCT b.*
FROM books b
JOIN borrowing br ON b.book_id = br.book_id;

-- Find the number of books currently available for borrowing in each category.
SELECT c.category_name, SUM(b.available_copies) AS available_books
FROM books b
JOIN categories c ON b.category_id = c.category_id
GROUP BY c.category_name;

-- List all overdue books along with the borrower's name and due date.
SELECT u.name AS borrower_name, b.title, br.due_date
FROM borrowing br
JOIN users u ON br.user_id = u.user_id
JOIN books b ON br.book_id = b.book_id
WHERE br.status = 'Overdue';

-- Get the total fine amount pending for a particular user.
SELECT u.name, SUM(f.fine_amount) AS total_pending_fine
FROM fines f
JOIN users u ON f.user_id = u.user_id
WHERE f.fine_status = 'Pending' AND f.user_id = 1
GROUP BY u.name;

-- List all reservations that are still pending.
SELECT r.*, u.name AS user_name, b.title AS book_title
FROM reservations r
JOIN users u ON r.user_id = u.user_id
JOIN books b ON r.book_id = b.book_id
WHERE r.status = 'Pending';

-- Find the book that has been borrowed the most.
SELECT TOP 1 b.title, COUNT(br.borrow_id) AS times_borrowed
FROM borrowing br
JOIN books b ON br.book_id = b.book_id
GROUP BY b.title
ORDER BY times_borrowed DESC;

-- Count the number of books borrowed by each user.
SELECT u.user_id, u.name, COUNT(br.borrow_id) AS books_borrowed
FROM users u
LEFT JOIN borrowing br ON u.user_id = br.user_id
GROUP BY u.user_id, u.name
ORDER BY books_borrowed DESC;

-- Get a list of books that were borrowed but never returned.
SELECT b.title, u.name AS borrower_name, br.borrow_date, br.due_date
FROM borrowing br
JOIN books b ON br.book_id = b.book_id
JOIN users u ON br.user_id = u.user_id
WHERE br.return_date IS NULL;

-- Retrieve the most active borrowers (users who borrowed the most books)
SELECT TOP 3 u.user_id, u.name, COUNT(br.borrow_id) AS total_borrowed
FROM borrowing br
JOIN users u ON br.user_id = u.user_id
GROUP BY u.user_id, u.name
ORDER BY total_borrowed DESC;

-- Find the most popular book category based on borrow count
SELECT TOP 1 c.category_name, COUNT(br.borrow_id) AS borrow_count
FROM borrowing br
JOIN books b ON br.book_id = b.book_id
JOIN categories c ON b.category_id = c.category_id
GROUP BY c.category_name
ORDER BY borrow_count DESC;

-- Find overdue books along with the number of days overdue
SELECT u.name AS borrower_name, b.title, br.due_date, 
       DATEDIFF(DAY, br.due_date, GETDATE()) AS days_overdue
FROM borrowing br
JOIN users u ON br.user_id = u.user_id
JOIN books b ON br.book_id = b.book_id
WHERE br.due_date < GETDATE() AND br.return_date IS NULL;

-- Find the average number of books borrowed per user 
SELECT AVG(borrow_count) AS avg_books_borrowed_per_user
FROM (
    SELECT COUNT(br.borrow_id) AS borrow_count
    FROM borrowing br
    GROUP BY br.user_id
) AS borrow_stats;

-- Find the librarian who has been working the longest
SELECT TOP 1 u.name AS librarian_name, l.hire_date
FROM librarians l
JOIN users u ON l.user_id = u.user_id
ORDER BY l.hire_date ASC;

-- Find users who have both borrowed and reserved books
SELECT DISTINCT u.user_id, u.name
FROM users u
JOIN borrowing br ON u.user_id = br.user_id
JOIN reservations r ON u.user_id = r.user_id;

-- List users who have paid at least one fine
SELECT DISTINCT u.user_id, u.name
FROM users u
JOIN fines f ON u.user_id = f.user_id
WHERE f.fine_status = 'Paid';

-- Find the total number of books borrowed per category
SELECT c.category_name, COUNT(br.book_id) AS total_borrowed
FROM borrowing br
JOIN books b ON br.book_id = b.book_id
JOIN categories c ON b.category_id = c.category_id
GROUP BY c.category_name
ORDER BY total_borrowed DESC;

-- Retrieve the most recent borrowing transactions
SELECT TOP 10 u.name AS borrower_name, b.title, br.borrow_date, br.due_date
FROM borrowing br
JOIN users u ON br.user_id = u.user_id
JOIN books b ON br.book_id = b.book_id
ORDER BY br.borrow_date DESC;

-- List books that have been both borrowed and reserved
SELECT DISTINCT b.title
FROM books b
JOIN borrowing br ON b.book_id = br.book_id
JOIN reservations r ON b.book_id = r.book_id;

-- List all users who have outstanding fines
SELECT DISTINCT u.user_id, u.name, SUM(f.fine_amount) AS total_due
FROM users u
JOIN fines f ON u.user_id = f.user_id
WHERE f.fine_status = 'Pending'
GROUP BY u.user_id, u.name;

-- Find books borrowed and returned late
SELECT b.title, u.name AS borrower_name, br.due_date, br.return_date
FROM borrowing br
JOIN books b ON br.book_id = b.book_id
JOIN users u ON br.user_id = u.user_id
WHERE br.return_date > br.due_date;

-- Find the user who has borrowed the highest number of books
SELECT TOP 1 u.user_id, u.name, COUNT(br.borrow_id) AS total_borrowed
FROM borrowing br
JOIN users u ON br.user_id = u.user_id
GROUP BY u.user_id, u.name
ORDER BY total_borrowed DESC;

-- Find books that were borrowed but returned before the due date
SELECT b.title, u.name AS borrower_name, br.borrow_date, br.due_date, br.return_date
FROM borrowing br
JOIN books b ON br.book_id = b.book_id
JOIN users u ON br.user_id = u.user_id
WHERE br.return_date IS NOT NULL AND br.return_date < br.due_date;

-- Find the earliest borrowed book (oldest borrow record)
SELECT TOP 1 b.title, u.name AS borrower_name, br.borrow_date
FROM borrowing br
JOIN books b ON br.book_id = b.book_id
JOIN users u ON br.user_id = u.user_id
ORDER BY br.borrow_date ASC;

-- Retrieve the number of users who have borrowed at least one book
SELECT COUNT(DISTINCT br.user_id) AS total_borrowers
FROM borrowing br;

-- Find books that were borrowed exactly once
SELECT b.title, COUNT(br.borrow_id) AS times_borrowed
FROM borrowing br
JOIN books b ON br.book_id = b.book_id
GROUP BY b.title
HAVING COUNT(br.borrow_id) = 1;
