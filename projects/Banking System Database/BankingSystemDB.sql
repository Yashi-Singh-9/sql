-- Project in PostgreSQL 
-- Create Database
CREATE DATABASE BankingSystemDB;
\c BankingSystemDB;

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DOB DATE,
    PhoneNumber VARCHAR(15),
    Email VARCHAR(100),
    Address VARCHAR(255),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Accounts (
    AccountID INT PRIMARY KEY,
    CustomerID INT,
    AccountType VARCHAR(20),
    Balance DECIMAL(10,2),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY,
    AccountID INT,
    TransactionType VARCHAR(20),
    Amount DECIMAL(10,2),
    TransactionDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);

CREATE TABLE Loans (
    LoanID INT PRIMARY KEY,
    CustomerID INT,
    LoanType VARCHAR(50),
    LoanAmount DECIMAL(10,2),
    InterestRate DECIMAL(5,2),
    LoanStatus VARCHAR(20),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Position VARCHAR(50),
    Salary DECIMAL(10,2),
    BranchID INT
);

CREATE TABLE Branches (
    BranchID INT PRIMARY KEY,
    BranchName VARCHAR(100),
    Location VARCHAR(100)
);

CREATE TABLE Cards (
    CardID INT PRIMARY KEY,
    AccountID INT,
    CardType VARCHAR(20),
    CardNumber VARCHAR(16),
    ExpiryDate DATE,
    CVV INT,
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);

CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY,
    AccountID INT,
    PaymentAmount DECIMAL(10,2),
    PaymentDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ReceiverName VARCHAR(100),
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);

-- Inserting into Customers
INSERT INTO Customers (CustomerID, FirstName, LastName, DOB, PhoneNumber, Email, Address)
VALUES 
(1, 'John', 'Doe', '1985-07-10', '1234567890', 'john@example.com', '123 Street, NY'),
(2, 'Jane', 'Smith', '1990-03-22', '0987654321', 'jane@example.com', '456 Avenue, LA'),
(3, 'Michael', 'Brown', '1978-12-05', '1112223333', 'michael@example.com', '789 Blvd, TX'),
(4, 'Emily', 'Johnson', '1995-06-15', '4445556666', 'emily@example.com', '321 Lane, FL'),
(5, 'David', 'Williams', '1982-09-30', '7778889999', 'david@example.com', '654 Road, IL');

-- Inserting into Accounts
INSERT INTO Accounts (AccountID, CustomerID, AccountType, Balance)
VALUES 
(1, 1, 'Savings', 15000.00),
(2, 2, 'Checking', 5000.00),
(3, 3, 'Savings', 12000.00),
(4, 1, 'Checking', 2000.00),
(5, 4, 'Savings', 18000.00);

-- Inserting into Transactions
INSERT INTO Transactions (TransactionID, AccountID, TransactionType, Amount)
VALUES 
(1, 1, 'Deposit', 5000.00),
(2, 2, 'Withdrawal', 200.00),
(3, 3, 'Deposit', 8000.00),
(4, 4, 'Transfer', 500.00),
(5, 5, 'Withdrawal', 1000.00);

-- Inserting into Loans
INSERT INTO Loans (LoanID, CustomerID, LoanType, LoanAmount, InterestRate, LoanStatus)
VALUES 
(1, 1, 'Home Loan', 60000.00, 5.5, 'Approved'),
(2, 2, 'Car Loan', 20000.00, 4.2, 'Pending'),
(3, 3, 'Personal Loan', 55000.00, 6.0, 'Approved'),
(4, 4, 'Home Loan', 75000.00, 5.8, 'Approved'),
(5, 5, 'Education Loan', 30000.00, 3.5, 'Processing');

-- Inserting into Employees
INSERT INTO Employees (EmployeeID, FirstName, LastName, Position, Salary, BranchID)
VALUES 
(1, 'Alice', 'Green', 'Manager', 70000.00, 1),
(2, 'Bob', 'White', 'Clerk', 40000.00, 1),
(3, 'Charlie', 'Black', 'Cashier', 35000.00, 2),
(4, 'Diana', 'Blue', 'Loan Officer', 50000.00, 3),
(5, 'Edward', 'Gray', 'Teller', 38000.00, 2);

