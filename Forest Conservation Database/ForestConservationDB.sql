CREATE DATABASE ForestConservationDB;
USE ForestConservationDB;

-- Forests Table 
CREATE TABLE forests (
  forest_id INT IDENTITY(1,1) PRIMARY KEY,
  name VARCHAR(20),
  location VARCHAR(50),
  area DECIMAL(10,2),
  protected_status VARCHAR(3) CHECK (protected_status IN ('Yes', 'No')),
  established_year INT
);

-- Species Table 
CREATE TABLE species (
  species_id INT IDENTITY(1,1) PRIMARY KEY,
  common_name VARCHAR(20),
  scientific_name VARCHAR(50),
  conservation_status VARCHAR(30),
  forest_id INT,
  FOREIGN KEY (forest_id) REFERENCES forests(forest_id)
);

-- Rangers Table 
CREATE TABLE rangers (
  ranger_id INT IDENTITY(1,1) PRIMARY KEY,
  name VARCHAR(20),
  contact BIGINT,
  assigned_forest INT,
  FOREIGN KEY (assigned_forest) REFERENCES forests(forest_id)
);

-- Threats Table 
CREATE TABLE threats (
  threat_id INT IDENTITY(1,1) PRIMARY KEY,
  threat_type VARCHAR(20),
  severity VARCHAR(50),
  forest_id INT,
  FOREIGN KEY (forest_id) REFERENCES forests(forest_id)
);

-- Conservation Projects Table 
CREATE TABLE conservation_projects (
  project_id INT IDENTITY(1,1) PRIMARY KEY,
  project_name VARCHAR(20),
  start_date DATE,
  end_date DATE,
  budget DECIMAL(10,2),
  forest_id INT,
  FOREIGN KEY (forest_id) REFERENCES forests(forest_id)
);

-- Insert sample data into forests table 
INSERT INTO forests (name, location, area, protected_status, established_year) 
VALUES 
('Amazon', 'Brazil', 5500.75, 'Yes', 1980),
('Congo Basin', 'Central Africa', 4000.50, 'Yes', 1975),
('Black Forest', 'Germany', 600.20, 'No', 1900),
('Daintree', 'Australia', 1200.45, 'Yes', 1985),
('Sundarbans', 'Bangladesh/India', 10000.90, 'Yes', 1973);

-- Insert sample data into species table 
INSERT INTO species (common_name, scientific_name, conservation_status, forest_id) 
VALUES 
('Jaguar', 'Panthera onca', 'Near Threatened', 1),
('Gorilla', 'Gorilla beringei', 'Endangered', 2),
('Red Fox', 'Vulpes vulpes', 'Least Concern', 3),
('Cassowary', 'Casuarius casuarius', 'Vulnerable', 4),
('Bengal Tiger', 'Panthera tigris tigris', 'Endangered', 5),
('Sloth', 'Bradypus variegatus', 'Least Concern', 1),
('Okapi', 'Okapia johnstoni', 'Endangered', 2),
('Koala', 'Phascolarctos cinereus', 'Vulnerable', 4);

-- Insert sample data into rangers table 
INSERT INTO rangers (name, contact, assigned_forest) 
VALUES 
('John Doe', 1234567890, 1),
('Jane Smith', 2345678901, 2),
('Max Müller', 3456789012, 3),
('Alice Brown', 4567890123, 4),
('Rahul Sharma', 5678901234, 5),
('Carlos Santos', 6789012345, 1),
('Liam Johnson', 7890123456, 2),
('Emma Wilson', 8901234567, 3);

-- Insert sample data into threats table 
INSERT INTO threats (threat_type, severity, forest_id) 
VALUES 
('Deforestation', 'High', 1),
('Poaching', 'Medium', 2),
('Wildfires', 'High', 3),
('Invasive Species', 'Low', 4),
('Climate Change', 'High', 5),
('Illegal Logging', 'Medium', 1),
('Pollution', 'Low', 3);

