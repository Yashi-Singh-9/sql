-- Project in PostgreSQL 
-- Create Database
CREATE DATABASE FraudDetectionDB;
\c FraudDetectionDB;

-- Customers Table  
CREATE TABLE customers (
  customer_id SERIAL PRIMARY KEY,
  customer_name VARCHAR(100),
  dob DATE,
  email VARCHAR(100) UNIQUE,
  phone BIGINT,
  address VARCHAR(100)
);

-- Accounts Table 
CREATE TABLE accounts (
  account_id SERIAL PRIMARY KEY,
  customer_id INT,
  account_type VARCHAR(100),
  balance DECIMAL(15,2) NOT NULL DEFAULT 0.00,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Transactions Table  
CREATE TABLE transactions (
  transaction_id SERIAL PRIMARY KEY,
  account_id INT,
  transaction_type VARCHAR(6) CHECK (transaction_type IN ('Credit', 'Debit')),
  amount DECIMAL(15,2) NOT NULL CHECK (amount > 0),
  transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  locations VARCHAR(100),
  device_id VARCHAR(100),
  FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);

-- Devices Table 
CREATE TABLE devices (
  device_id VARCHAR(100) PRIMARY KEY,
  customer_id INT,
  device_type VARCHAR(50),
  ip_address VARCHAR(45),
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Fraud Alerts Table 
CREATE TABLE fraud_alerts (
  alert_id SERIAL PRIMARY KEY,
  transaction_id INT,
  fraud_type VARCHAR(100),
  alert_date DATE,
  status VARCHAR(9) CHECK (status IN ('Pending', 'Resolved')),
  FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id)
);  

-- Insert Data into Customers Table
INSERT INTO customers (customer_name, dob, email, phone, address) VALUES
('John Doe', '1985-06-15', 'john.doe@example.com', 9876543210, '123 Main St, NY'),
('Alice Smith', '1990-09-25', 'alice.smith@example.com', 8765432109, '456 Elm St, CA'),
('Bob Johnson', '1982-12-05', 'bob.johnson@example.com', 7654321098, '789 Pine St, TX'),
('Emily Davis', '1995-03-18', 'emily.davis@example.com', 6543210987, '321 Oak St, FL'),
('Michael Brown', '1988-07-22', 'michael.brown@example.com', 5432109876, '654 Cedar St, WA');

-- Insert Data into Accounts Table
INSERT INTO accounts (customer_id, account_type, balance) VALUES
(1, 'Savings', 5000.00),
(2, 'Checking', 3200.50),
(3, 'Savings', 8700.75),
(4, 'Checking', 1230.60),
(5, 'Savings', 9999.99);

-- Insert Data into Transactions Table
INSERT INTO transactions (account_id, transaction_type, amount, locations, device_id) VALUES
(1, 'Debit', 500.00, 'New York, NY', 'D123'),
(2, 'Credit', 1200.50, 'Los Angeles, CA', 'D234'),
(3, 'Debit', 750.25, 'Houston, TX', 'D345'),
(4, 'Debit', 200.00, 'Miami, FL', 'D123'),
(5, 'Credit', 999.99, 'Seattle, WA', 'D567');

-- Insert Data into Devices Table
INSERT INTO devices (device_id, customer_id, device_type, ip_address) VALUES
('D123', 1, 'Mobile', '192.168.1.10'),
('D234', 2, 'Laptop', '192.168.1.20'),
('D345', 3, 'Tablet', '192.168.1.30'),
('D678', 4, 'Mobile', '192.168.1.10'),
('D567', 5, 'Desktop', '192.168.1.50');

-- Insert Data into Fraud Alerts Table
INSERT INTO fraud_alerts (transaction_id, fraud_type, alert_date, status) VALUES
(1, 'Unusual Location', '2025-02-20', 'Pending'),
(2, 'High Transaction Amount', '2025-02-21', 'Resolved'),
(3, 'Frequent Small Transactions', '2025-02-22', 'Pending'),
(4, 'Device Change', '2025-02-23', 'Resolved'),
(5, 'Multiple Failed Attempts', '2025-02-24', 'Pending');

-- Find all transactions above a certain amount (possible fraud case).
SELECT * 
FROM transactions 
WHERE amount > 1000; 

-- Retrieve details of fraud alerts that are still pending.
SELECT * 
FROM fraud_alerts 
WHERE status = 'Pending';

-- Retrieve All Transactions for a Specific Customer
SELECT t.*
FROM transactions t
JOIN accounts a ON t.account_id = a.account_id
JOIN customers c ON a.customer_id = c.customer_id
WHERE c.customer_name = 'John Doe';

-- Find Transactions Made from a Suspicious IP Address
SELECT t.*
FROM transactions t
JOIN devices d ON t.device_id = d.device_id
WHERE d.ip_address = '192.168.1.10';

-- List Transactions That Happened in Different Locations for the Same Device (Possible Fraud)
SELECT device_id, COUNT(DISTINCT locations) AS location_count
FROM transactions
GROUP BY device_id
HAVING COUNT(DISTINCT locations) > 1;

-- Find Fraud Alerts Along with Transaction Details
SELECT f.alert_id, f.fraud_type, f.alert_date, f.status, t.*
FROM fraud_alerts f
JOIN transactions t ON f.transaction_id = t.transaction_id;

-- List Devices Used in Fraudulent Transactions
SELECT DISTINCT d.*
FROM devices d
JOIN transactions t ON d.device_id = t.device_id
JOIN fraud_alerts f ON t.transaction_id = f.transaction_id;

--Find Transactions Made During Unusual Hours (e.g., Midnight to 5 AM)
SELECT * 
FROM transactions
WHERE EXTRACT(HOUR FROM transaction_date) BETWEEN 0 AND 5;

-- Find Customers Who Recently Changed Devices (Potential Account Takeover)
SELECT c.customer_id, c.customer_name, d.device_id, d.device_type, d.ip_address
FROM devices d
JOIN customers c ON d.customer_id = c.customer_id
WHERE d.device_id NOT IN (
    SELECT DISTINCT device_id
    FROM transactions t
    JOIN accounts a ON t.account_id = a.account_id
    WHERE a.customer_id = c.customer_id
);
