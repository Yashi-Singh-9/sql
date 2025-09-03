-- MS SQL Project 
CREATE DATABASE StockMarketDB;
USE StockMarketDB;

-- Stocks Table 
CREATE TABLE stocks (
  stock_id INT IDENTITY(1,1) PRIMARY KEY,
  stock_name VARCHAR(50) NOT NULL,
  ticker_symbol VARCHAR(10) UNIQUE NOT NULL,
  sector VARCHAR(50),
  industry VARCHAR(50),
  market_cap DECIMAL(15,2)
);

-- Stock Prices Table 
CREATE TABLE stock_prices (
  price_id INT IDENTITY(1,1) PRIMARY KEY,
  stock_id INT NOT NULL,
  date DATE NOT NULL,
  open_price DECIMAL(10,2),
  high_price DECIMAL(10,2),
  low_price DECIMAL(10,2),
  close_price DECIMAL(10,2),
  volume BIGINT NOT NULL,
  FOREIGN KEY (stock_id) REFERENCES stocks(stock_id)
);

-- Transactions Table 
CREATE TABLE transactions (
  transaction_id INT IDENTITY(1,1) PRIMARY KEY,
  user_id INT NOT NULL,
  stock_id INT NOT NULL,
  transaction_date DATETIME NOT NULL,
  transaction_type VARCHAR(5) CHECK (transaction_type IN ('BUY', 'SELL')) NOT NULL,
  quantity INT NOT NULL,
  price_per_share DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (stock_id) REFERENCES stocks(stock_id)
);

-- Users Table  
CREATE TABLE users (
  user_id INT IDENTITY(1,1) PRIMARY KEY,
  username VARCHAR(20) UNIQUE NOT NULL,
  email VARCHAR(50) UNIQUE NOT NULL,
  phone_number BIGINT UNIQUE,
  created_at DATETIME,
);

-- Dividends Table 
CREATE TABLE dividends (
  dividend_id INT IDENTITY(1,1) PRIMARY KEY,
  stock_id INT,
  dividend_date DATE NOT NULL,
  dividend_amount DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (stock_id) REFERENCES stocks(stock_id)
);

-- Watchlist Table 
CREATE TABLE watchlist (
  watchlist_id INT IDENTITY(1,1) PRIMARY KEY,
  user_id INT NOT NULL,
  stock_id INT NOT NULL,
  added_date DATETIME,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (stock_id) REFERENCES stocks(stock_id)
);

-- Market News Table 
CREATE TABLE market_news (
  news_id INT IDENTITY(1,1) PRIMARY KEY,
  title VARCHAR(50) NOT NULL,
  content TEXT NOT NULL,
  published_date DATE NOT NULL
);

-- Insert Sample Data into Users Table  
INSERT INTO users (username, email, phone_number, created_at)  
VALUES  
('john_doe', 'john@example.com', 1234567890, GETDATE()),  
('jane_smith', 'jane@example.com', 2345678901, GETDATE()),  
('alice_wonder', 'alice@example.com', 3456789012, GETDATE()),  
('bob_builder', 'bob@example.com', 4567890123, GETDATE()),  
('charlie_brown', 'charlie@example.com', 5678901234, GETDATE()),  
('david_miller', 'david@example.com', 6789012345, GETDATE()),  
('eva_green', 'eva@example.com', 7890123456, GETDATE()),  
('frank_white', 'frank@example.com', 8901234567, GETDATE());  

-- Insert Sample Data into Stocks Table  
INSERT INTO stocks (stock_name, ticker_symbol, sector, industry, market_cap)  
VALUES  
('Apple Inc.', 'AAPL', 'Technology', 'Consumer Electronics', 2500000000000.00),  
('Microsoft Corp.', 'MSFT', 'Technology', 'Software', 2300000000000.00),  
('Amazon.com Inc.', 'AMZN', 'Consumer Discretionary', 'E-commerce', 1700000000000.00),  
('Tesla Inc.', 'TSLA', 'Automobile', 'Electric Vehicles', 800000000000.00),  
('Google LLC', 'GOOGL', 'Technology', 'Internet Services', 1600000000000.00),  
('Meta Platforms', 'META', 'Technology', 'Social Media', 1000000000000.00),  
('NVIDIA Corp.', 'NVDA', 'Technology', 'Semiconductors', 1200000000000.00),  
('Johnson & Johnson', 'JNJ', 'Healthcare', 'Pharmaceuticals', 450000000000.00);  

