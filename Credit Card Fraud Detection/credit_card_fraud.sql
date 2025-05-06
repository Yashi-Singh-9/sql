-- Create Database
CREATE DATABASE credit_card_fraud;
USE credit_card_fraud;

-- Users Table  
CREATE TABLE users (
  user_id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50),
  email VARCHAR(50) UNIQUE,
  phone_number BIGINT UNIQUE,
  address VARCHAR(100),
  created_at DATE
);

-- Cards Table  
CREATE TABLE cards (
  card_id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT,
  card_number BIGINT UNIQUE,
  expiry_date DATE,
  cvv INT,
  card_type ENUM('VISA', 'MasterCard', 'Amex', 'Discover'), 
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Transactions Table 
CREATE TABLE transactions (
  transaction_id INT PRIMARY KEY AUTO_INCREMENT,
  card_id INT,
  amount DECIMAL(10,2),
  merchant_name VARCHAR(50),
  location VARCHAR(50),
  transaction_time TIME,
  statuss ENUM('Failed', 'Success'),
  FOREIGN KEY (card_id) REFERENCES cards(card_id)
);

-- Fraud Detection Table 
CREATE TABLE fraud_detection (
  fraud_id INT PRIMARY KEY AUTO_INCREMENT,
  transaction_id INT,
  is_fraudulent BOOLEAN,
  reason ENUM('Unusual Location', 'Large Amount'),
  reported_at DATE,
  FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id)
);

-- Merchants Table 
CREATE TABLE merchants (
  merchant_id INT PRIMARY KEY AUTO_INCREMENT,
  merchant_name VARCHAR(50),
  category ENUM('Retail', 'Travel', 'Food & Beverage', 'Electronics', 'Healthcare', 'Entertainment', 'Finance', 'Others'),
  location VARCHAR(50)
);

-- Insert into users table
INSERT INTO users (name, email, phone_number, address, created_at) VALUES
('John Doe', 'john@example.com', 1234567890, '123 Main St, NY', '2024-01-01'),
('Jane Smith', 'jane@example.com', 1234567891, '456 Elm St, CA', '2024-01-05'),
('Alice Johnson', 'alice@example.com', 1234567892, '789 Oak St, TX', '2024-01-10'),
('Bob Brown', 'bob@example.com', 1234567893, '321 Pine St, FL', '2024-01-15'),
('Charlie White', 'charlie@example.com', 1234567894, '654 Cedar St, WA', '2024-01-20'),
('Emma Black', 'emma@example.com', 1234567895, '987 Birch St, NV', '2024-01-25'),
('Oliver Green', 'oliver@example.com', 1234567896, '147 Maple St, CO', '2024-02-01'),
('Sophia Blue', 'sophia@example.com', 1234567897, '258 Spruce St, AZ', '2024-02-05');

-- Insert into cards table
INSERT INTO cards (user_id, card_number, expiry_date, cvv, card_type) VALUES
(1, 4111111111111111, '2026-12-31', 123, 'VISA'),
(2, 5500000000000004, '2025-11-30', 456, 'MasterCard'),
(3, 340000000000009, '2026-10-31', 789, 'Amex'),
(4, 6011000000000004, '2025-09-30', 234, 'Discover'),
(5, 4111222233334444, '2027-08-31', 567, 'VISA'),
(6, 5500111122223333, '2026-07-31', 890, 'MasterCard'),
(7, 340011112222334, '2025-06-30', 345, 'Amex'),
(8, 6011222233334445, '2027-05-31', 678, 'Discover');

-- Insert into transactions table
INSERT INTO transactions (card_id, amount, merchant_name, location, transaction_time, statuss) VALUES
(1, 150.75, 'Walmart', 'New York', '14:30:00', 'Success'),
(2, 89.99, 'Amazon', 'Los Angeles', '12:15:00', 'Success'),
(3, 2000.00, 'Best Buy', 'Houston', '16:45:00', 'Failed'),
(4, 45.60, 'Starbucks', 'Miami', '09:30:00', 'Success'),
(5, 300.20, 'Apple Store', 'Seattle', '18:20:00', 'Success'),
(6, 120.50, 'Uber', 'Chicago', '20:10:00', 'Success'),
(7, 5000.00, 'Louis Vuitton', 'Las Vegas', '21:50:00', 'Failed'),
(8, 75.99, 'McDonalds', 'Phoenix', '11:05:00', 'Success');