-- Insert sample data into conservation_projects table 
INSERT INTO conservation_projects (project_name, start_date, end_date, budget, forest_id) 
VALUES 
('Reforestation', '2024-01-01', '2025-12-31', 500000.00, 1),
('Anti-Poaching', '2023-06-15', '2026-06-15', 750000.00, 2),
('Fire Prevention', '2022-03-10', '2024-03-10', 300000.00, 3),
('Species Protection', '2025-07-01', '2028-07-01', 600000.00, 4),
('Mangrove Restoration', '2021-08-20', '2023-08-20', 450000.00, 5),
('Community Engagement', '2023-05-10', '2025-05-10', 200000.00, 1),
('Forest Monitoring', '2022-10-01', '2024-10-01', 350000.00, 2),
('Eco-Tourism', '2023-09-12', '2026-09-12', 400000.00, 3);

-- Find all forests that are protected.
SELECT * 
FROM forests
WHERE protected_status = 'Yes';

-- List species in a specific forest.
SELECT common_name, scientific_name, conservation_status 
FROM species 
WHERE forest_id = 3;

-- Count the number of rangers assigned to each forest.
SELECT assigned_forest, COUNT(*) AS ranger_count 
FROM rangers 
GROUP BY assigned_forest;

-- Find forests that have ongoing conservation projects.
SELECT DISTINCT f.*
FROM forests f
JOIN conservation_projects cp ON f.forest_id = cp.forest_id
WHERE cp.end_date >= GETDATE();

-- Identify the most common threats in each forest.
SELECT forest_id, threat_type, COUNT(*) AS occurrence 
FROM threats 
GROUP BY forest_id, threat_type 
ORDER BY forest_id, occurrence DESC;

-- Find the species with the highest conservation concern.
SELECT TOP 1 * 
FROM species 
ORDER BY 
  CASE conservation_status
    WHEN 'Critically Endangered' THEN 1
    WHEN 'Endangered' THEN 2
    WHEN 'Vulnerable' THEN 3
    WHEN 'Near Threatened' THEN 4
    WHEN 'Least Concern' THEN 5
  END ;

-- Calculate the total budget allocated to conservation projects in a specific forest.
SELECT forest_id, SUM(budget) AS total_budget 
FROM conservation_projects 
WHERE forest_id = 5
GROUP BY forest_id;

-- List all forests along with the number of species they contain.
SELECT f.name, COUNT(s.species_id) AS species_count 
FROM forests f
LEFT JOIN species s ON f.forest_id = s.forest_id
GROUP BY f.name;

-- Retrieve the contact details of all rangers working in a protected forest.
SELECT r.name, r.contact 
FROM rangers r
JOIN forests f ON r.assigned_forest = f.forest_id
WHERE f.protected_status = 'Yes';

-- Find forests where no conservation projects have been initiated.
SELECT f.* 
FROM forests f
LEFT JOIN conservation_projects cp ON f.forest_id = cp.forest_id
WHERE cp.forest_id IS NULL;

-- Find the forests that have the highest number of species.
SELECT TOP 1 f.name, COUNT(s.species_id) AS species_count 
FROM forests f
JOIN species s ON f.forest_id = s.forest_id
GROUP BY f.name
ORDER BY species_count DESC;

-- List the conservation projects along with their duration (in days).
SELECT project_name, DATEDIFF(DAY, start_date, end_date) AS duration_days 
FROM conservation_projects;

-- Find forests where the severity of threats is marked as "High" or "Critical".
SELECT DISTINCT f.*
FROM forests f
JOIN threats t ON f.forest_id = t.forest_id
WHERE t.severity IN ('High', 'Critical');

-- Find the oldest forest in terms of establishment year.
SELECT TOP 1 * 
FROM forests 
ORDER BY established_year ASC;

-- Find the top 3 forests with the largest area.
SELECT TOP 3 * 
FROM forests 
ORDER BY area DESC;

SELECT * from threats