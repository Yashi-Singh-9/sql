-- Project in PostgreSQL 
-- Create Database
CREATE DATABASE GlobalShippingDB;
-- Switch to the new database
\c GlobalShippingDB;

-- Shipping Companies
CREATE TABLE ShippingCompanies (
    CompanyID SERIAL PRIMARY KEY,
    CompanyName VARCHAR(100) NOT NULL,
    Country VARCHAR(50),
    ContactInfo VARCHAR(100)
);

-- Ships
CREATE TABLE Ships (
    ShipID SERIAL PRIMARY KEY,
    ShipName VARCHAR(100) NOT NULL,
    Capacity INT NOT NULL,
    CompanyID INT REFERENCES ShippingCompanies(CompanyID) ON DELETE SET NULL
);

-- Ports
CREATE TABLE Ports (
    PortID SERIAL PRIMARY KEY,
    PortName VARCHAR(100) NOT NULL,
    Country VARCHAR(50) NOT NULL
);

-- Shipments
CREATE TABLE Shipments (
    ShipmentID SERIAL PRIMARY KEY,
    ShipID INT REFERENCES Ships(ShipID) ON DELETE CASCADE,
    OriginPortID INT REFERENCES Ports(PortID) ON DELETE CASCADE,
    DestinationPortID INT REFERENCES Ports(PortID) ON DELETE CASCADE,
    DepartureDate DATE NOT NULL,
    ArrivalDate DATE NOT NULL,
    Status VARCHAR(50) CHECK (Status IN ('In Transit', 'Delivered', 'Delayed'))
);

-- Containers
CREATE TABLE Containers (
    ContainerID SERIAL PRIMARY KEY,
    ContainerType VARCHAR(50) NOT NULL,
    WeightLimit DECIMAL(10,2) NOT NULL,
    ShipID INT REFERENCES Ships(ShipID) ON DELETE SET NULL
);

-- Cargo
CREATE TABLE Cargo (
    CargoID SERIAL PRIMARY KEY,
    ContainerID INT REFERENCES Containers(ContainerID) ON DELETE CASCADE,
    ShipmentID INT REFERENCES Shipments(ShipmentID) ON DELETE CASCADE,
    Description TEXT NOT NULL,
    Weight DECIMAL(10,2) NOT NULL,
    Value DECIMAL(15,2) NOT NULL
);

-- Customers
CREATE TABLE Customers (
    CustomerID SERIAL PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(20),
    Address TEXT
);

-- Orders
CREATE TABLE Orders (
    OrderID SERIAL PRIMARY KEY,
    CustomerID INT REFERENCES Customers(CustomerID) ON DELETE CASCADE,
    ShipmentID INT REFERENCES Shipments(ShipmentID) ON DELETE CASCADE,
    OrderDate DATE NOT NULL,
    DeliveryDate DATE NOT NULL,
    OrderStatus VARCHAR(50) CHECK (OrderStatus IN ('Processing', 'Shipped', 'Delivered'))
);

-- Insert into Shipping Companies
INSERT INTO ShippingCompanies (CompanyName, Country, ContactInfo) VALUES
('Maersk Line', 'Denmark', 'contact@maersk.com'),
('MSC', 'Switzerland', 'contact@msc.com'),
('CMA CGM', 'France', 'contact@cmacgm.com'),
('Hapag-Lloyd', 'Germany', 'contact@hapag-lloyd.com');

-- Insert into Ships
INSERT INTO Ships (ShipName, Capacity, CompanyID) VALUES
('Ever Given', 20000, 1),
('MSC Zoe', 19000, 2),
('CMA CGM Marco Polo', 17000, 3),
('Hapag-Lloyd Tokyo Express', 15000, 4);

-- Insert into Ports
INSERT INTO Ports (PortName, Country) VALUES
('Port of Shanghai', 'China'),
('Port of Rotterdam', 'Netherlands'),
('Port of Singapore', 'Singapore'),
('Port of Los Angeles', 'USA');

-- Insert into Shipments
INSERT INTO Shipments (ShipID, OriginPortID, DestinationPortID, DepartureDate, ArrivalDate, Status) VALUES
(1, 1, 2, '2025-02-15', '2025-03-10', 'In Transit'),
(2, 2, 3, '2025-02-20', '2025-03-15', 'Delayed'),
(3, 3, 4, '2025-02-25', '2025-03-20', 'In Transit'),
(4, 4, 1, '2025-02-10', '2025-02-28', 'Delivered');

-- Insert into Containers
INSERT INTO Containers (ContainerType, WeightLimit, ShipID) VALUES
('Refrigerated', 20000.00, 1),
('Dry', 15000.00, 2),
('Hazardous', 18000.00, 3),
('Dry', 16000.00, 4);

-- Insert into Cargo
INSERT INTO Cargo (ContainerID, ShipmentID, Description, Weight, Value) VALUES
(1, 1, 'Frozen Fish', 18000.00, 500000.00),
(2, 2, 'Electronics', 14000.00, 750000.00),
(3, 3, 'Chemicals', 16000.00, 600000.00),
(4, 4, 'Clothing', 15000.00, 450000.00);

