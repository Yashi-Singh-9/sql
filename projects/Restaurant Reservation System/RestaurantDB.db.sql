-- SQL Lite Project
sqlite3 RestaurantDB.db

-- Customers Table 
CREATE TABLE customers (
  customer_id INTEGER PRIMARY KEY,
  name VARCHAR(20),
  phone BIGINT,
  email VARCHAR(50) UNIQUE
);

-- Tables Table 
CREATE TABLE tabless (
  table_id INTEGER PRIMARY KEY,
  table_number INTEGER,
  capacity INTEGER,
  status VARCHAR(20) CHECK (status IN ('Available', 'Reserved', 'Occupied'))
);

-- Reservations Table  
CREATE TABLE reservations (
  reservation_id INTEGER PRIMARY KEY,
  customer_id INTEGER,
  table_id INTEGER,
  reservation_date DATE,
  reservation_time TIME,
  status VARCHAR(15) CHECK (status IN ('Pending', 'Confirmed', 'Cancelled')),
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  FOREIGN KEY (table_id) REFERENCES tabless(table_id)
);

-- Menu Table  
CREATE TABLE menu (
  menu_id INTEGER PRIMARY KEY,
  item_name VARCHAR(20),
  price DECIMAL(4,2),
  category VARCHAR(20) CHECK (category IN ('Starter', 'Main Course', 'Dessert', 'Beverage'))
);

-- Orders Table  
CREATE TABLE orders (
  order_id INTEGER PRIMARY KEY,
  reservation_id INTEGER,
  order_date DATE,
  total_amount DECIMAL(4,2),
  FOREIGN KEY (reservation_id) REFERENCES reservations(reservation_id)
);

-- Order Items Table 
CREATE TABLE order_items (
  order_item_id INTEGER PRIMARY KEY,
  order_id INTEGER,
  menu_id INTEGER,
  quantity INTEGER,
  subtotal DECIMAL(4,2),
  FOREIGN KEY (order_id) REFERENCES orders(order_id),
  FOREIGN KEY (menu_id) REFERENCES menu(menu_id)
);

