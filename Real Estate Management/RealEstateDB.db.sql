-- Project in SQL Lite 
sqlite3 RealEstateDB.db

-- Owners Table  
CREATE TABLE owners (
  owner_id INTEGER PRIMARY KEY,
  name VARCHAR(50),
  contact_number BIGINT,
  email VARCHAR(50) UNIQUE
);

-- Properties Table  
CREATE TABLE properties (
  property_id INTEGER PRIMARY KEY,
  address TEXT,
  city VARCHAR(50),
  state VARCHAR(50),
  zip_code VARCHAR(20),
  price DECIMAL(15,2),
  type VARCHAR(15) CHECK (type IN ('Apartment', 'House', 'Commercial')),
  status VARCHAR(12) CHECK (status IN ('Available', 'Sold', 'Rented')),
  owner_id INT,
  FOREIGN KEY (owner_id) REFERENCES owners(owner_id)
);

-- Tenants Table  
CREATE TABLE tenants (
  tenant_id INTEGER PRIMARY KEY,
  name VARCHAR(50),
  contact_number BIGINT,
  email VARCHAR(50) UNIQUE
);

-- Leases Table  
CREATE TABLE leases (
  lease_id INTEGER PRIMARY KEY,
  property_id INTEGER,
  tenant_id INTEGER,
  start_date DATE,
  end_date DATE,
  monthly_rent DECIMAL(12,2),
  status VARCHAR(10) CHECK (status IN ('Active', 'Terminated')),
  FOREIGN KEY (property_id) REFERENCES properties(property_id),
  FOREIGN KEY (tenant_id) REFERENCES tenants(tenant_id)
);

-- Transactions Table  
CREATE TABLE transactions (
  transaction_id INTEGER PRIMARY KEY,
  lease_id INTEGER,
  payment_date DATE,
  amount_paid DECIMAL(15,2),
  payment_method VARCHAR(15),
  FOREIGN KEY (lease_id) REFERENCES leases(lease_id)
);

-- Agents Table  
CREATE TABLE agents (
  agent_id INTEGER PRIMARY KEY,
  name VARCHAR(50),
  contact_number BIGINT,
  email VARCHAR(50) UNIQUE
);

-- Sales Table  
CREATE TABLE sales (
  sale_id INTEGER PRIMARY KEY,
  property_id INTEGER,
  buyer_name VARCHAR(50),
  sale_price DECIMAL(15,2),
  sale_date DATE,
  agent_id INTEGER,
  FOREIGN KEY (property_id) REFERENCES properties(property_id),
  FOREIGN KEY (agent_id) REFERENCES agents(agent_id)
);  

-- Insert data into owners table
INSERT INTO owners (owner_id, name, contact_number, email) VALUES
(1, 'John Doe', 1234567890, 'john@example.com'),
(2, 'Jane Smith', 9876543210, 'jane@example.com'),
(3, 'Michael Johnson', 5551234567, NULL),
(4, 'Alice Brown', 4442223333, 'alice@example.com'),
(5, 'Robert Wilson', 6669998888, NULL),
(6, 'Emily Davis', 7778889999, 'emily@example.com'),
(7, 'Daniel White', 9998887776, 'daniel@example.com'),
(8, 'Laura Scott', 1112223334, NULL),
(9, 'David King', 2223334445, 'david@example.com'),
(10, 'Emma Harris', 3334445556, 'emma@example.com');