-- Insert Sample Data into Stock Prices Table  
INSERT INTO stock_prices (stock_id, date, open_price, high_price, low_price, close_price, volume)  
VALUES  
(1, '2024-02-20', 175.00, 180.00, 172.50, 178.00, 50000000),  
(2, '2024-02-20', 320.00, 325.00, 318.00, 322.50, 30000000),  
(3, '2024-02-20', 140.00, 145.00, 138.50, 143.00, 40000000),  
(4, '2024-02-20', 800.00, 815.00, 790.00, 810.00, 20000000),  
(5, '2024-02-20', 135.00, 138.00, 133.50, 136.50, 25000000),  
(6, '2024-02-20', 250.00, 255.00, 248.00, 252.00, 27000000),  
(7, '2024-02-20', 650.00, 660.00, 645.00, 655.00, 15000000),  
(8, '2024-02-20', 155.00, 158.00, 152.00, 157.00, 22000000);  

-- Insert Sample Data into Transactions Table  
INSERT INTO transactions (user_id, stock_id, transaction_date, transaction_type, quantity, price_per_share)  
VALUES  
(1, 1, '2024-02-15 10:30:00', 'BUY', 10, 170.00),  
(2, 2, '2024-02-15 11:00:00', 'BUY', 15, 310.00),  
(3, 3, '2024-02-16 09:45:00', 'SELL', 5, 135.00),  
(4, 4, '2024-02-16 13:20:00', 'BUY', 20, 780.00),  
(5, 5, '2024-02-17 12:10:00', 'SELL', 8, 132.00),  
(6, 6, '2024-02-18 14:30:00', 'BUY', 12, 245.00),  
(7, 7, '2024-02-19 15:40:00', 'BUY', 18, 640.00),  
(8, 8, '2024-02-19 16:00:00', 'SELL', 7, 150.00);  

-- Insert Sample Data into Dividends Table  
INSERT INTO dividends (stock_id, dividend_date, dividend_amount)  
VALUES  
(1, '2024-02-10', 0.82),  
(2, '2024-02-11', 1.20),  
(3, '2024-02-12', 0.60),  
(4, '2024-02-13', 0.50),  
(5, '2024-02-14', 1.10),  
(6, '2024-02-15', 0.75),  
(7, '2024-02-16', 0.90),  
(8, '2024-02-17', 1.30);  

-- Insert Sample Data into Watchlist Table  
INSERT INTO watchlist (user_id, stock_id, added_date)  
VALUES  
(1, 1, GETDATE()),  
(2, 2, GETDATE()),  
(3, 3, GETDATE()),  
(4, 4, GETDATE()),  
(5, 5, GETDATE()),  
(6, 6, GETDATE()),  
(7, 7, GETDATE()),  
(8, 8, GETDATE());  

-- Insert Sample Data into Market News Table  
INSERT INTO market_news (title, content, published_date)  
VALUES  
('Tech Stocks Rally', 'Technology stocks surge after strong earnings reports.', '2024-02-19'),  
('Federal Reserve Policy', 'Interest rate decisions impact market trends.', '2024-02-18'),  
('Tesla Unveils New Model', 'Tesla announces new electric vehicle for mass market.', '2024-02-17'),  
('Amazon Growth', 'Amazon reports record-breaking holiday sales.', '2024-02-16'),  
('NVIDIA Hits New Highs', 'Chipmaker sees strong demand for AI processors.', '2024-02-15'),  
('Google AI Breakthrough', 'Alphabet reveals advancements in AI technology.', '2024-02-14'),  
('Meta’s VR Expansion', 'Meta expands virtual reality offerings.', '2024-02-13'),  
('Johnson & Johnson Dividend', 'Healthcare giant announces increased dividend payout.', '2024-02-12');  

-- Retrieve the top 5 stocks with the highest closing price for a given date.
SELECT TOP 5 s.stock_name, sp.date, sp.close_price
FROM stock_prices sp
JOIN stocks s ON sp.stock_id = s.stock_id
WHERE sp.date = '2024-02-20'
ORDER BY sp.close_price DESC;

-- Find the user who has the highest total investment (sum of quantity * price_per_share).
SELECT TOP 1 u.username, SUM(t.quantity * t.price_per_share) AS total_investment
FROM transactions t
JOIN users u ON t.user_id = u.user_id
GROUP BY u.username
ORDER BY total_investment DESC;

-- Find the total number of stocks a user has in their watchlist.
SELECT u.username, COUNT(w.watchlist_id) AS total_stocks_in_watchlist
FROM watchlist w
JOIN users u ON w.user_id = u.user_id
GROUP BY u.username;