-- Inserting into Branches
INSERT INTO Branches (BranchID, BranchName, Location)
VALUES 
(1, 'NY Main', 'New York'),
(2, 'LA West', 'Los Angeles'),
(3, 'TX Central', 'Texas');

-- Inserting into Cards
INSERT INTO Cards (CardID, AccountID, CardType, CardNumber, ExpiryDate, CVV)
VALUES 
(1, 1, 'Credit', '1234567812345678', '2028-06-30', 123),
(2, 2, 'Debit', '2345678923456789', '2026-09-30', 456),
(3, 3, 'Credit', '3456789034567890', '2025-12-31', 789),
(4, 4, 'Debit', '4567890145678901', '2027-03-31', 101),
(5, 5, 'Credit', '5678901256789012', '2029-08-31', 202);

-- Inserting into Payments
INSERT INTO Payments (PaymentID, AccountID, PaymentAmount, ReceiverName)
VALUES 
(1, 1, 500.00, 'Amazon'),
(2, 2, 1000.00, 'Walmart'),
(3, 3, 200.00, 'Netflix'),
(4, 4, 150.00, 'Spotify'),
(5, 5, 300.00, 'Apple');

-- 1. Customers with account balance greater than $10,000
SELECT * 
FROM Customers 
WHERE CustomerID IN (SELECT CustomerID FROM Accounts WHERE Balance > 10000);

-- 2. Transactions made on a specific date
SELECT * 
FROM Transactions 
WHERE DATE(TransactionDate) = '2025-02-26';

-- 3. Loans greater than $50,000
SELECT * 
FROM Loans 
WHERE LoanAmount > 50000;

-- 4. Customers with both savings and checking accounts
SELECT CustomerID 
FROM Accounts 
GROUP BY CustomerID 
HAVING COUNT(DISTINCT AccountType) = 2;

-- 5. Total deposits and withdrawals in the last month
SELECT TransactionType, SUM(Amount) 
FROM Transactions 
WHERE TransactionDate >= CURRENT_DATE - INTERVAL '1 month'
GROUP BY TransactionType;

-- 6. Branch with the highest number of customers
SELECT BranchID, COUNT(*) AS TotalCustomers 
FROM Employees 
GROUP BY BranchID 
ORDER BY TotalCustomers DESC 
LIMIT 1;

-- 7. Top 5 customers with highest loan amounts
SELECT CustomerID, SUM(LoanAmount) AS TotalLoanAmount 
FROM Loans 
GROUP BY CustomerID 
ORDER BY TotalLoanAmount DESC 
LIMIT 5;

-- 8. Employees working in a specific branch (e.g., BranchID = 1)
SELECT * 
FROM Employees 
WHERE BranchID = 1;

-- 9. Total balance of all accounts belonging to a specific customer (e.g., CustomerID = 1)
SELECT SUM(Balance) AS TotalBalance 
FROM Accounts 
WHERE CustomerID = 1;

-- 10. Total loan amount issued by each branch
SELECT BranchID, SUM(LoanAmount) AS TotalLoans 
FROM Loans 
JOIN Employees ON Loans.CustomerID = Employees.EmployeeID GROUP BY BranchID;

-- 11. Find the total number of accounts each customer has
SELECT CustomerID, COUNT(*) AS TotalAccounts
FROM Accounts
GROUP BY CustomerID;

-- 12. Get the total number of transactions per account type 
SELECT A.AccountType, COUNT(T.TransactionID) AS TotalTransactions
FROM Accounts A
LEFT JOIN Transactions T ON A.AccountID = T.AccountID
GROUP BY A.AccountType;

-- 13. Find employees who earn more than the average salary of all employees
SELECT * 
FROM Employees 
WHERE Salary > (SELECT AVG(Salary) FROM Employees);

-- 14. Find the customer who has the highest total balance across all accounts
SELECT C.CustomerID, C.FirstName, C.LastName, SUM(A.Balance) AS TotalBalance
FROM Customers C
JOIN Accounts A ON C.CustomerID = A.CustomerID
GROUP BY C.CustomerID, C.FirstName, C.LastName
ORDER BY TotalBalance DESC
LIMIT 1;