-- Insert data into properties table
INSERT INTO properties (property_id, address, city, state, zip_code, price, type, status, owner_id) VALUES
(1, '123 Main St', 'New York', 'NY', '10001', 500000.00, 'Apartment', 'Available', 1),
(2, '456 Maple Ave', 'Los Angeles', 'CA', '90001', 750000.00, 'House', 'Sold', 2),
(3, '789 Oak St', 'Chicago', 'IL', '60601', 1200000.00, 'Commercial', 'Rented', 3),
(4, '101 Pine St', 'Houston', 'TX', '77001', 300000.00, 'Apartment', 'Available', 4),
(5, '202 Birch Ave', 'Phoenix', 'AZ', '85001', 450000.00, 'House', 'Available', 5),
(6, '303 Cedar Rd', 'Philadelphia', 'PA', '19101', 600000.00, 'Apartment', 'Sold', 6),
(7, '404 Walnut St', 'San Antonio', 'TX', '78201', 850000.00, 'Commercial', 'Rented', 7),
(8, '505 Elm St', 'San Diego', 'CA', '92101', 950000.00, 'House', 'Available', 8),
(9, '606 Spruce Ave', 'Dallas', 'TX', '75201', 1100000.00, 'Commercial', 'Sold', 9),
(10, '707 Fir St', 'San Francisco', 'CA', '94101', 1300000.00, 'Apartment', 'Available', 10);

-- Insert data into tenants table
INSERT INTO tenants (tenant_id, name, contact_number, email) VALUES
(1, 'Chris Brown', 5556667771, 'chris@example.com'),
(2, 'Nancy Clark', 6667778882, 'nancy@example.com'),
(3, 'Steven Hall', 7778889993, NULL),
(4, 'Rachel Green', 8889990004, 'rachel@example.com'),
(5, 'Brian Adams', 9990001115, 'brian@example.com'),
(6, 'Megan Roberts', 1112223336, NULL),
(7, 'Tyler Moore', 2223334447, 'tyler@example.com'),
(8, 'Samantha Turner', 3334445558, 'samantha@example.com'),
(9, 'Jason Lee', 4445556669, NULL),
(10, 'Olivia Thomas', 5556667770, 'olivia@example.com');

-- Insert data into leases table
INSERT INTO leases (lease_id, property_id, tenant_id, start_date, end_date, monthly_rent, status) VALUES
(1, 3, 1, '2024-01-01', '2025-01-01', 2000.00, 'Active'),
(2, 7, 2, '2023-06-15', '2024-06-15', 3500.00, 'Active'),
(3, 3, 3, '2023-09-01', '2024-09-01', 5000.00, 'Active'),
(4, 7, 4, '2022-12-01', '2023-12-01', 4500.00, 'Terminated'),
(5, 3, 5, '2023-02-01', '2024-02-01', 2200.00, 'Active'),
(6, 7, 6, '2024-03-01', '2025-03-01', 4800.00, 'Active'),
(7, 3, 7, '2023-11-01', '2024-11-01', 2100.00, 'Terminated'),
(8, 7, 8, '2024-01-15', '2025-01-15', 3700.00, 'Active'),
(9, 3, 9, '2023-07-01', '2024-07-01', 2300.00, 'Active'),
(10, 7, 10, '2024-05-01', '2025-05-01', 4100.00, 'Active');

-- Insert data into transactions table
INSERT INTO transactions (transaction_id, lease_id, payment_date, amount_paid, payment_method) VALUES
(1, 1, '2024-02-01', 2000.00, 'Credit Card'),
(2, 2, '2024-01-15', 3500.00, 'Bank Transfer'),
(3, 3, '2024-01-01', 5000.00, 'Cash'),
(4, 4, '2023-11-01', 4500.00, 'Credit Card'),
(5, 5, '2024-02-01', 2200.00, 'PayPal'),
(6, 6, '2024-03-01', 4800.00, 'Bank Transfer'),
(7, 7, '2023-12-01', 2100.00, 'Cash'),
(8, 8, '2024-01-15', 3700.00, 'PayPal'),
(9, 9, '2024-02-01', 2300.00, 'Bank Transfer'),
(10, 10, '2024-05-01', 4100.00, 'Credit Card');

