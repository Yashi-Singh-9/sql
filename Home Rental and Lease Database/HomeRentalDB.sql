-- Project in PostgreSQL 
-- Create Database
CREATE DATABASE HomeRentalDB;
\c HomeRentalDB;

CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(15) NOT NULL,
    user_type VARCHAR(10) CHECK (user_type IN ('Landlord', 'Tenant')),
    address TEXT
);

INSERT INTO Users (name, email, phone_number, user_type, address) VALUES
('Alice Johnson', 'alice@example.com', '123-456-7890', 'Landlord', '123 Main St, NY'),
('Bob Smith', 'bob@example.com', '987-654-3210', 'Tenant', '456 Elm St, NY'),
('Charlie Brown', 'charlie@example.com', '555-555-5555', 'Landlord', '789 Oak St, NY');

CREATE TABLE Properties (
    property_id SERIAL PRIMARY KEY,
    owner_id INT REFERENCES Users(user_id) ON DELETE CASCADE,
    address TEXT NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    zip_code VARCHAR(10) NOT NULL,
    property_type VARCHAR(20) CHECK (property_type IN ('Apartment', 'House')),
    bedrooms INT CHECK (bedrooms > 0),
    bathrooms INT CHECK (bathrooms > 0),
    rent_amount DECIMAL(10,2) CHECK (rent_amount > 0),
    available_from DATE NOT NULL
);

INSERT INTO Properties (owner_id, address, city, state, zip_code, property_type, bedrooms, bathrooms, rent_amount, available_from) VALUES
(1, '101 Sunset Blvd', 'New York', 'NY', '10001', 'Apartment', 2, 1, 2000.00, '2025-03-01'),
(1, '202 Pine St', 'Boston', 'MA', '02108', 'House', 3, 2, 2500.00, '2025-04-01'),
(3, '303 Cedar Rd', 'Chicago', 'IL', '60601', 'Apartment', 1, 1, 1800.00, '2025-05-01');

CREATE TABLE Leases (
    lease_id SERIAL PRIMARY KEY,
    property_id INT REFERENCES Properties(property_id) ON DELETE CASCADE,
    tenant_id INT REFERENCES Users(user_id) ON DELETE CASCADE,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL CHECK (end_date > start_date),
    monthly_rent DECIMAL(10,2) CHECK (monthly_rent > 0),
    security_deposit DECIMAL(10,2) CHECK (security_deposit >= 0),
    payment_status VARCHAR(10) CHECK (payment_status IN ('Paid', 'Pending'))
);

INSERT INTO Leases (property_id, tenant_id, start_date, end_date, monthly_rent, security_deposit, payment_status) VALUES
(1, 2, '2024-06-01', '2025-06-01', 2000.00, 2000.00, 'Paid'),
(2, 2, '2024-07-01', '2025-07-01', 2500.00, 2500.00, 'Pending'),
(3, 2, '2024-08-01', '2025-08-01', 1800.00, 1800.00, 'Paid');

CREATE TABLE Payments (
    payment_id SERIAL PRIMARY KEY,
    lease_id INT REFERENCES Leases(lease_id) ON DELETE CASCADE,
    payment_date DATE NOT NULL,
    amount DECIMAL(10,2) CHECK (amount > 0),
    payment_method VARCHAR(20) CHECK (payment_method IN ('Credit Card', 'Bank Transfer', 'Cash')),
    status VARCHAR(10) CHECK (status IN ('Successful', 'Failed', 'Pending'))
);

INSERT INTO Payments (lease_id, payment_date, amount, payment_method, status) VALUES
(1, '2024-06-05', 2000.00, 'Bank Transfer', 'Successful'),
(2, '2024-07-05', 2500.00, 'Credit Card', 'Pending'),
(3, '2024-08-05', 1800.00, 'Cash', 'Successful');
 
CREATE TABLE MaintenanceRequests (
    request_id SERIAL PRIMARY KEY,
    property_id INT REFERENCES Properties(property_id) ON DELETE CASCADE,
    tenant_id INT REFERENCES Users(user_id) ON DELETE CASCADE,
    request_date DATE NOT NULL,
    status VARCHAR(15) CHECK (status IN ('Pending', 'In Progress', 'Completed')),
    description TEXT NOT NULL
);

