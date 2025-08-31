-- MS SQL Project
CREATE DATABASE NaturalDisasterDB;
USE NaturalDisasterDB;

CREATE TABLE Locations (
    location_id INT IDENTITY(1,1) PRIMARY KEY,
    country VARCHAR(100) NOT NULL,
    state VARCHAR(100),
    city VARCHAR(100),
    latitude DECIMAL(9,6),
    longitude DECIMAL(9,6)
);

CREATE TABLE Disasters (
    disaster_id INT IDENTITY(1,1) PRIMARY KEY,
    disaster_type VARCHAR(20) CHECK (disaster_type IN ('Earthquake', 'Flood', 'Hurricane', 'Tornado', 'Wildfire', 'Tsunami', 'Drought', 'Landslide', 'Volcanic Eruption')) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    location_id INT,
    FOREIGN KEY (location_id) REFERENCES Locations(location_id) ON DELETE SET NULL
);

CREATE TABLE Casualties (
    casualty_id INT IDENTITY(1,1) PRIMARY KEY,
    disaster_id INT,
    injured_count INT CHECK (injured_count >= 0),
    death_count INT CHECK (death_count >= 0),
    missing_count INT CHECK (missing_count >= 0),
    FOREIGN KEY (disaster_id) REFERENCES Disasters(disaster_id) ON DELETE CASCADE
);

CREATE TABLE Economic_Loss (
    loss_id INT IDENTITY(1,1) PRIMARY KEY,
    disaster_id INT,
    estimated_damage DECIMAL(15,2) CHECK (estimated_damage >= 0),
    currency VARCHAR(10) NOT NULL,
    insurance_coverage DECIMAL(15,2) CHECK (insurance_coverage >= 0),
    FOREIGN KEY (disaster_id) REFERENCES Disasters(disaster_id) ON DELETE CASCADE
);

CREATE TABLE Relief_Aid (
    aid_id INT IDENTITY(1,1) PRIMARY KEY,
    disaster_id INT,
    organization_name VARCHAR(150) NOT NULL,
    aid_amount DECIMAL(15,2) CHECK (aid_amount >= 0),
    aid_type VARCHAR(15) CHECK (aid_type IN ('Medical', 'Shelter', 'Food', 'Financial', 'Logistics', 'Other')) NOT NULL,
    distribution_date DATE,
    FOREIGN KEY (disaster_id) REFERENCES Disasters(disaster_id) ON DELETE CASCADE
);

CREATE TABLE Emergency_Responders (
    responder_id INT IDENTITY(1,1) PRIMARY KEY,
    disaster_id INT,
    team_name VARCHAR(100) NOT NULL,
    total_personnel INT CHECK (total_personnel >= 0),
    response_time_hours DECIMAL(5,2) CHECK (response_time_hours >= 0),
    FOREIGN KEY (disaster_id) REFERENCES Disasters(disaster_id) ON DELETE CASCADE
);

CREATE TABLE Evacuations (
    evacuation_id INT IDENTITY(1,1) PRIMARY KEY,
    disaster_id INT,
    evacuated_people_count INT CHECK (evacuated_people_count >= 0),
    evacuation_center VARCHAR(255) NOT NULL,
    FOREIGN KEY (disaster_id) REFERENCES Disasters(disaster_id) ON DELETE CASCADE
);

-- Insert sample locations
INSERT INTO Locations (country, state, city, latitude, longitude) VALUES
('USA', 'California', 'Los Angeles', 34.052235, -118.243683),
('Japan', 'Tokyo', 'Tokyo', 35.689487, 139.691711),
('India', 'Maharashtra', 'Mumbai', 19.076090, 72.877426),
('Brazil', 'São Paulo', 'São Paulo', -23.550520, -46.633308),
('Australia', 'New South Wales', 'Sydney', -33.868820, 151.209290);

-- Insert sample disasters (some location_id can be NULL)
INSERT INTO Disasters (disaster_type, start_date, end_date, location_id) VALUES
('Earthquake', '2023-01-10', '2023-01-15', 1),
('Flood', '2023-03-05', NULL, 2),
('Hurricane', '2023-06-20', '2023-06-25', 3),
('Wildfire', '2023-08-10', NULL, 4),
('Tsunami', '2023-09-15', '2023-09-18', NULL);

