-- Project in PostgreSQL 
-- Create database
CREATE DATABASE ecommerce_order_management;
\c ecommerce_order_management;

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    address TEXT,
    registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    description TEXT,
    price NUMERIC(10, 2),
    stock_quantity INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50) DEFAULT 'Pending' -- Pending, Shipped, Delivered, Cancelled
);

CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    product_id INT REFERENCES products(product_id),
    quantity INT,
    unit_price NUMERIC(10, 2)
);

CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    payment_method VARCHAR(50), -- e.g., Card, PayPal, COD
    payment_status VARCHAR(50), -- Paid, Unpaid, Refunded
    amount NUMERIC(10,2),
    paid_at TIMESTAMP
);

CREATE TABLE shipping (
    shipping_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    shipping_address TEXT,
    shipping_method VARCHAR(50),
    tracking_number VARCHAR(100),
    shipped_at TIMESTAMP,
    delivered_at TIMESTAMP
);

INSERT INTO customers (full_name, email, phone, address) VALUES
('Alice Smith', 'alice@shop.com', '555-1001', '123 Main St'),
('Bob Johnson', 'bob@shop.com', '555-1002', '456 Oak St');

INSERT INTO products (name, description, price, stock_quantity) VALUES
('Wireless Mouse', 'Ergonomic and battery-powered', 25.99, 100),
('Bluetooth Speaker', 'Portable with deep bass', 45.50, 50),
('Gaming Keyboard', 'RGB backlit mechanical keys', 65.00, 75);

INSERT INTO orders (customer_id, status) VALUES
(1, 'Pending'),
(2, 'Shipped');

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 2, 25.99),
(1, 3, 1, 65.00),
(2, 2, 1, 45.50);

INSERT INTO payments (order_id, payment_method, payment_status, amount, paid_at) VALUES
(1, 'Card', 'Paid', 116.98, NOW()),
(2, 'PayPal', 'Paid', 45.50, NOW());

INSERT INTO shipping (order_id, shipping_address, shipping_method, tracking_number, shipped_at, delivered_at) VALUES
(2, '456 Oak St', 'UPS', '1Z999999', NOW() - INTERVAL '1 day', NOW());

-- Get all orders with total value
SELECT o.order_id, c.full_name, SUM(oi.quantity * oi.unit_price) AS total_amount, o.status
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, c.full_name, o.status;

-- Get customer order history
SELECT o.order_id, o.order_date, o.status, p.name, oi.quantity, oi.unit_price
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.customer_id = 1;

-- Pending orders
SELECT order_id, order_date, status
FROM orders
WHERE status = 'Pending';

-- Total Revenue Generated
SELECT SUM(amount) AS total_revenue
FROM payments
WHERE payment_status = 'Paid';

-- Top Customers by Spending
SELECT c.full_name, c.email, SUM(p.amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN payments p ON o.order_id = p.order_id
WHERE p.payment_status = 'Paid'
GROUP BY c.full_name, c.email
ORDER BY total_spent DESC
LIMIT 2;

-- Most Sold Products
SELECT pr.name, SUM(oi.quantity) AS total_sold
FROM order_items oi
JOIN products pr ON oi.product_id = pr.product_id
GROUP BY pr.name
ORDER BY total_sold DESC
LIMIT 1;

-- Average Delivery Time
SELECT 
    AVG(delivered_at - shipped_at) AS avg_delivery_time
FROM shipping
WHERE delivered_at IS NOT NULL AND shipped_at IS NOT NULL;

-- Track a Specific Order’s Shipping Status
SELECT 
    o.order_id, s.tracking_number, s.shipping_method, s.shipped_at, s.delivered_at
FROM orders o
JOIN shipping s ON o.order_id = s.order_id
WHERE o.order_id = 2;

-- Current Stock Valuation (by Retail Price)
SELECT SUM(price * stock_quantity) AS total_stock_value
FROM products;

-- Full Order Summary (All Info in One)
SELECT 
    o.order_id,
    c.full_name AS customer,
    o.order_date,
    o.status,
    SUM(oi.quantity * oi.unit_price) AS total_amount,
    p.payment_status,
    s.shipping_method,
    s.tracking_number,
    s.delivered_at
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN payments p ON o.order_id = p.order_id
LEFT JOIN shipping s ON o.order_id = s.order_id
GROUP BY o.order_id, c.full_name, o.order_date, o.status, p.payment_status, s.shipping_method, s.tracking_number, s.delivered_at;
