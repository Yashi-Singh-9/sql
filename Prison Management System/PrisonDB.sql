CREATE DATABASE PrisonDB;
USE PrisonDB;

-- Prisons Table  
CREATE TABLE prisons (
  prison_id INT IDENTITY(1,1) PRIMARY KEY,
  prison_name VARCHAR(20),
  location VARCHAR(50),
  capacity INT CHECK (capacity >= 0)
);

-- Prisoners Table 
CREATE TABLE prisoners (
  prisoner_id INT IDENTITY(1,1) PRIMARY KEY,
  first_name VARCHAR(20),
  last_name VARCHAR(20),
  date_of_birth DATE,
  gender VARCHAR(10) CHECK (gender IN ('Female', 'Male', 'Other')),
  crime_committed INT,
  sentence_years INT,
  entry_date DATE,
  release_date DATE,
  prison_id INT,
  FOREIGN KEY (prison_id) REFERENCES prisons(prison_id)
);

-- Cells Table 
CREATE TABLE cells (
  cell_id INT IDENTITY(1,1) PRIMARY KEY,
  prison_id INT,
  cell_number INT,
  capacity DECIMAL(10,2),
  FOREIGN KEY (prison_id) REFERENCES prisons(prison_id)
);

-- Guards Table  
CREATE TABLE guards (
  guard_id INT IDENTITY(1,1) PRIMARY KEY,
  first_name VARCHAR(20),
  last_name VARCHAR(20),
  shift VARCHAR(10) CHECK (shift IN ('Morning', 'Afternoon', 'Night')),
  prison_id INT,
  
);

-- Assignments Table 
CREATE TABLE assignments (
  assignment_id INT IDENTITY(1,1) PRIMARY KEY,
  guard_id INT,
  prisoner_id INT,
  FOREIGN KEY (guard_id) REFERENCES guards(guard_id),
  FOREIGN KEY (prisoner_id) REFERENCES prisoners(prisoner_id)
);

-- Visits Table 
CREATE TABLE visits (
  visit_id INT IDENTITY(1,1) PRIMARY KEY,
  prisoner_id INT,
  visitor_name VARCHAR(20),
  relation VARCHAR(20),
  visit_date DATE,
  FOREIGN KEY (prisoner_id) REFERENCES prisoners(prisoner_id)
);

-- Punishments Table  
CREATE TABLE punishments (
  punishment_id INT IDENTITY(1,1) PRIMARY KEY,
  prisoner_id INT,
  punishment_type VARCHAR(20),
  duration_days INT,
  FOREIGN KEY (prisoner_id) REFERENCES prisoners(prisoner_id)
); 

-- Insert data into prisons table
INSERT INTO prisons (prison_name, location, capacity) VALUES
('Alcatraz', 'San Francisco, CA', 300),
('Sing Sing', 'Ossining, NY', 250),
('Rikers Island', 'New York, NY', 500),
('San Quentin', 'San Rafael, CA', 350),
('Folsom', 'Folsom, CA', 400),
('Leavenworth', 'Leavenworth, KS', 450),
('Attica', 'Attica, NY', 350),
('Pelican Bay', 'Crescent City, CA', 500);

-- Insert data into prisoners table
INSERT INTO prisoners (first_name, last_name, date_of_birth, gender, crime_committed, sentence_years, entry_date, release_date, prison_id) VALUES
('John', 'Doe', '1985-06-15', 'Male', 101, 10, '2020-05-10', '2030-05-10', 1),
('Jane', 'Smith', '1992-09-21', 'Female', 102, 7, '2019-08-15', '2026-08-15', 2),
('Robert', 'Brown', '1980-03-12', 'Male', 103, 15, '2018-11-01', '2033-11-01', 3),
('Alice', 'Johnson', '1995-07-19', 'Female', 104, 5, '2022-02-14', '2027-02-14', 4),
('Michael', 'Davis', '1983-12-30', 'Male', 105, 12, '2017-06-25', '2029-06-25', 5),
('Emily', 'Wilson', '1990-05-02', 'Female', 106, 8, '2021-09-10', '2029-09-10', 6),
('David', 'Martinez', '1988-08-18', 'Male', 107, 20, '2015-12-20', '2035-12-20', 7),
('Sophia', 'Lopez', '1993-04-25', 'Female', 108, 6, '2023-01-05', '2029-01-05', 8);

-- Insert data into cells table
INSERT INTO cells (prison_id, cell_number, capacity) VALUES
(1, 101, 2),
(2, 102, 2),
(3, 103, 1),
(4, 104, 2),
(5, 105, 1),
(6, 106, 2),
(7, 107, 2),
(8, 108, 1);

-- Insert data into guards table
INSERT INTO guards (first_name, last_name, shift, prison_id) VALUES
('Tom', 'Harris', 'Morning', 1),
('Sarah', 'Evans', 'Afternoon', 2),
('James', 'Clark', 'Night', 3),
('Laura', 'White', 'Morning', 4),
('Peter', 'Anderson', 'Afternoon', 5),
('Anna', 'Taylor', 'Night', 6),
('Daniel', 'Thomas', 'Morning', 7),
('Rebecca', 'Rodriguez', 'Afternoon', 8);

