-- Project in PostgreSQL 
-- Create Database
CREATE DATABASE Blood_Donation_DB;
\c Blood_Donation_DB;

-- Donor Table
CREATE TABLE Donor (
    donor_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INT CHECK (age >= 18 AND age <= 65),
    gender VARCHAR(10) CHECK (gender IN ('Male', 'Female', 'Other')),
    blood_type VARCHAR(5) NOT NULL,
    contact_number VARCHAR(15) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE,
    address TEXT
);

-- Hospital Table
CREATE TABLE Hospital (
    hospital_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address TEXT NOT NULL,
    contact_number VARCHAR(15) UNIQUE NOT NULL
);

-- Blood Bank Table
CREATE TABLE Blood_Bank (
    blood_bank_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location TEXT NOT NULL,
    contact_number VARCHAR(15) UNIQUE NOT NULL
);

-- Donation Table
CREATE TABLE Donation (
    donation_id SERIAL PRIMARY KEY,
    donor_id INT REFERENCES Donor(donor_id) ON DELETE CASCADE,
    blood_bank_id INT REFERENCES Blood_Bank(blood_bank_id) ON DELETE SET NULL,
    donation_date DATE NOT NULL DEFAULT CURRENT_DATE,
    quantity INT CHECK (quantity > 0)
);

-- Blood Stock Table
CREATE TABLE Blood_Stock (
    stock_id SERIAL PRIMARY KEY,
    blood_bank_id INT REFERENCES Blood_Bank(blood_bank_id) ON DELETE CASCADE,
    blood_type VARCHAR(5) NOT NULL,
    quantity INT CHECK (quantity >= 0) NOT NULL
);

-- Request Table
CREATE TABLE Request (
    request_id SERIAL PRIMARY KEY,
    hospital_id INT REFERENCES Hospital(hospital_id) ON DELETE CASCADE,
    blood_bank_id INT REFERENCES Blood_Bank(blood_bank_id) ON DELETE CASCADE,
    blood_type VARCHAR(5) NOT NULL,
    quantity INT CHECK (quantity > 0) NOT NULL,
    request_date DATE NOT NULL DEFAULT CURRENT_DATE,
    status VARCHAR(20) CHECK (status IN ('Pending', 'Approved', 'Rejected'))
);

-- Insert Donors
INSERT INTO Donor (name, age, gender, blood_type, contact_number, email, address)
VALUES 
    ('John Doe', 25, 'Male', 'O+', '1234567890', 'john@example.com', 'New York'),
    ('Alice Smith', 30, 'Female', 'A+', '2345678901', 'alice@example.com', 'Los Angeles'),
    ('Robert Brown', 22, 'Male', 'B-', '3456789012', 'robert@example.com', 'Chicago'),
    ('Emily Davis', 40, 'Female', 'AB+', '4567890123', 'emily@example.com', 'Houston');

-- Insert Blood Banks
INSERT INTO Blood_Bank (name, location, contact_number)
VALUES 
    ('Red Cross Center', 'New York', '5551234567'),
    ('City Blood Bank', 'Los Angeles', '5552345678');

-- Insert Hospitals
INSERT INTO Hospital (name, address, contact_number)
VALUES 
    ('NY General Hospital', 'New York', '6661234567'),
    ('LA Medical Center', 'Los Angeles', '6662345678');

-- Insert Donations
INSERT INTO Donation (donor_id, blood_bank_id, donation_date, quantity)
VALUES 
    (1, 1, '2024-01-15', 500),
    (2, 2, '2024-02-10', 450),
    (3, 1, '2024-02-20', 500),
    (1, 2, '2024-03-05', 600);

-- Insert Blood Stock
INSERT INTO Blood_Stock (blood_bank_id, blood_type, quantity)
VALUES 
    (1, 'O+', 500),
    (1, 'B-', 500),
    (2, 'A+', 450),
    (2, 'O+', 600);

-- Insert Blood Requests
INSERT INTO Request (hospital_id, blood_bank_id, blood_type, quantity, request_date, status)
VALUES 
    (1, 1, 'O+', 300, '2024-02-25', 'Pending'),
    (2, 2, 'A+', 200, '2024-03-10', 'Approved'),
    (1, 2, 'O+', 400, '2024-03-12', 'Rejected');

