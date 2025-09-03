-- Project in PostgreSQL 
-- Create Database
CREATE DATABASE ecommerce_fraud_detection;
\c ecommerce_fraud_detection

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    address TEXT,
    registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE transactions (
    transaction_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    amount NUMERIC(10, 2),
    payment_method VARCHAR(50),
    ip_address VARCHAR(50),
    location VARCHAR(100),
    transaction_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE fraud_flags (
    flag_id SERIAL PRIMARY KEY,
    transaction_id INT REFERENCES transactions(transaction_id),
    is_fraud BOOLEAN,
    fraud_score NUMERIC(5, 2), -- from 0 to 100
    detected_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reason TEXT
);

CREATE TABLE devices (
    device_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    device_type VARCHAR(50),
    browser VARCHAR(50),
    os VARCHAR(50),
    last_used TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE login_activity (
    login_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    ip_address VARCHAR(50),
    location VARCHAR(100),
    device_id INT REFERENCES devices(device_id),
    login_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO users (full_name, email, phone, address) VALUES
('Alice Smith', 'alice@shop.com', '555-1001', '123 Main St'),
('Bob Lee', 'bob@shop.com', '555-1002', '456 Oak St'),
('Charlie Ray', 'charlie@shop.com', '555-1003', '789 Pine St'),
('Diana Wayne', 'diana@shop.com', '555-1004', '135 Elm St'),
('Ethan Snow', 'ethan@shop.com', '555-1005', '246 Maple St'),
('Fiona Moon', 'fiona@shop.com', '555-1006', '864 Cedar St');

INSERT INTO transactions (user_id, amount, payment_method, ip_address, location) VALUES
(1, 150.00, 'Credit Card', '192.168.1.10', 'New York'),
(2, 800.00, 'PayPal', '192.168.1.11', 'California'),
(3, 25.99, 'Credit Card', '192.168.1.12', 'Texas'),
(4, 999.00, 'Bitcoin', '192.168.1.13', 'Nigeria'),
(5, 5.50, 'Debit Card', '192.168.1.14', 'Ohio'),
(6, 4500.00, 'Credit Card', '192.168.1.15', 'Russia');

INSERT INTO fraud_flags (transaction_id, is_fraud, fraud_score, reason) VALUES
(1, FALSE, 12.5, 'Legit user, known IP'),
(2, FALSE, 30.0, 'High amount but verified PayPal'),
(3, FALSE, 8.0, 'Small purchase'),
(4, TRUE, 92.0, 'Suspicious location and payment method'),
(5, FALSE, 5.0, 'Low risk'),
(6, TRUE, 97.5, 'Unusual amount and foreign IP');

INSERT INTO devices (user_id, device_type, browser, os) VALUES
(1, 'Laptop', 'Chrome', 'Windows 10'),
(2, 'Mobile', 'Safari', 'iOS'),
(3, 'Tablet', 'Firefox', 'Android'),
(4, 'Laptop', 'Edge', 'Windows 11'),
(5, 'Mobile', 'Chrome', 'Android'),
(6, 'Desktop', 'Opera', 'Linux');

INSERT INTO login_activity (user_id, ip_address, location, device_id) VALUES
(1, '192.168.1.10', 'New York', 1),
(2, '192.168.1.11', 'California', 2),
(3, '192.168.1.12', 'Texas', 3),
(4, '10.0.0.5', 'Nigeria', 4),
(5, '172.16.0.1', 'Ohio', 5),
(6, '203.0.113.1', 'Russia', 6);

-- Show all fraudulent transactions
SELECT t.*, f.fraud_score, f.reason
FROM fraud_flags f
JOIN transactions t ON f.transaction_id = t.transaction_id
WHERE f.is_fraud = TRUE;

-- Get users with most frauds
SELECT u.full_name, COUNT(*) AS fraud_count
FROM fraud_flags f
JOIN transactions t ON f.transaction_id = t.transaction_id
JOIN users u ON t.user_id = u.user_id
WHERE f.is_fraud = TRUE
GROUP BY u.full_name
ORDER BY fraud_count DESC;

-- Average fraud score by location
SELECT t.location, ROUND(AVG(f.fraud_score), 2) AS avg_score
FROM fraud_flags f
JOIN transactions t ON f.transaction_id = t.transaction_id
GROUP BY t.location
ORDER BY avg_score DESC;

-- Recent login activity for a specific user
SELECT la.login_time, la.ip_address, la.location, d.device_type
FROM login_activity la
JOIN devices d ON la.device_id = d.device_id
WHERE la.user_id = 1
ORDER BY la.login_time DESC
LIMIT 5;

-- List all transactions flagged as fraud with user and location details
SELECT 
    u.full_name,
    t.transaction_id,
    t.amount,
    t.payment_method,
    t.location,
    f.fraud_score,
    f.reason,
    f.detected_at
FROM fraud_flags f
JOIN transactions t ON f.transaction_id = t.transaction_id
JOIN users u ON t.user_id = u.user_id
WHERE f.is_fraud = TRUE
ORDER BY f.fraud_score DESC;

-- Fraud detection rate per payment method
SELECT 
    t.payment_method,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN f.is_fraud THEN 1 ELSE 0 END) AS fraud_transactions,
    ROUND(100.0 * SUM(CASE WHEN f.is_fraud THEN 1 ELSE 0 END) / COUNT(*), 2) AS fraud_rate_percent
FROM transactions t
JOIN fraud_flags f ON t.transaction_id = f.transaction_id
GROUP BY t.payment_method
ORDER BY fraud_rate_percent DESC;

-- Top locations with the highest number of frauds
SELECT 
    t.location,
    COUNT(*) AS fraud_count
FROM transactions t
JOIN fraud_flags f ON t.transaction_id = f.transaction_id
WHERE f.is_fraud = TRUE
GROUP BY t.location
ORDER BY fraud_count DESC;

-- Users logging in from multiple IPs (possible account sharing or compromise)
SELECT 
    la.user_id,
    u.full_name,
    COUNT(DISTINCT la.ip_address) AS distinct_ips
FROM login_activity la
JOIN users u ON la.user_id = u.user_id
GROUP BY la.user_id, u.full_name
HAVING COUNT(DISTINCT la.ip_address) > 1
ORDER BY distinct_ips DESC;

-- Transactions happening within short time intervals (possible bot activity)
SELECT 
    user_id,
    transaction_id,
    transaction_time,
    LAG(transaction_time) OVER (PARTITION BY user_id ORDER BY transaction_time) AS previous_time,
    EXTRACT(EPOCH FROM (transaction_time - LAG(transaction_time) OVER (PARTITION BY user_id ORDER BY transaction_time))) AS seconds_diff
FROM transactions
ORDER BY user_id, transaction_time;

-- High-value transactions over a certain threshold
SELECT 
    t.transaction_id,
    u.full_name,
    t.amount,
    t.payment_method,
    t.location,
    f.fraud_score
FROM transactions t
JOIN users u ON t.user_id = u.user_id
LEFT JOIN fraud_flags f ON t.transaction_id = f.transaction_id
WHERE t.amount > 1000
ORDER BY t.amount DESC;