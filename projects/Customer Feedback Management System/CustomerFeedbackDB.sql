-- Project In MariaDB 
-- Create Database
CREATE DATABASE CustomerFeedbackDB;
USE CustomerFeedbackDB;

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(15),
    RegisteredDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Feedback (
    FeedbackID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    Comments TEXT,
    FeedbackDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2)
);

CREATE TABLE ProductFeedback (
    FeedbackID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    ProductID INT,
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    Review TEXT,
    FeedbackDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID) ON DELETE CASCADE
);

INSERT INTO Customers (FirstName, LastName, Email, Phone) VALUES
('John', 'Doe', 'john.doe@example.com', '1234567890'),
('Alice', 'Smith', 'alice.smith@example.com', '2345678901'),
('Robert', 'Brown', 'robert.brown@example.com', '3456789012'),
('Emma', 'Davis', 'emma.davis@example.com', '4567890123'),
('Michael', 'Wilson', 'michael.wilson@example.com', '5678901234');

INSERT INTO Products (Name, Category, Price) VALUES
('Smartphone X', 'Electronics', 799.99),
('Laptop Pro', 'Computers', 1299.99),
('Wireless Headphones', 'Accessories', 199.99),
('Smartwatch Z', 'Wearable', 249.99),
('Gaming Console', 'Entertainment', 499.99);

INSERT INTO Feedback (CustomerID, Rating, Comments) VALUES
(1, 5, 'Excellent service and support.'),
(2, 4, 'Good experience but can improve.'),
(3, 3, 'Average customer support.'),
(4, 5, 'Amazing service, highly recommended!'),
(5, 2, 'Not satisfied with the response time.');

INSERT INTO ProductFeedback (CustomerID, ProductID, Rating, Review) VALUES
(1, 1, 5, 'Great phone with awesome features.'),
(2, 2, 4, 'Laptop is powerful but battery life can be better.'),
(3, 3, 3, 'Sound quality is decent, but a bit overpriced.'),
(4, 4, 5, 'Very stylish and lightweight smartwatch.'),
(5, 5, 4, 'Gaming console works smoothly, but lacks some games.');

-- Retrieve All Customers
SELECT * FROM Customers;

-- Retrieve All Feedback
SELECT c.FirstName, c.LastName, f.Rating, f.Comments, f.FeedbackDate 
FROM Feedback f
JOIN Customers c ON f.CustomerID = c.CustomerID;

-- Find the Average Customer Satisfaction Rating
SELECT AVG(Rating) AS AverageRating FROM Feedback;

-- List Customers Who Gave Negative Feedback
SELECT c.FirstName, c.LastName, f.Rating, f.Comments
FROM Feedback f
JOIN Customers c ON f.CustomerID = c.CustomerID
WHERE f.Rating <= 2;

-- Get the Best-Rated Product
SELECT p.Name, AVG(pf.Rating) AS AverageRating
FROM ProductFeedback pf
JOIN Products p ON pf.ProductID = p.ProductID
GROUP BY p.ProductID
ORDER BY AverageRating DESC
LIMIT 1;

-- Retrieve Customer Feedback for a Specific Product (e.g., "Laptop Pro")
SELECT c.FirstName, c.LastName, pf.Rating, pf.Review
FROM ProductFeedback pf
JOIN Customers c ON pf.CustomerID = c.CustomerID
JOIN Products p ON pf.ProductID = p.ProductID
WHERE p.Name = 'Laptop Pro';

-- Count the Number of Feedback Entries per Rating
SELECT Rating, COUNT(*) AS FeedbackCount
FROM Feedback
GROUP BY Rating
ORDER BY Rating DESC;

-- Find Products with the Most Feedback
SELECT p.Name, COUNT(pf.FeedbackID) AS FeedbackCount
FROM ProductFeedback pf
JOIN Products p ON pf.ProductID = p.ProductID
GROUP BY p.ProductID
ORDER BY FeedbackCount DESC;

-- Retrieve Customers Who Gave a 5-Star Rating
SELECT c.FirstName, c.LastName, f.Rating, f.Comments 
FROM Feedback f
JOIN Customers c ON f.CustomerID = c.CustomerID
WHERE f.Rating = 5;

-- Find the Product with the Lowest Rating
SELECT p.Name, AVG(pf.Rating) AS AverageRating
FROM ProductFeedback pf
JOIN Products p ON pf.ProductID = p.ProductID
GROUP BY p.ProductID
ORDER BY AverageRating ASC
LIMIT 1;

-- Count the Number of Feedback Entries per Product
SELECT p.Name, COUNT(pf.FeedbackID) AS TotalFeedback
FROM ProductFeedback pf
JOIN Products p ON pf.ProductID = p.ProductID
GROUP BY p.ProductID
ORDER BY TotalFeedback DESC;

-- Get the Most Active Customer (Who Gave the Most Feedback)
SELECT c.FirstName, c.LastName, COUNT(f.FeedbackID) AS TotalFeedbacks
FROM Feedback f
JOIN Customers c ON f.CustomerID = c.CustomerID
GROUP BY c.CustomerID
ORDER BY TotalFeedbacks DESC
LIMIT 1;

-- Show Customer Feedback Sorted by Latest First
SELECT c.FirstName, c.LastName, f.Rating, f.Comments, f.FeedbackDate
FROM Feedback f
JOIN Customers c ON f.CustomerID = c.CustomerID
ORDER BY f.FeedbackDate DESC;
