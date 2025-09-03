-- Project in PostgreSQL 
-- Create Database
CREATE DATABASE crypto_exchange;
-- Switch to the new database
\c crypto_exchange;

-- Users Table
CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Wallets Table
CREATE TABLE Wallets (
    wallet_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id) ON DELETE CASCADE,
    balance DECIMAL(18,8) DEFAULT 0.0,
    currency VARCHAR(10) NOT NULL
);

-- Cryptocurrencies Table
CREATE TABLE Cryptocurrencies (
    crypto_id SERIAL PRIMARY KEY,
    symbol VARCHAR(10) UNIQUE NOT NULL,
    name VARCHAR(50) NOT NULL,
    current_price DECIMAL(18,8) NOT NULL
);

-- Orders Table
CREATE TABLE Orders (
    order_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id) ON DELETE CASCADE,
    crypto_id INT REFERENCES Cryptocurrencies(crypto_id) ON DELETE CASCADE,
    order_type VARCHAR(10) CHECK (order_type IN ('BUY', 'SELL')),
    quantity DECIMAL(18,8) NOT NULL,
    price DECIMAL(18,8) NOT NULL,
    status VARCHAR(15) CHECK (status IN ('Pending', 'Completed')) DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Transactions Table
CREATE TABLE Transactions (
    transaction_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES Orders(order_id) ON DELETE CASCADE,
    transaction_type VARCHAR(10) CHECK (transaction_type IN ('Deposit', 'Withdraw')),
    amount DECIMAL(18,8) NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Trades Table
CREATE TABLE Trades (
    trade_id SERIAL PRIMARY KEY,
    buyer_id INT REFERENCES Users(user_id) ON DELETE CASCADE,
    seller_id INT REFERENCES Users(user_id) ON DELETE CASCADE,
    crypto_id INT REFERENCES Cryptocurrencies(crypto_id) ON DELETE CASCADE,
    trade_price DECIMAL(18,8) NOT NULL,
    quantity DECIMAL(18,8) NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert Users
INSERT INTO Users (username, email, password_hash) VALUES
('Alice', 'alice@example.com', 'hash1'),
('Bob', 'bob@example.com', 'hash2'),
('Charlie', 'charlie@example.com', 'hash3'),
('David', 'david@example.com', 'hash4'),
('Eve', 'eve@example.com', 'hash5');

-- Insert Cryptocurrencies
INSERT INTO Cryptocurrencies (symbol, name, current_price) VALUES
('BTC', 'Bitcoin', 45000.50),
('ETH', 'Ethereum', 3200.75),
('XRP', 'Ripple', 1.25),
('ADA', 'Cardano', 2.10),
('DOGE', 'Dogecoin', 0.30);

-- Insert Wallets
INSERT INTO Wallets (user_id, balance, currency) VALUES
(1, 2.5, 'BTC'),
(2, 5.0, 'ETH'),
(3, 1000.0, 'XRP'),
(4, 200.0, 'ADA'),
(5, 5000.0, 'DOGE');

-- Insert Orders
INSERT INTO Orders (user_id, crypto_id, order_type, quantity, price) VALUES
(1, 1, 'BUY', 0.5, 45000.50),
(2, 2, 'SELL', 1.0, 3200.75),
(3, 3, 'BUY', 500.0, 1.25),
(4, 4, 'SELL', 100.0, 2.10),
(5, 5, 'BUY', 1000.0, 0.30);

-- Insert Transactions
INSERT INTO Transactions (order_id, transaction_type, amount) VALUES
(1, 'Deposit', 20000.00),
(2, 'Withdraw', 5000.00),
(3, 'Deposit', 1000.00),
(4, 'Withdraw', 210.00),
(5, 'Deposit', 300.00);

-- Insert Trades
INSERT INTO Trades (buyer_id, seller_id, crypto_id, trade_price, quantity) VALUES
(1, 2, 1, 45000.50, 0.5),
(3, 4, 3, 1.25, 500),
(5, 1, 5, 0.30, 1000),
(2, 3, 2, 3200.75, 1),
(4, 5, 4, 2.10, 100);

-- Get Total Cryptocurrency Holdings for a User
SELECT u.username, w.currency, SUM(w.balance) AS total_balance
FROM Wallets w
JOIN Users u ON w.user_id = u.user_id
WHERE u.username = 'Alice'
GROUP BY u.username, w.currency;

-- Find All Pending Buy Orders
SELECT o.order_id, u.username, c.symbol, o.quantity, o.price
FROM Orders o
JOIN Users u ON o.user_id = u.user_id
JOIN Cryptocurrencies c ON o.crypto_id = c.crypto_id
WHERE o.order_type = 'BUY' AND o.status = 'Pending';

-- Find the Total Value of a User's Portfolio
SELECT u.username, SUM(w.balance * c.current_price) AS total_value
FROM Wallets w
JOIN Users u ON w.user_id = u.user_id
JOIN Cryptocurrencies c ON w.currency = c.symbol
WHERE u.username = 'Alice'
GROUP BY u.username;

-- Find Top 3 Traders by Trade Volume
SELECT u.username, COUNT(t.trade_id) AS total_trades
FROM Trades t
JOIN Users u ON t.buyer_id = u.user_id OR t.seller_id = u.user_id
GROUP BY u.username
ORDER BY total_trades DESC
LIMIT 3;

-- Find the Total Amount Spent by a User on Buy Orders
SELECT u.username, SUM(o.quantity * o.price) AS total_spent
FROM Orders o
JOIN Users u ON o.user_id = u.user_id
WHERE o.order_type = 'BUY'
GROUP BY u.username
ORDER BY total_spent DESC;

-- Find the Most Traded Cryptocurrency (By Volume)
SELECT c.symbol, SUM(t.quantity) AS total_volume
FROM Trades t
JOIN Cryptocurrencies c ON t.crypto_id = c.crypto_id
GROUP BY c.symbol
ORDER BY total_volume DESC
LIMIT 1;

-- Detect Unusually Large Transactions (Anomaly Detection)
SELECT u.username, t.transaction_type, t.amount
FROM Transactions t
JOIN Orders o ON t.order_id = o.order_id
JOIN Users u ON o.user_id = u.user_id
WHERE t.amount > 10000; 

-- Calculate the Average Buy Price Per User for Each Crypto
SELECT u.username, c.symbol, AVG(o.price) AS avg_buy_price
FROM Orders o
JOIN Users u ON o.user_id = u.user_id
JOIN Cryptocurrencies c ON o.crypto_id = c.crypto_id
WHERE o.order_type = 'BUY'
GROUP BY u.username, c.symbol
ORDER BY u.username;

-- Find the Top 3 Users Who Sold the Most Crypto
SELECT u.username, SUM(o.quantity) AS total_sold
FROM Orders o
JOIN Users u ON o.user_id = u.user_id
WHERE o.order_type = 'SELL'
GROUP BY u.username
ORDER BY total_sold DESC
LIMIT 3;

-- Get the Latest 5 Transactions for a User
SELECT t.transaction_id, t.transaction_type, t.amount, t.timestamp
FROM Transactions t
JOIN Orders o ON t.order_id = o.order_id
JOIN Users u ON o.user_id = u.user_id
WHERE u.username = 'Alice'
ORDER BY t.timestamp DESC
LIMIT 5;

-- Find Users Who Have More Than $10,000 in Crypto Holdings
SELECT u.username, SUM(w.balance * c.current_price) AS total_value
FROM Wallets w
JOIN Users u ON w.user_id = u.user_id
JOIN Cryptocurrencies c ON w.currency = c.symbol
GROUP BY u.username
HAVING SUM(w.balance * c.current_price) > 10000
ORDER BY total_value DESC;

-- Get the Daily Trading Volume for Each Cryptocurrency
SELECT c.symbol, DATE(t.timestamp) AS trade_date, SUM(t.quantity) AS daily_volume
FROM Trades t
JOIN Cryptocurrencies c ON t.crypto_id = c.crypto_id
GROUP BY c.symbol, trade_date
ORDER BY trade_date DESC;

-- Find Pending Orders That Have Not Been Matched Yet 
SELECT o.order_id, u.username, c.symbol, o.order_type, o.quantity, o.price
FROM Orders o
JOIN Users u ON o.user_id = u.user_id
JOIN Cryptocurrencies c ON o.crypto_id = c.crypto_id
WHERE o.status = 'Pending'
ORDER BY o.created_at ASC;

-- Find the Highest Priced Trade for Each Cryptocurrency
SELECT c.symbol, MAX(t.trade_price) AS highest_trade_price
FROM Trades t
JOIN Cryptocurrencies c ON t.crypto_id = c.crypto_id
GROUP BY c.symbol
ORDER BY highest_trade_price DESC;

-- Get the Number of Users Who Have Deposited But Not Withdrawn
SELECT COUNT(DISTINCT o.user_id) AS users_with_deposits
FROM Transactions t
JOIN Orders o ON t.order_id = o.order_id
WHERE t.transaction_type = 'Deposit'
AND o.user_id NOT IN (
    SELECT DISTINCT o2.user_id
    FROM Transactions t2
    JOIN Orders o2 ON t2.order_id = o2.order_id
    WHERE t2.transaction_type = 'Withdraw'
);

-- Find the Total Amount Withdrawn Per User
SELECT u.username, SUM(t.amount) AS total_withdrawn
FROM Transactions t
JOIN Orders o ON t.order_id = o.order_id
JOIN Users u ON o.user_id = u.user_id
WHERE t.transaction_type = 'Withdraw'
GROUP BY u.username
ORDER BY total_withdrawn DESC;
