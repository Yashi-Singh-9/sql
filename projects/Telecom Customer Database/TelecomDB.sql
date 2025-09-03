-- Project In MariaDB 
-- Creating the database
CREATE DATABASE TelecomDB;
USE TelecomDB;

CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100) UNIQUE,
    PhoneNumber VARCHAR(15) UNIQUE,
    Address TEXT,
    City VARCHAR(50),
    State VARCHAR(50),
    Country VARCHAR(50),
    ZipCode VARCHAR(10),
    DateJoined DATE
);

CREATE TABLE Plans (
    PlanID INT AUTO_INCREMENT PRIMARY KEY,
    PlanName VARCHAR(100),
    MonthlyCharge DECIMAL(10,2),
    DataLimitGB DECIMAL(5,2),
    CallMinutes INT,
    SMSLimit INT,
    PlanType ENUM('Prepaid', 'Postpaid')
);
 
CREATE TABLE Subscriptions (
    SubscriptionID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT,
    PlanID INT,
    StartDate DATE,
    EndDate DATE,
    Status ENUM('Active', 'Inactive', 'Suspended'),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (PlanID) REFERENCES Plans(PlanID)
);

CREATE TABLE Payments (
    PaymentID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT,
    Amount DECIMAL(10,2),
    PaymentDate DATE,
    PaymentMethod ENUM('Credit Card', 'Debit Card', 'PayPal', 'Net Banking'),
    TransactionID VARCHAR(50) UNIQUE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE UsageData (
    UsageID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT,
    DataUsedGB DECIMAL(5,2),
    MinutesUsed INT,
    SMSUsed INT,
    UsageDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

INSERT INTO Customers (FirstName, LastName, Email, PhoneNumber, Address, City, State, Country, ZipCode, DateJoined) 
VALUES 
('John', 'Doe', 'john.doe@email.com', '1234567890', '123 Elm Street', 'New York', 'NY', 'USA', '10001', '2023-01-15'),
('Alice', 'Smith', 'alice.smith@email.com', '9876543210', '456 Oak Street', 'Los Angeles', 'CA', 'USA', '90001', '2023-02-20'),
('Bob', 'Johnson', 'bob.johnson@email.com', '1122334455', '789 Pine Avenue', 'Chicago', 'IL', 'USA', '60601', '2023-03-10'),
('Eve', 'Adams', 'eve.adams@email.com', '6677889900', '321 Maple Drive', 'Houston', 'TX', 'USA', '77001', '2023-04-05'),
('Charlie', 'Brown', 'charlie.brown@email.com', '4433221100', '654 Birch Road', 'Miami', 'FL', 'USA', '33101', '2023-05-18');

INSERT INTO Plans (PlanName, MonthlyCharge, DataLimitGB, CallMinutes, SMSLimit, PlanType) 
VALUES 
('Basic Plan', 19.99, 5, 500, 100, 'Prepaid'),
('Standard Plan', 29.99, 10, 1000, 200, 'Postpaid'),
('Premium Plan', 49.99, 50, 3000, 500, 'Postpaid'),
('Unlimited Plan', 69.99, NULL, NULL, NULL, 'Postpaid'),
('Budget Plan', 14.99, 2, 200, 50, 'Prepaid');

INSERT INTO Subscriptions (CustomerID, PlanID, StartDate, EndDate, Status) 
VALUES 
(1, 2, '2024-01-01', '2025-01-01', 'Active'),
(2, 3, '2024-02-01', '2025-02-01', 'Active'),
(3, 1, '2024-03-01', '2024-09-01', 'Inactive'),
(4, 4, '2024-04-01', '2025-04-01', 'Active'),
(5, 5, '2024-05-01', '2024-11-01', 'Suspended');

INSERT INTO Payments (CustomerID, Amount, PaymentDate, PaymentMethod, TransactionID) 
VALUES 
(1, 29.99, '2024-01-10', 'Credit Card', 'TXN12345'),
(2, 49.99, '2024-02-15', 'Debit Card', 'TXN67890'),
(3, 19.99, '2024-03-20', 'PayPal', 'TXN11223'),
(4, 69.99, '2024-04-25', 'Net Banking', 'TXN44556'),
(5, 14.99, '2024-05-30', 'Credit Card', 'TXN77889');

INSERT INTO UsageData (CustomerID, DataUsedGB, MinutesUsed, SMSUsed, UsageDate) 
VALUES 
(1, 7.5, 800, 150, '2024-01-05'),
(2, 12.3, 1200, 300, '2024-02-10'),
(3, 3.2, 400, 80, '2024-03-15'),
(4, 50.0, 5000, 1000, '2024-04-20'),
(5, 1.8, 150, 30, '2024-05-25');

-- Find all customers who haven't made a payment in the last 3 months
SELECT C.CustomerID, C.FirstName, C.LastName, C.Email, C.PhoneNumber
FROM Customers C
LEFT JOIN Payments P ON C.CustomerID = P.CustomerID
WHERE P.PaymentDate IS NULL 
   OR P.PaymentDate < DATE_SUB(CURDATE(), INTERVAL 3 MONTH);

-- Retrieve customers whose usage exceeded their plan limit in the past month
SELECT C.CustomerID, C.FirstName, C.LastName, P.PlanName, U.DataUsedGB, U.MinutesUsed, U.SMSUsed
FROM Customers C
JOIN Subscriptions S ON C.CustomerID = S.CustomerID
JOIN Plans P ON S.PlanID = P.PlanID
JOIN UsageData U ON C.CustomerID = U.CustomerID
WHERE U.UsageDate >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
AND (U.DataUsedGB > P.DataLimitGB OR U.MinutesUsed > P.CallMinutes OR U.SMSUsed > P.SMSLimit);

-- Get the total revenue generated from postpaid plans
SELECT SUM(P.Amount) AS TotalRevenue
FROM Payments P
JOIN Subscriptions S ON P.CustomerID = S.CustomerID
JOIN Plans PL ON S.PlanID = PL.PlanID
WHERE PL.PlanType = 'Postpaid';

-- Find the most popular telecom plan based on the number of subscriptions
SELECT P.PlanName, COUNT(S.SubscriptionID) AS TotalSubscriptions
FROM Plans P
JOIN Subscriptions S ON P.PlanID = S.PlanID
GROUP BY P.PlanID
ORDER BY TotalSubscriptions DESC
LIMIT 1;

-- Find customers who have an active subscription but have not used any services (data, calls, or SMS) in the last month
SELECT C.CustomerID, C.FirstName, C.LastName
FROM Customers C
JOIN Subscriptions S ON C.CustomerID = S.CustomerID
LEFT JOIN UsageData U ON C.CustomerID = U.CustomerID 
   AND U.UsageDate >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
WHERE S.Status = 'Active'
AND (U.UsageID IS NULL OR (U.DataUsedGB = 0 AND U.MinutesUsed = 0 AND U.SMSUsed = 0));

-- Calculate the total amount paid by each customer in the past year
SELECT C.CustomerID, C.FirstName, C.LastName, SUM(P.Amount) AS TotalAmountPaid
FROM Customers C
JOIN Payments P ON C.CustomerID = P.CustomerID
WHERE P.PaymentDate >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY C.CustomerID;
