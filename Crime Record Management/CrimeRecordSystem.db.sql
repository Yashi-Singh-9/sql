sqlite3 CrimeRecordSystem.db

-- Criminals Table
CREATE TABLE criminals (
  criminal_id INTEGER PRIMARY KEY,
  name VARCHAR(20),
  age INT,
  gender VARCHAR(10),
  address TEXT,
  contact_number BIGINT
);

-- Crimes Table
CREATE TABLE crimes (
  crime_id INTEGER PRIMARY KEY,
  crime_type VARCHAR(20),
  crime_date DATETIME,
  crime_location VARCHAR(20),
  description TEXT
);

-- Officers Table
CREATE TABLE officers (
  officer_id INTEGER PRIMARY KEY,
  name VARCHAR(20),
  rank BIGINT,
  station_name VARCHAR(20),
  contact_number BIGINT
);  

-- Cases Table
CREATE Table cases (
  case_id INTEGER PRIMARY KEY,
  crime_id INTEGER,
  officer_id INTEGER,
  status VARCHAR(10) CHECK (status IN ('Open', 'Closed')),
  report_date DATETIME,
  FOREIGN KEY (crime_id) REFERENCES crimes(crime_id),
  FOREIGN KEY (officer_id) REFERENCES officers(officer_id)
);                            

-- Victims Table
CREATE TABLE victims (
  victim_id INTEGER PRIMARY KEY,
  name VARCHAR(20),
  age INTEGER,
  gender VARCHAR(10) CHECK (gender IN ('Female', 'Male', 'Others')),
  contact_number BIGINT
);

--  Suspects Table
CREATE TABLE suspects (
  suspect_id INTEGER PRIMARY KEY,
  name VARCHAR(20),
  age INTEGER,
  gender VARCHAR(10) CHECK (gender IN ('Female', 'Male', 'Others')),
  address TEXT
);

-- Evidence Table
CREATE Table evidence (
  evidence_id INTEGER PRIMARY KEY,
  case_id INTEGER,
  evidence_type VARCHAR(20),
  description TEXT,
  FOREIGN KEY (case_id) REFERENCES cases(case_id)
);

-- Witnesses Table
CREATE TABLE witness (
  witness_id INTEGER PRIMARY KEY,
  case_id INTEGER,
  name VARCHAR(20),
  statement TEXT,
  FOREIGN KEY (case_id) REFERENCES cases(case_id)
);

-- Insert sample data into criminals table
INSERT INTO criminals (criminal_id, name, age, gender, address, contact_number) VALUES
(1, 'John Doe', 34, 'Male', '123 Main St, NY', 9876543210),
(2, 'Jane Smith', 28, 'Female', '456 Park Ave, NY', 8765432109),
(3, 'Robert Brown', 40, 'Male', '789 Elm St, CA', 7654321098),
(4, 'Emily White', 25, 'Female', '101 Pine St, TX', 6543210987),
(5, 'Michael Johnson', 38, 'Male', '202 Oak St, FL', 5432109876),
(6, 'Sarah Davis', 30, 'Female', '303 Birch St, IL', 4321098765),
(7, 'William Wilson', 45, 'Male', '404 Cedar St, WA', 3210987654),
(8, 'Olivia Martinez', 29, 'Female', '505 Maple St, CO', 2109876543);

-- Insert sample data into crimes table
INSERT INTO crimes (crime_id, crime_type, crime_date, crime_location, description) VALUES
(1, 'Theft', '2024-01-15 14:30:00', 'Downtown', 'Stolen purse from a pedestrian.'),
(2, 'Assault', '2024-02-10 19:15:00', 'Mall', 'Physical altercation between individuals.'),
(3, 'Burglary', '2024-03-05 02:45:00', 'Residential Area', 'Forced entry into a house.'),
(4, 'Fraud', '2024-04-20 11:00:00', 'Bank', 'Fake check deposited.'),
(5, 'Homicide', '2024-05-15 22:10:00', 'Alleyway', 'Victim found deceased.'),
(6, 'Robbery', '2024-06-08 17:20:00', 'Gas Station', 'Armed robbery reported.'),
(7, 'Vandalism', '2024-07-12 03:00:00', 'School', 'Graffiti and property damage.'),
(8, 'Kidnapping', '2024-08-25 09:30:00', 'Park', 'Child reported missing.');

-- Insert sample data into officers table
INSERT INTO officers (officer_id, name, rank, station_name, contact_number) VALUES
(1, 'David Harris', 3, 'Central Station', 1234567890),
(2, 'Sophia Clark', 2, 'West Side Station', 2345678901),
(3, 'James Lewis', 4, 'East Side Station', 3456789012),
(4, 'Isabella Scott', 3, 'North Station', 4567890123),
(5, 'Ethan Young', 1, 'South Station', 5678901234),
(6, 'Mia King', 2, 'Downtown Station', 6789012345),
(7, 'Noah Turner', 5, 'Suburban Station', 7890123456),
(8, 'Charlotte Hall', 4, 'Rural Station', 8901234567);

