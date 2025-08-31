-- SQL Lite Project
sqlite3 MissingPersonsDB.db

-- Persons Table  
CREATE TABLE persons (
  person_id INTEGER PRIMARY KEY,
  first_name VARCHAR(20),
  last_name VARCHAR(20),
  age INTEGER CHECK (age >= 0), 
  gender VARCHAR(10) CHECK (gender IN ('Female', 'Male', 'Other')),
  date_of_birth DATE,
  last_seen_location VARCHAR(50),
  date_missing DATE,
  photo_url VARCHAR(500)
);

-- Reports Table  
CREATE TABLE reports (
  report_id INTEGER PRIMARY KEY,
  person_id INTEGER,
  reported_by VARCHAR(20),
  contact_number BIGINT,
  relationship_to_person VARCHAR(20),
  report_date DATE,
  status VARCHAR(10) CHECK (status IN ('Open', 'Found', 'Closed')),
  FOREIGN KEY (person_id) REFERENCES persons(person_id)
);

-- Found Persons Table 
CREATE TABLE found_persons (
  found_id INTEGER PRIMARY KEY,
  person_id INTEGER,
  found_date DATE,
  found_location VARCHAR(20),
  found_by VARCHAR(20),
  remarks TEXT,
  FOREIGN KEY (person_id) REFERENCES persons(person_id)
);

-- Investigations Table 
CREATE TABLE investigations (
  investigation_id INTEGER PRIMARY KEY,
  person_id INTEGER,
  assigned_officer VARCHAR(20),
  department VARCHAR(20),
  last_update DATETIME,
  case_status VARCHAR(10) CHECK (case_status IN ('Open', 'In Progress', 'Closed')),
  FOREIGN KEY (person_id) REFERENCES persons(person_id)
);

-- Users Table  
CREATE TABLE users (
  user_id INTEGER PRIMARY KEY,
  username VARCHAR(20),
  password_hash TEXT,
  role VARCHAR(15) CHECK (role IN ('Admin', 'Officer', 'Public User'))
);

-- Insert sample data into persons table
INSERT INTO persons (person_id, first_name, last_name, age, gender, date_of_birth, last_seen_location, date_missing, photo_url) VALUES
(1, 'John', 'Doe', 35, 'Male', '1989-05-14', 'Central Park, NY', '2024-01-10', 'https://example.com/photos/johndoe.jpg'),
(2, 'Jane', 'Smith', 29, 'Female', '1995-08-23', 'Los Angeles, CA', '2023-11-05', 'https://example.com/photos/janesmith.jpg'),
(3, 'Michael', 'Brown', 42, 'Male', '1982-12-30', 'Houston, TX', '2023-12-18', 'https://example.com/photos/michaelbrown.jpg'),
(4, 'Emily', 'Johnson', 19, 'Female', '2005-04-10', 'Miami, FL', '2024-02-01', 'https://example.com/photos/emilyjohnson.jpg'),
(5, 'David', 'Williams', 50, 'Male', '1974-03-15', 'Seattle, WA', '2024-01-22', 'https://example.com/photos/davidwilliams.jpg'),
(6, 'Sophia', 'Miller', 25, 'Female', '1999-07-19', 'Denver, CO', '2023-10-14', 'https://example.com/photos/sophiamiller.jpg'),
(7, 'Christopher', 'Taylor', 38, 'Male', '1986-11-27', 'Chicago, IL', '2024-02-05', 'https://example.com/photos/christophertaylor.jpg'),
(8, 'Olivia', 'Anderson', 17, 'Female', '2006-09-02', 'Phoenix, AZ', '2024-01-30', 'https://example.com/photos/oliviaanderson.jpg'),
(9, 'Liam', 'Martinez', 22, 'Male', '2002-06-12', 'San Francisco, CA', '2023-12-28', 'https://example.com/photos/liammartinez.jpg'),
(10, 'Emma', 'Clark', 31, 'Female', '1993-05-06', 'Las Vegas, NV', '2023-09-20', 'https://example.com/photos/emmaclark.jpg');

