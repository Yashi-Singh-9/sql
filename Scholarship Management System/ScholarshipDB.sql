-- Project in PostgreSQL 
-- Create the database
CREATE DATABASE ScholarshipDB;
\c ScholarshipDB;

-- Students Table 
CREATE TABLE students (
  student_id SERIAL PRIMARY KEY,
  student_name VARCHAR(50),
  email VARCHAR(100) UNIQUE,
  phone BIGINT,
  date_of_birth DATE,
  address VARCHAR(100),
  programs VARCHAR(100)
);

-- Scholarships Table 
CREATE TABLE scholarships (
  scholarship_id SERIAL PRIMARY KEY,
  scholarship_name VARCHAR(50),
  amount DECIMAL(10,2),
  eligibility_criteria TEXT,
  application_deadline DATE
);

-- Applications Table  
CREATE TABLE applications (
  application_id SERIAL PRIMARY KEY,
  student_id INT,
  scholarship_id INT,
  status VARCHAR(9) CHECK (status IN ('Pending', 'Approved', 'Rejected')),
  date_applied DATE,
  FOREIGN KEY (student_id) REFERENCES students(student_id),
  FOREIGN KEY (scholarship_id) REFERENCES scholarships(scholarship_id)
);

-- Awarded Scholarships Table 
CREATE TABLE awarded_scholarships (
  award_id SERIAL PRIMARY KEY,
  application_id INT,
  award_date DATE,
  disbursement_status VARCHAR(50),
  FOREIGN KEY (application_id) REFERENCES applications(application_id)
);

-- Universities Table  
CREATE TABLE universities (
  university_id SERIAL PRIMARY KEY,
  university_name VARCHAR(100),
  locations VARCHAR(50),
  ranking INT
);

-- Student University Table
CREATE TABLE student_university (
  student_university_id SERIAL PRIMARY KEY,
  student_id INT,
  university_id INT,
  FOREIGN KEY (student_id) REFERENCES students(student_id),
  FOREIGN KEY (university_id) REFERENCES universities(university_id)
);

-- Donors Table 
CREATE TABLE donors (
  donor_id SERIAL PRIMARY KEY,
  donor_name VARCHAR(50),
  contact_info BIGINT,
  donation_amount DECIMAL(10,2)
);

-- Scholarship Donor Table
CREATE TABLE scholarship_donor (
  scholarship_donor_id SERIAL PRIMARY KEY,
  scholarship_id INT,
  donor_id INT,
  FOREIGN KEY (scholarship_id) REFERENCES scholarships(scholarship_id),
  FOREIGN KEY (donor_id) REFERENCES donors(donor_id)
);  

-- Insert sample data into students table
INSERT INTO students (student_name, email, phone, date_of_birth, address, programs) VALUES
('Alice Johnson', 'alice@example.com', 1234567890, '2000-05-14', '123 Main St, NY', 'Computer Science'),
('Bob Smith', 'bob@example.com', 9876543210, '1999-08-22', '456 Elm St, CA', 'Mechanical Engineering'),
('Charlie Brown', 'charlie@example.com', 1122334455, '2001-11-10', '789 Oak St, TX', 'Business Administration'),
('David Lee', 'david@example.com', 2233445566, '2002-01-15', '101 Pine St, FL', 'Electrical Engineering'),
('Emma Watson', 'emma@example.com', 3344556677, '1998-06-30', '202 Maple St, IL', 'Medicine'),
('Frank White', 'frank@example.com', 4455667788, '2003-09-25', '303 Cedar St, WA', 'Law');

-- Insert sample data into scholarships table
INSERT INTO scholarships (scholarship_name, amount, eligibility_criteria, application_deadline) VALUES
('Merit Scholarship', 5000.00, 'GPA > 3.5', '2025-01-01'),
('Need-Based Scholarship', 3000.00, 'Family income < $40,000', '2025-02-15'),
('STEM Scholarship', 4000.00, 'Majoring in STEM fields', '2025-03-10'),
('Arts Excellence Scholarship', 2000.00, 'Outstanding performance in Arts', '2025-04-05'),
('Athletic Scholarship', 3500.00, 'Exceptional sports performance', '2025-05-20'),
('Community Service Scholarship', 2500.00, 'Volunteering experience', '2025-06-30');

-- Insert sample data into applications table
INSERT INTO applications (student_id, scholarship_id, status, date_applied) VALUES
(1, 1, 'Pending', '2024-12-01'),
(2, 3, 'Approved', '2024-11-15'),
(3, 2, 'Rejected', '2024-10-10'),
(4, 4, 'Pending', '2024-09-05'),
(5, 5, 'Approved', '2024-08-20'),
(6, 6, 'Rejected', '2024-07-25');

-- Insert sample data into awarded_scholarships table
INSERT INTO awarded_scholarships (application_id, award_date, disbursement_status) VALUES
(2, '2024-12-10', 'Disbursed'),
(5, '2024-09-01', 'Pending'),
(1, '2024-12-15', 'Processing'),
(4, '2024-10-05', 'Disbursed'),
(3, '2024-08-30', 'Rejected'),
(6, '2024-07-28', 'Rejected');

-- Insert sample data into universities table
INSERT INTO universities (university_name, locations, ranking) VALUES
('Harvard University', 'USA', 1),
('Stanford University', 'USA', 2),
('MIT', 'USA', 3),
('Oxford University', 'UK', 4),
('Cambridge University', 'UK', 5),
('University of Toronto', 'Canada', 6);