-- Insert sample data into cases table
INSERT INTO cases (case_id, crime_id, officer_id, status, report_date) VALUES
(1, 1, 2, 'Open', '2024-01-16 10:00:00'),
(2, 2, 3, 'Closed', '2024-02-11 15:00:00'),
(3, 3, NULL, 'Open', '2024-03-06 12:30:00'),
(4, NULL, 1, 'Closed', '2024-04-21 09:45:00'),
(5, 5, 5, 'Open', '2024-05-16 20:00:00'),
(6, 6, NULL, 'Closed', '2024-06-09 18:00:00'),
(7, NULL, 4, 'Open', '2024-07-13 08:30:00'),
(8, 8, 7, 'Closed', '2024-08-26 14:15:00');

-- Insert sample data into victims table
INSERT INTO victims (victim_id, name, age, gender, contact_number) VALUES
(1, 'Alice Green', 27, 'Female', 9876543211),
(2, 'Brian Taylor', 35, 'Male', 8765432110),
(3, 'Chloe Adams', 22, 'Female', 7654321109),
(4, 'Daniel Evans', 41, 'Male', 6543211098),
(5, 'Emma Harris', 29, 'Female', 5432110987),
(6, 'Liam Walker', 33, 'Male', 4321109876),
(7, 'Sophia Roberts', 26, 'Female', 3211098765),
(8, 'Mason Wright', 38, 'Male', 2109876544);

-- Insert sample data into suspects table
INSERT INTO suspects (suspect_id, name, age, gender, address) VALUES
(1, 'Jake Miller', 32, 'Male', '700 Spruce St, NY'),
(2, 'Emily Johnson', 24, 'Female', '800 Walnut St, CA'),
(3, 'Michael Smith', 37, 'Male', '900 Chestnut St, TX'),
(4, 'Jessica Brown', 29, 'Female', '1000 Redwood St, FL'),
(5, 'Nathan Lee', 41, 'Male', '1100 Cypress St, IL'),
(6, 'Sophia Wilson', 31, 'Female', '1200 Hickory St, WA'),
(7, 'Oliver Thomas', 36, 'Male', '1300 Willow St, CO'),
(8, 'Ava Martinez', 28, 'Female', '1400 Magnolia St, GA');

-- Insert sample data into evidence table
INSERT INTO evidence (evidence_id, case_id, evidence_type, description) VALUES
(1, 1, 'Fingerprint', 'Partial fingerprint found at scene.'),
(2, 2, 'CCTV Footage', 'Video recording of suspect.'),
(3, 3, 'Weapon', 'Knife recovered from crime scene.'),
(4, NULL, 'Document', 'Fake financial records found.'),
(5, 5, 'DNA Sample', 'Hair sample found on victim.'),
(6, 6, 'Footprint', 'Shoe print analysis matches suspect.'),
(7, NULL, 'Clothing', 'Suspect left a jacket at scene.'),
(8, 8, 'Witness Testimony', 'Eyewitness identified suspect.');

-- Insert sample data into witness table
INSERT INTO witness (witness_id, case_id, name, statement) VALUES
(1, 1, 'Henry Carter', 'Saw a man running away from the scene.'),
(2, NULL, 'Lisa Perez', 'Heard loud noises but did not see anyone.'),
(3, 3, 'Ethan White', 'Identified the suspect in a lineup.'),
(4, 4, 'Grace Nelson', 'Noticed the suspect entering the bank.'),
(5, NULL, 'Dylan Baker', 'Gave a vague description of the suspect.'),
(6, 6, 'Olivia Rivera', 'Saw the suspect holding a weapon.'),
(7, 7, 'Noah Carter', 'Heard the suspect bragging about the crime.'),
(8, 8, 'Emma Lopez', 'Recognized the missing child from a photo.');

-- List all criminals involved in a specific case.
SELECT c.criminal_id, c.name, c.age, c.gender, c.address, c.contact_number
FROM criminals c
JOIN cases cs ON c.criminal_id = cs.crime_id
WHERE cs.case_id = 5;

-- Find the number of crimes recorded in each city.
SELECT crime_location, COUNT(*) AS crime_count
FROM crimes
GROUP BY crime_location;

-- Retrieve all open cases handled by a specific officer.
SELECT *
FROM cases
WHERE officer_id = 3 AND status = 'Open';

-- Find cases where a specific suspect is involved.
SELECT cs.case_id, cs.status, cs.report_date
FROM cases cs
JOIN crimes cr ON cs.crime_id = cr.crime_id
JOIN suspects s ON s.name = cr.description
WHERE s.suspect_id = 2;

-- List all evidence associated with a given case.
SELECT evidence_id, evidence_type, description
FROM evidence
WHERE case_id = 2;

-- Find all crimes that occurred in a specific date range.
SELECT * 
FROM crimes 
WHERE crime_date BETWEEN '2024-01-01' AND '2024-03-31';

-- Get the count of crimes committed per crime type.
SELECT crime_type, COUNT(*) AS crime_count
FROM crimes
GROUP BY crime_type;

-- List officers who have handled more than 5 cases.
SELECT o.officer_id, o.name, o.rank, o.station_name, COUNT(c.case_id) AS cases_handled
FROM officers o
JOIN cases c ON o.officer_id = c.officer_id
GROUP BY o.officer_id
HAVING COUNT(c.case_id) > 5;

-- Retrieve the latest case details based on the report date.
SELECT *
FROM cases
ORDER BY report_date DESC
LIMIT 1;

-- Find all witnesses who provided statements for a particular case.
SELECT witness_id, name, statement
FROM witness
WHERE case_id = 6;