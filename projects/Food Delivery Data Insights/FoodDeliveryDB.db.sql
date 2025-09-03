-- SQL Lite Project
sqlite3 FoodDeliveryDB.db

-- Users Table  
CREATE TABLE users (
  user_id INTEGER Primary Key,
  name VARCHAR(20),
  email VARCHAR(20),
  phone_number BIGINT,
  address TEXT,
  created_at DATETIME
);

-- Restaurants Table  
CREATE TABLE restaurants (
  restaurant_id INTEGER Primary Key,
  name VARCHAR(20),
  location VARCHAR(20),
  rating INTEGER CHECK (rating BETWEEN 1 AND 10),
  created_at DATETIME
);

-- Menu Items Table 
CREATE TABLE menu_table (
  item_id INTEGER Primary Key,
  restaurant_id INTEGER,
  item_name VARCHAR(20),
  price INT,
  category VARCHAR(20),
  FOREIGN key (restaurant_id) REFERENCES restaurants(restaurant_id)
);

-- Orders Table  
CREATE TABLE orders (
  order_id INTEGER Primary Key,
  user_id INTEGER,
  restaurant_id INTEGER,
  total_price INTEGER,
  order_status VARCHAR(20),
  created_at DATETIME,
  Foreign Key (user_id) REFERENCES users(user_id),
  Foreign Key (restaurant_id) REFERENCES restaurants(restaurant_id)
);  

-- Order Items Table  
CREATE TABLE order_table (
  order_item_id INTEGER Primary Key,
  order_id INTEGER,
  item_id INTEGER,
  quantity INTEGER,
  price INTEGER,
  Foreign Key (order_id) REFERENCES orders(order_id),
  Foreign Key (item_id) REFERENCES menu_items(item_id)
);

-- Delivery Person Table 
CREATE TABLE delivery_person (
  delivery_person_id INTEGER Primary Key,
  name VARCHAR(20),
  phone_number BIGINT,
  rating INTEGER CHECK (rating BETWEEN 1 AND 10)
);

-- Delivery Table  
CREATE Table delivery (
  delivery_id INTEGER Primary Key,
  order_id INTEGER, 
  delivery_status VARCHAR(20),
  delivery_time TIME,
  delivery_person_id INT, 
  Foreign Key (order_id) REFERENCES orders(order_id),
  Foreign Key (delivery_person_id) REFERENCES delivery_person(delivery_person_id)
);

-- Insert Users  
INSERT INTO users (name, email, phone_number, address, created_at) VALUES
('Alice', 'alice@gmail.com', 9876543210, '123 Main St', '2024-02-14 08:00:00'),
('Bob', 'bob@gmail.com', 9876543211, '456 Oak St', '2024-02-14 08:15:00'),
('Charlie', 'charlie@gmail.com', 9876543212, '789 Pine St', '2024-02-14 08:30:00'),
('David', 'david@gmail.com', 9876543213, '321 Elm St', '2024-02-14 08:45:00'),
('Eve', 'eve@gmail.com', 9876543214, '654 Maple St', '2024-02-14 09:00:00'),
('Frank', 'frank@gmail.com', 9876543215, '987 Birch St', '2024-02-14 09:15:00'),
('Grace', 'grace@gmail.com', 9876543216, '741 Cedar St', '2024-02-14 09:30:00'),
('Hank', 'hank@gmail.com', 9876543217, '852 Walnut St', '2024-02-14 09:45:00');

-- Insert Restaurants  
INSERT INTO restaurants (name, location, rating, created_at) VALUES
('Pizza Palace', 'Downtown', 8, '2024-02-14 10:00:00'),
('Sushi Spot', 'Midtown', 9, '2024-02-14 10:15:00'),
('Burger Barn', 'Uptown', 7, '2024-02-14 10:30:00'),
('Taco Town', 'Downtown', 8, '2024-02-14 10:45:00'),
('Pasta Place', 'Midtown', 9, '2024-02-14 11:00:00'),
('Vegan Vibes', 'Uptown', 7, '2024-02-14 11:15:00'),
('BBQ Haven', 'Suburbs', 10, '2024-02-14 11:30:00'),
('Deli Delight', 'Downtown', 8, '2024-02-14 11:45:00');

-- Insert Menu Items  
INSERT INTO menu_table (restaurant_id, item_name, price, category) VALUES
(1, 'Margherita Pizza', 10.99, 'Pizza'),
(1, 'Pepperoni Pizza', 12.99, 'Pizza'),
(2, 'Salmon Sushi', 14.99, 'Sushi'),
(2, 'Tuna Roll', 13.99, 'Sushi'),
(3, 'Cheeseburger', 8.99, 'Burger'),
(3, 'Double Patty Burger', 11.99, 'Burger'),
(4, 'Chicken Tacos', 9.99, 'Tacos'),
(4, 'Beef Tacos', 10.99, 'Tacos');

-- Insert Orders  
INSERT INTO orders (user_id, restaurant_id, total_price, order_status, created_at) VALUES
(1, 1, 23.98, 'Delivered', '2024-02-14 12:30:00'),
(2, 2, 28.98, 'Preparing', '2024-02-14 13:45:00'),
(3, 3, 20.98, 'Delivered', '2024-02-14 14:10:00'),
(4, 4, 19.98, 'Out for Delivery', '2024-02-14 15:20:00'),
(5, 1, 12.99, 'Delivered', '2024-02-14 16:00:00'),
(6, 3, 11.99, 'Preparing', '2024-02-14 16:40:00'),
(7, 2, 27.99, 'Delivered', '2024-02-14 17:15:00'),
(8, 4, 18.99, 'Out for Delivery', '2024-02-14 18:00:00');