-- Insert data into agents table
INSERT INTO agents (agent_id, name, contact_number, email) VALUES
(1, 'Sarah Parker', 9998887771, 'sarah@example.com'),
(2, 'Tom Anderson', 8887776662, NULL),
(3, 'Lisa Brooks', 7776665553, 'lisa@example.com'),
(4, 'Kevin Ramirez', 6665554444, 'kevin@example.com'),
(5, 'Angela Stewart', 5554443335, 'angela@example.com'),
(6, 'Jack Mitchell', 4443332226, NULL),
(7, 'Sophia Foster', 3332221117, 'sophia@example.com'),
(8, 'Ethan Reed', 2221110008, 'ethan@example.com'),
(9, 'Hannah Scott', 1110009999, NULL),
(10, 'Dylan Carter', 0009998880, 'dylan@example.com');

-- Insert data into sales table
INSERT INTO sales (sale_id, property_id, buyer_name, sale_price, sale_date, agent_id) VALUES
(1, 2, 'William Brown', 750000.00, '2023-12-10', 1),
(2, 6, 'Sophia Wilson', 600000.00, '2024-01-05', 2),
(3, 9, 'James Lee', 1100000.00, '2023-11-20', 3),
(4, 2, 'Natalie Adams', 730000.00, '2023-10-15', 4),
(5, 6, 'Oliver Clark', 620000.00, '2024-02-01', 5),
(6, 9, 'Lucas Turner', 1080000.00, '2023-09-25', 6),
(7, 2, 'Emma Hall', 740000.00, '2023-08-30', 7),
(8, 6, 'Mia Roberts', 610000.00, '2024-03-10', 8),
(9, 9, 'Benjamin Scott', 1120000.00, '2023-07-14', 9),
(10, 2, 'Isabella White', 755000.00, '2023-06-22', 10);

-- Retrieve all available properties with a price greater than $500,000.
SELECT * 
FROM properties 
WHERE status = 'Available' 
AND price > 500000;

-- Find the total number of properties owned by each owner.
SELECT owner_id, COUNT(*) AS total_properties
FROM properties
GROUP BY owner_id;

-- List the tenants whose leases are expiring in the next 30 days.
SELECT * 
FROM tenants 
WHERE tenant_id IN (
    SELECT tenant_id 
    FROM leases 
    WHERE end_date BETWEEN DATE('now') AND DATE('now', '+30 days')
);

-- Retrieve the details of properties along with their owner's information.
SELECT p.*, o.name AS owner_name, o.contact_number, o.email
FROM properties p
JOIN owners o ON p.owner_id = o.owner_id;

-- Find the agent who has sold the highest number of properties.
SELECT a.agent_id, a.name, COUNT(s.sale_id) AS properties_sold
FROM sales s
JOIN agents a ON s.agent_id = a.agent_id
GROUP BY a.agent_id
ORDER BY properties_sold DESC
LIMIT 1;

-- Get the total revenue generated from property sales in the last year.
SELECT SUM(sale_price) AS total_revenue
FROM sales
WHERE sale_date >= DATE('now', '-1 year');

-- List all transactions for a specific tenant sorted by date.
SELECT t.*
FROM transactions t
JOIN leases l ON t.lease_id = l.lease_id
WHERE l.tenant_id = 5
ORDER BY t.payment_date ASC;

-- Identify properties that have never been rented or sold.
SELECT * 
FROM properties 
WHERE property_id NOT IN (SELECT property_id FROM leases)
AND property_id NOT IN (SELECT property_id FROM sales);

-- Find the average monthly rent of all leased properties.
SELECT AVG(monthly_rent) AS average_rent
FROM leases;

-- Retrieve properties that have had more than one tenant.
SELECT property_id, COUNT(DISTINCT tenant_id) AS tenant_count
FROM leases
GROUP BY property_id
HAVING COUNT(DISTINCT tenant_id) > 1;

-- Get the list of tenants who have missed rent payments in the last 3 months.
SELECT t.tenant_id, t.name
FROM tenants t
JOIN leases l ON t.tenant_id = l.tenant_id
LEFT JOIN transactions tr ON l.lease_id = tr.lease_id 
AND tr.payment_date BETWEEN DATE('now', '-3 months') AND DATE('now')
WHERE tr.transaction_id IS NULL;

