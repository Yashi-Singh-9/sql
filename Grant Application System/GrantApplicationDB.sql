CREATE DATABASE GrantApplicationDB;
USE GrantApplicationDB;

-- Users Table  
CREATE TABLE users (
  user_id INT IDENTITY(1,1) PRIMARY KEY,
  first_name VARCHAR(20),
  last_name VARCHAR(20),
  email VARCHAR(50) UNIQUE,
  password TEXT,
  phone_number BIGINT,
  role VARCHAR(10) CHECK (role IN ('Applicant', 'Reviewer', 'Admin'))
);

-- Grant Programs Table 
CREATE TABLE grant_programs (
  grant_id INT IDENTITY(1,1) PRIMARY KEY,
  grant_name VARCHAR(20),
  description TEXT,
  funding_amount DECIMAL(10,2),
  application_deadline DATE
);

-- Applications Table 
CREATE TABLE applications (
  application_id INT IDENTITY(1,1) PRIMARY KEY,
  user_id INT,
  grant_id INT,
  submission_date DATE,
  status VARCHAR(15) CHECK (status IN ('Submitted', 'Under Review', 'Approved', 'Rejected')),
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (grant_id) REFERENCES grant_programs(grant_id)
);

-- Application Documents Table 
CREATE TABLE application_documents (
  document_id INT IDENTITY(1,1) PRIMARY KEY,
  application_id INT,
  document_name VARCHAR(20),
  document_type VARCHAR(20),
  upload_date DATE,
  FOREIGN KEY (application_id) REFERENCES applications(application_id)
);

-- Reviews Table  
CREATE TABLE reviews (
  review_id INT IDENTITY(1,1) PRIMARY KEY,
  application_id INT,
  reviewer_id INT,
  comments TEXT,
  rating INT CHECK (rating BETWEEN 1 AND 10),
  review_date DATE,
  FOREIGN KEY (application_id) REFERENCES applications(application_id),
  FOREIGN KEY (reviewer_id) REFERENCES users(user_id)
);

-- Funds Disbursement Table 
CREATE TABLE funds_disbursement (
  disbursement_id INT IDENTITY(1,1) PRIMARY KEY,
  application_id INT,
  amount_disbursed DECIMAL(10,2),
  disbursement_date DATE,
  payment_status VARCHAR(10) CHECK (payment_status IN ('Pending', 'Completed')),
  FOREIGN KEY (application_id) REFERENCES applications(application_id)
);  

-- Audit Logs Table 
CREATE TABLE audit_logs (
  log_id INT IDENTITY(1,1) PRIMARY KEY,
  user_id INT,
  action VARCHAR(50),
  timestamp DATETIME,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);  

-- Insert into Users Table
INSERT INTO users (first_name, last_name, email, password, phone_number, role) VALUES
('Alice', 'Johnson', 'alice@example.com', 'password1', 1234567890, 'Applicant'),
('Bob', 'Smith', 'bob@example.com', 'password2', 1234567891, 'Reviewer'),
('Charlie', 'Brown', 'charlie@example.com', 'password3', 1234567892, 'Admin'),
('David', 'Williams', 'david@example.com', 'password4', 1234567893, 'Applicant'),
('Emma', 'Davis', 'emma@example.com', 'password5', 1234567894, 'Reviewer'),
('Frank', 'Miller', 'frank@example.com', 'password6', 1234567895, 'Applicant'),
('Grace', 'Wilson', 'grace@example.com', 'password7', 1234567896, 'Applicant');

-- Insert into Grant Programs Table
INSERT INTO grant_programs (grant_name, description, funding_amount, application_deadline) VALUES
('Tech Grant', 'Funding for tech startups', 50000.00, '2025-06-30'),
('Health Grant', 'Funding for healthcare research', 75000.00, '2025-07-15'),
('Edu Grant', 'Support for education programs', 60000.00, '2025-08-01'),
('Agri Grant', 'Funds for agricultural projects', 45000.00, '2025-09-10'),
('Energy Grant', 'Renewable energy support', 90000.00, '2025-10-05'),
('Infra Grant', 'Infrastructure development funding', 120000.00, '2025-11-20'),
('Arts Grant', 'Support for artists and creators', 30000.00, '2025-12-01');

-- Insert into Applications Table
INSERT INTO applications (user_id, grant_id, submission_date, status) VALUES
(1, 1, '2025-02-01', 'Submitted'),
(4, 2, '2025-02-05', 'Under Review'),
(6, 3, '2025-02-10', 'Approved'),
(1, 4, '2025-02-12', 'Rejected'),
(4, 5, '2025-02-15', 'Submitted'),
(6, 6, '2025-02-18', 'Under Review'),
(7, 7, '2025-02-20', 'Submitted');

