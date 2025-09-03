-- SQL Lite Project
sqlite3 BackgroundCheckDB.db

-- Applicants Table 
CREATE TABLE applicants (
  applicant_id INTEGER PRIMARY KEY,
  first_name VARCHAR(20),
  last_name VARCHAR(20),
  date_of_birth DATE,
  ssn BIGINT UNIQUE,
  email VARCHAR(50) UNIQUE,
  phone BIGINT,
  address VARCHAR(50)
);

INSERT INTO applicants (first_name, last_name, date_of_birth, ssn, email, phone, address) VALUES
('John', 'Doe', '1990-05-15', 123456789, 'john.doe@example.com', 9876543210, '123 Main St, NY'),
('Jane', 'Smith', '1985-08-22', 234567890, 'jane.smith@example.com', 8765432109, '456 Oak St, CA'),
('Robert', 'Brown', '1992-11-10', 345678901, 'robert.brown@example.com', 7654321098, '789 Pine St, TX'),
('Emily', 'Johnson', '1988-03-05', 456789012, 'emily.johnson@example.com', 6543210987, '101 Maple St, FL'),
('Michael', 'Davis', '1995-07-19', 567890123, 'michael.davis@example.com', 5432109876, '202 Cedar St, WA'),
('Sarah', 'Wilson', '1991-09-30', 678901234, 'sarah.wilson@example.com', 4321098765, '303 Birch St, IL'),
('David', 'Martinez', '1987-12-25', 789012345, 'david.martinez@example.com', 3210987654, '404 Walnut St, NV'),
('Emma', 'Anderson', '1993-04-17', 890123456, 'emma.anderson@example.com', 2109876543, '505 Aspen St, CO');

-- Background Checks Table 
CREATE TABLE background_checks (
  check_id INTEGER PRIMARY KEY,
  applicant_id INTEGER,
  check_type VARCHAR(15) CHECK (check_type IN ('Criminal', 'Employment', 'Credit')),
  status VARCHAR(15) CHECK (status IN ('Pending', 'Completed', 'Failed')),
  requested_date DATE,
  completed_date DATE,
  FOREIGN KEY (applicant_id) REFERENCES applicants(applicant_id)
);

INSERT INTO background_checks (applicant_id, check_type, status, requested_date, completed_date) VALUES
(1, 'Criminal', 'Completed', '2024-01-10', '2024-01-15'),
(2, 'Employment', 'Pending', '2024-02-05', NULL),
(3, 'Credit', 'Failed', '2024-01-20', '2024-01-25'),
(4, 'Criminal', 'Completed', '2024-02-01', '2024-02-07'),
(1, 'Employment', 'Pending', '2024-02-10', NULL),
(5, 'Credit', 'Completed', '2024-01-15', '2024-01-22'),
(6, 'Criminal', 'Failed', '2024-02-12', '2024-02-18'),
(3, 'Employment', 'Completed', '2024-02-05', '2024-02-10'),
(7, 'Credit', 'Pending', '2024-02-15', NULL),
(NULL, 'Criminal', 'Pending', '2024-02-18', NULL);

-- Criminal Records Table
CREATE TABLE criminal_records (
  record_id INTEGER PRIMARY KEY,
  applicant_id INTEGER,
  offense VARCHAR(30),
  date_of_offense DATE,
  court_details TEXT,
  verdict VARCHAR(30),
  FOREIGN KEY (applicant_id) REFERENCES applicants(applicant_id)
);

INSERT INTO criminal_records (applicant_id, offense, date_of_offense, court_details, verdict) VALUES
(1, 'Theft', '2018-06-15', 'NY District Court - Case #4587', 'Guilty'),
(3, 'Assault', '2020-09-22', 'TX Supreme Court - Case #7821', 'Not Guilty'),
(5, 'Fraud', '2019-11-10', 'WA Federal Court - Case #3654', 'Guilty'),
(1, 'DUI', '2021-04-03', 'NY District Court - Case #6523', 'Guilty'),
(6, 'Vandalism', '2022-07-19', 'IL County Court - Case #9998', 'Dismissed'),
(NULL, 'Burglary', '2017-08-30', 'Unknown Court - Case #1234', 'Pending');

-- Employment History Table
CREATE TABLE employment_history (
  employment_id INTEGER PRIMARY KEY,
  applicant_id INTEGER,
  company_name VARCHAR(20),
  position VARCHAR(20),
  start_date DATE,
  end_date DATE,
  reference_contact BIGINT,
  FOREIGN KEY (applicant_id) REFERENCES applicants(applicant_id)
);

