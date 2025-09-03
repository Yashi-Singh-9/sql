-- Project In MariaDB 
-- Creating the database
CREATE DATABASE UrbanPlanningDB;
USE UrbanPlanningDB;

-- Projects Table  
CREATE Table projects (
  project_id INT PRIMARY KEY AUTO_INCREMENT,
  project_name VARCHAR(100) NOT NULL,
  location VARCHAR(100) NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NULL,
  budget DECIMAL(10,2) NOT NULL,
  Status VARCHAR(50)
);

-- Zones Table  
CREATE TABLE zones (
  zone_id INT PRIMARY KEY AUTO_INCREMENT,
  zone_name VARCHAR(100) NOT NULL,
  type ENUM('Residential', 'Commercial', 'Industrial') NOT NULL,
  regulations TEXT 
);

-- Permits Table 
CREATE TABLE permits (
  permit_id INT PRIMARY KEY AUTO_INCREMENT,
  project_id INT NOT NULL,
  issued_date DATE NOT NULL,
  expiry_date DATE NOT NULL,
  approval_status VARCHAR(20),
  FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

-- Developers Table 
CREATE TABLE developers (
  developer_id INT PRIMARY KEY AUTO_INCREMENT,
  developer_name VARCHAR(50) NOT NULL,
  contact_info TEXT,
  company_name VARCHAR(100)
);

-- Project Developers Table
CREATE TABLE project_developers (
  project_id INT,
  developer_id INT,
  FOREIGN KEY (project_id) REFERENCES projects(project_id),
  FOREIGN KEY (developer_id) REFERENCES developers(developer_id)
);

-- Buildings Table  
CREATE TABLE buildings (
  buildings_id INT PRIMARY KEY AUTO_INCREMENT,
  project_id INT NOT NULL,
  zone_id INT NOT NULL,
  building_type VARCHAR(100) NOT NULL,
  floor INT NOT NULL,
  height DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (project_id) REFERENCES projects(project_id),
  FOREIGN KEY (zone_id) REFERENCES zones(zone_id)
);

-- Inspections Table 
CREATE TABLE inspections (
  inspections_id INT PRIMARY KEY AUTO_INCREMENT,
  project_id INT NOT NULL,
  inspector_name VARCHAR(50) NOT NULL,
  inspection_date DATE NOT NULL,
  result ENUM('Pass', 'Fail') NOT NULL,
  remarks TEXT,
  FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

-- Public Complaints Table
CREATE TABLE public_complaints (
  complaints_id INT PRIMARY KEY AUTO_INCREMENT,
  project_id INT NOT NULL,
  complaint_details TEXT NOT NULL,
  submitted_by VARCHAR(100) NOT NULL,
  submission_date DATE NOT NULL,
  status VARCHAR(50) NOT NULL,
  FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

-- Inserting into Projects Table
INSERT INTO projects (project_name, location, start_date, end_date, budget, Status) VALUES
('Greenwood Heights', 'Downtown', '2023-01-15', '2025-06-20', 5000000.00, 'Ongoing'),
('Sunset Plaza', 'Westside', '2022-05-10', '2024-09-15', 7500000.00, 'Completed'),
('Riverside Mall', 'Eastside', '2023-08-01', NULL, 6000000.00, 'In Progress'),
('Skyline Towers', 'Uptown', '2024-02-01', NULL, 9000000.00, 'Ongoing'),
('TechPark Hub', 'Midtown', '2021-11-25', '2023-12-10', 8500000.00, 'Completed');

-- Inserting into Zones Table
INSERT INTO zones (zone_name, type, regulations) VALUES
('Residential Area 1', 'Residential', 'Max height: 15m, Noise control enforced'),
('Commercial Zone A', 'Commercial', 'Business hours: 8 AM - 10 PM, No heavy vehicles'),
('Industrial Park 3', 'Industrial', 'Heavy machinery allowed, Safety protocols required'),
('Residential Area 2', 'Residential', 'Green spaces mandatory, Parking restrictions'),
('Business District B', 'Commercial', 'Skyscrapers allowed, Fire safety required');

-- Inserting into Permits Table
INSERT INTO permits (project_id, issued_date, expiry_date, approval_status) VALUES
(1, '2023-02-10', '2026-02-10', 'Approved'),
(2, '2022-06-15', '2025-06-15', 'Approved'),
(3, '2023-09-05', '2026-09-05', 'Pending'),
(4, '2024-03-10', '2027-03-10', 'Approved'),
(5, '2021-12-01', '2024-12-01', 'Approved');

-- Inserting into Developers Table
INSERT INTO developers (developer_name, contact_info, company_name) VALUES
('John Doe', 'john@example.com, +123456789', 'Skyline Builders'),
('Alice Smith', 'alice@example.com, +987654321', 'Urban Developments Ltd'),
('Michael Johnson', 'michael@example.com, +456123789', 'Future Realty'),
('Sarah Brown', 'sarah@example.com, +789321456', 'Sunrise Constructions'),
('David Wilson', 'david@example.com, +321654987', 'TechBuild Co.');

-- Inserting into Project Developers Table
INSERT INTO project_developers (project_id, developer_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

-- Inserting into Buildings Table
INSERT INTO buildings (project_id, zone_id, building_type, floor, height) VALUES
(1, 1, 'Apartment', 10, 30.00),
(2, 2, 'Shopping Mall', 5, 20.50),
(3, 3, 'Factory', 3, 15.00),
(4, 4, 'Condo', 25, 75.00),
(5, 5, 'Office Building', 15, 50.00);

-- Inserting into Inspections Table
INSERT INTO inspections (project_id, inspector_name, inspection_date, result, remarks) VALUES
(1, 'Robert White', '2023-06-15', 'Pass', 'All regulations met'),
(2, 'Emma Green', '2022-12-20', 'Pass', 'Minor fixes required'),
(3, 'Daniel Clark', '2024-01-10', 'Fail', 'Safety concerns in structure'),
(4, 'Olivia Lewis', '2024-07-05', 'Pass', 'Excellent quality'),
(5, 'James Hall', '2022-10-30', 'Pass', 'Meets environmental standards');

-- Inserting into Public Complaints Table
INSERT INTO public_complaints (project_id, complaint_details, submitted_by, submission_date, status) VALUES
(1, 'Noise pollution issues reported.', 'Mark Taylor', '2023-07-01', 'Under Review'),
(2, 'Traffic congestion near the mall.', 'Sophia Wilson', '2022-08-15', 'Resolved'),
(3, 'Factory emissions affecting nearby areas.', 'Liam Brown', '2024-02-05', 'Pending'),
(4, 'Construction debris on roads.', 'Emily Harris', '2024-03-20', 'Under Investigation'),
(5, 'Lack of parking spaces in the office complex.', 'Jacob Martinez', '2023-11-10', 'Resolved');

-- Retrieve all ongoing projects along with their developers.
SELECT p.project_id, p.project_name, d.developer_name, d.company_name
FROM projects p
JOIN project_developers pd ON p.project_id = pd.project_id
JOIN developers d ON pd.developer_id = d.developer_id
WHERE p.Status = 'Ongoing';

-- List all permits that are expired or about to expire in the next 30 days.
SELECT permit_id, project_id, issued_date, expiry_date, approval_status
FROM permits
WHERE expiry_date <= CURDATE() + INTERVAL 30 DAY;

-- Find the total budget allocated to projects in each zone.
SELECT z.zone_name, SUM(p.budget) AS total_budget
FROM projects p
JOIN buildings b ON p.project_id = b.project_id
JOIN zones z ON b.zone_id = z.zone_id
GROUP BY z.zone_name;

-- Get the number of buildings per project, categorized by building type.
SELECT p.project_name, b.building_type, COUNT(b.buildings_id) AS num_buildings
FROM buildings b
JOIN projects p ON b.project_id = p.project_id
GROUP BY p.project_name, b.building_type;

-- Show all projects that have failed at least one inspection.
SELECT DISTINCT p.project_id, p.project_name
FROM projects p
JOIN inspections i ON p.project_id = i.project_id
WHERE i.result = 'Fail';

-- Find projects that have received complaints but have no resolution status.
SELECT DISTINCT p.project_id, p.project_name
FROM projects p
JOIN public_complaints c ON p.project_id = c.project_id
WHERE c.status IN ('Pending', 'Under Review', 'Under Investigation');

-- Retrieve the zones with the highest number of active projects.
SELECT z.zone_name, COUNT(DISTINCT p.project_id) AS active_projects
FROM projects p
JOIN buildings b ON p.project_id = b.project_id
JOIN zones z ON b.zone_id = z.zone_id
WHERE p.Status = 'Ongoing' OR p.Status = 'In Progress'
GROUP BY z.zone_name
ORDER BY active_projects DESC
LIMIT 1;

-- Show buildings that exceed the permitted height in their respective zones.
SELECT b.buildings_id, p.project_name, z.zone_name, b.building_type, b.height
FROM buildings b
JOIN projects p ON b.project_id = p.project_id
JOIN zones z ON b.zone_id = z.zone_id
WHERE b.height > CAST(REGEXP_SUBSTR(z.regulations, '[0-9]+') AS DECIMAL(10,2));

-- Retrieve the total number of complaints for each project.
SELECT p.project_id, p.project_name, COUNT(c.complaints_id) AS total_complaints
FROM projects p
LEFT JOIN public_complaints c ON p.project_id = c.project_id
GROUP BY p.project_id, p.project_name;

-- Get a list of projects and the number of permits they have.
SELECT p.project_id, p.project_name, COUNT(pe.permit_id) AS total_permits
FROM projects p
LEFT JOIN permits pe ON p.project_id = pe.project_id
GROUP BY p.project_id, p.project_name;

-- List the projects along with their last inspection result.
SELECT p.project_id, p.project_name, i.inspection_date, i.result
FROM projects p
JOIN inspections i ON p.project_id = i.project_id
WHERE i.inspection_date = (
    SELECT MAX(i2.inspection_date) 
    FROM inspections i2 
    WHERE i2.project_id = p.project_id
);