-- Insert sample data into reports table
INSERT INTO reports (report_id, person_id, reported_by, contact_number, relationship_to_person, report_date, status) VALUES
(1, 1, 'Alice Doe', 1234567890, 'Sister', '2024-01-12', 'Open'),
(2, 2, 'Robert Smith', 9876543210, 'Brother', '2023-11-07', 'Found'),
(3, 3, 'Sarah Brown', 1112223333, 'Wife', '2023-12-20', 'Open'),
(4, 4, 'David Johnson', 4445556666, 'Father', '2024-02-02', 'Open'),
(5, 5, 'Nancy Williams', 7778889999, 'Wife', '2024-01-24', 'Open'),
(6, 6, 'James Miller', 6667778888, 'Brother', '2023-10-16', 'Found'),
(7, 7, 'Laura Taylor', 5556667777, 'Sister', '2024-02-06', 'Open'),
(8, 8, 'Robert Anderson', 9998887777, 'Father', '2024-01-31', 'Open'),
(9, 9, 'Maria Martinez', 8887776666, 'Mother', '2023-12-30', 'Open'),
(10, 10, 'Oliver Clark', 2223334444, 'Husband', '2023-09-22', 'Closed');

-- Insert sample data into found_persons table
INSERT INTO found_persons (found_id, person_id, found_date, found_location, found_by, remarks) VALUES
(1, 2, '2023-12-01', 'San Diego, CA', 'Officer Mike', 'Person found safe at a shelter.'),
(2, 3, '2024-01-05', 'Austin, TX', 'Detective Lisa', 'Person found, but in critical condition.'),
(3, 6, '2023-11-02', 'Colorado Springs, CO', 'Officer Jason', 'Person found unharmed at a bus station.'),
(4, 10, '2023-10-15', 'Los Angeles, CA', 'Detective Sarah', 'Found in a rehabilitation center.'),
(5, 2, '2023-12-10', 'San Francisco, CA', 'Social Worker Mark', 'Person found seeking assistance at a shelter.');

-- Insert sample data into investigations table
INSERT INTO investigations (investigation_id, person_id, assigned_officer, department, last_update, case_status) VALUES
(1, 1, 'Detective John', 'Missing Persons Unit', '2024-01-15 10:00:00', 'In Progress'),
(2, 2, 'Officer Kate', 'Local Police', '2023-12-02 15:30:00', 'Closed'),
(3, 3, 'Detective Ryan', 'FBI', '2024-01-06 09:20:00', 'Closed'),
(4, 4, 'Officer Emma', 'Missing Persons Unit', '2024-02-03 12:45:00', 'Open'),
(5, 5, 'Detective Lucas', 'State Police', '2024-01-25 08:00:00', 'In Progress'),
(6, 6, 'Officer Henry', 'Missing Persons Unit', '2023-11-03 13:45:00', 'Closed'),
(7, 7, 'Detective Morgan', 'FBI', '2024-02-07 14:20:00', 'Open'),
(8, 8, 'Officer Hannah', 'Local Police', '2024-02-01 10:10:00', 'Open'),
(9, 9, 'Detective Cole', 'State Police', '2024-01-02 17:30:00', 'In Progress'),
(10, 10, 'Officer Kevin', 'Local Police', '2023-10-16 09:50:00', 'Closed');

-- Insert sample data into users table
INSERT INTO users (user_id, username, password_hash, role) VALUES
(1, 'admin_user', 'hashedpassword1', 'Admin'),
(2, 'officer_mike', 'hashedpassword2', 'Officer'),
(3, 'public_alice', 'hashedpassword3', 'Public User'),
(4, 'detective_ryan', 'hashedpassword4', 'Officer'),
(5, 'officer_lucas', 'hashedpassword5', 'Officer'),
(6, 'detective_morgan', 'hashedpassword6', 'Officer'),
(7, 'public_nancy', 'hashedpassword7', 'Public User'),
(8, 'admin_jessica', 'hashedpassword8', 'Admin'),
(9, 'officer_hannah', 'hashedpassword9', 'Officer'),
(10, 'public_robert', 'hashedpassword10', 'Public User');

-- List the number of missing persons by gender.
SELECT gender, COUNT(*) AS total_missing 
FROM persons 
GROUP BY gender;

-- Find missing persons who were last seen in a specific city.
SELECT * 
FROM persons 
WHERE last_seen_location LIKE '%NY%';

-- Retrieve details of cases that have been open for more than 6 months.
SELECT * 
FROM investigations 
WHERE case_status = 'Open' 
AND last_update <= DATE('now', '-6 months');

-- Find all missing persons who have been found but not yet marked as "Closed" in reports.
SELECT p.person_id, p.first_name, p.last_name, r.status, f.found_date 
FROM found_persons f
JOIN reports r ON f.person_id = r.person_id
JOIN persons p ON f.person_id = p.person_id
WHERE r.status != 'Closed';