-- Insert into Application Documents Table
INSERT INTO application_documents (application_id, document_name, document_type, upload_date) VALUES
(1, 'Proposal1', 'PDF', '2025-02-02'),
(2, 'Proposal2', 'DOC', '2025-02-06'),
(3, 'Proposal3', 'PDF', '2025-02-11'),
(4, 'Proposal4', 'DOCX', '2025-02-13'),
(5, 'Proposal5', 'PDF', '2025-02-16'),
(6, 'Proposal6', 'DOC', '2025-02-19'),
(7, 'Proposal7', 'PDF', '2025-02-21');

-- Insert into Reviews Table
INSERT INTO reviews (application_id, reviewer_id, comments, rating, review_date) VALUES
(1, 2, 'Good proposal', 8, '2025-02-03'),
(2, 5, 'Needs improvements', 6, '2025-02-07'),
(3, 2, 'Excellent work', 10, '2025-02-12'),
(4, 5, 'Lack of details', 5, '2025-02-14'),
(5, 2, 'Strong case', 9, '2025-02-17'),
(6, 5, 'Moderate proposal', 7, '2025-02-20'),
(7, 2, 'Decent effort', 8, '2025-02-22');

-- Insert into Funds Disbursement Table
INSERT INTO funds_disbursement (application_id, amount_disbursed, disbursement_date, payment_status) VALUES
(3, 60000.00, '2025-02-15', 'Completed'),
(5, 45000.00, '2025-02-18', 'Pending'),
(1, 50000.00, '2025-02-20', 'Completed'),
(7, 30000.00, '2025-02-22', 'Pending'),
(6, 120000.00, '2025-02-24', 'Completed'),
(2, 75000.00, '2025-02-26', 'Completed'),
(4, 90000.00, '2025-02-28', 'Pending');

-- Insert into Audit Logs Table
INSERT INTO audit_logs (user_id, action, timestamp) VALUES
(1, 'Login', '2025-02-01 10:00:00'),
(2, 'Review Submitted', '2025-02-03 14:00:00'),
(3, 'Updated Grant', '2025-02-05 09:30:00'),
(4, 'Submitted Application', '2025-02-07 16:45:00'),
(5, 'Reviewed Application', '2025-02-09 12:20:00'),
(6, 'Application Approved', '2025-02-11 08:10:00'),
(7, 'Funds Disbursed', '2025-02-13 17:25:00');

-- Retrieve all grant programs with a funding amount greater than $10,000.
SELECT * 
FROM grant_programs 
WHERE funding_amount > 10000;

-- Find all applications submitted by a specific user.
SELECT * 
FROM applications 
WHERE user_id = 4;

-- Retrieve all applications that are currently under review.
SELECT * 
FROM applications 
WHERE status = 'Under Review';

-- Get a list of documents uploaded for a specific application.
SELECT * 
FROM application_documents 
WHERE application_id = 6;

-- Retrieve the total number of applications for each grant.
SELECT reviews.*, users.first_name, users.last_name 
FROM reviews 
JOIN users ON reviews.reviewer_id = users.user_id 
WHERE application_id = 5;

-- Find all reviews for a specific application along with reviewer comments.
SELECT reviews.*, users.first_name, users.last_name FROM reviews 
JOIN users ON reviews.reviewer_id = users.user_id 
WHERE application_id = 1;

-- -- Retrieve all approved applications that have received fund disbursements.
SELECT * 
FROM applications 
WHERE status = 'Approved' 
AND application_id IN (SELECT application_id FROM funds_disbursement);

-- Find the average rating for applications under a specific grant.
SELECT grant_id, AVG(rating) AS average_rating FROM reviews 
JOIN applications ON reviews.application_id = applications.application_id 
WHERE grant_id = 4 GROUP BY grant_id;

-- Retrieve a list of funds disbursed along with the applicant details.
SELECT funds_disbursement.*, users.first_name, users.last_name FROM funds_disbursement 
JOIN applications ON funds_disbursement.application_id = applications.application_id 
JOIN users ON applications.user_id = users.user_id;

-- Retrieve the most recent applications submitted.
SELECT TOP 3 * 
FROM applications 
ORDER BY submission_date DESC;

-- Count the number of applications in each status category.
SELECT status, COUNT(*) AS count 
FROM applications 
GROUP BY status;

-- Find the top 5 grants with the highest number of applications.
SELECT TOP 4 grant_id, COUNT(*) AS total_applications 
FROM applications 
GROUP BY grant_id 
ORDER BY total_applications DESC;

-- Retrieve the details of the latest review for each application.
SELECT r.* FROM reviews r
JOIN (SELECT application_id, MAX(review_date) AS latest_review FROM reviews GROUP BY application_id) latest
ON r.application_id = latest.application_id AND r.review_date = latest.latest_review;

-- Find the total amount disbursed for each grant program.
SELECT g.grant_name, SUM(f.amount_disbursed) AS total_disbursed FROM funds_disbursement f
JOIN applications a ON f.application_id = a.application_id
JOIN grant_programs g ON a.grant_id = g.grant_id
GROUP BY g.grant_name;