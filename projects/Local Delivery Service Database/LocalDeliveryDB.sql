-- Project in PostgreSQL 
-- Create Database
CREATE DATABASE LocalDeliveryDB;
\c LocalDeliveryDB;

CREATE TABLE Customers (
    CustomerID SERIAL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Phone VARCHAR(15) UNIQUE NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Address TEXT NOT NULL
);

CREATE TABLE DeliveryAgents (
    AgentID SERIAL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Phone VARCHAR(15) UNIQUE NOT NULL,
    VehicleType VARCHAR(50) NOT NULL,
    LicenseNumber VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE Orders (
    OrderID SERIAL PRIMARY KEY,
    CustomerID INT NOT NULL,
    AgentID INT NULL, 
    OrderDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    DeliveryDate TIMESTAMP NULL,
    Status VARCHAR(50) CHECK (Status IN ('Pending', 'In Transit', 'Delivered', 'Cancelled')) NOT NULL,
    TotalAmount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE,
    FOREIGN KEY (AgentID) REFERENCES DeliveryAgents(AgentID) ON DELETE SET NULL
);

CREATE TABLE OrderItems (
    ItemID SERIAL PRIMARY KEY,
    OrderID INT NOT NULL,
    ItemName VARCHAR(100) NOT NULL,
    Quantity INT CHECK (Quantity > 0) NOT NULL,
    Price DECIMAL(10,2) CHECK (Price > 0) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE
);

CREATE TABLE Payments (
    PaymentID SERIAL PRIMARY KEY,
    OrderID INT NOT NULL,
    PaymentDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Amount DECIMAL(10,2) NOT NULL,
    PaymentMethod VARCHAR(50) CHECK (PaymentMethod IN ('Cash', 'Card', 'Online')) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE
);

CREATE TABLE DeliveryTracking (
    TrackingID SERIAL PRIMARY KEY,
    OrderID INT NOT NULL,
    AgentID INT NOT NULL,
    CurrentLocation VARCHAR(255) NOT NULL,
    StatusUpdateTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Status VARCHAR(50) CHECK (Status IN ('Picked Up', 'In Transit', 'Out for Delivery', 'Delivered')) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE,
    FOREIGN KEY (AgentID) REFERENCES DeliveryAgents(AgentID) ON DELETE CASCADE
);

INSERT INTO Customers (Name, Phone, Email, Address) VALUES
('Alice Johnson', '1234567890', 'alice@example.com', '123 Maple St, NY'),
('Bob Smith', '2345678901', 'bob@example.com', '456 Oak St, CA'),
('Charlie Brown', '3456789012', 'charlie@example.com', '789 Pine St, TX'),
('David Wilson', '4567890123', 'david@example.com', '321 Elm St, FL'),
('Emma Davis', '5678901234', 'emma@example.com', '654 Birch St, WA');

INSERT INTO DeliveryAgents (Name, Phone, VehicleType, LicenseNumber) VALUES
('John Rider', '9876543210', 'Bike', 'LIC12345'),
('Sophia Walker', '8765432109', 'Scooter', 'LIC23456'),
('Michael Speed', '7654321098', 'Car', 'LIC34567'),
('Olivia Dash', '6543210987', 'Van', 'LIC45678'),
('James Drive', '5432109876', 'Bike', 'LIC56789');

INSERT INTO Orders (CustomerID, AgentID, Status, TotalAmount) VALUES
(1, 1, 'Pending', 49.99),
(2, 2, 'In Transit', 89.50),
(3, NULL, 'Pending', 29.99),
(4, 3, 'Delivered', 120.00),
(5, 4, 'In Transit', 60.75);

INSERT INTO OrderItems (OrderID, ItemName, Quantity, Price) VALUES
(1, 'Laptop Bag', 1, 49.99),
(2, 'Headphones', 2, 44.75),
(2, 'Phone Charger', 1, 15.00),
(4, 'Office Chair', 1, 120.00),
(5, 'Books', 3, 20.25);

INSERT INTO Payments (OrderID, Amount, PaymentMethod) VALUES
(1, 49.99, 'Card'),
(2, 89.50, 'Online'),
(4, 120.00, 'Cash'),
(5, 60.75, 'Card'),
(3, 29.99, 'Online');

INSERT INTO DeliveryTracking (OrderID, AgentID, CurrentLocation, Status) VALUES
(1, 1, 'Warehouse', 'Picked Up'),
(2, 2, 'City Center', 'In Transit'),
(4, 3, 'Customer Address', 'Delivered'),
(5, 4, 'Highway Exit 7', 'In Transit'),
(2, 2, 'Near Customer Location', 'Out for Delivery');

-- Get all orders placed by Alice Johnson
SELECT Orders.OrderID, Orders.OrderDate, Orders.Status, Orders.TotalAmount
FROM Orders
JOIN Customers ON Orders.CustomerID = Customers.CustomerID
WHERE Customers.Name = 'Alice Johnson';

-- Count of completed (Delivered) orders per delivery agent
SELECT DeliveryAgents.Name AS AgentName, COUNT(Orders.OrderID) AS TotalDeliveries
FROM Orders
JOIN DeliveryAgents ON Orders.AgentID = DeliveryAgents.AgentID
WHERE Orders.Status = 'Delivered'
GROUP BY DeliveryAgents.Name;

-- Get pending orders with customer names and contact details
SELECT Orders.OrderID, Customers.Name AS CustomerName, Customers.Phone, Orders.TotalAmount
FROM Orders
JOIN Customers ON Orders.CustomerID = Customers.CustomerID
WHERE Orders.Status = 'Pending';

-- Calculate total revenue from delivered orders
SELECT SUM(TotalAmount) AS TotalRevenue
FROM Orders
WHERE Status = 'Delivered';

-- Get top 5 customers based on number of orders placed
SELECT Customers.Name AS CustomerName, COUNT(Orders.OrderID) AS TotalOrders
FROM Orders
JOIN Customers ON Orders.CustomerID = Customers.CustomerID
GROUP BY Customers.Name
ORDER BY TotalOrders DESC
LIMIT 5;

-- Get assigned but undelivered orders
SELECT Orders.OrderID, Customers.Name AS CustomerName, DeliveryAgents.Name AS AgentName, Orders.Status
FROM Orders
JOIN Customers ON Orders.CustomerID = Customers.CustomerID
JOIN DeliveryAgents ON Orders.AgentID = DeliveryAgents.AgentID
WHERE Orders.Status IN ('Pending', 'In Transit');

-- Agents with no completed (Delivered) orders
SELECT DeliveryAgents.Name AS AgentName
FROM DeliveryAgents
LEFT JOIN Orders ON DeliveryAgents.AgentID = Orders.AgentID AND Orders.Status = 'Delivered'
WHERE Orders.OrderID IS NULL;

-- Get orders with payment details
SELECT Orders.OrderID, Customers.Name AS CustomerName, Payments.Amount, Payments.PaymentMethod, Payments.PaymentDate
FROM Orders
JOIN Customers ON Orders.CustomerID = Customers.CustomerID
JOIN Payments ON Orders.OrderID = Payments.OrderID;

-- Calculate average time difference between order and delivery
SELECT AVG(EXTRACT(EPOCH FROM (DeliveryDate - OrderDate)) / 3600) AS AvgDeliveryTime_Hours
FROM Orders
WHERE Status = 'Delivered' AND DeliveryDate IS NOT NULL;
