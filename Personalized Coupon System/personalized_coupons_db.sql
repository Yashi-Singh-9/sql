-- Project In MariaDB 
-- Creating the database
CREATE DATABASE personalized_coupons_db;
USE personalized_coupons_db;

CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15) UNIQUE,
    registration_date DATETIME DEFAULT NOW()
);

CREATE TABLE Coupons (
    coupon_id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(50) UNIQUE,
    discount_percentage DECIMAL(5,2),
    expiry_date DATETIME,
    minimum_order_value DECIMAL(10,2),
    status ENUM('active', 'expired', 'used') DEFAULT 'active'
);

CREATE TABLE User_Coupons (
    user_coupon_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    coupon_id INT,
    assigned_date DATETIME DEFAULT NOW(),
    used_date DATETIME NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (coupon_id) REFERENCES Coupons(coupon_id) ON DELETE CASCADE
);

CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    total_amount DECIMAL(10,2),
    order_date DATETIME DEFAULT NOW(),
    coupon_id INT NULL,
    final_amount DECIMAL(10,2),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (coupon_id) REFERENCES Coupons(coupon_id) ON DELETE SET NULL
);

CREATE TABLE Coupon_Redemption (
    redemption_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    coupon_id INT,
    order_id INT,
    redemption_date DATETIME DEFAULT NOW(),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (coupon_id) REFERENCES Coupons(coupon_id) ON DELETE CASCADE,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE
);

-- Insert Users
INSERT INTO Users (name, email, phone, registration_date) VALUES
('Alice Smith', 'alice@example.com', '1234567890', NOW()),
('Bob Johnson', 'bob@example.com', '1234567891', NOW()),
('Charlie Brown', 'charlie@example.com', '1234567892', NOW()),
('David Williams', 'david@example.com', '1234567893', NOW()),
('Eve Adams', 'eve@example.com', '1234567894', NOW());

-- Insert Coupons
INSERT INTO Coupons (code, discount_percentage, expiry_date, minimum_order_value, status) VALUES
('DISCOUNT10', 10.00, '2025-12-31', 50.00, 'active'),
('SAVE20', 20.00, '2025-10-15', 100.00, 'active'),
('OFF30', 30.00, '2024-06-01', 200.00, 'expired'),
('BIGSALE50', 50.00, '2025-05-20', 300.00, 'active'),
('WELCOME5', 5.00, '2026-01-01', 20.00, 'active');

-- Insert User_Coupons 
INSERT INTO User_Coupons (user_id, coupon_id, assigned_date) VALUES
(1, 1, NOW()),
(2, 2, NOW()),
(3, 3, NOW()),
(4, 1, NOW()),
(5, 2, NOW());

-- Insert Orders 
INSERT INTO Orders (user_id, total_amount, order_date, coupon_id, final_amount) VALUES
(1, 120.00, NOW(), 2, 96.00),
(2, 210.00, NOW(), 3, 147.00),
(3, 75.00, NOW(), 5, 71.25),
(4, 330.00, NOW(), 4, 165.00),
(5, 95.00, NOW(), NULL, 95.00);

-- Insert Coupon_Redemption 
INSERT INTO Coupon_Redemption (user_id, coupon_id, order_id, redemption_date) VALUES
(1, 2, 1, NOW()),
(2, 3, 2, NOW()),
(3, 5, 3, NOW()),
(4, 4, 4, NOW()),
(1, 2, 1, NOW());  

-- View all users and their assigned coupons
SELECT u.name, c.code, uc.assigned_date
FROM Users u
JOIN User_Coupons uc ON u.user_id = uc.user_id
JOIN Coupons c ON uc.coupon_id = c.coupon_id;

-- Find the most used coupon
SELECT c.code, COUNT(cr.coupon_id) AS usage_count
FROM Coupon_Redemption cr
JOIN Coupons c ON cr.coupon_id = c.coupon_id
GROUP BY cr.coupon_id
ORDER BY usage_count DESC
LIMIT 1;

