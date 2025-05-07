-- Project in PostgreSQL 
-- Create the database
CREATE DATABASE MicrofinanceDB;
\c MicrofinanceDB; 

-- Customers Table 
CREATE TABLE customers (
  customer_id SERIAL PRIMARY KEY,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  dob DATE,
  phone_number BIGINT,
  email VARCHAR(50) UNIQUE,
  address VARCHAR(100),
  created_at DATE
);

-- Loans Table  
CREATE TABLE loans (
  loan_id SERIAL PRIMARY KEY,
  customer_id INT,
  loan_amount DECIMAL(10,2),
  interest_rate FLOAT,
  loan_term_in_months INT,
  loan_status VARCHAR(10) CHECK (loan_status IN ('Active', 'Paid', 'Defaulted')),
  disbursal_date DATE,
  due_date DATE,
  created_at DATE
);

-- Payments Table 
CREATE TABLE payments (
  payment_id SERIAL PRIMARY KEY,
  loan_id INT,
  amount_paid DECIMAL(10,2),
  payment_date DATE,
  payment_status VARCHAR(10) CHECK (payment_status IN ('Completed', 'Pending', 'Failed')),
  created_at DATE,
  FOREIGN KEY (loan_id) REFERENCES loans(loan_id)
);

-- Guarantors Table  
CREATE TABLE guarantors (
  guarantor_id SERIAL PRIMARY KEY,
  customer_id INT,
  loan_id INT,
  guarantor_name VARCHAR(50),
  guarantor_phone BIGINT,
  guarantor_relationship VARCHAR(50),
  created_at DATE,
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  FOREIGN KEY (loan_id) REFERENCES loans(loan_id)
);

-- Loan Repayment Schedule Table 
CREATE TABLE loan_repayment_schedule (
  schedule_id SERIAL PRIMARY KEY,
  loan_id INT,
  due_date DATE,
  installment_amount DECIMAL(10,2),
  status VARCHAR(7) CHECK (status IN ('Pending', 'Paid', 'Overdue')),
  created_at DATE,
  FOREIGN KEY (loan_id) REFERENCES loans(loan_id)
);

-- Users Table 
CREATE TABLE users (
  user_id SERIAL PRIMARY KEY,
  username VARCHAR(50),
  password_hash TEXT,
  roles VARCHAR(12) CHECK (roles IN ('Admin', 'Loan Officer', 'Manager')),
  created_at DATE
);

-- Branches Table 
CREATE TABLE branches (
  branch_id SERIAL PRIMARY KEY,
  branch_name VARCHAR(50),
  branch_address VARCHAR(100),
  created_at DATE 
);  

-- Insert Sample Customers  
INSERT INTO customers (first_name, last_name, dob, phone_number, email, address, created_at) VALUES  
('John', 'Doe', '1985-06-15', 9876543210, 'johndoe@example.com', '123 Main St, NY', '2024-02-20'),
('Jane', 'Smith', '1990-09-25', 8765432109, 'janesmith@example.com', '456 Elm St, CA', '2024-02-20'),
('Michael', 'Johnson', '1982-12-05', 7654321098, 'michaelj@example.com', '789 Oak St, TX', '2024-02-20'),
('Emily', 'Davis', '1995-07-19', 6543210987, 'emilyd@example.com', '159 Pine St, FL', '2024-02-20'),
('David', 'Brown', '1988-04-10', 5432109876, 'davidb@example.com', '753 Cedar St, WA', '2024-02-20'),
('Sarah', 'Wilson', '1992-11-30', 4321098765, 'sarahw@example.com', '951 Birch St, NV', '2024-02-20');

-- Insert Sample Loans  
INSERT INTO loans (customer_id, loan_amount, interest_rate, loan_term_in_months, loan_status, disbursal_date, due_date, created_at) VALUES  
(1, 5000.00, 5.5, 12, 'Active', '2024-01-01', '2024-12-31', '2024-02-20'),
(2, 10000.00, 6.0, 24, 'Paid', '2023-01-15', '2025-01-15', '2024-02-20'),
(3, 7500.00, 4.8, 18, 'Defaulted', '2022-06-01', '2023-12-01', '2024-02-20'),
(4, 12000.00, 5.2, 36, 'Active', '2024-02-01', '2027-02-01', '2024-02-20'),
(5, 1500.00, 3.9, 6, 'Paid', '2023-09-01', '2024-03-01', '2024-02-20'),
(6, 3000.00, 4.5, 12, 'Active', '2023-12-01', '2024-12-01', '2024-02-20');

-- Insert Sample Payments  
INSERT INTO payments (loan_id, amount_paid, payment_date, payment_status, created_at) VALUES  
(1, 500.00, '2024-02-10', 'Completed', '2024-02-20'),
(2, 1000.00, '2023-12-15', 'Completed', '2024-02-20'),
(3, 750.00, '2023-05-20', 'Failed', '2024-02-20'),
(4, 1200.00, '2024-02-05', 'Completed', '2024-02-20'),
(5, 250.00, '2024-01-10', 'Completed', '2024-02-20'),
(6, 300.00, '2024-02-01', 'Pending', '2024-02-20');

