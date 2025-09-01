-- SQL Lite Project
sqlite3 finance_tracker.db

-- Users Table
CREATE TABLE users (
  user_id INTEGER PRIMARY KEY,
  name VARCHAR(20),
  email VARCHAR(20) UNIQUE,
  password VARCHAR(20),
  created_at DATETIME
);

-- Accounts Table
CREATE Table accounts (
  account_id INTEGER PRIMARY KEY,
  user_id INTEGER,
  account_name VARCHAR(30),
  account_type VARCHAR(15) CHECK (account_type IN ('Savings', 'Checking', 'Credit')),
  balance INTEGER,
  created_at DATETIME,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Categories Table
CREATE TABLE categories (
  category_id INTEGER PRIMARY KEY,
  category_name VARCHAR(20),
  category_type VARCHAR(20) CHECK (category_type IN ('Income', 'Expense'))
);  

-- Transactions Table
CREATE Table transactions (
  transaction_id INTEGER PRIMARY KEY,
  user_id INTEGER,
  account_id INTEGER,
  transaction_type VARCHAR(10) CHECK (transaction_type IN ('Income', 'Expense')),
  category_id INTEGER,
  amount INTEGER,
  transaction_date DATE,
  description TEXT,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (account_id) REFERENCES accounts(account_id),
  FOREIGN KEY (category_id) REFERENCES categories(category_id)
);  

-- Budget Table
CREATE TABLE budget (
  budget_id INTEGER PRIMARY KEY,
  user_id INTEGER,
  category_id INTEGER,
  amount_limit INTEGER,
  start_date DATE,
  end_date DATE,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- Recurring Payments Table
CREATE Table recurring_payment (
  recurring_id INTEGER,
  user_id INTEGER,
  account_id INTEGER,
  amount INTEGER,
  next_due_date DATE,
  frequency VARCHAR(15) CHECK ( frequency IN ('Monthly', 'Weekly', 'Yearly')),
  description TEXT,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);  

-- Insert Users
INSERT INTO users (user_id, name, email, password, created_at) VALUES
(1, 'Alice', 'alice@example.com', 'pass123', '2024-01-01 10:00:00'),
(2, 'Bob', 'bob@example.com', 'pass456', '2024-01-02 11:30:00'),
(3, 'Charlie', 'charlie@example.com', 'pass789', '2024-01-03 12:45:00'),
(4, 'David', 'david@example.com', 'pass000', '2024-01-04 14:15:00');

-- Insert Accounts
INSERT INTO accounts (account_id, user_id, account_name, account_type, balance, created_at) VALUES
(1, 1, 'Alice Savings', 'Savings', 5000, '2024-01-01 10:05:00'),
(2, 1, 'Alice Checking', 'Checking', 2000, '2024-01-01 10:10:00'),
(3, 2, 'Bob Credit', 'Credit', -1500, '2024-01-02 11:35:00'),
(4, 3, 'Charlie Savings', 'Savings', 8000, '2024-01-03 12:50:00'),
(5, 4, 'David Checking', 'Checking', 1200, '2024-01-04 14:20:00');

-- Insert Categories
INSERT INTO categories (category_id, category_name, category_type) VALUES
(1, 'Salary', 'Income'),
(2, 'Groceries', 'Expense'),
(3, 'Entertainment', 'Expense'),
(4, 'Investment', 'Income'),
(5, 'Rent', 'Expense');

-- Insert Transactions
INSERT INTO transactions (transaction_id, user_id, account_id, transaction_type, category_id, amount, transaction_date, description) VALUES
(1, 1, 1, 'Income', 1, 3000, '2024-01-05', 'Monthly salary'),
(2, 1, 2, 'Expense', 2, 200, '2024-01-06', 'Grocery shopping'),
(3, 2, 3, 'Expense', 5, 1000, '2024-01-07', 'Rent payment'),
(4, 3, 4, 'Income', 4, 5000, '2024-01-08', 'Stock dividend'),
(5, 4, 5, 'Expense', 3, 100, '2024-01-09', 'Movie night');

-- Insert Budget
INSERT INTO budget (budget_id, user_id, category_id, amount_limit, start_date, end_date) VALUES
(1, 1, 2, 500, '2024-01-01', '2024-01-31'),
(2, 2, 5, 1200, '2024-01-01', '2024-01-31'),
(3, 3, 3, 300, '2024-01-01', '2024-01-31'),
(4, 4, 4, 2000, '2024-01-01', '2024-01-31');

-- Insert Recurring Payments
INSERT INTO recurring_payment (recurring_id, user_id, account_id, amount, next_due_date, frequency, description) VALUES
(1, 1, 2, 50, '2024-02-01', 'Monthly', 'Netflix Subscription'),
(2, 2, 3, 100, '2024-02-05', 'Monthly', 'Gym Membership'),
(3, 3, 4, 200, '2024-02-10', 'Yearly', 'Insurance Payment'),
(4, 4, 5, 30, '2024-02-15', 'Weekly', 'Spotify Subscription');

-- Find the total expenses for each user in the last month.
SELECT user_id, SUM(amount) AS total_expenses
FROM transactions
WHERE transaction_type = 'Expense' AND transaction_date >= DATE('now', '-1 month')
GROUP BY user_id;

-- Get the top 3 spending categories for a user in a given time period.
SELECT category_id, SUM(amount) AS total_spent
FROM transactions
WHERE user_id = 1 AND transaction_type = 'Expense' 
AND transaction_date BETWEEN '2024-01-01' AND '2024-01-31'
GROUP BY category_id
ORDER BY total_spent DESC
LIMIT 3;

-- Retrieve all transactions where the amount exceeds the budget limit for the category.
SELECT t.*
FROM transactions t
JOIN budget b ON t.user_id = b.user_id AND t.category_id = b.category_id
WHERE t.amount > b.amount_limit;

-- List all recurring payments due in the next 7 days.
SELECT * FROM recurring_payment
WHERE next_due_date BETWEEN DATE('now') AND DATE('now', '+7 days');

-- Find users who have never made a transaction.
SELECT u.*
FROM users u
LEFT JOIN transactions t ON u.user_id = t.user_id
WHERE t.user_id IS NULL;

-- Calculate the remaining budget for each user by category.
SELECT b.user_id, b.category_id, b.amount_limit - IFNULL(SUM(t.amount), 0) AS remaining_budget
FROM budget b
LEFT JOIN transactions t ON b.user_id = t.user_id AND b.category_id = t.category_id AND t.transaction_type = 'Expense'
GROUP BY b.user_id, b.category_id;

-- Get the account with the highest balance for each user.
SELECT user_id, account_id, account_name, balance
FROM accounts a
WHERE balance = (SELECT MAX(balance) FROM accounts a2 WHERE a2.user_id = a.user_id);

-- Find the average transaction amount for each category.
SELECT category_id, AVG(amount) AS avg_transaction_amount
FROM transactions
GROUP BY category_id;

-- List all users who have at least one account with a negative balance.
SELECT DISTINCT user_id 
FROM accounts
WHERE balance < 0;

-- Get the total income vs total expenses for each user in the last year.
SELECT user_id,
    SUM(CASE WHEN transaction_type = 'Income' THEN amount ELSE 0 END) AS total_income,
    SUM(CASE WHEN transaction_type = 'Expense' THEN amount ELSE 0 END) AS total_expenses
FROM transactions
WHERE transaction_date >= DATE('now', '-1 year')
GROUP BY user_id;
