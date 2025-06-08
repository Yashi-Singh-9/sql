-- Project in PostgreSQL 
-- Create Database
CREATE DATABASE BookstoreDB;
\c BookstoreDB;

-- Authors Table
CREATE TABLE Authors (
    author_id SERIAL PRIMARY KEY,
    author_name VARCHAR(255) NOT NULL,
    bio TEXT
);

-- Genres Table
CREATE TABLE Genres (
    genre_id SERIAL PRIMARY KEY,
    genre_name VARCHAR(100) NOT NULL
);

-- Publishers Table
CREATE TABLE Publishers (
    publisher_id SERIAL PRIMARY KEY,
    publisher_name VARCHAR(255) NOT NULL,
    contact_info TEXT
);

-- Books Table
CREATE TABLE Books (
    book_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author_id INT REFERENCES Authors(author_id),
    genre_id INT REFERENCES Genres(genre_id),
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT NOT NULL,
    publisher_id INT REFERENCES Publishers(publisher_id),
    published_date DATE
);

-- Customers Table
CREATE TABLE Customers (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone_number VARCHAR(20),
    address TEXT
);

-- Orders Table
CREATE TABLE Orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES Customers(customer_id),
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2)
);

-- Order_Items Table
CREATE TABLE Order_Items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES Orders(order_id),
    book_id INT REFERENCES Books(book_id),
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL
);

-- Employees Table
CREATE TABLE Employees (
    employee_id SERIAL PRIMARY KEY,
    employee_name VARCHAR(255) NOT NULL,
    role VARCHAR(100),
    salary DECIMAL(10,2) NOT NULL
);

-- Suppliers Table
CREATE TABLE Suppliers (
    supplier_id SERIAL PRIMARY KEY,
    supplier_name VARCHAR(255) NOT NULL,
    contact_info TEXT
);