-- Insert Order Items  
INSERT INTO order_table (order_id, item_id, quantity, price) VALUES
(1, 1, 2, 10.99),
(2, 3, 2, 14.99),
(3, 5, 2, 8.99),
(4, 7, 2, 9.99),
(5, 2, 1, 12.99),
(6, 6, 1, 11.99),
(7, 4, 2, 13.99),
(8, 8, 2, 9.49);

-- Insert Delivery Persons  
INSERT INTO delivery_person (name, phone_number, rating) VALUES
('Tom', 9998887771, 9),
('Jerry', 9998887772, 8),
('Mickey', 9998887773, 10),
('Donald', 9998887774, 7),
('Goofy', 9998887775, 8),
('Pluto', 9998887776, 9),
('Scooby', 9998887777, 9),
('Shaggy', 9998887778, 10);

-- Insert Deliveries  
INSERT INTO delivery (order_id, delivery_status, delivery_time, delivery_person_id) VALUES
(1, 'Delivered', '12:30:00', 1),
(2, 'Preparing', '00:00:00', 2),
(3, 'Delivered', '13:15:00', 3),
(4, 'Out for Delivery', '14:45:00', 4),
(5, 'Delivered', '15:30:00', 5),
(6, 'Preparing', '00:00:00', 6),
(7, 'Delivered', '16:10:00', 7),
(8, 'Out for Delivery', '17:05:00', 8);

-- Find the number of users who placed at least one order.
SELECT COUNT(DISTINCT user_id) AS active_users
FROM orders;

-- Identify users who have never placed an order.
SELECT u.user_id, u.name, u.email
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
WHERE o.user_id IS NULL;

-- List the top 5 highest-rated restaurants.
SELECT name, location, rating
FROM restaurants
ORDER BY rating DESC
LIMIT 5;

-- Find the restaurant with the most orders.
SELECT r.restaurant_id, r.name, COUNT(o.order_id) AS total_orders
FROM restaurants r
JOIN orders o ON r.restaurant_id = o.restaurant_id
GROUP BY r.restaurant_id, r.name
ORDER BY total_orders DESC
LIMIT 1;

-- Identify the most ordered menu item across all restaurants.
SELECT m.item_name, COUNT(o.item_id) AS total_orders
FROM order_table o
JOIN menu_table m ON o.item_id = m.item_id
GROUP BY m.item_name
ORDER BY total_orders DESC
LIMIT 1;

-- Find the average price of menu items for each restaurant.
SELECT r.name AS restaurant_name, AVG(m.price) AS avg_price
FROM menu_table m
JOIN restaurants r ON m.restaurant_id = r.restaurant_id
GROUP BY r.restaurant_id, r.name;

-- Find the total revenue generated by each restaurant.
SELECT r.restaurant_id, r.name, SUM(o.total_price) AS total_revenue
FROM orders o
JOIN restaurants r ON o.restaurant_id = r.restaurant_id
GROUP BY r.restaurant_id, r.name
ORDER BY total_revenue DESC;

-- Identify peak order hours based on the created_at timestamp.
SELECT strftime('%H', created_at) AS order_hour, COUNT(order_id) AS total_orders
FROM orders
GROUP BY order_hour
ORDER BY total_orders DESC
LIMIT 5;

-- Find the most commonly ordered item for a specific restaurant.
SELECT m.item_name, COUNT(o.item_id) AS total_orders
FROM order_table o
JOIN menu_table m ON o.item_id = m.item_id
WHERE m.restaurant_id = 1
GROUP BY m.item_name
ORDER BY total_orders DESC
LIMIT 1;

-- Calculate the total quantity of items sold for each category.
SELECT m.category, SUM(o.quantity) AS total_quantity
FROM order_table o
JOIN menu_table m ON o.item_id = m.item_id
GROUP BY m.category
ORDER BY total_quantity DESC;

-- Find the average delivery time for each restaurant.
SELECT r.name AS restaurant_name, AVG(julianday(d.delivery_time) - julianday(o.created_at)) * 24 * 60 AS avg_delivery_time_minutes
FROM orders o
JOIN delivery d ON o.order_id = d.order_id
JOIN restaurants r ON o.restaurant_id = r.restaurant_id
WHERE d.delivery_time IS NOT NULL
GROUP BY r.restaurant_id, r.name
ORDER BY avg_delivery_time_minutes;

-- Identify the fastest delivery agent based on average delivery time.
SELECT d.delivery_person_id, p.name AS delivery_agent, AVG(julianday(d.delivery_time) - julianday(o.created_at)) * 24 * 60 AS avg_delivery_time_minutes
FROM delivery d
JOIN orders o ON d.order_id = o.order_id
JOIN delivery_person p ON d.delivery_person_id = p.delivery_person_id
WHERE d.delivery_time IS NOT NULL
GROUP BY d.delivery_person_id, p.name
ORDER BY avg_delivery_time_minutes ASC
LIMIT 1;

-- Find the delivery agent who has completed the most deliveries.
SELECT d.delivery_person_id, p.name AS delivery_agent, COUNT(d.delivery_id) AS total_deliveries
FROM delivery d
JOIN delivery_person p ON d.delivery_person_id = p.delivery_person_id
GROUP BY d.delivery_person_id, p.name
ORDER BY total_deliveries DESC
LIMIT 1;

-- Identify delivery agents with a rating above 8.
SELECT delivery_person_id, name, phone_number, rating
FROM delivery_person
WHERE rating > 8;