INSERT INTO employment_history (applicant_id, company_name, position, start_date, end_date, reference_contact) VALUES
(1, 'TechCorp', 'Software Engineer', '2018-06-01', '2022-07-15', 9876543210),
(2, 'HealthPlus', 'Nurse', '2015-03-10', '2020-05-22', 8765432109),
(3, 'BankTrust', 'Accountant', '2017-09-18', '2021-12-30', 7654321098),
(4, 'EduWorld', 'Teacher', '2016-08-25', '2019-10-10', 6543210987),
(1, 'WebSoft', 'Frontend Developer', '2022-09-01', NULL, 5432109876),
(5, 'MediCare', 'Pharmacist', '2019-11-10', '2023-01-15', 4321098765),
(6, 'Construx', 'Civil Engineer', '2014-07-20', '2019-08-30', 3210987654),
(3, 'AutoWorks', 'Financial Analyst', '2022-02-01', NULL, 2109876543),
(7, 'GreenTech', 'Research Scientist', '2018-04-10', '2022-06-30', 7654321987),
(NULL, 'Unknown Co.', 'Unlisted Job', '2020-01-15', '2021-12-31', 8765432190);

-- Education History Table 
CREATE TABLE education_history (
  education_id INTEGER PRIMARY KEY,
  applicant_id INTEGER,
  institution_name VARCHAR(50),
  degree VARCHAR(50),
  start_year INTEGER,
  end_year INTEGER,
  FOREIGN KEY (applicant_id) REFERENCES applicants(applicant_id)
);

INSERT INTO education_history (applicant_id, institution_name, degree, start_year, end_year) VALUES
(1, 'Harvard University', 'B.Sc. Computer Science', 2010, 2014),
(2, 'Stanford University', 'M.Sc. Nursing', 2012, 2016),
(3, 'University of Texas', 'BBA Finance', 2008, 2012),
(4, 'MIT', 'Ph.D. Physics', 2015, 2020),
(1, 'Columbia University', 'M.Sc. Software Engineering', 2015, 2017),
(5, 'University of Washington', 'Doctor of Pharmacy', 2011, 2015),
(6, 'Illinois Institute of Technology', 'B.Sc. Civil Engineering', 2009, 2013),
(NULL, 'Unknown College', 'Unverified Degree', 2016, 2020);

-- Check Results Table
CREATE TABLE check_results (
  result_id INTEGER PRIMARY KEY,
  check_id INTEGER,
  result_description TEXT,
  status VARCHAR(10) CHECK (status IN ('Pass', 'Fail', 'Pending')),
  remarks TEXT,
  FOREIGN KEY (check_id) REFERENCES background_checks(check_id)
);

INSERT INTO check_results (check_id, result_description, status, remarks) VALUES
(1, 'No criminal record found.', 'Pass', 'Cleared for employment.'),
(2, 'Employment verification pending.', 'Pending', 'Waiting for company response.'),
(3, 'Credit score below required threshold.', 'Fail', 'Advised applicant to improve credit score.'),
(4, 'Minor traffic violations, no major offenses.', 'Pass', 'No impact on hiring decision.'),
(5, 'Employment history not verified yet.', 'Pending', 'Follow-up needed with employer.'),
(6, 'Good credit history, no issues found.', 'Pass', 'Meets financial requirements.'),
(7, 'Criminal record found - Vandalism.', 'Fail', 'Further review required by HR.'),
(8, 'Previous employer confirmed work experience.', 'Pass', 'Positive feedback received.'),
(9, 'Credit check in progress.', 'Pending', 'Expected completion within a week.'),
(10, 'Background check request submitted.', 'Pending', 'Awaiting initial report.');

-- Users Table  
CREATE TABLE users (
  user_id INTEGER PRIMARY KEY,
  name VARCHAR(20),
  email VARCHAR(50) UNIQUE,
  phone BIGINT,
  role VARCHAR(10) CHECK (role IN ('Admin', 'HR', 'Employer'))
);

INSERT INTO users (name, email, phone, role) VALUES
('Alice Johnson', 'alice.admin@example.com', 9876543210, 'Admin'),
('Bob Smith', 'bob.hr@example.com', 8765432109, 'HR'),
('Charlie Davis', 'charlie.hr@example.com', 7654321098, 'HR'),
('David Wilson', 'david.employer@example.com', 6543210987, 'Employer'),
('Emma Thompson', 'emma.employer@example.com', 5432109876, 'Employer'),
('Frank Miller', 'frank.admin@example.com', 4321098765, 'Admin'),
('Grace Lee', 'grace.hr@example.com', 3210987654, 'HR'),
('Henry Clark', 'henry.employer@example.com', 2109876543, 'Employer');

-- Check Requests Table
CREATE TABLE check_requests (
  request_id INTEGER PRIMARY KEY,
  user_id INTEGER,
  applicant_id INTEGER,
  check_id INTEGER,
  requested_date DATE,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (applicant_id) REFERENCES applicants(applicant_id),
  FOREIGN KEY (check_id) REFERENCES background_checks(check_id)
);

