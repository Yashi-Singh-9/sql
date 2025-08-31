-- MS SQL Project
CREATE DATABASE FoodDeliveryDatabase;
USE FoodDeliveryDatabase;

-- Customers Table  
CREATE TABLE customers (
  customer_id INT IDENTITY(1,1) PRIMARY KEY,
  first_name VARCHAR(20),
  last_name VARCHAR(20),
  email VARCHAR(50) UNIQUE,
  phone_number BIGINT,
  address TEXT
);

-- Restaurants Table 
CREATE TABLE restaurants (
  restaurant_id INT IDENTITY(1,1) PRIMARY KEY,
  restaurant_name VARCHAR(20),
  location VARCHAR(20),
  contact_number BIGINT,
  cuisine_type VARCHAR(20)
);

-- Food Items Table 
CREATE TABLE food_items (
  food_item_id INT IDENTITY(1,1) PRIMARY KEY,
  restaurant_id INT,
  food_name VARCHAR(20),
  price DECIMAL(5,2),
  category VARCHAR(15) CHECK (category IN ('appetizer', 'main course', 'dessert')),
  FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id)
);

-- Orders Table 
CREATE TABLE orders (
  order_id INT IDENTITY(1,1) PRIMARY KEY,
  customer_id INT,
  order_date DATE,
  total_amount DECIMAL(5, 2),
  order_status VARCHAR(15) CHECK (order_status IN ('Pending', 'Completed', 'Canceled')), 
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Order Items Table 
CREATE TABLE order_items (
  order_item_id INT IDENTITY(1,1) PRIMARY KEY,
  order_id INT,
  food_item_id INT,
  quantity INT,
  FOREIGN KEY (order_id) REFERENCES orders(order_id),
  FOREIGN KEY (food_item_id) REFERENCES food_items(food_item_id)
);

-- Delivery Personnel Table 
CREATE TABLE delivery_personnel (
  delivery_id INT IDENTITY(1,1) PRIMARY KEY,
  first_name VARCHAR(20),
  last_name VARCHAR(20),
  phone_number BIGINT,
  vehicle_type VARCHAR(15) CHECK (vehicle_type IN ('Bus', 'Car', 'Biscycle', 'Bike'))
);

-- Deliveries Table  
CREATE TABLE deliveries (
  delivery_id INT IDENTITY(1,1) PRIMARY KEY,
  order_id INT,
  delivery_status VARCHAR(10) CHECK (delivery_status IN ('In Transit', 'Delivered')),
  delivery_time TIME,
  FOREIGN KEY (delivery_id) REFERENCES deliveries(delivery_id),
  FOREIGN KEY (order_id) REFERENCES orders (order_id)
);

-- Payments Table 
CREATE TABLE payments (
  payment_id INT IDENTITY(1,1) PRIMARY KEY,
  order_id INT,
  payment_date DATE,
  payment_method VARCHAR(15) CHECK (payment_method IN ('Debit Card', 'Credit Card', 'Cash')),
  payment_status VARCHAR(15) CHECK (payment_status IN ('Pending', 'Completed')),
  FOREIGN KEY (order_id) REFERENCES orders (order_id)
);  

-- Insert into Customers Table
INSERT INTO customers (first_name, last_name, email, phone_number, address) VALUES
('John', 'Doe', 'john.doe@email.com', 9876543210, '123 Elm Street'),
('Jane', 'Smith', 'jane.smith@email.com', 8765432109, '456 Oak Avenue'),
('Alice', 'Johnson', 'alice.j@email.com', 7654321098, '789 Pine Road'),
('Bob', 'Brown', 'bob.brown@email.com', 6543210987, '321 Maple Lane'),
('Charlie', 'Davis', 'charlie.d@email.com', 5432109876, '567 Birch Blvd'),
('Emily', 'White', 'emily.w@email.com', 4321098765, '890 Cedar Drive'),
('Michael', 'Miller', 'michael.m@email.com', 3210987654, '135 Willow Way'),
('Sarah', 'Wilson', 'sarah.w@email.com', 2109876543, '246 Spruce Circle');

-- Insert into Restaurants Table
INSERT INTO restaurants (restaurant_name, location, contact_number, cuisine_type) VALUES
('Tasty Bites', 'Downtown', 9876543211, 'Italian'),
('Spice Heaven', 'Uptown', 8765432112, 'Indian'),
('Sushi World', 'Midtown', 7654321123, 'Japanese'),
('Burger Hub', 'Downtown', 6543211234, 'American'),
('Pasta House', 'West End', 5432112345, 'Italian'),
('Curry Delight', 'East End', 4321123456, 'Indian'),
('Grill Corner', 'Central', 3211234567, 'BBQ'),
('Vegan Treats', 'North Side', 2109876543, 'Vegan');

-- Insert into Food Items Table
INSERT INTO food_items (restaurant_id, food_name, price, category) VALUES
(1, 'Margherita Pizza', 12.99, 'main course'),
(2, 'Butter Chicken', 14.99, 'main course'),
(3, 'Salmon Sushi', 18.99, 'appetizer'),
(4, 'Cheeseburger', 9.99, 'main course'),
(5, 'Spaghetti Carbonara', 13.49, 'main course'),
(6, 'Paneer Tikka', 10.99, 'appetizer'),
(7, 'Grilled Ribs', 19.99, 'main course'),
(8, 'Vegan Brownie', 6.99, 'dessert');

-- Insert into Orders Table
INSERT INTO orders (customer_id, order_date, total_amount, order_status) VALUES
(1, '2024-02-01', 32.97, 'Completed'),
(2, '2024-02-02', 28.98, 'Pending'),
(3, '2024-02-03', 37.48, 'Completed'),
(4, '2024-02-04', 19.99, 'Canceled'),
(5, '2024-02-05', 25.48, 'Completed'),
(6, '2024-02-06', 14.99, 'Pending'),
(7, '2024-02-07', 27.98, 'Completed'),
(8, '2024-02-08', 29.98, 'Pending');

-- Insert into Order Items Table
INSERT INTO order_items (order_id, food_item_id, quantity) VALUES
(1, 1, 2),
(1, 3, 1),
(2, 2, 2),
(3, 5, 1),
(3, 6, 2),
(4, 7, 1),
(5, 8, 3),
(6, 4, 1);

-- Insert into Delivery Personnel Table
INSERT INTO delivery_personnel (first_name, last_name, phone_number, vehicle_type) VALUES
('Tom', 'Harris', 9988776655, 'Bike'),
('Anna', 'Jones', 8877665544, 'Car'),
('Robert', 'Taylor', 7766554433, 'Bike'),
('Lucy', 'Anderson', 6655443322, 'Biscycle'),
('James', 'Moore', 5544332211, 'Car'),
('Olivia', 'Martin', 4433221100, 'Bus'),
('Daniel', 'Lee', 3322110099, 'Bike'),
('Sophia', 'Walker', 2211009988, 'Biscycle');

-- Insert into Deliveries Table
INSERT INTO deliveries (order_id, delivery_status, delivery_time) VALUES
(1, 'Delivered', '12:30:00'),
(2, 'In Transit', '14:15:00'),
(3, 'Delivered', '18:45:00'),
(4, 'Delivered', '16:30:00'),
(5, 'In Transit', '20:00:00'),
(6, 'Delivered', '22:10:00'),
(7, 'In Transit', '11:45:00'),
(8, 'Delivered', '15:25:00');

-- Insert into Payments Table
INSERT INTO payments (order_id, payment_date, payment_method, payment_status) VALUES
(1, '2024-02-01', 'Credit Card', 'Completed'),
(2, '2024-02-02', 'Debit Card', 'Pending'),
(3, '2024-02-03', 'Cash', 'Completed'),
(4, '2024-02-04', 'Credit Card', 'Completed'),
(5, '2024-02-05', 'Debit Card', 'Pending'),
(6, '2024-02-06', 'Cash', 'Completed'),
(7, '2024-02-07', 'Credit Card', 'Pending'),
(8, '2024-02-08', 'Debit Card', 'Completed');

-- Find all food items in a particular restaurant
SELECT food_name, price, category 
FROM food_items 
WHERE restaurant_id = (SELECT restaurant_id FROM restaurants WHERE restaurant_name = 'Tasty Bites');

-- Get all orders by a specific customer
SELECT order_id, order_date, total_amount, order_status 
FROM orders 
WHERE customer_id = (SELECT customer_id FROM customers WHERE email = 'john.doe@email.com');

-- Find the total amount spent by each customer
SELECT c.customer_id, c.first_name, c.last_name, SUM(o.total_amount) AS total_spent 
FROM customers c 
JOIN orders o ON c.customer_id = o.customer_id 
GROUP BY c.customer_id, c.first_name, c.last_name;

-- List of all food items ordered in a particular order
SELECT oi.order_id, fi.food_name, oi.quantity 
FROM order_items oi 
JOIN food_items fi ON oi.food_item_id = fi.food_item_id 
WHERE oi.order_id = 3;

-- Get all deliveries for a specific order
SELECT d.delivery_id, d.order_id, d.delivery_status, d.delivery_time 
FROM deliveries d 
WHERE d.order_id = 5;

-- Track payment details for a specific order
SELECT p.payment_id, p.order_id, p.payment_date, p.payment_method, p.payment_status 
FROM payments p 
WHERE p.order_id = 7;

-- Get the status of each order along with food items ordered
SELECT o.order_id, o.order_status, fi.food_name, oi.quantity 
FROM orders o 
JOIN order_items oi ON o.order_id = oi.order_id 
JOIN food_items fi ON oi.food_item_id = fi.food_item_id 
ORDER BY o.order_id;

-- Find which delivery personnel delivered the order
SELECT d.delivery_id, dp.first_name, dp.last_name, dp.phone_number, dp.vehicle_type 
FROM deliveries d 
JOIN delivery_personnel dp ON d.delivery_id = dp.delivery_id 
WHERE d.order_id = 1;