-- Payments Table 
CREATE TABLE payments (
  payment_id INTEGER PRIMARY KEY,
  order_id INTEGER,
  payment_method VARCHAR(20) CHECK (payment_method IN ('Cash', 'Card', 'Online')),
  payment_status VARCHAR(8) CHECK (payment_status IN ('Paid', 'Pending')),
  payment_date DATE,
  FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

INSERT INTO customers (customer_id, name, phone, email) VALUES
(1, 'John Doe', 1234567890, 'john.doe@example.com'),
(2, 'Jane Smith', 9876543210, 'jane.smith@example.com'),
(3, 'Alice Johnson', 5551234567, 'alice.johnson@example.com'),
(4, 'Bob Brown', 5559876543, 'bob.brown@example.com'),
(5, 'Charlie White', 5552468100, 'charlie.white@example.com'),
(6, 'David Lee', 5551112233, 'david.lee@example.com'),
(7, 'Eva Green', 5553344556, 'eva.green@example.com'),
(8, 'Frank Black', 5556677889, 'frank.black@example.com');

INSERT INTO tabless (table_id, table_number, capacity, status) VALUES
(1, 1, 4, 'Available'),
(2, 2, 2, 'Reserved'),
(3, 3, 6, 'Occupied'),
(4, 4, 4, 'Available'),
(5, 5, 2, 'Occupied'),
(6, 6, 6, 'Available'),
(7, 7, 4, 'Reserved'),
(8, 8, 4, 'Available');

INSERT INTO reservations (reservation_id, customer_id, table_id, reservation_date, reservation_time, status) VALUES
(1, 1, 2, '2025-02-18', '19:00', 'Confirmed'),
(2, 2, 3, '2025-02-18', '20:00', 'Pending'),
(3, 3, 1, '2025-02-19', '18:30', 'Confirmed'),
(4, 4, 5, '2025-02-19', '21:00', 'Cancelled'),
(5, 5, 6, '2025-02-20', '17:45', 'Confirmed'),
(6, 6, 7, '2025-02-20', '18:00', 'Pending'),
(7, 7, 8, '2025-02-21', '20:00', 'Confirmed'),
(8, 8, 4, '2025-02-21', '22:30', 'Pending');

INSERT INTO menu (menu_id, item_name, price, category) VALUES
(1, 'Caesar Salad', 5.99, 'Starter'),
(2, 'Grilled Chicken', 12.99, 'Main Course'),
(3, 'Chocolate Cake', 4.50, 'Dessert'),
(4, 'Lemonade', 2.99, 'Beverage'),
(5, 'Mushroom Soup', 6.50, 'Starter'),
(6, 'Steak', 18.99, 'Main Course'),
(7, 'Cheesecake', 5.00, 'Dessert'),
(8, 'Iced Tea', 3.50, 'Beverage');

INSERT INTO orders (order_id, reservation_id, order_date, total_amount) VALUES
(1, 1, '2025-02-18', 23.48),
(2, 2, '2025-02-18', 19.49),
(3, 3, '2025-02-19', 30.99),
(4, 5, '2025-02-20', 42.48),
(5, 6, '2025-02-20', 40.48),
(6, 7, '2025-02-21', 27.50),
(7, 8, '2025-02-21', 21.99),
(8, 4, '2025-02-19', 0.00); 

INSERT INTO order_items (order_item_id, order_id, menu_id, quantity, subtotal) VALUES
(1, 1, 1, 1, 5.99),
(2, 1, 2, 1, 12.99),
(3, 1, 4, 1, 2.99),
(4, 2, 2, 1, 12.99),
(5, 2, 8, 1, 3.50),
(6, 3, 6, 1, 18.99),
(7, 3, 3, 1, 4.50),
(8, 4, 5, 1, 6.50),
(9, 5, 2, 2, 25.98),
(10, 5, 4, 1, 2.99),
(11, 6, 7, 1, 5.00),
(12, 6, 8, 1, 3.50),
(13, 7, 1, 2, 11.98),
(14, 7, 6, 1, 18.99),
(15, 8, 2, 1, 12.99),
(16, 8, 4, 1, 2.99);

INSERT INTO payments (payment_id, order_id, payment_method, payment_status, payment_date) VALUES
(1, 1, 'Card', 'Paid', '2025-02-18'),
(2, 2, 'Cash', 'Paid', '2025-02-18'),
(3, 3, 'Card', 'Paid', '2025-02-19'),
(4, 5, 'Card', 'Paid', '2025-02-20'),
(5, 6, 'Online', 'Pending', '2025-02-20'),
(6, 7, 'Cash', 'Paid', '2025-02-21'),
(7, 8, 'Card', 'Paid', '2025-02-21'),
(8, 4, 'Cash', 'Pending', '2025-02-19');

-- Find all reservations made by a specific customer.
SELECT r.reservation_id, r.reservation_date, r.reservation_time, r.status, t.table_number
FROM reservations r
JOIN tabless t ON r.table_id = t.table_id
WHERE r.customer_id = 3;

-- List available tables for a given date and time.
SELECT t.table_number, t.capacity
FROM tabless t
WHERE t.status = 'Available'
AND t.table_id NOT IN (
    SELECT r.table_id
    FROM reservations r
    WHERE r.reservation_date = '2025-02-18'
    AND r.reservation_time = '19:00'
);

-- Retrieve the total amount spent by a customer.
SELECT SUM(o.total_amount) AS total_spent
FROM orders o
JOIN reservations r ON o.reservation_id = r.reservation_id
WHERE r.customer_id = 5;

-- Find the most popular menu item.
SELECT m.item_name, SUM(oi.quantity) AS total_quantity
FROM order_items oi
JOIN menu m ON oi.menu_id = m.menu_id
GROUP BY m.item_name
ORDER BY total_quantity DESC
LIMIT 1;

-- Get the total revenue generated in the last month.
SELECT SUM(o.total_amount) AS total_revenue
FROM payments p
JOIN orders o ON p.order_id = o.order_id
WHERE o.order_date BETWEEN DATE('now', 'start of month', '-1 month') AND DATE('now', 'start of month')
AND p.payment_status = 'Paid';

-- List customers who have never made a reservation.
SELECT c.name
FROM customers c
LEFT JOIN reservations r ON c.customer_id = r.customer_id
WHERE r.reservation_id IS NULL;

-- Find pending reservations.
SELECT r.reservation_id, r.reservation_date, r.reservation_time, c.name AS customer_name
FROM reservations r
JOIN customers c ON r.customer_id = c.customer_id
WHERE r.status = 'Pending';

-- Show all orders with more than 2 items.
SELECT o.order_id, o.order_date, o.total_amount
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id
HAVING COUNT(oi.order_item_id) > 2;

-- List all customers who have spent more than $500 in the restaurant.
SELECT c.name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN reservations r ON c.customer_id = r.customer_id
JOIN orders o ON r.reservation_id = o.reservation_id
GROUP BY c.customer_id
HAVING total_spent > 500;

-- Find which tables are most frequently booked.
SELECT t.table_number, COUNT(r.reservation_id) AS booking_count
FROM tabless t
JOIN reservations r ON t.table_id = r.table_id
GROUP BY t.table_id
ORDER BY booking_count DESC;