INSERT INTO check_requests (user_id, applicant_id, check_id, requested_date) VALUES
(2, 1, 1, '2024-01-05'),
(3, 2, 2, '2024-02-01'),
(4, 3, 3, '2024-01-15'),
(5, 4, 4, '2024-02-10'),
(6, 1, 5, '2024-02-12'),
(7, 5, 6, '2024-01-20'),
(8, 6, 7, '2024-02-14'),
(2, 3, 8, '2024-02-05'),
(3, 7, 9, '2024-02-18'),
(5, NULL, 10, '2024-02-20');

-- Find all background checks that are still pending.
SELECT * 
FROM background_checks 
WHERE status = 'Pending';

-- Get the full employment history of a specific applicant.
SELECT * 
FROM employment_history 
WHERE applicant_id = 4 
ORDER BY start_date DESC;

-- List all criminal records of applicants who failed their background check.
SELECT cr.* 
FROM criminal_records cr
JOIN background_checks bc ON cr.applicant_id = bc.applicant_id
WHERE bc.status = 'Failed';

-- Find the number of background checks performed by each user.
SELECT u.user_id, u.name, COUNT(cr.request_id) AS total_checks
FROM users u
LEFT JOIN check_requests cr ON u.user_id = cr.user_id
GROUP BY u.user_id, u.name;

-- Show the average duration taken to complete background checks by type.
SELECT check_type, AVG(julianday(completed_date) - julianday(requested_date)) AS avg_days
FROM background_checks
WHERE completed_date IS NOT NULL
GROUP BY check_type;

-- Fetch all education history for a specific applicant sorted by most recent.
SELECT * 
FROM education_history 
WHERE applicant_id = 2 
ORDER BY end_year DESC;

-- Get the most common reason for background check failures.
SELECT result_description, COUNT(*) AS failure_count
FROM check_results
WHERE status = 'Fail'
GROUP BY result_description
ORDER BY failure_count DESC
LIMIT 1;

-- Find the top 5 most frequently requested background check types.
SELECT check_type, COUNT(*) AS request_count
FROM background_checks
GROUP BY check_type
ORDER BY request_count DESC
LIMIT 5;

-- List all applicants who have failed at least one background check.
SELECT DISTINCT applicant_id 
FROM background_checks 
WHERE status = 'Failed';

-- Get the most recent background check result for each applicant.
SELECT bc.applicant_id, bc.check_id, r.result_description, r.status
FROM background_checks bc
JOIN check_results r ON bc.check_id = r.check_id
WHERE bc.requested_date = (SELECT MAX(requested_date) FROM background_checks WHERE applicant_id = bc.applicant_id);

-- List all applicants who have had more than 1 background checks performed.
SELECT applicant_id, COUNT(*) AS check_count
FROM background_checks
GROUP BY applicant_id
HAVING COUNT(*) > 1;

-- Find users (HR/Employers) who have requested the most background checks.
SELECT u.user_id, u.name, u.role, COUNT(cr.request_id) AS total_requests
FROM users u
JOIN check_requests cr ON u.user_id = cr.user_id
GROUP BY u.user_id, u.name, u.role
ORDER BY total_requests DESC
LIMIT 5;

-- Retrieve all background checks requested by a specific user in a given time period.
SELECT * FROM check_requests
WHERE user_id = 2 AND requested_date BETWEEN '2024-01-01' AND '2024-02-01';

-- Show the percentage of background checks that resulted in a "Pass" vs. "Fail".
SELECT status, COUNT(*) * 100.0 / (SELECT COUNT(*) FROM check_results) AS percentage
FROM check_results
GROUP BY status;

-- List all users who have never requested a background check.
SELECT * 
FROM users 
WHERE user_id NOT IN (SELECT DISTINCT user_id FROM check_requests);

-- Retrieve the total number of background checks performed in the last year.
SELECT COUNT(*) AS total_checks
FROM background_checks
WHERE requested_date >= date('now', '-1 year');

-- List all applicants along with the number of background checks they have undergone.
SELECT a.applicant_id, a.first_name, a.last_name, COUNT(bc.check_id) AS total_checks
FROM applicants a
LEFT JOIN background_checks bc ON a.applicant_id = bc.applicant_id
GROUP BY a.applicant_id, a.first_name, a.last_name;

-- Find the longest duration background check.
SELECT *, (julianday(completed_date) - julianday(requested_date)) AS duration_days
FROM background_checks
WHERE completed_date IS NOT NULL
ORDER BY duration_days DESC
LIMIT 1;

-- Retrieve all applicants whose education degree contains the word 'Engineering'.
SELECT * 
FROM education_history 
WHERE LOWER(degree) LIKE '%engineering%';

-- Find users who requested background checks on more than 1 different applicants.
SELECT user_id, COUNT(DISTINCT applicant_id) AS unique_applicants
FROM check_requests
GROUP BY user_id
HAVING COUNT(DISTINCT applicant_id) > 1;

-- Find the average number of background checks performed per applicant.
SELECT AVG(check_count) AS avg_checks_per_applicant
FROM (SELECT COUNT(*) AS check_count FROM background_checks GROUP BY applicant_id);
