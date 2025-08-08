sqlite3 BusinessExpenseDB.db

-- Users Table  
CREATE TABLE users (
  user_id INTEGER PRIMARY KEY,
  name VARCHAR(20) NOT NULL,
  email VARCHAR(50) NOT NULL,
  password TEXT
);

-- Categories Table  
CREATE TABLE categories (
  category_id INTEGER PRIMARY KEY,
  category_name VARCHAR(20) NOT NULL
);

-- Expenses Table  
CREATE TABLE expenses (
  expense_id INTEGER PRIMARY KEY,
  user_id INTEGER,
  category_id INTEGER,
  amount DECIMAL(10,2) NOT NULL,
  description TEXT,
  date DATE NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- Payment Methods Table 
CREATE TABLE payment_methods (
  method_id INTEGER PRIMARY KEY,
  method_name VARCHAR(20) CHECK (method_name IN ('Credit Card', 'Cash', 'Bank Transfer'))
);

-- Expense Payments Table 
CREATE TABLE expense_payments (
  expense_payment_id INTEGER PRIMARY KEY,
  expense_id INTEGER,
  method_id INTEGER,
  transaction_reference VARCHAR(50),
  FOREIGN KEY (expense_id) REFERENCES expenses(expense_id),
  FOREIGN KEY (method_id) REFERENCES payment_methods(method_id)
);

-- Vendors Table 
CREATE TABLE vendors (
  vendor_id INTEGER PRIMARY KEY,
  vendor_name VARCHAR(50)
);

-- Expense Vendors Table 
CREATE TABLE expense_vendors (
  expense_vendor_id INTEGER PRIMARY KEY,
  expense_id INTEGER,
  vendor_id INTEGER,
  FOREIGN KEY (expense_id) REFERENCES expenses(expense_id),
  FOREIGN Key (vendor_id) REFERENCES vendors(vendor_id)
);

-- Insert Users
INSERT INTO users (user_id, name, email, password) VALUES
(1, 'Alice Johnson', 'alice@example.com', 'pass123'),
(2, 'Bob Smith', 'bob@example.com', 'secure456'),
(3, 'Charlie Brown', 'charlie@example.com', 'hello789'),
(4, 'David White', 'david@example.com', 'password1'),
(5, 'Eve Adams', 'eve@example.com', 'mypassword'),
(6, 'Frank Martin', 'frank@example.com', '123secure'),
(7, 'Grace Lee', 'grace@example.com', 'gracepass'),
(8, 'Henry Wilson', 'henry@example.com', 'henry123');

-- Insert Categories
INSERT INTO categories (category_id, category_name) VALUES
(1, 'Travel'),
(2, 'Food'),
(3, 'Office Supplies'),
(4, 'Entertainment'),
(5, 'Utilities'),
(6, 'Software'),
(7, 'Marketing'),
(8, 'Training');

-- Insert Expenses
INSERT INTO expenses (expense_id, user_id, category_id, amount, description, date) VALUES
(1, 1, 2, 45.99, 'Lunch with client', '2024-02-01'),
(2, 2, 3, 120.50, 'Printer ink', '2024-02-02'),
(3, 3, 1, 300.00, 'Flight ticket', '2024-02-03'),
(4, 4, 4, 80.75, 'Team movie night', '2024-02-04'),
(5, 5, 5, 200.00, 'Electricity bill', '2024-02-05'),
(6, 6, 6, 99.99, 'Software subscription', '2024-02-06'),
(7, 7, 7, 150.00, 'Facebook ads', '2024-02-07'),
(8, 8, 8, 50.00, 'Online training course', '2024-02-08');

-- Insert Payment Methods
INSERT INTO payment_methods (method_id, method_name) VALUES
(1, 'Credit Card'),
(2, 'Cash'),
(3, 'Bank Transfer');

-- Insert Expense Payments
INSERT INTO expense_payments (expense_payment_id, expense_id, method_id, transaction_reference) VALUES
(1, 1, 1, 'TXN12345'),
(2, 2, 2, 'TXN12346'),
(3, 3, 3, 'TXN12347'),
(4, 4, 1, 'TXN12348'),
(5, 5, 2, 'TXN12349'),
(6, 6, 3, 'TXN12350'),
(7, 7, 1, 'TXN12351'),
(8, 8, 2, 'TXN12352');

-- Insert Vendors
INSERT INTO vendors (vendor_id, vendor_name) VALUES
(1, 'Amazon'),
(2, 'Uber Eats'),
(3, 'Delta Airlines'),
(4, 'AMC Theatres'),
(5, 'Electric Co.'),
(6, 'Adobe Inc.'),
(7, 'Facebook'),
(8, 'Udemy');

-- Insert Expense Vendors
INSERT INTO expense_vendors (expense_vendor_id, expense_id, vendor_id) VALUES
(1, 1, 2),
(2, 2, 1),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5),
(6, 6, 6),
(7, 7, 7),
(8, 8, 8);

