CREATE DATABASE CustomerFeedbackDB;
USE CustomerFeedbackDB;

-- Customers Table  
CREATE TABLE customers (
  customer_id INT IDENTITY(1,1) PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  email VARCHAR(50) UNIQUE,
  phone_number BIGINT
);

-- Products Table 
CREATE TABLE products (
  product_id INT IDENTITY(1,1) PRIMARY KEY,
  product_name VARCHAR(50),
  category VARCHAR(50)
);

-- Feedback Table  
CREATE TABLE feedback (
  feedback_id INT IDENTITY(1,1) PRIMARY KEY,
  customer_id INT,
  product_id INT,
  rating INT CHECK (rating BETWEEN 1 AND 5),
  comments TEXT,
  feedback_date DATE,
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id),  
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Responses Table  
CREATE TABLE responses (
  response_id INT IDENTITY(1,1) PRIMARY KEY,
  feedback_id INT,
  admin_id INT,
  response_text TEXT,
  response_date DATE,
  FOREIGN KEY (feedback_id) REFERENCES feedback(feedback_id),
  FOREIGN KEY (admin_id) REFERENCES admins(admin_id)
);

-- Admins Table  
CREATE TABLE admins (
  admin_id INT IDENTITY(1,1) PRIMARY KEY,
  admin_name VARCHAR(50) NOT NULL,
  email VARCHAR(50) UNIQUE
);  

-- Insert sample data into Customers Table
INSERT INTO customers (name, email, phone_number) VALUES
('Alice Johnson', 'alice@example.com', 1234567890),
('Bob Smith', 'bob@example.com', 2345678901),
('Charlie Brown', 'charlie@example.com', 3456789012),
('David White', 'david@example.com', 4567890123),
('Emma Green', 'emma@example.com', 5678901234),
('Frank Black', 'frank@example.com', 6789012345),
('Grace Adams', 'grace@example.com', 7890123456),
('Hannah Lee', 'hannah@example.com', 8901234567);

-- Insert sample data into Products Table
INSERT INTO products (product_name, category) VALUES
('Laptop', 'Electronics'),
('Smartphone', 'Electronics'),
('Headphones', 'Accessories'),
('Smartwatch', 'Wearables'),
('Backpack', 'Bags'),
('Tablet', 'Electronics'),
('Gaming Console', 'Entertainment'),
('Camera', 'Photography');

-- Insert sample data into Feedback Table
INSERT INTO feedback (customer_id, product_id, rating, comments, feedback_date) VALUES
(1, 1, 5, 'Excellent laptop, great battery life!', '2024-02-10'),
(2, 2, 4, 'Good smartphone, but battery drains fast.', '2024-02-11'),
(3, 3, 3, 'Decent headphones, average sound quality.', '2024-02-12'),
(4, 4, 5, 'Amazing smartwatch with many features!', '2024-02-13'),
(5, 5, 4, 'Durable backpack, spacious and stylish.', '2024-02-14'),
(6, 6, 2, 'Tablet performance is slow.', '2024-02-15'),
(7, 7, 5, 'Best gaming console, worth the price!', '2024-02-16'),
(8, 8, 4, 'Camera quality is good but low light needs improvement.', '2024-02-17');

-- Insert sample data into Admins Table
INSERT INTO admins (admin_name, email) VALUES
('John Admin', 'john.admin@example.com'),
('Sophia Manager', 'sophia.manager@example.com'),
('Michael Supervisor', 'michael.supervisor@example.com'),
('Emily Admin', 'emily.admin@example.com');

-- Insert sample data into Responses Table
INSERT INTO responses (feedback_id, admin_id, response_text, response_date) VALUES
(1, 1, 'Thank you for your feedback! Glad you liked it.', '2024-02-11'),
(2, 2, 'We appreciate your input and will work on battery improvements.', '2024-02-12'),
(3, 3, 'We are looking into sound quality enhancements.', '2024-02-13'),
(4, 1, 'Glad to hear you love the smartwatch!', '2024-02-14'),
(5, 2, 'Thank you for your review on the backpack.', '2024-02-15'),
(6, 3, 'We are working on performance improvements.', '2024-02-16'),
(7, 4, 'Enjoy your gaming console! Thanks for the feedback.', '2024-02-17'),
(8, 1, 'Noted on the camera feedback, we will work on it.', '2024-02-18');

-- Retrieve all feedback for a specific product (e.g., product_id = 5)
SELECT * 
FROM feedback 
WHERE product_id = 5;

-- Find the average rating for each product.
SELECT product_id, AVG(rating) AS average_rating 
FROM feedback 
GROUP BY product_id;

-- List all feedback with customer details who rated below 3 stars.
SELECT c.customer_id, c.name, c.email, f.feedback_id, f.product_id, f.rating, f.comments, f.feedback_date 
FROM feedback f
JOIN customers c ON f.customer_id = c.customer_id
WHERE f.rating < 3;

-- Count the number of feedback entries for each product.
SELECT product_id, COUNT(*) AS feedback_count 
FROM feedback 
GROUP BY product_id;

-- Get the latest feedback given in the system.
SELECT TOP 1 * 
FROM feedback 
ORDER BY feedback_date DESC;

-- Retrieve feedback along with admin responses.
SELECT f.feedback_id, f.customer_id, f.product_id, f.rating, f.comments, f.feedback_date, 
       r.response_text, r.response_date, a.admin_name 
FROM feedback f
LEFT JOIN responses r ON f.feedback_id = r.feedback_id
LEFT JOIN admins a ON r.admin_id = a.admin_id;

-- Find the customers who have given the most feedback.
SELECT TOP 1 customer_id, COUNT(*) AS feedback_count 
FROM feedback 
GROUP BY customer_id 
ORDER BY feedback_count DESC;

-- Find products that have never received any feedback.
SELECT p.product_id, p.product_name 
FROM products p
LEFT JOIN feedback f ON p.product_id = f.product_id
WHERE f.product_id IS NULL;

-- Retrieve all admins who have responded to at least one feedback.
SELECT DISTINCT a.admin_id, a.admin_name, a.email 
FROM admins a
JOIN responses r ON a.admin_id = r.admin_id;

-- Delete all feedback given before a certain date (e.g., ‘2023-01-01’).
DELETE FROM feedback WHERE feedback_date < '2023-01-01';
