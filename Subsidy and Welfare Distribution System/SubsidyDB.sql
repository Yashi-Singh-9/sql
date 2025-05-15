-- Creating the database
CREATE DATABASE SubsidyDB;
USE SubsidyDB;

-- Beneficiaries Table 
CREATE TABLE beneficiaries (
  beneficiary_id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  dob DATE NOT NULL,
  gender ENUM('Male', 'Female', 'Other') NOT NULL,
  national_id VARCHAR(20) UNIQUE NOT NULL,
  phone BIGINT UNIQUE,
  address TEXT NOT NULL
);

-- Programs Table  
CREATE TABLE programs (
  program_id INT PRIMARY KEY AUTO_INCREMENT,
  program_name VARCHAR(100) NOT NULL,
  description TEXT,
  budget DECIMAL(15,2) NOT NULL,
  eligibility_criteria TEXT NOT NULL
);

-- Subsidy Distributions Table
CREATE TABLE subsidy_distributions (
  distribution_id INT PRIMARY KEY AUTO_INCREMENT,
  beneficiary_id INT NOT NULL,
  program_id INT NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  distribution_date DATE NOT NULL,
  status ENUM('Pending', 'Approved', 'Rejected') DEFAULT 'Pending',
  FOREIGN KEY (beneficiary_id) REFERENCES beneficiaries(beneficiary_id),
  FOREIGN KEY (program_id) REFERENCES programs(program_id)
);

-- Payments Table  
CREATE TABLE payments (
  payment_id INT PRIMARY KEY AUTO_INCREMENT,
  distribution_id INT NOT NULL,
  payment_date DATE NOT NULL,
  payment_method ENUM('Bank Transfer', 'Cash', 'Mobile Wallet') NOT NULL,
  transaction_id INT UNIQUE NOT NULL,
  status ENUM('Completed', 'Failed', 'Pending') DEFAULT 'Pending',
  FOREIGN KEY (distribution_id) REFERENCES subsidy_distributions(distribution_id)
);

-- Government Agencies Table
CREATE TABLE goverment_agencies (
  agency_id INT PRIMARY KEY AUTO_INCREMENT,
  agency_name VARCHAR(100) NOT NULL,
  contact_person VARCHAR(100) NOT NULL,
  contact_email VARCHAR(100) UNIQUE NOT NULL,
  phone BIGINT UNIQUE
);

-- Program Agencies Table 
CREATE TABLE program_agencies (
  program_id INT NOT NULL,
  agency_id INT NOT NULL,
  assigned_date DATE DEFAULT CURRENT_DATE,
  FOREIGN KEY (program_id) REFERENCES programs(program_id),
  FOREIGN KEY (agency_id) REFERENCES goverment_agencies(agency_id)
);

-- Insert sample data into beneficiaries table
INSERT INTO beneficiaries (name, dob, gender, national_id, phone, address) VALUES
('John Doe', '1985-06-15', 'Male', 'NID12345', 9876543210, '123 Main St, City A'),
('Jane Smith', '1990-09-20', 'Female', 'NID67890', 9876543211, '456 Oak St, City B'),
('Alice Johnson', '1978-03-11', 'Female', 'NID11223', 9876543212, '789 Pine St, City C'),
('Bob Williams', '1995-12-05', 'Male', 'NID44556', 9876543213, '101 Maple St, City D'),
('Emma Brown', '1982-07-25', 'Female', 'NID77889', 9876543214, '202 Birch St, City E');

-- Insert sample data into programs table
INSERT INTO programs (program_name, description, budget, eligibility_criteria) VALUES
('Food Assistance', 'Provides food subsidies to low-income families', 1000000.00, 'Income below 20,000 per year'),
('Housing Support', 'Helps with rent subsidies', 2000000.00, 'No home ownership and income below 30,000 per year'),
('Health Coverage', 'Provides medical aid to unemployed individuals', 1500000.00, 'Unemployed for at least 6 months'),
('Education Grants', 'Scholarships for underprivileged students', 1200000.00, 'Enrolled in school with a GPA above 3.0'),
('Small Business Aid', 'Support for small businesses affected by crisis', 2500000.00, 'Business revenue decline of at least 30%');

-- Insert sample data into subsidy_distributions table
INSERT INTO subsidy_distributions (beneficiary_id, program_id, amount, distribution_date, status) VALUES
(1, 1, 500.00, '2024-01-10', 'Approved'),
(2, 2, 750.00, '2024-02-15', 'Pending'),
(3, 3, 600.00, '2024-03-20', 'Rejected'),
(4, 1, 500.00, '2024-01-25', 'Approved'),
(5, 4, 800.00, '2024-04-10', 'Approved'),
(1, 2, 700.00, '2024-02-05', 'Approved'),
(3, 5, 1000.00, '2024-05-15', 'Pending');

-- Insert sample data into payments table
INSERT INTO payments (distribution_id, payment_date, payment_method, transaction_id, status) VALUES
(1, '2024-01-12', 'Bank Transfer', 100001, 'Completed'),
(2, '2024-02-18', 'Cash', 100002, 'Pending'),
(4, '2024-01-28', 'Mobile Wallet', 100003, 'Completed'),
(5, '2024-04-12', 'Bank Transfer', 100004, 'Completed'),
(7, '2024-05-18', 'Cash', 100005, 'Pending');

-- Insert sample data into goverment_agencies table
INSERT INTO goverment_agencies (agency_name, contact_person, contact_email, phone) VALUES
('Ministry of Social Welfare', 'Michael Carter', 'michael@welfare.gov', 9876543220),
('Housing Department', 'Sarah Connor', 'sarah@housing.gov', 9876543221),
('Health Ministry', 'David Anderson', 'david@health.gov', 9876543222),
('Education Board', 'Emily Davis', 'emily@edu.gov', 9876543223),
('Small Business Authority', 'Robert Smith', 'robert@business.gov', 9876543224);