-- Insert into fraud_detection table
INSERT INTO fraud_detection (transaction_id, is_fraudulent, reason, reported_at) VALUES
(3, TRUE, 'Large Amount', '2024-02-15'),
(7, TRUE, 'Unusual Location', '2024-02-18'),
(5, FALSE, NULL, NULL),
(1, FALSE, NULL, NULL),
(2, FALSE, NULL, NULL),
(4, FALSE, NULL, NULL),
(6, FALSE, NULL, NULL),
(8, FALSE, NULL, NULL);

-- Insert into merchants table
INSERT INTO merchants (merchant_name, category, location) VALUES
('Walmart', 'Retail', 'New York'),
('Amazon', 'Retail', 'Los Angeles'),
('Best Buy', 'Electronics', 'Houston'),
('Starbucks', 'Food & Beverage', 'Miami'),
('Apple Store', 'Electronics', 'Seattle'),
('Uber', 'Travel', 'Chicago'),
('Louis Vuitton', 'Retail', 'Las Vegas'),
('McDonalds', 'Food & Beverage', 'Phoenix');

-- Retrieve all transactions that were marked as fraudulent.
SELECT t.* 
FROM transactions t
JOIN fraud_detection f ON t.transaction_id = f.transaction_id
WHERE f.is_fraudulent = TRUE;

-- List all transactions where the transaction location is different from the cardholder's address.
SELECT t.*
FROM transactions t
JOIN cards c ON t.card_id = c.card_id
JOIN users u ON c.user_id = u.user_id
WHERE t.location NOT LIKE CONCAT('%', u.address, '%');

-- Identify the top 5 merchants with the most fraudulent transactions.
SELECT m.merchant_name, COUNT(f.fraud_id) AS fraud_count
FROM merchants m
JOIN transactions t ON m.merchant_name = t.merchant_name
JOIN fraud_detection f ON t.transaction_id = f.transaction_id
WHERE f.is_fraudulent = TRUE
GROUP BY m.merchant_name
ORDER BY fraud_count DESC
LIMIT 5;

-- List users who have the highest number of transactions marked as fraud.
SELECT u.user_id, u.name, COUNT(f.fraud_id) AS fraud_count
FROM users u
JOIN cards c ON u.user_id = c.user_id
JOIN transactions t ON c.card_id = t.card_id
JOIN fraud_detection f ON t.transaction_id = f.transaction_id
WHERE f.is_fraudulent = TRUE
GROUP BY u.user_id
ORDER BY fraud_count DESC
LIMIT 5;

-- Show the number of fraudulent transactions per month.
SELECT DATE_FORMAT(f.reported_at, '%Y-%m') AS fraud_month, COUNT(f.fraud_id) AS fraud_count
FROM fraud_detection f
WHERE f.is_fraudulent = TRUE
GROUP BY fraud_month
ORDER BY fraud_month DESC;

-- Find the percentage of fraudulent transactions over total transactions per card type.
SELECT c.card_type, 
       COUNT(f.fraud_id) AS fraud_transactions, 
       COUNT(t.transaction_id) AS total_transactions, 
       (COUNT(f.fraud_id) / COUNT(t.transaction_id)) * 100 AS fraud_percentage
FROM cards c
JOIN transactions t ON c.card_id = t.card_id
LEFT JOIN fraud_detection f ON t.transaction_id = f.transaction_id AND f.is_fraudulent = TRUE
GROUP BY c.card_type
ORDER BY fraud_percentage DESC;

-- Identify the most common reason for fraudulent transactions.
SELECT reason, COUNT(*) AS fraud_count
FROM fraud_detection
WHERE is_fraudulent = TRUE
GROUP BY reason
ORDER BY fraud_count DESC;

-- Retrieve the total number of transactions per user and their fraud percentage
SELECT u.user_id, u.name, COUNT(t.transaction_id) AS total_transactions, 
       COUNT(f.fraud_id) AS fraud_transactions, 
       (COUNT(f.fraud_id) / COUNT(t.transaction_id)) * 100 AS fraud_percentage
FROM users u
JOIN cards c ON u.user_id = c.user_id
JOIN transactions t ON c.card_id = t.card_id
LEFT JOIN fraud_detection f ON t.transaction_id = f.transaction_id AND f.is_fraudulent = TRUE
GROUP BY u.user_id
ORDER BY fraud_percentage DESC;

-- Find the peak hours for fraudulent transactions.
SELECT HOUR(transaction_time) AS hour_of_day, COUNT(f.fraud_id) AS fraud_count
FROM transactions t
JOIN fraud_detection f ON t.transaction_id = f.transaction_id
WHERE f.is_fraudulent = TRUE
GROUP BY hour_of_day
ORDER BY fraud_count DESC;