-- Find the total expenses for each user in the last month.
SELECT 
    e.user_id, 
    u.name, 
    SUM(e.amount) AS total_expense
FROM expenses e
JOIN users u ON e.user_id = u.user_id
WHERE strftime('%Y-%m', e.date) = strftime('%Y-%m', 'now', '-1 month')
GROUP BY e.user_id;

-- List all expenses made using a specific payment method (e.g., "Credit Card").
SELECT 
    e.expense_id, 
    e.user_id, 
    e.amount, 
    e.description, 
    e.date, 
    pm.method_name
FROM expenses e
JOIN expense_payments ep ON e.expense_id = ep.expense_id
JOIN payment_methods pm ON ep.method_id = pm.method_id
WHERE pm.method_name = 'Credit Card';

-- Find the top 5 categories where users spend the most.
SELECT 
    c.category_id, 
    c.category_name, 
    SUM(e.amount) AS total_spent
FROM expenses e
JOIN categories c ON e.category_id = c.category_id
GROUP BY c.category_id
ORDER BY total_spent DESC
LIMIT 5;

-- Get a breakdown of expenses by category for a specific user.
SELECT 
    c.category_id, 
    c.category_name, 
    SUM(e.amount) AS total_spent
FROM expenses e
JOIN categories c ON e.category_id = c.category_id
WHERE e.user_id = 3
GROUP BY c.category_id;

-- Find users who have spent more than $5000 in the last 3 months.
SELECT 
    e.user_id, 
    u.name, 
    SUM(e.amount) AS total_spent
FROM expenses e
JOIN users u ON e.user_id = u.user_id
WHERE e.date >= date('now', '-3 months')
GROUP BY e.user_id
HAVING total_spent > 5000;

-- List all expenses along with their vendor names (if available).
SELECT 
    e.expense_id, 
    e.user_id, 
    e.amount, 
    e.description, 
    e.date, 
    v.vendor_name
FROM expenses e
LEFT JOIN expense_vendors ev ON e.expense_id = ev.expense_id
LEFT JOIN vendors v ON ev.vendor_id = v.vendor_id;

-- Show all expenses along with their payment method details.
SELECT 
    e.expense_id, 
    e.user_id, 
    e.amount, 
    e.description, 
    e.date, 
    pm.method_name, 
    ep.transaction_reference
FROM expenses e
LEFT JOIN expense_payments ep ON e.expense_id = ep.expense_id
LEFT JOIN payment_methods pm ON ep.method_id = pm.method_id;

-- Find the most used payment method for expenses.
SELECT 
    pm.method_name, 
    COUNT(ep.expense_payment_id) AS usage_count
FROM expense_payments ep
JOIN payment_methods pm ON ep.method_id = pm.method_id
GROUP BY pm.method_name
ORDER BY usage_count DESC
LIMIT 1;

-- List users who have never logged an expense.
SELECT 
    u.user_id, 
    u.name, 
    u.email
FROM users u
LEFT JOIN expenses e ON u.user_id = e.user_id
WHERE e.user_id IS NULL;

-- Get the average expense amount for each category.
SELECT 
    c.category_id, 
    c.category_name, 
    AVG(e.amount) AS avg_expense
FROM expenses e
JOIN categories c ON e.category_id = c.category_id
GROUP BY c.category_id;