-- Find stocks that have never been sold in transactions.
SELECT s.stock_name
FROM stocks s
LEFT JOIN transactions t ON s.stock_id = t.stock_id AND t.transaction_type = 'SELL'
WHERE t.transaction_id IS NULL;

-- Retrieve the total number of stocks each user has in their watchlist, sorted by the highest count.
SELECT u.username, COUNT(w.watchlist_id) AS total_watchlist_stocks
FROM watchlist w
JOIN users u ON w.user_id = u.user_id
GROUP BY u.username
ORDER BY total_watchlist_stocks DESC;

-- Retrieve the highest stock price for each stock
SELECT s.stock_name, MAX(sp.high_price) AS highest_price
FROM stock_prices sp
JOIN stocks s ON sp.stock_id = s.stock_id
GROUP BY s.stock_name;

-- Find the most traded stock based on volume for a given date
SELECT TOP 1 s.stock_name, sp.date, sp.volume
FROM stock_prices sp
JOIN stocks s ON sp.stock_id = s.stock_id
WHERE sp.date = '2024-02-20'
ORDER BY sp.volume DESC;

-- Retrieve the average closing price of each stock
SELECT s.stock_name, AVG(sp.close_price) AS avg_closing_price
FROM stock_prices sp
JOIN stocks s ON sp.stock_id = s.stock_id
GROUP BY s.stock_name;

-- Find the most active user (who has made the most transactions)
SELECT TOP 1 u.username, COUNT(t.transaction_id) AS total_transactions
FROM transactions t
JOIN users u ON t.user_id = u.user_id
GROUP BY u.username
ORDER BY total_transactions DESC;

-- Get the latest transaction details for each stock
SELECT s.stock_name, t.transaction_type, t.quantity, t.price_per_share, t.transaction_date
FROM transactions t
JOIN stocks s ON t.stock_id = s.stock_id
WHERE t.transaction_date = (SELECT MAX(transaction_date) FROM transactions WHERE stock_id = s.stock_id);

-- Retrieve the total dividend paid for each stock
SELECT s.stock_name, SUM(d.dividend_amount) AS total_dividend
FROM dividends d
JOIN stocks s ON d.stock_id = s.stock_id
GROUP BY s.stock_name;

-- Get the number of transactions per stock
SELECT s.stock_name, COUNT(t.transaction_id) AS total_transactions
FROM transactions t
JOIN stocks s ON t.stock_id = s.stock_id
GROUP BY s.stock_name
ORDER BY total_transactions DESC;

-- Retrieve the latest stock prices for all stocks
SELECT s.stock_name, sp.date, sp.close_price
FROM stock_prices sp
JOIN stocks s ON sp.stock_id = s.stock_id
WHERE sp.date = (SELECT MAX(date) FROM stock_prices);

-- Find users who have the most stocks in their watchlist
SELECT TOP 3 u.username, COUNT(w.watchlist_id) AS total_watchlist_stocks
FROM watchlist w
JOIN users u ON w.user_id = u.user_id
GROUP BY u.username
ORDER BY total_watchlist_stocks DESC;

-- Retrieve all stock transactions for a given user (e.g., 'john_doe')
SELECT u.username, s.stock_name, t.transaction_type, t.quantity, t.price_per_share, t.transaction_date
FROM transactions t
JOIN users u ON t.user_id = u.user_id
JOIN stocks s ON t.stock_id = s.stock_id
WHERE u.username = 'john_doe'
ORDER BY t.transaction_date DESC;

-- Find the most frequently bought stock
SELECT TOP 1 s.stock_name, COUNT(t.transaction_id) AS buy_count
FROM transactions t
JOIN stocks s ON t.stock_id = s.stock_id
WHERE t.transaction_type = 'BUY'
GROUP BY s.stock_name
ORDER BY buy_count DESC;

-- Find the average market cap per sector
SELECT sector, AVG(market_cap) AS avg_market_cap
FROM stocks
GROUP BY sector;

-- Retrieve news articles related to 'Technology'
SELECT title, content, published_date
FROM market_news
WHERE title LIKE '%Technology%' OR content LIKE '%Technology%'
ORDER BY published_date DESC;

-- Find the user with the highest dividend earnings
SELECT TOP 1 u.username, SUM(d.dividend_amount * t.quantity) AS total_earnings
FROM transactions t
JOIN dividends d ON t.stock_id = d.stock_id
JOIN users u ON t.user_id = u.user_id
GROUP BY u.username
ORDER BY total_earnings DESC;