-- Insert sample data into student_university table
INSERT INTO student_university (student_id, university_id) VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6);

-- Insert sample data into donors table
INSERT INTO donors (donor_name, contact_info, donation_amount) VALUES
('John Doe', 5551112222, 10000.00),
('Jane Smith', 5553334444, 8000.00),
('Michael Brown', 5555556666, 12000.00),
('Emily Davis', 5557778888, 5000.00),
('Chris Wilson', 5559990000, 7000.00),
('Olivia Taylor', 5552223333, 9000.00);

-- Insert sample data into scholarship_donor table
INSERT INTO scholarship_donor (scholarship_id, donor_id) VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6);

-- Find the total amount of scholarships awarded to a specific student.
SELECT s.student_id, s.student_name, COALESCE(SUM(sch.amount), 0) AS total_awarded
FROM awarded_scholarships aw
JOIN applications a ON aw.application_id = a.application_id
JOIN scholarships sch ON a.scholarship_id = sch.scholarship_id
JOIN students s ON a.student_id = s.student_id
WHERE s.student_id = 2
GROUP BY s.student_id, s.student_name;

-- List all students who applied for a scholarship but were rejected.
SELECT DISTINCT s.student_id, s.student_name
FROM students s
JOIN applications a ON s.student_id = a.student_id
WHERE a.status = 'Rejected';

-- Get the names of universities that have the highest number of students receiving scholarships.
SELECT u.university_name, COUNT(aw.award_id) AS total_awards
FROM awarded_scholarships aw
JOIN applications a ON aw.application_id = a.application_id
JOIN students s ON a.student_id = s.student_id
JOIN student_university su ON s.student_id = su.student_id
JOIN universities u ON su.university_id = u.university_id
GROUP BY u.university_name
ORDER BY total_awards DESC
LIMIT 1;

-- List students along with the names of scholarships they received.
SELECT s.student_id, s.student_name, sch.scholarship_name
FROM awarded_scholarships aw
JOIN applications a ON aw.application_id = a.application_id
JOIN scholarships sch ON a.scholarship_id = sch.scholarship_id
JOIN students s ON a.student_id = s.student_id;

-- Retrieve the latest awarded scholarships sorted by award date.
SELECT aw.award_id, s.student_name, sch.scholarship_name, aw.award_date
FROM awarded_scholarships aw
JOIN applications a ON aw.application_id = a.application_id
JOIN scholarships sch ON a.scholarship_id = sch.scholarship_id
JOIN students s ON a.student_id = s.student_id
ORDER BY aw.award_date DESC;

-- Retrieve students along with the number of scholarships they have applied for.
SELECT s.student_id, s.student_name, COUNT(a.application_id) AS total_applications
FROM students s
LEFT JOIN applications a ON s.student_id = a.student_id
GROUP BY s.student_id, s.student_name
ORDER BY total_applications DESC;

-- Find the average amount of scholarships awarded to students.
SELECT AVG(sch.amount) AS avg_scholarship_amount
FROM awarded_scholarships aw
JOIN applications a ON aw.application_id = a.application_id
JOIN scholarships sch ON a.scholarship_id = sch.scholarship_id;

-- List students who received a scholarship but haven't received the disbursement yet.
SELECT s.student_id, s.student_name, sch.scholarship_name, aw.disbursement_status
FROM awarded_scholarships aw
JOIN applications a ON aw.application_id = a.application_id
JOIN scholarships sch ON a.scholarship_id = sch.scholarship_id
JOIN students s ON a.student_id = s.student_id
WHERE aw.disbursement_status NOT IN ('Disbursed');

-- Retrieve the total number of applications per scholarship.
SELECT sch.scholarship_id, sch.scholarship_name, COUNT(a.application_id) AS total_applicants
FROM scholarships sch
LEFT JOIN applications a ON sch.scholarship_id = a.scholarship_id
GROUP BY sch.scholarship_id, sch.scholarship_name
ORDER BY total_applicants DESC;

-- Retrieve the donors who have donated the highest amount.
SELECT donor_id, donor_name, donation_amount
FROM donors
ORDER BY donation_amount DESC
LIMIT 5;

-- Find the number of students per university who have applied for a scholarship.
SELECT u.university_name, COUNT(DISTINCT s.student_id) AS total_students_applied
FROM universities u
JOIN student_university su ON u.university_id = su.university_id
JOIN students s ON su.student_id = s.student_id
JOIN applications a ON s.student_id = a.student_id
GROUP BY u.university_name
ORDER BY total_students_applied DESC;

-- Retrieve scholarships along with the total donation amount they have received. 
SELECT sch.scholarship_name, COALESCE(SUM(d.donation_amount), 0) AS total_donation
FROM scholarships sch
LEFT JOIN scholarship_donor sd ON sch.scholarship_id = sd.scholarship_id
LEFT JOIN donors d ON sd.donor_id = d.donor_id
GROUP BY sch.scholarship_name
ORDER BY total_donation DESC;

-- Retrieve scholarships with the highest approval rate.
SELECT sch.scholarship_id, sch.scholarship_name,
       COUNT(CASE WHEN a.status = 'Approved' THEN 1 END) * 100.0 / COUNT(a.application_id) AS approval_rate
FROM scholarships sch
JOIN applications a ON sch.scholarship_id = a.scholarship_id
GROUP BY sch.scholarship_id, sch.scholarship_name
ORDER BY approval_rate DESC;