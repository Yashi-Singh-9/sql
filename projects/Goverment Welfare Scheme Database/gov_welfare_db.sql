-- Project In MariaDB 
-- Creating the database
CREATE DATABASE gov_welfare_db;
USE gov_welfare_db;

-- Citizens Table
CREATE TABLE citizens (
    citizen_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    dob DATE NOT NULL,
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    aadhar_number VARCHAR(12) UNIQUE NOT NULL,
    address TEXT NOT NULL,
    income DECIMAL(10,2) NOT NULL
);

-- Schemes Table
CREATE TABLE schemes (
    scheme_id INT AUTO_INCREMENT PRIMARY KEY,
    scheme_name VARCHAR(255) UNIQUE NOT NULL,
    eligibility_criteria TEXT NOT NULL,
    benefit_amount DECIMAL(10,2) NOT NULL
);

-- Applications Table
CREATE TABLE applications (
    application_id INT AUTO_INCREMENT PRIMARY KEY,
    citizen_id INT NOT NULL,
    scheme_id INT NOT NULL,
    application_date DATE DEFAULT CURRENT_DATE NOT NULL,
    status ENUM('Pending', 'Approved', 'Rejected') DEFAULT 'Pending',
    FOREIGN KEY (citizen_id) REFERENCES citizens(citizen_id),
    FOREIGN KEY (scheme_id) REFERENCES schemes(scheme_id)
);

-- Payments Table
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    application_id INT NOT NULL,
    payment_date DATE DEFAULT CURRENT_DATE NOT NULL,
    amount_paid DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (application_id) REFERENCES applications(application_id)
);

-- Insert Citizens Data
INSERT INTO citizens (name, dob, gender, aadhar_number, address, income) VALUES
('Amit Sharma', '1985-07-12', 'Male', '123456789012', 'Delhi, India', 300000.00),
('Priya Verma', '1992-03-25', 'Female', '987654321098', 'Mumbai, India', 250000.00),
('Rohit Mehra', '1995-08-10', 'Male', '456789123456', 'Kolkata, India', 150000.00),
('Neha Kapoor', '1990-11-15', 'Female', '789123456789', 'Chennai, India', 200000.00),
('Rajesh Kumar', '1980-05-20', 'Male', '321654987654', 'Pune, India', 180000.00);

-- Insert Schemes Data
INSERT INTO schemes (scheme_name, eligibility_criteria, benefit_amount) VALUES
('Pension Scheme', 'Age > 60 and Income < 200000', 5000.00),
('Education Scholarship', 'Income < 300000 and Age < 25', 25000.00),
('Healthcare Benefits', 'Income < 250000', 15000.00),
('Housing Scheme', 'Income < 200000', 100000.00);

-- Insert Applications Data
INSERT INTO applications (citizen_id, scheme_id, application_date, status) VALUES
(1, 1, '2025-01-05', 'Approved'),
(2, 2, '2025-02-10', 'Pending'),
(3, 3, '2025-01-20', 'Rejected'),
(4, 4, '2025-02-15', 'Approved'),
(5, 3, '2025-02-18', 'Approved');

-- Insert Payments Data
INSERT INTO payments (application_id, payment_date, amount_paid) VALUES
(1, '2025-02-01', 5000.00),
(4, '2025-02-20', 100000.00),
(5, '2025-02-25', 15000.00);

--  Find all citizens who applied for a scheme but were rejected.
SELECT c.name, a.application_id, s.scheme_name
FROM applications a
JOIN citizens c ON a.citizen_id = c.citizen_id
JOIN schemes s ON a.scheme_id = s.scheme_id
WHERE a.status = 'Rejected';

-- List all schemes along with the total number of applications received.
SELECT s.scheme_name, COUNT(a.application_id) AS total_applications
FROM schemes s
LEFT JOIN applications a ON s.scheme_id = a.scheme_id
GROUP BY s.scheme_name;

-- Find the total amount paid for each scheme.
SELECT s.scheme_name, SUM(p.amount_paid) AS total_paid
FROM payments p
JOIN applications a ON p.application_id = a.application_id
JOIN schemes s ON a.scheme_id = s.scheme_id
GROUP BY s.scheme_name;

-- Retrieve the names of all citizens who received payments under a specific scheme.
SELECT DISTINCT c.name
FROM payments p
JOIN applications a ON p.application_id = a.application_id
JOIN citizens c ON a.citizen_id = c.citizen_id
JOIN schemes s ON a.scheme_id = s.scheme_id
WHERE s.scheme_name = 'Healthcare Benefits';

-- Identify the scheme with the highest number of approved applications.
SELECT s.scheme_name, COUNT(a.application_id) AS approved_count
FROM applications a
JOIN schemes s ON a.scheme_id = s.scheme_id
WHERE a.status = 'Approved'
GROUP BY s.scheme_name
ORDER BY approved_count DESC
LIMIT 1;

-- List all citizens along with the schemes they have applied for (even if they haven't applied for any).
SELECT c.name, s.scheme_name, a.status
FROM citizens c
LEFT JOIN applications a ON c.citizen_id = a.citizen_id
LEFT JOIN schemes s ON a.scheme_id = s.scheme_id
ORDER BY c.name;

-- Find the total amount spent on welfare schemes.
SELECT SUM(amount_paid) AS total_amount_spent 
FROM payments;

-- Retrieve the most recent payment made to any citizen.
SELECT c.name, s.scheme_name, p.amount_paid, p.payment_date
FROM payments p
JOIN applications a ON p.application_id = a.application_id
JOIN citizens c ON a.citizen_id = c.citizen_id
JOIN schemes s ON a.scheme_id = s.scheme_id
ORDER BY p.payment_date DESC
LIMIT 1;

-- Get the top 3 schemes with the highest total payments distributed.
SELECT s.scheme_name, SUM(p.amount_paid) AS total_paid
FROM payments p
JOIN applications a ON p.application_id = a.application_id
JOIN schemes s ON a.scheme_id = s.scheme_id
GROUP BY s.scheme_name
ORDER BY total_paid DESC
LIMIT 3;

-- Count the number of citizens by gender who have applied for schemes.
SELECT c.gender, COUNT(DISTINCT c.citizen_id) AS total_applicants
FROM citizens c
JOIN applications a ON c.citizen_id = a.citizen_id
GROUP BY c.gender;

-- Find the scheme with the highest benefit amount.
SELECT scheme_name, benefit_amount
FROM schemes
ORDER BY benefit_amount DESC
LIMIT 1;

--  Find the percentage of applications that are still pending.
SELECT 
    (COUNT(CASE WHEN status = 'Pending' THEN 1 END) * 100.0 / COUNT(*)) AS pending_percentage
FROM applications;

-- Retrieve all rejected applications and the reason if available.
SELECT a.application_id, c.name, s.scheme_name, a.status
FROM applications a
JOIN citizens c ON a.citizen_id = c.citizen_id
JOIN schemes s ON a.scheme_id = s.scheme_id
WHERE a.status = 'Rejected';