-- Insert data into assignments table
INSERT INTO assignments (guard_id, prisoner_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8);

-- Insert data into visits table
INSERT INTO visits (prisoner_id, visitor_name, relation, visit_date) VALUES
(1, 'Mary Doe', 'Sister', '2024-01-10'),
(2, 'Mark Smith', 'Brother', '2024-01-12'),
(3, 'Susan Brown', 'Mother', '2024-01-15'),
(4, 'James Johnson', 'Father', '2024-01-18'),
(5, 'Patricia Davis', 'Wife', '2024-01-20'),
(6, 'Michael Wilson', 'Husband', '2024-01-22'),
(7, 'Linda Martinez', 'Daughter', '2024-01-25'),
(8, 'Daniel Lopez', 'Brother', '2024-01-28');

-- Insert data into punishments table
INSERT INTO punishments (prisoner_id, punishment_type, duration_days) VALUES
(1, 'Solitary', 10),
(2, 'No Visitation', 5),
(3, 'Solitary', 15),
(4, 'Extra Duty', 7),
(5, 'No Recreation', 12),
(6, 'Solitary', 8),
(7, 'No Visitation', 6),
(8, 'Extra Duty', 9);

-- Find all prisoners in a specific prison.
SELECT * 
FROM prisoners 
WHERE prison_id = 5;

-- Get a list of prisoners whose sentence ends within the next year.
SELECT * 
FROM prisoners 
WHERE release_date BETWEEN GETDATE() AND DATEADD(YEAR, 1, GETDATE());

-- Find the total number of prisoners in each prison.
SELECT p.prison_name, COUNT(pr.prisoner_id) AS total_prisoners
FROM prisons p
LEFT JOIN prisoners pr ON p.prison_id = pr.prison_id
GROUP BY p.prison_name;

-- List guards working in a particular shift.
SELECT * FROM guards 
WHERE shift = 'Afternoon';

-- Get all the prisoners assigned to a specific guard.
SELECT pr.*
FROM prisoners pr
JOIN assignments a ON pr.prisoner_id = a.prisoner_id
WHERE a.guard_id =  2;

-- Get the number of visitors per prisoner.
SELECT pr.prisoner_id, pr.first_name, pr.last_name, COUNT(v.visit_id) AS total_visits
FROM prisoners pr
LEFT JOIN visits v ON pr.prisoner_id = v.prisoner_id
GROUP BY pr.prisoner_id, pr.first_name, pr.last_name;

-- List all empty cells in a given prison.
SELECT c.cell_id, c.cell_number 
FROM cells c
LEFT JOIN prisoners p ON c.prison_id = p.prison_id
WHERE c.prison_id = 2
AND p.prisoner_id IS NULL;

-- Find prisoners who have been visited by a specific visitor.
SELECT pr.*
FROM prisoners pr
JOIN visits v ON pr.prisoner_id = v.prisoner_id
WHERE v.visitor_name = 'Mary Doe';

-- Find the prisoner(s) who have served the longest sentence so far.
SELECT TOP 1 *, DATEDIFF(YEAR, entry_date, GETDATE()) AS years_served
FROM prisoners
ORDER BY years_served DESC;

-- Get the details of prisoners who have received the maximum number of visits.
SELECT TOP 1 pr.prisoner_id, pr.first_name, pr.last_name, pr.date_of_birth, pr.gender, 
             pr.crime_committed, pr.sentence_years, pr.entry_date, pr.release_date, 
             pr.prison_id, COUNT(v.visit_id) AS visit_count 
FROM prisoners pr
JOIN visits v ON pr.prisoner_id = v.prisoner_id
GROUP BY pr.prisoner_id, pr.first_name, pr.last_name, pr.date_of_birth, pr.gender, 
         pr.crime_committed, pr.sentence_years, pr.entry_date, pr.release_date, 
         pr.prison_id
ORDER BY visit_count DESC;

-- Find the number of punishments given to prisoners in a particular prison.
SELECT p.prison_name, COUNT(pu.punishment_id) AS total_punishments
FROM prisons p
JOIN prisoners pr ON p.prison_id = pr.prison_id
JOIN punishments pu ON pr.prisoner_id = pu.prisoner_id
WHERE p.prison_id = 3
GROUP BY p.prison_name;

-- Find guards who have supervised the highest number of prisoners.
SELECT TOP 1 g.guard_id, g.first_name, g.last_name, COUNT(a.prisoner_id) AS supervised_prisoners
FROM guards g
JOIN assignments a ON g.guard_id = a.guard_id
GROUP BY g.guard_id, g.first_name, g.last_name
ORDER BY supervised_prisoners DESC;

-- Get the list of all cells that are fully occupied.
SELECT c.cell_id, c.cell_number, c.prison_id
FROM cells c
JOIN (
    SELECT prison_id, COUNT(prisoner_id) AS occupied_cells
    FROM prisoners
    GROUP BY prison_id
) p ON c.prison_id = p.prison_id
WHERE c.capacity <= p.occupied_cells;