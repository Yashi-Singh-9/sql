-- Project In MariaDB 
-- Create Database
CREATE DATABASE SupplyChainDB;
USE SupplyChainDB;

-- Create Suppliers Table
CREATE TABLE Suppliers (
    SupplierID INT AUTO_INCREMENT PRIMARY KEY,
    SupplierName VARCHAR(255) NOT NULL,
    ContactName VARCHAR(255),
    Phone VARCHAR(20),
    Email VARCHAR(255),
    Address TEXT
);

-- Create Products Table
CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(255) NOT NULL,
    SupplierID INT,
    Price DECIMAL(10,2),
    StockQuantity INT,
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID) ON DELETE SET NULL
);

-- Create Orders Table
CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    ProductID INT,
    Quantity INT NOT NULL,
    OrderDate DATE,
    Status ENUM('Pending', 'Shipped', 'Delivered', 'Cancelled') DEFAULT 'Pending',
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID) ON DELETE CASCADE
);

-- Insert Data into Suppliers
INSERT INTO Suppliers (SupplierName, ContactName, Phone, Email, Address) VALUES
('Global Supplies Ltd.', 'John Doe', '+1234567890', 'john@globalsupplies.com', '123 Supply St, NY'),
('Tech Distributors', 'Jane Smith', '+9876543210', 'jane@techdistro.com', '456 Warehouse Ave, CA'),
('Food & Goods Co.', 'Michael Brown', '+1122334455', 'michael@foodgoods.com', '789 Market Rd, TX'),
('Industrial Needs Inc.', 'Sarah White', '+9988776655', 'sarah@industrialneeds.com', '101 Factory Ln, FL');

-- Insert Data into Products
INSERT INTO Products (ProductName, SupplierID, Price, StockQuantity) VALUES
('Laptop', 2, 1200.00, 50),
('Smartphone', 2, 800.00, 100),
('Rice Bag (50kg)', 3, 50.00, 200),
('Industrial Drill', 4, 300.00, 30);

-- Insert Data into Orders
INSERT INTO Orders (ProductID, Quantity, OrderDate, Status) VALUES
(1, 5, '2024-02-25', 'Shipped'),
(2, 10, '2024-02-26', 'Pending'),
(3, 20, '2024-02-27', 'Delivered'),
(4, 2, '2024-02-28', 'Cancelled');

-- Retrieve all suppliers and their products
SELECT s.SupplierName, p.ProductName, p.Price, p.StockQuantity 
FROM Suppliers s 
JOIN Products p ON s.SupplierID = p.SupplierID;

-- Check stock availability for all products
SELECT ProductName, StockQuantity 
FROM Products 
ORDER BY StockQuantity DESC;

-- Retrieve all pending orders
SELECT * FROM Orders WHERE Status = 'Pending';

-- Find the total number of orders placed per product
SELECT p.ProductName, COUNT(o.OrderID) AS TotalOrders 
FROM Orders o 
JOIN Products p ON o.ProductID = p.ProductID 
GROUP BY p.ProductName;

-- Get supplier details for a specific product (e.g., 'Laptop')
SELECT s.SupplierName, s.ContactName, s.Phone, s.Email 
FROM Suppliers s 
JOIN Products p ON s.SupplierID = p.SupplierID 
WHERE p.ProductName = 'Laptop';

-- List all products along with their supplier details
SELECT p.ProductName, s.SupplierName, s.ContactName, s.Phone, s.Email 
FROM Products p
JOIN Suppliers s ON p.SupplierID = s.SupplierID;

-- Find the most expensive product
SELECT ProductName, Price 
FROM Products 
ORDER BY Price DESC 
LIMIT 1;

-- Find the cheapest product
SELECT ProductName, Price 
FROM Products 
ORDER BY Price ASC 
LIMIT 1;

-- Get the total stock value of all products
SELECT SUM(StockQuantity * Price) AS TotalStockValue 
FROM Products;

-- Get the total number of orders placed per supplier
SELECT s.SupplierName, COUNT(o.OrderID) AS TotalOrders 
FROM Orders o
JOIN Products p ON o.ProductID = p.ProductID
JOIN Suppliers s ON p.SupplierID = s.SupplierID
GROUP BY s.SupplierName;

-- Find the most frequently ordered product
SELECT p.ProductName, COUNT(o.OrderID) AS OrderCount 
FROM Orders o
JOIN Products p ON o.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY OrderCount DESC
LIMIT 1;

-- Check which products have low stock (less than 100 items left)
SELECT ProductName, StockQuantity 
FROM Products 
WHERE StockQuantity < 100;

-- Get all delivered orders with product details
SELECT o.OrderID, p.ProductName, o.Quantity, o.OrderDate 
FROM Orders o
JOIN Products p ON o.ProductID = p.ProductID
WHERE o.Status = 'Delivered';

-- Calculate the total revenue from all orders
SELECT SUM(o.Quantity * p.Price) AS TotalRevenue 
FROM Orders o
JOIN Products p ON o.ProductID = p.ProductID;

-- Find the supplier with the most products
SELECT s.SupplierName, COUNT(p.ProductID) AS ProductCount 
FROM Suppliers s
JOIN Products p ON s.SupplierID = p.SupplierID
GROUP BY s.SupplierName
ORDER BY ProductCount DESC
LIMIT 1;

-- Find the month with the highest number of orders
SELECT MONTH(OrderDate) AS Month, COUNT(OrderID) AS TotalOrders 
FROM Orders
GROUP BY MONTH(OrderDate)
ORDER BY TotalOrders DESC
LIMIT 1;

-- Find the order with the highest quantity
SELECT OrderID, ProductID, Quantity 
FROM Orders 
ORDER BY Quantity DESC 
LIMIT 1;

-- Get pending orders along with supplier details
SELECT o.OrderID, p.ProductName, s.SupplierName, o.Quantity, o.OrderDate
FROM Orders o
JOIN Products p ON o.ProductID = p.ProductID
JOIN Suppliers s ON p.SupplierID = s.SupplierID
WHERE o.Status = 'Pending';