-- Insert sample casualties (some disasters may not have casualties)
INSERT INTO Casualties (disaster_id, injured_count, death_count, missing_count) VALUES
(1, 100, 10, 5),
(2, 500, 20, 15),
(3, 200, 5, 2),
(4, NULL, NULL, NULL),
(5, 50, 2, 1);

-- Insert sample economic losses
INSERT INTO Economic_Loss (disaster_id, estimated_damage, currency, insurance_coverage) VALUES
(1, 10000000.50, 'USD', 5000000.25),
(2, 5000000.00, 'JPY', 2000000.00),
(3, 7500000.75, 'INR', 4000000.50),
(4, 12000000.00, 'BRL', NULL),
(5, 9500000.25, 'AUD', 7000000.75);

-- Insert sample relief aid (some disasters may not have aid)
INSERT INTO Relief_Aid (disaster_id, organization_name, aid_amount, aid_type, distribution_date) VALUES
(1, 'Red Cross', 500000.00, 'Medical', '2023-01-12'),
(2, 'UNICEF', 1000000.00, 'Food', '2023-03-07'),
(3, 'WHO', 750000.00, 'Medical', '2023-06-22'),
(4, 'Local Government', NULL, 'Shelter', NULL),
(5, 'World Food Programme', 1200000.00, 'Food', '2023-09-16');

-- Insert sample emergency responders
INSERT INTO Emergency_Responders (disaster_id, team_name, total_personnel, response_time_hours) VALUES
(1, 'LA Fire Department', 50, 2.5),
(2, 'Tokyo Rescue Team', 100, 1.2),
(3, 'Indian Army', 200, 3.0),
(4, 'São Paulo Emergency Services', 75, NULL),
(5, 'Australian Navy', 150, 4.5);

-- Insert sample evacuations
INSERT INTO Evacuations (disaster_id, evacuated_people_count, evacuation_center) VALUES
(1, 5000, 'LA Convention Center'),
(2, 10000, 'Tokyo Dome'),
(3, 7500, 'Mumbai Sports Complex'),
(4, 15500, 'LLM'),
(5, 9000, 'Sydney Olympic Park');

-- Find the total number of casualties for each disaster.
SELECT 
    d.disaster_id, 
    d.disaster_type, 
    COALESCE(SUM(c.injured_count + c.death_count + c.missing_count), 0) AS total_casualties
FROM Disasters d
LEFT JOIN Casualties c ON d.disaster_id = c.disaster_id
GROUP BY d.disaster_id, d.disaster_type;

-- Identify the top 3 most economically devastating disasters.
SELECT TOP 3
    d.disaster_id, 
    d.disaster_type, 
    e.estimated_damage, 
    e.currency
FROM Economic_Loss e
JOIN Disasters d ON e.disaster_id = d.disaster_id
ORDER BY e.estimated_damage DESC;

-- List all disasters that lasted more than a week.
SELECT 
    disaster_id, 
    disaster_type, 
    start_date, 
    end_date, 
    DATEDIFF(DAY, start_date, end_date) AS duration_days
FROM Disasters
WHERE end_date IS NOT NULL 
    AND DATEDIFF(DAY, start_date, end_date) > 7;

-- Determine the average response time of emergency responders per disaster.
SELECT 
    disaster_id, 
    AVG(response_time_hours) AS avg_response_time
FROM Emergency_Responders
WHERE response_time_hours IS NOT NULL
GROUP BY disaster_id;

-- Find which country has experienced the most disasters.
SELECT TOP 1
    l.country, 
    COUNT(d.disaster_id) AS total_disasters
FROM Disasters d
JOIN Locations l ON d.location_id = l.location_id
GROUP BY l.country
ORDER BY total_disasters DESC;

-- Calculate the total aid received for each disaster.
SELECT 
    d.disaster_id, 
    d.disaster_type, 
    COALESCE(SUM(r.aid_amount), 0) AS total_aid
FROM Disasters d
LEFT JOIN Relief_Aid r ON d.disaster_id = r.disaster_id
GROUP BY d.disaster_id, d.disaster_type;

-- Determine which type of disaster caused the highest number of deaths.
SELECT TOP 1
    d.disaster_type, 
    SUM(c.death_count) AS total_deaths
FROM Disasters d
JOIN Casualties c ON d.disaster_id = c.disaster_id
GROUP BY d.disaster_type
ORDER BY total_deaths DESC;