-- Identify the property that generated the most revenue (sales + rent).
SELECT p.property_id, 
       COALESCE(SUM(s.sale_price), 0) + COALESCE(SUM(t.amount_paid), 0) AS total_revenue
FROM properties p
LEFT JOIN sales s ON p.property_id = s.property_id
LEFT JOIN leases l ON p.property_id = l.property_id
LEFT JOIN transactions t ON l.lease_id = t.lease_id
GROUP BY p.property_id
ORDER BY total_revenue DESC
LIMIT 1;

-- List all properties managed by a specific real estate agent.
SELECT p.*
FROM properties p
JOIN sales s ON p.property_id = s.property_id
WHERE s.agent_id = 2;

-- Retrieve the details of all rented properties along with tenant details.
SELECT p.*, t.name AS tenant_name, t.contact_number, t.email, l.start_date, l.end_date, l.monthly_rent
FROM properties p
JOIN leases l ON p.property_id = l.property_id
JOIN tenants t ON l.tenant_id = t.tenant_id
WHERE l.status = 'Active';

-- Find the number of properties rented by each tenant.
SELECT tenant_id, COUNT(*) AS total_rented_properties
FROM leases
GROUP BY tenant_id;

-- Get the details of the most expensive property sold.
SELECT * 
FROM sales 
ORDER BY sale_price DESC 
LIMIT 1;

-- Find the total number of sales handled by each agent.
SELECT agent_id, COUNT(*) AS total_sales
FROM sales
GROUP BY agent_id;

-- Find the top 5 most expensive properties available for sale.
SELECT * 
FROM properties 
WHERE status = 'Available' 
ORDER BY price DESC 
LIMIT 5;

-- Retrieve properties along with their last sale price and last rent amount.
SELECT p.property_id, p.address, 
       (SELECT sale_price FROM sales s WHERE s.property_id = p.property_id ORDER BY sale_date DESC LIMIT 1) AS last_sale_price,
       (SELECT monthly_rent FROM leases l WHERE l.property_id = p.property_id ORDER BY end_date DESC LIMIT 1) AS last_rent_amount
FROM properties p;

-- Get the total earnings for each owner from sales and rent.
SELECT o.owner_id, o.name, 
       COALESCE(SUM(s.sale_price), 0) + COALESCE(SUM(t.amount_paid), 0) AS total_earnings
FROM owners o
LEFT JOIN properties p ON o.owner_id = p.owner_id
LEFT JOIN sales s ON p.property_id = s.property_id
LEFT JOIN leases l ON p.property_id = l.property_id
LEFT JOIN transactions t ON l.lease_id = t.lease_id
GROUP BY o.owner_id;

-- Find tenants who have paid rent late at least once.
SELECT DISTINCT t.tenant_id, t.name
FROM tenants t
JOIN leases l ON t.tenant_id = l.tenant_id
JOIN transactions tr ON l.lease_id = tr.lease_id
WHERE tr.payment_date > l.start_date;

-- Retrieve all leases that were terminated early.
SELECT * 
FROM leases 
WHERE status = 'Terminated' 
AND end_date < DATE('now');

-- Get a list of properties that have been sold multiple times
SELECT property_id, COUNT(*) AS total_sales
FROM sales
GROUP BY property_id
HAVING COUNT(*) > 1;

-- Retrieve a summary of total rent and sales for each city
SELECT p.city, 
       SUM(s.sale_price) AS total_sales_revenue,
       SUM(t.amount_paid) AS total_rent_revenue
FROM properties p
LEFT JOIN sales s ON p.property_id = s.property_id
LEFT JOIN leases l ON p.property_id = l.property_id
LEFT JOIN transactions t ON l.lease_id = t.lease_id
GROUP BY p.city;

-- List all agents along with the total revenue generated from their sales.
SELECT a.agent_id, a.name, SUM(s.sale_price) AS total_revenue
FROM agents a
JOIN sales s ON a.agent_id = s.agent_id
GROUP BY a.agent_id
ORDER BY total_revenue DESC;