-- Insert Sample Guarantors  
INSERT INTO guarantors (customer_id, loan_id, guarantor_name, guarantor_phone, guarantor_relationship, created_at) VALUES  
(2, 1, 'Robert Doe', 9876504321, 'Brother', '2024-02-20'),
(3, 2, 'Laura Smith', 8765409876, 'Sister', '2024-02-20'),
(4, 3, 'James Johnson', 7654328765, 'Friend', '2024-02-20'),
(5, 4, 'Anna Davis', 6543217654, 'Parent', '2024-02-20'),
(6, 5, 'George Brown', 5432106543, 'Spouse', '2024-02-20'),
(1, 6, 'Sophia Wilson', 4321095432, 'Cousin', '2024-02-20');

-- Insert Sample Loan Repayment Schedule  
INSERT INTO loan_repayment_schedule (loan_id, due_date, installment_amount, status, created_at) VALUES  
(1, '2024-03-01', 416.67, 'Pending', '2024-02-20'),
(2, '2024-02-15', 416.67, 'Paid', '2024-02-20'),
(3, '2023-07-01', 416.67, 'Overdue', '2024-02-20'),
(4, '2024-03-01', 333.33, 'Pending', '2024-02-20'),
(5, '2024-01-01', 250.00, 'Paid', '2024-02-20'),
(6, '2024-02-01', 250.00, 'Pending', '2024-02-20');

-- Insert Sample Users  
INSERT INTO users (username, password_hash, roles, created_at) VALUES  
('admin1', 'hashed_password_1', 'Admin', '2024-02-20'),
('loanofficer1', 'hashed_password_2', 'Loan Officer', '2024-02-20'),
('manager1', 'hashed_password_3', 'Manager', '2024-02-20'),
('admin2', 'hashed_password_4', 'Admin', '2024-02-20'),
('loanofficer2', 'hashed_password_5', 'Loan Officer', '2024-02-20'),
('manager2', 'hashed_password_6', 'Manager', '2024-02-20');

-- Insert Sample Branches  
INSERT INTO branches (branch_name, branch_address, created_at) VALUES  
('New York Branch', '100 Broadway, NY', '2024-02-20'),
('California Branch', '200 Sunset Blvd, CA', '2024-02-20'),
('Texas Branch', '300 Houston St, TX', '2024-02-20'),
('Florida Branch', '400 Miami St, FL', '2024-02-20'),
('Washington Branch', '500 Seattle Ave, WA', '2024-02-20'),
('Nevada Branch', '600 Las Vegas Blvd, NV', '2024-02-20');

-- Find loans that are overdue for more than 30 days.
SELECT l.loan_id, l.customer_id, c.first_name, c.last_name, l.due_date
FROM loans l
JOIN customers c ON l.customer_id = c.customer_id
WHERE l.due_date < NOW() - INTERVAL '30 days' 
AND l.loan_status = 'Active';

-- List all guarantors who have guaranteed loans that are now in default.
SELECT g.guarantor_id, g.guarantor_name, g.guarantor_phone, g.customer_id, g.loan_id
FROM guarantors g
JOIN loans l ON g.loan_id = l.loan_id
WHERE l.loan_status = 'Defaulted';

-- Get the top 5 customers who have taken the highest loan amounts.
SELECT c.customer_id, c.first_name, c.last_name, SUM(l.loan_amount) AS total_loan_amount
FROM customers c
JOIN loans l ON c.customer_id = l.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_loan_amount DESC
LIMIT 5;

-- Calculate the total interest revenue expected for the next 12 months.
SELECT SUM((loan_amount * (interest_rate / 100) / loan_term_in_months) * 12) AS expected_interest_revenue
FROM loans
WHERE loan_status = 'Active';

-- Identify customers who have made an early loan repayment before the due date.
SELECT DISTINCT c.customer_id, c.first_name, c.last_name, p.payment_date, rs.due_date
FROM customers c
JOIN loans l ON c.customer_id = l.customer_id
JOIN payments p ON l.loan_id = p.loan_id
JOIN loan_repayment_schedule rs ON l.loan_id = rs.loan_id
WHERE p.payment_date < rs.due_date;

--Identify customers who have fully repaid their loans. 
SELECT c.customer_id, c.first_name, c.last_name
FROM customers c
JOIN loans l ON c.customer_id = l.customer_id
WHERE l.loan_status = 'Paid';

-- Find loans with the highest interest rates.
SELECT loan_id, customer_id, loan_amount, interest_rate, loan_term_in_months
FROM loans
ORDER BY interest_rate DESC
LIMIT 4;

-- Get the number of active loans per customer
SELECT c.customer_id, c.first_name, c.last_name, COUNT(l.loan_id) AS active_loans
FROM customers c
JOIN loans l ON c.customer_id = l.customer_id
WHERE l.loan_status = 'Active'
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY active_loans DESC;

-- Find all customers who have overdue loan payments.
SELECT DISTINCT c.customer_id, c.first_name, c.last_name
FROM customers c
JOIN loans l ON c.customer_id = l.customer_id
JOIN loan_repayment_schedule rs ON l.loan_id = rs.loan_id
WHERE rs.status = 'Overdue';