-- MS SQL Project
CREATE DATABASE BudgetTool;

-- Users Table 
CREATE TABLE users (
  user_id INT IDENTITY(1,1) PRIMARY KEY,
  name VARCHAR(50),
  email VARCHAR(50),
  password_hash VARCHAR(50)
);

-- Categories Table 
CREATE TABLE categories (
  category_id INT IDENTITY(1,1) PRIMARY KEY,
  category_name VARCHAR(50),
  category_type VARCHAR(15) CHECK (category_type IN ('Income', 'Expense'))
);
  
-- Income Table 
CREATE TABLE income (
  income_id INT IDENTITY(1,1) PRIMARY KEY,
  user_id INT,
  category_id INT,
  amount INT,
  date_received DATE,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- Expenses Table 
CREATE TABLE expenses (
  expense_id INT IDENTITY(1,1) PRIMARY KEY,
  user_id INT,
  category_id INT,
  amount INT,
  date_spent DATE,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- Budgets Table 
CREATE TABLE budget (
  budget_id INT IDENTITY(1,1) PRIMARY KEY,
  user_id INT,
  category_id INT,
  amount_limit INT,
  start_date DATE,
  end_date DATE,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- Transactions Table
CREATE TABLE transactions (
  transaction_id INT IDENTITY(1,1) PRIMARY KEY,
  user_id INT,
  category_id INT,
  amount INT,
  transaction_type VARCHAR(20) CHECK (transaction_type IN ('Income', 'Expense')),
  transaction_date DATE,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (category_id) REFERENCES categories(category_id)
);  

-- Insert sample users
INSERT INTO users (name, email, password_hash) VALUES
('Alice Johnson', 'alice@example.com', 'hashedpassword1'),
('Bob Smith', 'bob@example.com', 'hashedpassword2'),
('Charlie Brown', 'charlie@example.com', 'hashedpassword3');

-- Insert sample categories
INSERT INTO categories (category_name, category_type) VALUES
('Salary', 'Income'),
('Freelance', 'Income'),
('Groceries', 'Expense'),
('Rent', 'Expense'),
('Entertainment', 'Expense');

-- Insert sample income records
INSERT INTO income (user_id, category_id, amount, date_received) VALUES
(1, 1, 5000, '2024-02-01'),
(2, 2, 1200, '2024-02-05'),
(3, 1, 4500, '2024-02-10');

-- Insert sample expenses records
INSERT INTO expenses (user_id, category_id, amount, date_spent) VALUES
(1, 3, 200, '2024-02-02'),
(1, 4, 1500, '2024-02-03'),
(2, 5, 300, '2024-02-06'),
(3, 3, 250, '2024-02-11');

-- Insert sample budgets
INSERT INTO budget (user_id, category_id, amount_limit, start_date, end_date) VALUES
(1, 3, 500, '2024-02-01', '2024-02-28'),
(1, 4, 2000, '2024-02-01', '2024-02-28'),
(2, 5, 400, '2024-02-01', '2024-02-28'),
(3, 3, 600, '2024-02-01', '2024-02-28');

-- Insert sample transactions
INSERT INTO transactions (user_id, category_id, amount, transaction_type, transaction_date) VALUES
(1, 1, 5000, 'Income', '2024-02-01'),
(2, 2, 1200, 'Income', '2024-02-05'),
(1, 3, 200, 'Expense', '2024-02-02'),
(1, 4, 1500, 'Expense', '2024-02-03'),
(2, 5, 300, 'Expense', '2024-02-06'),
(3, 3, 250, 'Expense', '2024-02-11');

-- Find total income and expenses for each user.
SELECT user_id, 
       SUM(CASE WHEN transaction_type = 'Income' THEN amount ELSE 0 END) AS total_income, 
       SUM(CASE WHEN transaction_type = 'Expense' THEN amount ELSE 0 END) AS total_expenses
FROM transactions
GROUP BY user_id;

-- Find users who exceeded their budget for a specific month.
SELECT b.user_id, b.category_id, b.amount_limit, 
       SUM(e.amount) AS total_spent
FROM budget b
JOIN expenses e ON b.user_id = e.user_id AND b.category_id = e.category_id
WHERE e.date_spent BETWEEN b.start_date AND b.end_date
GROUP BY b.user_id, b.category_id, b.amount_limit
HAVING SUM(e.amount) > b.amount_limit;

-- List the top 3 expense categories for a user in the last 6 months.
SELECT TOP 3 user_id, category_id, SUM(amount) AS total_spent
FROM expenses
WHERE date_spent >= DATEADD(MONTH, -6, GETDATE())
GROUP BY user_id, category_id
ORDER BY total_spent DESC;

-- Calculate the remaining budget for each category of a user.
SELECT b.user_id, b.category_id, b.amount_limit - COALESCE(SUM(e.amount), 0) AS remaining_budget
FROM budget b
LEFT JOIN expenses e ON b.user_id = e.user_id AND b.category_id = e.category_id
AND e.date_spent BETWEEN b.start_date AND b.end_date
GROUP BY b.user_id, b.category_id, b.amount_limit;

-- Find the month with the highest spending for each user.
SELECT user_id, FORMAT(date_spent, 'yyyy-MM') AS month, SUM(amount) AS total_spent
FROM expenses
GROUP BY user_id, FORMAT(date_spent, 'yyyy-MM')
ORDER BY total_spent DESC;

-- Get all transactions sorted by date for a given user.
SELECT * FROM transactions
WHERE user_id = 2
ORDER BY transaction_date;

-- Identify users who haven’t recorded an expense in the last 3 months.
SELECT DISTINCT u.user_id, u.name
FROM users u
LEFT JOIN expenses e ON u.user_id = e.user_id AND e.date_spent >= DATEADD(MONTH, -3, GETDATE())
WHERE e.expense_id IS NULL;

-- Find the average income and expenses for all users per month.
SELECT FORMAT(transaction_date, 'yyyy-MM') AS month,
       AVG(CASE WHEN transaction_type = 'Income' THEN amount ELSE NULL END) AS avg_income,
       AVG(CASE WHEN transaction_type = 'Expense' THEN amount ELSE NULL END) AS avg_expense
FROM transactions
GROUP BY FORMAT(transaction_date, 'yyyy-MM');

-- Check if any category has been used more for expenses than income.
SELECT category_id, 
       SUM(CASE WHEN transaction_type = 'Income' THEN amount ELSE 0 END) AS total_income,
       SUM(CASE WHEN transaction_type = 'Expense' THEN amount ELSE 0 END) AS total_expenses
FROM transactions
GROUP BY category_id
HAVING SUM(CASE WHEN transaction_type = 'Expense' THEN amount ELSE 0 END) > 
       SUM(CASE WHEN transaction_type = 'Income' THEN amount ELSE 0 END);

-- Detect users whose total expenses exceed their total income.
SELECT user_id
FROM transactions
GROUP BY user_id
HAVING SUM(CASE WHEN transaction_type = 'Expense' THEN amount ELSE 0 END) > 
       SUM(CASE WHEN transaction_type = 'Income' THEN amount ELSE 0 END);