INSERT INTO MaintenanceRequests (property_id, tenant_id, request_date, status, description) VALUES
(1, 2, '2024-07-10', 'Pending', 'Leaky faucet in the kitchen'),
(2, 2, '2024-08-15', 'In Progress', 'Broken heater'),
(3, 2, '2024-09-20', 'Completed', 'Clogged sink in the bathroom');

-- Find the total rent collected for a specific property within a given year.
SELECT p.property_id, SUM(pay.amount) AS total_rent_collected
FROM Payments pay
JOIN Leases l ON pay.lease_id = l.lease_id
JOIN Properties p ON l.property_id = p.property_id
WHERE p.property_id = 1 AND EXTRACT(YEAR FROM pay.payment_date) = 2024
GROUP BY p.property_id;

--  List tenants who have pending rent payments.
SELECT DISTINCT u.user_id, u.name, u.email
FROM Users u
JOIN Leases l ON u.user_id = l.tenant_id
JOIN Payments p ON l.lease_id = p.lease_id
WHERE p.status = 'Pending';

-- Get all maintenance requests that are still unresolved.
SELECT * 
FROM MaintenanceRequests 
WHERE status IN ('Pending', 'In Progress');

-- Retrieve the top 3 landlords with the most properties listed.
SELECT u.user_id, u.name, COUNT(p.property_id) AS total_properties
FROM Users u
JOIN Properties p ON u.user_id = p.owner_id
WHERE u.user_type = 'Landlord'
GROUP BY u.user_id, u.name
ORDER BY total_properties DESC
LIMIT 3;

-- Find tenants who have leased more than one property.
SELECT u.user_id, u.name, COUNT(l.property_id) AS total_leased
FROM Users u
JOIN Leases l ON u.user_id = l.tenant_id
GROUP BY u.user_id, u.name
HAVING COUNT(l.property_id) > 1;

-- Identify properties with late rent payments.
SELECT p.property_id, p.address, u.name AS tenant_name, pay.amount, pay.status
FROM Payments pay
JOIN Leases l ON pay.lease_id = l.lease_id
JOIN Properties p ON l.property_id = p.property_id
JOIN Users u ON l.tenant_id = u.user_id
WHERE pay.status = 'Pending' AND pay.payment_date < CURRENT_DATE;

-- Find the highest rent property in each city.
SELECT city, MAX(rent_amount) AS highest_rent
FROM Properties
GROUP BY city;

-- List properties along with their landlord names.
SELECT p.property_id, p.address, p.city, p.rent_amount, u.name AS landlord_name
FROM Properties p
JOIN Users u ON p.owner_id = u.user_id
WHERE u.user_type = 'Landlord';

-- Find the total number of leases for each property.
SELECT p.property_id, p.address, COUNT(l.lease_id) AS total_leases
FROM Properties p
LEFT JOIN Leases l ON p.property_id = l.property_id
GROUP BY p.property_id, p.address
ORDER BY total_leases DESC;

-- Get the average rent per property type.
SELECT property_type, AVG(rent_amount) AS average_rent
FROM Properties
GROUP BY property_type;

-- Get a list of tenants and their total amount paid so far.
SELECT u.user_id, u.name, SUM(p.amount) AS total_paid
FROM Users u
JOIN Leases l ON u.user_id = l.tenant_id
JOIN Payments p ON l.lease_id = p.lease_id
WHERE p.status = 'Successful'
GROUP BY u.user_id, u.name;

-- Find the number of properties each landlord owns.
SELECT u.user_id, u.name, COUNT(p.property_id) AS total_properties
FROM Users u
JOIN Properties p ON u.user_id = p.owner_id
WHERE u.user_type = 'Landlord'
GROUP BY u.user_id, u.name;

-- Identify the top 3 most rented properties.
SELECT p.property_id, p.address, COUNT(l.lease_id) AS lease_count
FROM Properties p
JOIN Leases l ON p.property_id = l.property_id
GROUP BY p.property_id, p.address
ORDER BY lease_count DESC
LIMIT 3;

-- Generate a Report on Monthly Rent Collection
SELECT EXTRACT(MONTH FROM p.payment_date) AS month, 
       SUM(p.amount) AS total_rent_collected
FROM Payments p
WHERE p.status = 'Successful'
GROUP BY month
ORDER BY month;