-- Insert into Customers
INSERT INTO Customers (CustomerName, Email, Phone, Address) VALUES
('John Doe', 'johndoe@email.com', '1234567890', 'New York, USA'),
('Alice Smith', 'alice@email.com', '0987654321', 'London, UK'),
('Carlos Mendes', 'carlos@email.com', '5551234567', 'São Paulo, Brazil'),
('Wei Zhang', 'wei@email.com', '8887776666', 'Beijing, China');

-- Insert into Orders
INSERT INTO Orders (CustomerID, ShipmentID, OrderDate, DeliveryDate, OrderStatus) VALUES
(1, 1, '2025-02-10', '2025-03-12', 'Processing'),
(2, 2, '2025-02-15', '2025-03-18', 'Shipped'),
(3, 3, '2025-02-20', '2025-03-22', 'Delivered'),
(4, 4, '2025-02-05', '2025-02-28', 'Delivered');

-- Find all shipments that are currently in transit
SELECT ShipmentID, ShipID, OriginPortID, DestinationPortID, DepartureDate, ArrivalDate
FROM Shipments
WHERE Status = 'In Transit';

-- List the total number of shipments made by each shipping company
SELECT sc.CompanyName, COUNT(s.ShipID) AS TotalShipments
FROM ShippingCompanies sc
JOIN Ships s ON sc.CompanyID = s.CompanyID
JOIN Shipments sh ON s.ShipID = sh.ShipID
GROUP BY sc.CompanyName;

-- Get the total weight of cargo per ship
SELECT s.ShipName, SUM(c.Weight) AS TotalCargoWeight
FROM Ships s
JOIN Shipments sh ON s.ShipID = sh.ShipID
JOIN Cargo c ON sh.ShipmentID = c.ShipmentID
GROUP BY s.ShipName;

-- Find the most frequently used shipping routes (OriginPort → DestinationPort)
SELECT p1.PortName AS OriginPort, p2.PortName AS DestinationPort, COUNT(*) AS RouteCount
FROM Shipments sh
JOIN Ports p1 ON sh.OriginPortID = p1.PortID
JOIN Ports p2 ON sh.DestinationPortID = p2.PortID
GROUP BY p1.PortName, p2.PortName
ORDER BY RouteCount DESC
LIMIT 5;

-- List all delayed shipments along with their expected arrival dates
SELECT ShipmentID, ShipID, OriginPortID, DestinationPortID, ArrivalDate 
FROM Shipments
WHERE Status = 'Delayed';

-- Retrieve the total revenue generated from cargo shipments based on cargo value
SELECT SUM(Value) AS TotalRevenue 
FROM Cargo;

-- Get the top 3 customers who have placed the most orders
SELECT c.CustomerName, COUNT(o.OrderID) AS TotalOrders
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerName
ORDER BY TotalOrders DESC
LIMIT 3;

-- Find all ships that are currently carrying hazardous cargo
SELECT DISTINCT s.ShipName
FROM Ships s
JOIN Containers c ON s.ShipID = c.ShipID
JOIN Cargo ca ON c.ContainerID = ca.ContainerID
WHERE c.ContainerType = 'Hazardous';

-- Get the total number of shipments handled by each port
SELECT p.PortName, COUNT(sh.ShipmentID) AS TotalShipments
FROM Ports p
LEFT JOIN Shipments sh ON p.PortID = sh.OriginPortID OR p.PortID = sh.DestinationPortID
GROUP BY p.PortName
ORDER BY TotalShipments DESC;

-- Find the busiest port in terms of shipments
SELECT p.PortName, COUNT(sh.ShipmentID) AS TotalShipments
FROM Ports p
JOIN Shipments sh ON p.PortID = sh.OriginPortID OR p.PortID = sh.DestinationPortID
GROUP BY p.PortName
ORDER BY TotalShipments DESC
LIMIT 1;

-- List all shipments that have not yet been delivered
SELECT ShipmentID, ShipID, OriginPortID, DestinationPortID, Status
FROM Shipments
WHERE Status <> 'Delivered';

-- Find the largest shipment in terms of total cargo weight
SELECT sh.ShipmentID, SUM(ca.Weight) AS TotalWeight
FROM Shipments sh
JOIN Cargo ca ON sh.ShipmentID = ca.ShipmentID
GROUP BY sh.ShipmentID
ORDER BY TotalWeight DESC
LIMIT 1;

-- Get the average weight of cargo per shipment
SELECT sh.ShipmentID, AVG(ca.Weight) AS AvgWeight
FROM Shipments sh
JOIN Cargo ca ON sh.ShipmentID = ca.ShipmentID
GROUP BY sh.ShipmentID;

-- Find the company with the highest number of active shipments
SELECT sc.CompanyName, COUNT(sh.ShipmentID) AS ActiveShipments
FROM ShippingCompanies sc
JOIN Ships s ON sc.CompanyID = s.CompanyID
JOIN Shipments sh ON s.ShipID = sh.ShipID
WHERE sh.Status = 'In Transit'
GROUP BY sc.CompanyName
ORDER BY ActiveShipments DESC
LIMIT 1;

-- List all cargo items with a value greater than $500,000
SELECT CargoID, Description, Value
FROM Cargo
WHERE Value > 500000;

-- Find the latest shipment departure date
SELECT MAX(DepartureDate) AS LatestDeparture
FROM Shipments;

-- Get the total number of orders by status
SELECT OrderStatus, COUNT(OrderID) AS TotalOrders
FROM Orders
GROUP BY OrderStatus;
