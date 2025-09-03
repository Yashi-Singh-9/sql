-- Project in PostgreSQL 
-- Create Database
CREATE DATABASE HotelReservationDB;

-- Connect to Database
\c HotelReservationDB;

CREATE TABLE Customers (
    CustomerID SERIAL PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(15) NOT NULL,
    RegisteredDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Rooms (
    RoomID SERIAL PRIMARY KEY,
    RoomNumber VARCHAR(10) UNIQUE NOT NULL,
    RoomType VARCHAR(50) NOT NULL,
    PricePerNight DECIMAL(10,2) NOT NULL,
    Status VARCHAR(20) CHECK (Status IN ('Available', 'Occupied', 'Under Maintenance')) DEFAULT 'Available'
);

CREATE TABLE Reservations (
    ReservationID SERIAL PRIMARY KEY,
    CustomerID INT REFERENCES Customers(CustomerID) ON DELETE CASCADE,
    RoomID INT REFERENCES Rooms(RoomID) ON DELETE CASCADE,
    CheckInDate DATE NOT NULL,
    CheckOutDate DATE NOT NULL,
    TotalAmount DECIMAL(10,2),
    Status VARCHAR(20) CHECK (Status IN ('Confirmed', 'Cancelled', 'Checked In', 'Checked Out')) DEFAULT 'Confirmed',
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Payments (
    PaymentID SERIAL PRIMARY KEY,
    ReservationID INT REFERENCES Reservations(ReservationID) ON DELETE CASCADE,
    Amount DECIMAL(10,2) NOT NULL,
    PaymentDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PaymentMethod VARCHAR(50) CHECK (PaymentMethod IN ('Credit Card', 'Debit Card', 'Cash', 'Online'))
);

INSERT INTO Customers (FirstName, LastName, Email, Phone) VALUES
('John', 'Doe', 'john.doe@example.com', '1234567890'),
('Alice', 'Smith', 'alice.smith@example.com', '2345678901'),
('Robert', 'Brown', 'robert.brown@example.com', '3456789012');

INSERT INTO Rooms (RoomNumber, RoomType, PricePerNight, Status) VALUES
('101', 'Single', 100.00, 'Available'),
('102', 'Double', 150.00, 'Occupied'),
('103', 'Suite', 250.00, 'Available'),
('104', 'Deluxe', 200.00, 'Under Maintenance');

INSERT INTO Reservations (CustomerID, RoomID, CheckInDate, CheckOutDate, TotalAmount, Status) VALUES
(1, 1, '2025-03-10', '2025-03-12', 200.00, 'Confirmed'),
(2, 2, '2025-03-15', '2025-03-18', 450.00, 'Checked In'),
(3, 3, '2025-03-20', '2025-03-22', 500.00, 'Cancelled');

INSERT INTO Payments (ReservationID, Amount, PaymentMethod) VALUES
(1, 200.00, 'Credit Card'),
(2, 450.00, 'Cash');

-- Select all customers
SELECT * FROM Customers;

-- Select all rooms
SELECT * FROM Rooms;

-- Select all reservations
SELECT * FROM Reservations;

-- Select all payments
SELECT * FROM Payments;

-- Get all reservations along with customer details
SELECT r.ReservationID, c.FirstName, c.LastName, r.CheckInDate, r.CheckOutDate, r.TotalAmount, r.Status
FROM Reservations r
JOIN Customers c ON r.CustomerID = c.CustomerID;

-- Get all reservations along with room details
SELECT r.ReservationID, rm.RoomNumber, rm.RoomType, r.CheckInDate, r.CheckOutDate, r.TotalAmount, r.Status
FROM Reservations r
JOIN Rooms rm ON r.RoomID = rm.RoomID;

-- Find available rooms
SELECT * FROM Rooms WHERE Status = 'Available';

-- Find occupied rooms
SELECT * FROM Rooms WHERE Status = 'Occupied';

-- Get total revenue from payments
SELECT SUM(Amount) AS TotalRevenue FROM Payments;

-- Get the number of reservations per customer
SELECT CustomerID, COUNT(*) AS TotalReservations FROM Reservations GROUP BY CustomerID;

-- Get reservations that are confirmed
SELECT * FROM Reservations WHERE Status = 'Confirmed';

-- Get the latest payments made
SELECT * FROM Payments ORDER BY PaymentDate DESC;

-- Get customers who have made at least one reservation
SELECT DISTINCT c.CustomerID, c.FirstName, c.LastName
FROM Customers c
JOIN Reservations r ON c.CustomerID = r.CustomerID;

-- Count total number of rooms per type
SELECT RoomType, COUNT(*) AS TotalRooms FROM Rooms GROUP BY RoomType;

-- Get reservation details along with payment status
SELECT r.ReservationID, c.FirstName, c.LastName, r.CheckInDate, r.CheckOutDate, r.TotalAmount, r.Status, 
       COALESCE(p.Amount, 0) AS PaidAmount, 
       CASE WHEN p.Amount IS NULL THEN 'Unpaid' ELSE 'Paid' END AS PaymentStatus
FROM Reservations r
LEFT JOIN Customers c ON r.CustomerID = c.CustomerID
LEFT JOIN Payments p ON r.ReservationID = p.ReservationID;

-- Find rooms that have never been reserved
SELECT * FROM Rooms WHERE RoomID NOT IN (SELECT DISTINCT RoomID FROM Reservations);

-- Get reservations with their duration (number of nights)
SELECT ReservationID, CustomerID, RoomID, CheckInDate, CheckOutDate, 
       (CheckOutDate - CheckInDate) AS NightsStayed
FROM Reservations;

-- Find top-paying customers
SELECT c.CustomerID, c.FirstName, c.LastName, SUM(p.Amount) AS TotalPaid
FROM Customers c
JOIN Reservations r ON c.CustomerID = r.CustomerID
JOIN Payments p ON r.ReservationID = p.ReservationID
GROUP BY c.CustomerID, c.FirstName, c.LastName
ORDER BY TotalPaid DESC LIMIT 5;

-- Get reservations made in the last 30 days
SELECT * FROM Reservations WHERE CreatedAt >= NOW() - INTERVAL '30 days';

-- Count total reservations by status
SELECT Status, COUNT(*) AS TotalReservations FROM Reservations GROUP BY Status;