-- Get a count of missing reports per month in the current year.
SELECT strftime('%Y-%m', report_date) AS month, COUNT(*) AS report_count 
FROM reports 
WHERE strftime('%Y', report_date) = strftime('%Y', 'now') 
GROUP BY month 
ORDER BY month;

-- Find the officer assigned to the most investigations.
SELECT assigned_officer, COUNT(*) AS case_count 
FROM investigations 
GROUP BY assigned_officer 
ORDER BY case_count DESC 
LIMIT 1;

-- Get a list of missing persons along with the details of who reported them.
SELECT p.person_id, p.first_name, p.last_name, r.reported_by, r.contact_number, r.relationship_to_person, r.report_date
FROM persons p
JOIN reports r ON p.person_id = r.person_id;

-- Find persons who have been reported missing multiple times.
SELECT person_id, COUNT(*) AS report_count 
FROM reports 
GROUP BY person_id 
HAVING report_count > 1;

-- Get a list of found persons along with their last seen location and the date they were found.
SELECT f.found_id, p.first_name, p.last_name, p.last_seen_location, f.found_date, f.found_location, f.found_by
FROM found_persons f
JOIN persons p ON f.person_id = p.person_id;

-- List all reports where the contact number is missing or invalid.
SELECT * 
FROM reports 
WHERE contact_number IS NULL 
   OR LENGTH(CAST(contact_number AS TEXT)) < 11;

-- Find missing persons under the age of 18.
SELECT * 
FROM persons 
WHERE age < 18;

-- Identify missing persons who have been missing for over a year.
SELECT * 
FROM persons 
WHERE date_missing <= DATE('now', '-1 year');

-- Find all missing persons whose status is still ‘Open’ but have a related found record.
SELECT p.person_id, p.first_name, p.last_name, r.status, f.found_date 
FROM persons p
JOIN reports r ON p.person_id = r.person_id
JOIN found_persons f ON p.person_id = f.person_id
WHERE r.status = 'Open';

-- List investigations that have not been updated in the last 3 months.
SELECT * 
FROM investigations 
WHERE last_update <= DATE('now', '-3 months');

-- Find users who have reported more than one missing person.
SELECT reported_by, COUNT(*) AS report_count 
FROM reports 
GROUP BY reported_by 
HAVING report_count > 1;

-- Get the number of missing persons found per officer.
SELECT f.found_by, COUNT(*) AS found_count 
FROM found_persons f
GROUP BY f.found_by
ORDER BY found_count DESC;

-- Find all missing persons who were found in a different city from their last seen location.
SELECT p.person_id, p.first_name, p.last_name, p.last_seen_location, f.found_location 
FROM persons p
JOIN found_persons f ON p.person_id = f.person_id
WHERE p.last_seen_location != f.found_location;

-- Get the average time taken to find missing persons.
SELECT AVG(julianday(f.found_date) - julianday(p.date_missing)) AS avg_days_to_find
FROM persons p
JOIN found_persons f ON p.person_id = f.person_id;

-- Find the percentage of missing persons found within 30 days.
SELECT 
    (COUNT(f.person_id) * 100.0 / (SELECT COUNT(*) FROM persons)) AS found_within_30_days_percentage
FROM found_persons f
JOIN persons p ON f.person_id = p.person_id
WHERE julianday(f.found_date) - julianday(p.date_missing) <= 30;

-- List all missing persons along with the officer assigned to their case (if any).
SELECT p.person_id, p.first_name, p.last_name, i.assigned_officer 
FROM persons p
LEFT JOIN investigations i ON p.person_id = i.person_id;

-- Find the most common last-seen locations for missing persons.
SELECT last_seen_location, COUNT(*) AS occurrence 
FROM persons 
GROUP BY last_seen_location 
ORDER BY occurrence DESC 
LIMIT 5;

-- Retrieve all missing persons who were last seen at night (between 8 PM and 6 AM).
SELECT * 
FROM persons 
WHERE strftime('%H', date_missing) BETWEEN '20' AND '23' 
   OR strftime('%H', date_missing) BETWEEN '00' AND '06';

-- Identify which month has the highest number of missing reports.
SELECT strftime('%Y-%m', date_missing) AS month, COUNT(*) AS missing_count
FROM persons
GROUP BY month
ORDER BY missing_count DESC
LIMIT 1;
