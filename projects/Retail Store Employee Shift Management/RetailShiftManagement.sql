-- Project In MariaDB 
-- Creating the database
CREATE DATABASE RetailShiftManagement;
USE RetailShiftManagement;

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(15),
    Position VARCHAR(50),
    Salary DECIMAL(10,2)
);

INSERT INTO Employees (FirstName, LastName, Email, Phone, Position, Salary) VALUES
('John', 'Doe', 'john.doe@email.com', '1234567890', 'Cashier', 35000.00),
('Emma', 'Smith', 'emma.smith@email.com', '2345678901', 'Manager', 60000.00),
('Liam', 'Brown', 'liam.brown@email.com', '3456789012', 'Sales Associate', 32000.00),
('Olivia', 'Johnson', 'olivia.johnson@email.com', '4567890123', 'Stock Clerk', 30000.00),
('Noah', 'Williams', 'noah.williams@email.com', '5678901234', 'Cashier', 34000.00);

CREATE TABLE Shifts (
    ShiftID INT PRIMARY KEY AUTO_INCREMENT,
    ShiftName VARCHAR(50),
    StartTime TIME,
    EndTime TIME
);

INSERT INTO Shifts (ShiftName, StartTime, EndTime) VALUES
('Morning Shift', '08:00:00', '16:00:00'),
('Evening Shift', '16:00:00', '00:00:00'),
('Night Shift', '00:00:00', '08:00:00'),
('Weekend Shift', '10:00:00', '18:00:00'),
('Part-Time Shift', '12:00:00', '18:00:00');

CREATE TABLE Store (
    StoreID INT PRIMARY KEY AUTO_INCREMENT,
    StoreName VARCHAR(100),
    Location VARCHAR(255)
);

INSERT INTO Store (StoreName, Location) VALUES
('Downtown Mart', '123 Main Street'),
('Westside Plaza', '456 West Avenue'),
('Eastview Store', '789 East Road'),
('Central Market', '101 Central Blvd'),
('Suburb Superstore', '202 Suburb Lane');

CREATE TABLE Employee_Shifts (
    EmployeeShiftID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeID INT,
    ShiftID INT,
    ShiftDate DATE,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (ShiftID) REFERENCES Shifts(ShiftID)
);

INSERT INTO Employee_Shifts (EmployeeID, ShiftID, ShiftDate) VALUES
(1, 1, '2024-02-01'),
(2, 2, '2024-02-01'),
(3, 3, '2024-02-02'),
(4, 4, '2024-02-03'),
(5, 5, '2024-02-04');

CREATE TABLE Employee_Store (
    EmployeeStoreID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeID INT,
    StoreID INT,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (StoreID) REFERENCES Store(StoreID)
);

INSERT INTO Employee_Store (EmployeeID, StoreID) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

CREATE TABLE Attendance (
    AttendanceID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeID INT,
    ShiftID INT,
    Date DATE,
    CheckInTime DATETIME,
    CheckOutTime DATETIME,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (ShiftID) REFERENCES Shifts(ShiftID)
);

INSERT INTO Attendance (EmployeeID, ShiftID, Date, CheckInTime, CheckOutTime) VALUES
(1, 1, '2024-02-01', '2024-02-01 08:00:00', '2024-02-01 16:00:00'),
(2, 2, '2024-02-01', '2024-02-01 16:00:00', '2024-02-01 00:00:00'),
(3, 3, '2024-02-02', '2024-02-02 00:00:00', '2024-02-02 08:00:00'),
(4, 4, '2024-02-03', '2024-02-03 10:00:00', '2024-02-03 18:00:00'),
(5, 5, '2024-02-04', '2024-02-04 12:00:00', '2024-02-04 18:00:00');

-- Retrieve all employees who have worked on a specific shift
SELECT e.EmployeeID, e.FirstName, e.LastName, s.ShiftName
FROM Employees e
JOIN Attendance a ON e.EmployeeID = a.EmployeeID
JOIN Shifts s ON a.ShiftID = s.ShiftID
WHERE s.ShiftName = 'Morning Shift';

-- Find the total number of shifts an employee has worked in a given month
SELECT e.EmployeeID, e.FirstName, e.LastName, COUNT(a.ShiftID) AS TotalShifts
FROM Employees e
JOIN Attendance a ON e.EmployeeID = a.EmployeeID
WHERE MONTH(a.Date) = 2 AND YEAR(a.Date) = 2024
GROUP BY e.EmployeeID;

-- List all employees who are assigned to a specific store
SELECT e.EmployeeID, e.FirstName, e.LastName, s.StoreName
FROM Employees e
JOIN Employee_Store es ON e.EmployeeID = es.EmployeeID
JOIN Store s ON es.StoreID = s.StoreID
WHERE s.StoreName = 'Downtown Mart';

-- Get the total working hours for each employee in a given time range
SELECT e.EmployeeID, e.FirstName, e.LastName, 
       SUM(TIMESTAMPDIFF(HOUR, a.CheckInTime, a.CheckOutTime)) AS TotalHours
FROM Employees e
JOIN Attendance a ON e.EmployeeID = a.EmployeeID
WHERE a.Date BETWEEN '2024-02-01' AND '2024-02-28'
GROUP BY e.EmployeeID;

-- List stores with the most employees assigned
SELECT s.StoreName, COUNT(es.EmployeeID) AS EmployeeCount
FROM Store s
JOIN Employee_Store es ON s.StoreID = es.StoreID
GROUP BY s.StoreID
ORDER BY EmployeeCount DESC
LIMIT 5;

-- Get the most common shift worked by employees
SELECT s.ShiftName, COUNT(a.ShiftID) AS ShiftCount
FROM Shifts s
JOIN Attendance a ON s.ShiftID = a.ShiftID
GROUP BY s.ShiftID
ORDER BY ShiftCount DESC
LIMIT 1;

-- Retrieve all employees who worked overtime (more than 6 hours per shift)
SELECT e.EmployeeID, e.FirstName, e.LastName, a.Date, 
       TIMESTAMPDIFF(HOUR, a.CheckInTime, a.CheckOutTime) AS HoursWorked
FROM Employees e
JOIN Attendance a ON e.EmployeeID = a.EmployeeID
WHERE TIMESTAMPDIFF(HOUR, a.CheckInTime, a.CheckOutTime) > 6;

-- Find employees who have worked the most shifts
SELECT e.EmployeeID, e.FirstName, e.LastName, COUNT(a.ShiftID) AS TotalShifts
FROM Employees e
JOIN Attendance a ON e.EmployeeID = a.EmployeeID
GROUP BY e.EmployeeID
ORDER BY TotalShifts DESC
LIMIT 3;