-- Stock_Transactions Table
CREATE TABLE Stock_Transactions (
    transaction_id SERIAL PRIMARY KEY,
    book_id INT REFERENCES Books(book_id),
    supplier_id INT REFERENCES Suppliers(supplier_id),
    quantity INT NOT NULL,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert into Authors
INSERT INTO Authors (author_name, bio) VALUES
('J.K. Rowling', 'British author, best known for Harry Potter.'),
('George Orwell', 'Famous for 1984 and Animal Farm.'),
('J.R.R. Tolkien', 'Author of The Lord of the Rings.'),
('Agatha Christie', 'Renowned mystery novelist.'),
('Stephen King', 'Master of horror fiction.');

-- Insert into Genres
INSERT INTO Genres (genre_name) VALUES
('Fantasy'),
('Dystopian'),
('Mystery'),
('Horror'),
('Science Fiction');

-- Insert into Publishers
INSERT INTO Publishers (publisher_name, contact_info) VALUES
('Penguin Random House', 'contact@penguin.com'),
('HarperCollins', 'info@harpercollins.com'),
('Simon & Schuster', 'support@simon.com'),
('Macmillan Publishers', 'help@macmillan.com'),
('Scholastic', 'books@scholastic.com');

-- Insert into Books (Repetitive Foreign Keys)
INSERT INTO Books (title, author_id, genre_id, price, stock_quantity, publisher_id, published_date) VALUES
('Harry Potter and the Sorcerer''s Stone', 1, 1, 20.99, 50, 5, '1997-06-26'),
('1984', 2, 2, 15.50, 30, 1, '1949-06-08'),
('The Lord of the Rings', 3, 1, 25.99, 40, 2, '1954-07-29'),
('Murder on the Orient Express', 4, 3, 12.99, 20, 3, '1934-01-01'),
('The Shining', 5, 4, 18.99, 35, 4, '1977-01-28');

-- Insert into Customers
INSERT INTO Customers (customer_name, email, phone_number, address) VALUES
('Alice Johnson', 'alice@gmail.com', '123-456-7890', '123 Main St, NY'),
('Bob Smith', 'bob@gmail.com', '234-567-8901', '456 Oak St, LA'),
('Charlie Brown', 'charlie@gmail.com', '345-678-9012', '789 Pine St, TX'),
('David Lee', 'david@gmail.com', '456-789-0123', '159 Maple St, IL'),
('Eve Adams', 'eve@gmail.com', '567-890-1234', '753 Birch St, FL');

-- Insert into Orders (Repetitive Customer IDs)
INSERT INTO Orders (customer_id, total_amount) VALUES
(1, 50.99),
(2, 30.50),
(3, 75.99),
(1, 45.00),
(2, 60.99);

-- Insert into Order_Items (Repetitive Book IDs)
INSERT INTO Order_Items (order_id, book_id, quantity, price) VALUES
(1, 1, 2, 41.98),
(1, 3, 1, 25.99),
(2, 2, 1, 15.50),
(3, 4, 3, 38.97),
(4, 5, 1, 18.99);

-- Insert into Employees
INSERT INTO Employees (employee_name, role, salary) VALUES
('John Doe', 'Manager', 5000.00),
('Emily Davis', 'Cashier', 2500.00),
('Michael Scott', 'Salesperson', 3000.00),
('Sarah Connor', 'Stock Manager', 3500.00),
('Tom Cruise', 'Customer Support', 2800.00);

-- Insert into Suppliers
INSERT INTO Suppliers (supplier_name, contact_info) VALUES
('ABC Books Supply', 'supply@abcbooks.com'),
('XYZ Publishing', 'sales@xyzpublishing.com'),
('Global Distributors', 'contact@globaldistributors.com'),
('National Bookstore', 'help@nationalbookstore.com'),
('Local Print House', 'info@localprint.com');

-- Insert into Stock_Transactions 
INSERT INTO Stock_Transactions (book_id, supplier_id, quantity) VALUES
(1, 1, 20),
(2, 2, 15),
(3, 3, 25),
(4, 1, 10),
(5, 2, 30);

-- Retrieve all books that are stock of 30
SELECT book_id, title 
FROM Books 
WHERE stock_quantity = 30;

-- Find the total number of books sold in the last month
SELECT SUM(quantity) AS total_books_sold
FROM Order_Items
JOIN Orders ON Order_Items.order_id = Orders.order_id
WHERE order_date >= DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '1 month'
AND order_date < DATE_TRUNC('month', CURRENT_DATE);

-- Get the total sales amount for each customer
SELECT c.customer_id, c.customer_name, SUM(o.total_amount) AS total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC;

-- Retrieve the top 5 best-selling books
SELECT b.book_id, b.title, SUM(oi.quantity) AS total_sold
FROM Order_Items oi
JOIN Books b ON oi.book_id = b.book_id
GROUP BY b.book_id, b.title
ORDER BY total_sold DESC
LIMIT 5;

-- Find the customer who has made the highest number of purchases
SELECT c.customer_id, c.customer_name, COUNT(o.order_id) AS total_orders
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_orders DESC
LIMIT 1;

-- Get a list of books and their authors where the price is above $20
SELECT b.title, a.author_name, b.price
FROM Books b
JOIN Authors a ON b.author_id = a.author_id
WHERE b.price > 20.00;

-- Retrieve the total revenue generated by each genre
SELECT g.genre_name, SUM(oi.quantity * oi.price) AS total_revenue
FROM Order_Items oi
JOIN Books b ON oi.book_id = b.book_id
JOIN Genres g ON b.genre_id = g.genre_id
GROUP BY g.genre_name
ORDER BY total_revenue DESC;

-- Get the names of employees whose salary is above $3000
SELECT employee_name, salary
FROM Employees
WHERE salary > 3000.00;

-- Find the most popular book genre based on sales
SELECT g.genre_name, SUM(oi.quantity) AS total_sold
FROM Order_Items oi
JOIN Books b ON oi.book_id = b.book_id
JOIN Genres g ON b.genre_id = g.genre_id
GROUP BY g.genre_name
ORDER BY total_sold DESC
LIMIT 1;

-- Find the supplier who has supplied the most books
SELECT s.supplier_name, SUM(st.quantity) AS total_supplied
FROM Stock_Transactions st
JOIN Suppliers s ON st.supplier_id = s.supplier_id
GROUP BY s.supplier_name
ORDER BY total_supplied DESC
LIMIT 1;

-- List all customers who have never placed an order
SELECT c.customer_id, c.customer_name 
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- Retrieve the most recent order for each customer
SELECT DISTINCT ON (o.customer_id) 
    o.customer_id, c.customer_name, o.order_id, o.order_date, o.total_amount
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
ORDER BY o.customer_id, o.order_date DESC;

-- List all books with their publisher names
SELECT b.title, p.publisher_name 
FROM Books b
JOIN Publishers p ON b.publisher_id = p.publisher_id;

-- Find the total revenue generated per publisher
SELECT p.publisher_name, SUM(oi.quantity * oi.price) AS total_revenue
FROM Order_Items oi
JOIN Books b ON oi.book_id = b.book_id
JOIN Publishers p ON b.publisher_id = p.publisher_id
GROUP BY p.publisher_name
ORDER BY total_revenue DESC;