-- Insert sample data into program_agencies table
INSERT INTO program_agencies (program_id, agency_id, assigned_date) VALUES
(1, 1, '2024-01-01'),
(2, 2, '2024-02-01'),
(3, 3, '2024-03-01'),
(4, 4, '2024-04-01'),
(5, 5, '2024-05-01'),
(1, 3, '2024-06-01'),
(2, 5, '2024-07-01');

-- 1. Find all beneficiaries who have received subsidies of more than $1000 in the last year.
SELECT b.beneficiary_id, b.name, SUM(sd.amount) AS total_subsidy
FROM subsidy_distributions sd
JOIN beneficiaries b ON sd.beneficiary_id = b.beneficiary_id
WHERE sd.distribution_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY b.beneficiary_id, b.name
HAVING total_subsidy > 1000;

-- 2. List all programs along with the total amount distributed in each program.
SELECT p.program_id, p.program_name, COALESCE(SUM(sd.amount), 0) AS total_distributed
FROM programs p
LEFT JOIN subsidy_distributions sd ON p.program_id = sd.program_id
GROUP BY p.program_id, p.program_name;

-- 3. Find beneficiaries who have received subsidies from more than one program.
SELECT sd.beneficiary_id, b.name, COUNT(DISTINCT sd.program_id) AS program_count
FROM subsidy_distributions sd
JOIN beneficiaries b ON sd.beneficiary_id = b.beneficiary_id
GROUP BY sd.beneficiary_id, b.name
HAVING program_count > 1;

-- 4. Find the agency managing the highest number of programs.
SELECT ga.agency_id, ga.agency_name, COUNT(pa.program_id) AS program_count
FROM goverment_agencies ga
JOIN program_agencies pa ON ga.agency_id = pa.agency_id
GROUP BY ga.agency_id, ga.agency_name
ORDER BY program_count DESC
LIMIT 1;

-- 5. List all pending subsidy distributions along with beneficiary details.
SELECT sd.*, b.name, b.phone, b.address
FROM subsidy_distributions sd
JOIN beneficiaries b ON sd.beneficiary_id = b.beneficiary_id
WHERE sd.status = 'Pending';

-- 6. Get the total budget allocated versus the total distributed amount for each program.
SELECT p.program_id, p.program_name, p.budget, 
       COALESCE(SUM(sd.amount), 0) AS total_distributed
FROM programs p
LEFT JOIN subsidy_distributions sd ON p.program_id = sd.program_id
GROUP BY p.program_id, p.program_name, p.budget;

-- 7. Find the most used payment method for subsidies.
SELECT p.payment_method, COUNT(*) AS usage_count
FROM payments p
GROUP BY p.payment_method
ORDER BY usage_count DESC
LIMIT 1;

-- 8. Find beneficiaries who have received the highest subsidy amount.
SELECT b.beneficiary_id, b.name, SUM(sd.amount) AS total_subsidy
FROM subsidy_distributions sd
JOIN beneficiaries b ON sd.beneficiary_id = b.beneficiary_id
GROUP BY b.beneficiary_id, b.name
ORDER BY total_subsidy DESC
LIMIT 1;

-- 9. List the top 3 programs with the highest number of beneficiaries.
SELECT p.program_id, p.program_name, COUNT(sd.beneficiary_id) AS total_beneficiaries
FROM subsidy_distributions sd
JOIN programs p ON sd.program_id = p.program_id
GROUP BY p.program_id, p.program_name
ORDER BY total_beneficiaries DESC
LIMIT 3;

-- 10. Find beneficiaries who have received subsidies but haven’t received any payments yet.
SELECT DISTINCT b.beneficiary_id, b.name
FROM subsidy_distributions sd
JOIN beneficiaries b ON sd.beneficiary_id = b.beneficiary_id
LEFT JOIN payments p ON sd.distribution_id = p.distribution_id
WHERE p.payment_id IS NULL;

-- 11. Find the total number of approved, pending, and rejected subsidy distributions.
SELECT status, COUNT(*) AS total_distributions
FROM subsidy_distributions
GROUP BY status;

-- 12. Find the government agency managing the highest budget across all programs.
SELECT ga.agency_id, ga.agency_name, SUM(p.budget) AS total_budget
FROM goverment_agencies ga
JOIN program_agencies pa ON ga.agency_id = pa.agency_id
JOIN programs p ON pa.program_id = p.program_id
GROUP BY ga.agency_id, ga.agency_name
ORDER BY total_budget DESC
LIMIT 1;

-- 13. List all beneficiaries and the total subsidy they have received, including those who received none.
SELECT b.beneficiary_id, b.name, COALESCE(SUM(sd.amount), 0) AS total_subsidy
FROM beneficiaries b
LEFT JOIN subsidy_distributions sd ON b.beneficiary_id = sd.beneficiary_id
GROUP BY b.beneficiary_id, b.name
ORDER BY total_subsidy DESC;

-- 14. Find the average subsidy amount distributed per beneficiary.
SELECT AVG(total_subsidy) AS average_subsidy
FROM (
    SELECT b.beneficiary_id, SUM(sd.amount) AS total_subsidy
    FROM beneficiaries b
    LEFT JOIN subsidy_distributions sd ON b.beneficiary_id = sd.beneficiary_id
    GROUP BY b.beneficiary_id
) AS subsidy_totals;