-- Get orders with coupons applied
SELECT o.order_id, u.name, c.code, o.total_amount, o.final_amount
FROM Orders o
LEFT JOIN Users u ON o.user_id = u.user_id
LEFT JOIN Coupons c ON o.coupon_id = c.coupon_id;

-- Find users who have never used a coupon
SELECT u.name
FROM Users u
LEFT JOIN Coupon_Redemption cr ON u.user_id = cr.user_id
WHERE cr.user_id IS NULL;

-- Retrieve all active coupons assigned to a specific user
SELECT u.name, c.code, uc.assigned_date 
FROM Users u
JOIN User_Coupons uc ON u.user_id = uc.user_id
JOIN Coupons c ON uc.coupon_id = c.coupon_id
WHERE u.user_id = 1 AND c.status = 'active';

-- Retrieve total discount given per user
SELECT u.name, SUM(o.total_amount - o.final_amount) AS total_discount
FROM Orders o
JOIN Users u ON o.user_id = u.user_id
WHERE o.coupon_id IS NOT NULL
GROUP BY o.user_id;

-- List users who have used a coupon more than once
SELECT u.name, c.code, COUNT(cr.coupon_id) AS times_used
FROM Coupon_Redemption cr
JOIN Users u ON cr.user_id = u.user_id
JOIN Coupons c ON cr.coupon_id = c.coupon_id
GROUP BY cr.user_id, cr.coupon_id
HAVING COUNT(cr.coupon_id) > 1;

-- Retrieve all orders where a coupon was applied
SELECT o.order_id, u.name, c.code, o.total_amount, o.final_amount
FROM Orders o
JOIN Users u ON o.user_id = u.user_id
LEFT JOIN Coupons c ON o.coupon_id = c.coupon_id
WHERE o.coupon_id IS NOT NULL;

-- Find the top 3 users who saved the most money using coupons
SELECT u.name, SUM(o.total_amount - o.final_amount) AS total_savings
FROM Orders o
JOIN Users u ON o.user_id = u.user_id
WHERE o.coupon_id IS NOT NULL
GROUP BY o.user_id
ORDER BY total_savings DESC
LIMIT 3;

-- Count how many coupons were assigned but never redeemed
SELECT COUNT(*) AS unredeemed_coupons 
FROM User_Coupons uc
LEFT JOIN Coupon_Redemption cr ON uc.user_id = cr.user_id AND uc.coupon_id = cr.coupon_id
WHERE cr.coupon_id IS NULL;

-- Find the user who placed the most orders
SELECT u.name, COUNT(o.order_id) AS total_orders
FROM Orders o
JOIN Users u ON o.user_id = u.user_id
GROUP BY o.user_id
ORDER BY total_orders DESC
LIMIT 1;

-- Find the total revenue lost due to coupons
SELECT SUM(o.total_amount - o.final_amount) AS total_discount_given 
FROM Orders o
WHERE o.coupon_id IS NOT NULL;

-- Get the most frequently assigned coupon
SELECT c.code, COUNT(uc.coupon_id) AS times_assigned
FROM User_Coupons uc
JOIN Coupons c ON uc.coupon_id = c.coupon_id
GROUP BY uc.coupon_id
ORDER BY times_assigned DESC
LIMIT 1;

-- List all orders where a discount was applied, along with discount percentage
SELECT o.order_id, u.name, c.code, c.discount_percentage, o.total_amount, o.final_amount
FROM Orders o
JOIN Users u ON o.user_id = u.user_id
JOIN Coupons c ON o.coupon_id = c.coupon_id
WHERE o.coupon_id IS NOT NULL;

-- Find users who have more than one unused coupon
SELECT u.name, COUNT(uc.coupon_id) AS unused_coupons
FROM Users u
JOIN User_Coupons uc ON u.user_id = uc.user_id
LEFT JOIN Coupon_Redemption cr ON uc.user_id = cr.user_id AND uc.coupon_id = cr.coupon_id
WHERE cr.coupon_id IS NULL
GROUP BY u.user_id
HAVING COUNT(uc.coupon_id) > 1;
