-- Create Database
CREATE DATABASE LoyaltyProgramDB;
USE LoyaltyProgramDB;

-- Customers Table  
CREATE TABLE customers (
  customer_id INT PRIMARY KEY AUTO_INCREMENT,
  first_name VARCHAR(30),
  last_name VARCHAR(30),
  email VARCHAR(50) UNIQUE,
  phone_number BIGINT,
  date_of_birth DATE,
  created_at DATETIME
);

-- Loyalty Cards Table
CREATE TABLE loyalty_cards (
  card_id INT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT,
  points_balance DECIMAL(5,2),
  membership_tier VARCHAR(8) CHECK (membership_tier IN ('Silver', 'Gold', 'Platinum')),
  issued_date DATE,
  expiration_date DATE,
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Transactions Table 
CREATE TABLE transactions (
  transaction_id INT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT,
  store_id INT,
  amount_spent DECIMAL(5,2),
  points_earned INT,
  transaction_date DATE,
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  FOREIGN KEY (store_id) REFERENCES stores(store_id)
);

-- Stores Table 
CREATE TABLE stores (
  store_id INT PRIMARY KEY AUTO_INCREMENT,
  store_name VARCHAR(50),
  location VARCHAR(50)
);

-- Rewards Table 
CREATE TABLE rewards (
  reward_id INT PRIMARY KEY AUTO_INCREMENT,
  reward_name VARCHAR(50),
  points_required INT,
  reward_description TEXT
);

-- Redemptions Table 
CREATE TABLE redemptions (
  redemption_id INT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT,
  reward_id INT,
  redemption_date DATE,
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  FOREIGN KEY (reward_id) REFERENCES rewards(reward_id)
);  

-- Insert Data into Customers Table
INSERT INTO customers (first_name, last_name, email, phone_number, date_of_birth, created_at)
VALUES
  ('John', 'Doe', 'john.doe@example.com', 1234567890, '1990-05-15', NOW()),
  ('Jane', 'Smith', 'jane.smith@example.com', 9876543210, '1985-11-20', NOW()),
  ('Alice', 'Johnson', 'alice.johnson@example.com', 1231231234, '1992-08-25', NOW()),
  ('Bob', 'Brown', 'bob.brown@example.com', 3213214321, '1988-02-10', NOW()),
  ('Charlie', 'Williams', 'charlie.williams@example.com', 4567891230, '1994-06-30', NOW()),
  ('Emma', 'Davis', 'emma.davis@example.com', 6543219870, '1987-12-12', NOW()),
  ('David', 'Miller', 'david.miller@example.com', 7894561230, '1991-09-05', NOW());

-- Insert Data into Stores Table
INSERT INTO stores (store_name, location)
VALUES
  ('Tech Store', 'New York'),
  ('Grocery Mart', 'Los Angeles'),
  ('Book World', 'Chicago'),
  ('Fashion Hub', 'San Francisco'),
  ('Home Goods', 'Miami'),
  ('Electronics Outlet', 'Seattle'),
  ('Outdoor Adventure', 'Denver');

-- Insert Data into Loyalty Cards Table
INSERT INTO loyalty_cards (customer_id, points_balance, membership_tier, issued_date, expiration_date)
VALUES
  (1, 150.50, 'Silver', '2025-01-01', '2026-01-01'),
  (2, 320.00, 'Gold', '2024-03-15', '2025-03-15'),
  (3, 80.75, 'Silver', '2025-02-01', '2026-02-01'),
  (4, 450.25, 'Platinum', '2024-07-01', '2025-07-01'),
  (5, 500.00, 'Gold', '2023-11-10', '2024-11-10'),
  (6, 230.00, 'Silver', '2024-05-20', '2025-05-20'),
  (7, 370.40, 'Gold', '2024-09-12', '2025-09-12');

-- Insert Data into Transactions Table
INSERT INTO transactions (customer_id, store_id, amount_spent, points_earned, transaction_date)
VALUES
  (1, 1, 100.00, 50, '2025-02-10'),
  (2, 2, 200.00, 100, '2025-02-12'),
  (3, 3, 50.00, 25, '2025-02-15'),
  (4, 4, 120.00, 60, '2025-02-18'),
  (5, 5, 250.00, 125, '2025-02-19'),
  (6, 6, 150.00, 75, '2025-02-20'),
  (7, 7, 180.00, 90, '2025-02-22');

-- Insert Data into Rewards Table
INSERT INTO rewards (reward_name, points_required, reward_description)
VALUES
  ('Free Coffee', 50, 'A voucher for one free coffee of your choice.'),
  ('Gift Card', 100, 'A $10 gift card for your favorite store.'),
  ('Discount Coupon', 200, 'A 20% discount on your next purchase.'),
  ('Free Shirt', 300, 'A free branded shirt.'),
  ('Electronics Discount', 500, 'Get $50 off on any electronics product.'),
  ('Vacation Voucher', 800, 'A voucher for a 2-night stay at a luxury resort.'),
  ('Exclusive Event Access', 1000, 'Access to an exclusive event for VIP customers.');

-- Insert Data into Redemptions Table
INSERT INTO redemptions (customer_id, reward_id, redemption_date)
VALUES
  (1, 1, '2025-02-11'),
  (2, 2, '2025-02-13'),
  (3, 3, '2025-02-16'),
  (4, 4, '2025-02-19'),
  (5, 5, '2025-02-20'),
  (6, 6, '2025-02-21'),
  (7, 7, '2025-02-23');

-- Retrieve all customers who have more than 350 points.
SELECT c.customer_id, c.first_name, c.last_name, l.points_balance
FROM customers c
JOIN loyalty_cards l ON c.customer_id = l.customer_id
WHERE l.points_balance > 350;

-- Get the total points redeemed by each customer.
SELECT c.customer_id, c.first_name, c.last_name, 
       COALESCE(SUM(r.points_required), 0) AS total_points_redeemed
FROM customers c
LEFT JOIN redemptions rd ON c.customer_id = rd.customer_id
LEFT JOIN rewards r ON rd.reward_id = r.reward_id
GROUP BY c.customer_id;

-- Find the top 5 stores where the most transactions happened.
SELECT s.store_id, s.store_name, COUNT(t.transaction_id) AS total_transactions
FROM stores s
JOIN transactions t ON s.store_id = t.store_id
GROUP BY s.store_id
ORDER BY total_transactions DESC
LIMIT 5;

-- Retrieve the total points earned per customer in the last year.
SELECT c.customer_id, c.first_name, c.last_name, 
       COALESCE(SUM(t.points_earned), 0) AS total_points_earned
FROM customers c
LEFT JOIN transactions t ON c.customer_id = t.customer_id
WHERE t.transaction_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY c.customer_id;

-- Find the customer with the highest spending in the last 3 months.
SELECT c.customer_id, c.first_name, c.last_name, 
       SUM(t.amount_spent) AS total_spent
FROM customers c
JOIN transactions t ON c.customer_id = t.customer_id
WHERE t.transaction_date >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 1;

-- Show which reward has been redeemed the most.
SELECT r.reward_id, r.reward_name, COUNT(rd.redemption_id) AS total_redemptions
FROM rewards r
JOIN redemptions rd ON r.reward_id = rd.reward_id
GROUP BY r.reward_id
ORDER BY total_redemptions DESC
LIMIT 1;

-- Find all customers who have a Platinum membership but have spent less than $500.
SELECT c.customer_id, c.first_name, c.last_name, 
       COALESCE(SUM(t.amount_spent), 0) AS total_spent
FROM customers c
JOIN loyalty_cards l ON c.customer_id = l.customer_id
LEFT JOIN transactions t ON c.customer_id = t.customer_id
WHERE l.membership_tier = 'Platinum'
GROUP BY c.customer_id
HAVING total_spent < 500;

-- List customers whose loyalty cards are expiring within the next 30 days.
SELECT c.customer_id, c.first_name, c.last_name, l.expiration_date
FROM customers c
JOIN loyalty_cards l ON c.customer_id = l.customer_id
WHERE l.expiration_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 30 DAY);