-- Find all donors who have donated blood more than 1 times.
SELECT d.donor_id, d.name, COUNT(dn.donation_id) AS donation_count
FROM Donor d
JOIN Donation dn ON d.donor_id = dn.donor_id
GROUP BY d.donor_id, d.name
HAVING COUNT(dn.donation_id) > 1;

-- Retrieve the total quantity of each blood type available in all blood banks.
SELECT blood_type, SUM(quantity) AS total_quantity
FROM Blood_Stock
GROUP BY blood_type;

-- List the hospitals that have made the highest number of blood requests.
SELECT h.name, COUNT(r.request_id) AS total_requests
FROM Hospital h
JOIN Request r ON h.hospital_id = r.hospital_id
GROUP BY h.name
ORDER BY total_requests DESC
LIMIT 1;

-- Find which blood bank has the highest stock of O+ blood.
SELECT bb.name, bs.quantity
FROM Blood_Bank bb
JOIN Blood_Stock bs ON bb.blood_bank_id = bs.blood_bank_id
WHERE bs.blood_type = 'O+'
ORDER BY bs.quantity DESC
LIMIT 1;

-- Retrieve all pending blood requests along with hospital details.
SELECT r.request_id, h.name AS hospital_name, bb.name AS blood_bank_name, 
       r.blood_type, r.quantity, r.request_date
FROM Request r
JOIN Hospital h ON r.hospital_id = h.hospital_id
JOIN Blood_Bank bb ON r.blood_bank_id = bb.blood_bank_id
WHERE r.status = 'Pending';

-- List donors who have never donated blood.
SELECT d.donor_id, d.name
FROM Donor d
LEFT JOIN Donation dn ON d.donor_id = dn.donor_id
WHERE dn.donation_id IS NULL;

-- Find hospitals that have requested a specific blood type at least 2 times.
SELECT h.name, r.blood_type, COUNT(r.request_id) AS total_requests
FROM Request r
JOIN Hospital h ON r.hospital_id = h.hospital_id
GROUP BY h.name, r.blood_type
HAVING COUNT(r.request_id) >= 2;

-- Show the donation history of a specific donor
SELECT dn.donation_id, d.name, dn.donation_date, dn.quantity, bb.name AS blood_bank
FROM Donation dn
JOIN Donor d ON dn.donor_id = d.donor_id
JOIN Blood_Bank bb ON dn.blood_bank_id = bb.blood_bank_id
WHERE d.name = 'John Doe'
ORDER BY dn.donation_date DESC;

-- Retrieve the most recent blood donation in each blood bank.
SELECT bb.name AS blood_bank, MAX(dn.donation_date) AS last_donation_date
FROM Donation dn
JOIN Blood_Bank bb ON dn.blood_bank_id = bb.blood_bank_id
GROUP BY bb.name;

-- Find the average quantity of blood donated per donor.
SELECT d.name, AVG(dn.quantity) AS avg_quantity
FROM Donor d
JOIN Donation dn ON d.donor_id = dn.donor_id
GROUP BY d.name
ORDER BY avg_quantity DESC;

-- List donors who have donated at different blood banks.
SELECT d.name, COUNT(DISTINCT dn.blood_bank_id) AS different_banks
FROM Donor d
JOIN Donation dn ON d.donor_id = dn.donor_id
GROUP BY d.name
HAVING COUNT(DISTINCT dn.blood_bank_id) > 1;

-- Retrieve hospitals with the highest number of approved blood requests.
SELECT h.name, COUNT(r.request_id) AS approved_requests
FROM Request r
JOIN Hospital h ON r.hospital_id = h.hospital_id
WHERE r.status = 'Approved'
GROUP BY h.name
ORDER BY approved_requests DESC
LIMIT 3;

-- Show blood stock percentage in each blood bank.
SELECT bb.name AS blood_bank, bs.blood_type, 
       bs.quantity, 
       ROUND((bs.quantity::decimal / (SELECT SUM(quantity) FROM Blood_Stock)) * 100, 2) AS percentage
FROM Blood_Stock bs
JOIN Blood_Bank bb ON bs.blood_bank_id = bb.blood_bank_id
ORDER BY percentage DESC;