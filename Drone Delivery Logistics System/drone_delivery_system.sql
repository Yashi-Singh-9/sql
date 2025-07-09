-- MS SQL Project 
-- Create Database
CREATE DATABASE drone_delivery_system;
USE drone_delivery_system;

-- Drones
CREATE TABLE Drones (
    DroneID INT PRIMARY KEY IDENTITY,
    DroneModel VARCHAR(100),
    MaxWeight DECIMAL(6,2),
    BatteryLevel INT, -- in percentage
    Status VARCHAR(50), -- e.g., Available, In Transit, Maintenance
    LastServiceDate DATE
);

-- Pilots
CREATE TABLE Pilots (
    PilotID INT PRIMARY KEY IDENTITY,
    FullName VARCHAR(100),
    LicenseNumber VARCHAR(50) UNIQUE,
    ContactNumber VARCHAR(20),
    CertifiedSince DATE
);

-- Packages
CREATE TABLE Packages (
    PackageID INT PRIMARY KEY IDENTITY,
    Weight DECIMAL(6,2),
    Description VARCHAR(255),
    DestinationAddress VARCHAR(255),
    Status VARCHAR(50) -- e.g., Pending, Dispatched, Delivered
);

-- Delivery Routes
CREATE TABLE Routes (
    RouteID INT PRIMARY KEY IDENTITY,
    Origin VARCHAR(100),
    Destination VARCHAR(100),
    DistanceKm DECIMAL(6,2),
    EstimatedTimeMinutes INT
);

-- Deliveries
CREATE TABLE Deliveries (
    DeliveryID INT PRIMARY KEY IDENTITY,
    DroneID INT FOREIGN KEY REFERENCES Drones(DroneID),
    PackageID INT FOREIGN KEY REFERENCES Packages(PackageID),
    PilotID INT FOREIGN KEY REFERENCES Pilots(PilotID),
    RouteID INT FOREIGN KEY REFERENCES Routes(RouteID),
    DepartureTime DATETIME,
    ArrivalTime DATETIME,
    DeliveryStatus VARCHAR(50) -- e.g., Scheduled, In Progress, Completed
);

-- Drones
INSERT INTO Drones (DroneModel, MaxWeight, BatteryLevel, Status, LastServiceDate) VALUES
('DJI Mavic Pro', 5.00, 100, 'Available', '2024-12-01'),
('Autel Evo II', 6.50, 85, 'Maintenance', '2025-01-20'),
('Parrot Anafi', 3.50, 75, 'In Transit', '2025-03-10');

-- Pilots
INSERT INTO Pilots (FullName, LicenseNumber, ContactNumber, CertifiedSince) VALUES
('Alice Grant', 'DRONE1234', '555-1010', '2020-05-15'),
('Tom Watson', 'DRONE5678', '555-2020', '2021-09-10');

-- Packages
INSERT INTO Packages (Weight, Description, DestinationAddress, Status) VALUES
(2.50, 'Electronics - Tablet', '123 River Rd', 'Pending'),
(4.20, 'Books & Supplies', '88 Oak St', 'Dispatched'),
(1.80, 'Medical Kit', '42 Pine Ln', 'Delivered');

-- Routes
INSERT INTO Routes (Origin, Destination, DistanceKm, EstimatedTimeMinutes) VALUES
('Warehouse A', '123 River Rd', 12.5, 15),
('Warehouse A', '88 Oak St', 18.0, 22),
('Warehouse B', '42 Pine Ln', 10.2, 12);

-- Deliveries
INSERT INTO Deliveries (DroneID, PackageID, PilotID, RouteID, DepartureTime, ArrivalTime, DeliveryStatus) VALUES
(1, 1, 1, 1, '2025-04-09 10:00:00', NULL, 'Scheduled'),
(3, 2, 2, 2, '2025-04-08 14:30:00', '2025-04-08 14:55:00', 'Completed');

-- List all drones currently available
SELECT * 
FROM Drones 
WHERE Status = 'Available';

-- Check deliveries in progress or scheduled
SELECT d.DeliveryID, p.Description, d.DeliveryStatus
FROM Deliveries d
JOIN Packages p ON d.PackageID = p.PackageID
WHERE d.DeliveryStatus IN ('Scheduled', 'In Progress');

-- Calculate average delivery time per route
SELECT r.RouteID, r.Origin, r.Destination,
       AVG(DATEDIFF(MINUTE, d.DepartureTime, d.ArrivalTime)) AS AvgTimeMinutes
FROM Deliveries d
JOIN Routes r ON d.RouteID = r.RouteID
WHERE d.ArrivalTime IS NOT NULL
GROUP BY r.RouteID, r.Origin, r.Destination;

-- Pilot Delivery Summary (Total Deliveries Per Pilot)
SELECT pl.FullName, COUNT(d.DeliveryID) AS TotalDeliveries
FROM Deliveries d
JOIN Pilots pl ON d.PilotID = pl.PilotID
GROUP BY pl.FullName
ORDER BY TotalDeliveries DESC;

-- Drone Utilization (Total Deliveries by Drone)
SELECT dr.DroneModel, COUNT(d.DeliveryID) AS DeliveryCount
FROM Deliveries d
JOIN Drones dr ON d.DroneID = dr.DroneID
GROUP BY dr.DroneModel
ORDER BY DeliveryCount DESC;

-- Route Efficiency Comparison
SELECT 
    r.Origin,
    r.Destination,
    r.EstimatedTimeMinutes,
    AVG(DATEDIFF(MINUTE, d.DepartureTime, d.ArrivalTime)) AS AvgActualTime,
    (AVG(DATEDIFF(MINUTE, d.DepartureTime, d.ArrivalTime)) - r.EstimatedTimeMinutes) AS TimeVariance
FROM Deliveries d
JOIN Routes r ON d.RouteID = r.RouteID
WHERE d.ArrivalTime IS NOT NULL
GROUP BY r.Origin, r.Destination, r.EstimatedTimeMinutes;

-- Delivery History of a Specific Drone
SELECT d.DeliveryID, p.Description, d.DeliveryStatus, d.DepartureTime, d.ArrivalTime
FROM Deliveries d
JOIN Packages p ON d.PackageID = p.PackageID
WHERE d.DroneID = 1 
ORDER BY d.DepartureTime DESC;

-- Detailed Delivery Log
SELECT 
    d.DeliveryID,
    dr.DroneModel,
    p.Description AS Package,
    pl.FullName AS Pilot,
    r.Origin,
    r.Destination,
    d.DepartureTime,
    d.ArrivalTime,
    d.DeliveryStatus
FROM Deliveries d
JOIN Drones dr ON d.DroneID = dr.DroneID
JOIN Packages p ON d.PackageID = p.PackageID
JOIN Pilots pl ON d.PilotID = pl.PilotID
JOIN Routes r ON d.RouteID = r.RouteID
ORDER BY d.DepartureTime DESC;