-- Retrieve customers along with their membership tier and total transactions.
SELECT c.customer_id, c.first_name, c.last_name, l.membership_tier, 
       COUNT(t.transaction_id) AS total_transactions
FROM customers c
JOIN loyalty_cards l ON c.customer_id = l.customer_id
LEFT JOIN transactions t ON c.customer_id = t.customer_id
GROUP BY c.customer_id, l.membership_tier;

-- Find the average transaction amount for each membership tier.
SELECT l.membership_tier, AVG(t.amount_spent) AS avg_transaction_amount
FROM loyalty_cards l
JOIN customers c ON l.customer_id = c.customer_id
JOIN transactions t ON c.customer_id = t.customer_id
GROUP BY l.membership_tier;

-- Retrieve the customers who have redeemed the most rewards
SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.redemption_id) AS total_redemptions
FROM customers c
JOIN redemptions r ON c.customer_id = r.customer_id
GROUP BY c.customer_id
ORDER BY total_redemptions DESC
LIMIT 5;

-- Find stores where total spending is above $200.
SELECT s.store_id, s.store_name, SUM(t.amount_spent) AS total_spending
FROM stores s
JOIN transactions t ON s.store_id = t.store_id
GROUP BY s.store_id
HAVING total_spending > 200;

-- Retrieve the top 3 customers with the highest points balance
SELECT c.customer_id, c.first_name, c.last_name, l.points_balance
FROM customers c
JOIN loyalty_cards l ON c.customer_id = l.customer_id
ORDER BY l.points_balance DESC
LIMIT 3;

-- Find the number of customers in each membership tier
SELECT membership_tier, COUNT(customer_id) AS total_customers
FROM loyalty_cards
GROUP BY membership_tier;

-- Find the percentage of customers in each membership tier
SELECT membership_tier, 
       COUNT(customer_id) AS total_customers,
       (COUNT(customer_id) * 100.0 / (SELECT COUNT(*) FROM customers)) AS percentage
FROM loyalty_cards
GROUP BY membership_tier;

-- Find the top 3 rewards that require the most points
SELECT reward_name, points_required
FROM rewards
ORDER BY points_required DESC
LIMIT 3;