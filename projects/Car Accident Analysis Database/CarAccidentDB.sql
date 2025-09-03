-- Project In MariaDB 
-- Creating the database
CREATE DATABASE CarAccidentDB;
USE CarAccidentDB;

-- Create Locations Table
CREATE TABLE Locations (
    location_id INT PRIMARY KEY AUTO_INCREMENT,
    street VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    zip_code VARCHAR(20)
);

-- Create Accidents Table
CREATE TABLE Accidents (
    accident_id INT PRIMARY KEY AUTO_INCREMENT,
    date_time DATETIME,
    location_id INT,
    weather_condition VARCHAR(100),
    road_condition VARCHAR(100),
    accident_severity ENUM('Minor', 'Major', 'Fatal'),
    FOREIGN KEY (location_id) REFERENCES Locations(location_id)
);

-- Create Vehicles Table
CREATE TABLE Vehicles (
    vehicle_id INT PRIMARY KEY AUTO_INCREMENT,
    accident_id INT,
    vehicle_type VARCHAR(100),
    make VARCHAR(100),
    model VARCHAR(100),
    year YEAR,
    damage_severity ENUM('Minor', 'Moderate', 'Severe'),
    FOREIGN KEY (accident_id) REFERENCES Accidents(accident_id)
);

-- Create Drivers Table
CREATE TABLE Drivers (
    driver_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255),
    license_number VARCHAR(50) UNIQUE,
    age INT,
    gender VARCHAR(10),
    experience_years INT
);

-- Create Driver_Involvement Table
CREATE TABLE Driver_Involvement (
    accident_id INT,
    driver_id INT,
    vehicle_id INT,
    role VARCHAR(20) CHECK (role IN ('At fault', 'Victim')),
    PRIMARY KEY (accident_id, driver_id, vehicle_id),
    FOREIGN KEY (accident_id) REFERENCES Accidents(accident_id),
    FOREIGN KEY (driver_id) REFERENCES Drivers(driver_id),
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id)
);

-- Create Casualties Table
CREATE TABLE Casualties (
    casualty_id INT PRIMARY KEY AUTO_INCREMENT,
    accident_id INT,
    severity ENUM('Minor', 'Serious', 'Fatal'),
    person_type ENUM('Driver', 'Passenger', 'Pedestrian'),
    FOREIGN KEY (accident_id) REFERENCES Accidents(accident_id)
);

-- Insert Locations
INSERT INTO Locations (street, city, state, zip_code) VALUES
('123 Main St', 'Los Angeles', 'CA', '90001'),
('456 Elm St', 'San Francisco', 'CA', '94102'),
('789 Oak St', 'New York', 'NY', '10001');

-- Insert Accidents
INSERT INTO Accidents (date_time, location_id, weather_condition, road_condition, accident_severity) VALUES
('2024-02-28 08:30:00', 1, 'Clear', 'Dry', 'Major'),
('2024-02-28 15:45:00', 2, 'Rainy', 'Wet', 'Minor'),
('2024-02-28 21:10:00', 3, 'Snowy', 'Icy', 'Fatal');

-- Insert Vehicles
INSERT INTO Vehicles (accident_id, vehicle_type, make, model, year, damage_severity) VALUES
(1, 'Sedan', 'Toyota', 'Camry', 2020, 'Moderate'),
(1, 'SUV', 'Honda', 'CR-V', 2019, 'Severe'),
(2, 'Truck', 'Ford', 'F-150', 2022, 'Minor'),
(3, 'Motorcycle', 'Yamaha', 'YZF-R3', 2021, 'Severe');

-- Insert Drivers
INSERT INTO Drivers (name, license_number, age, gender, experience_years) VALUES
('John Doe', 'A1234567', 35, 'Male', 10),
('Jane Smith', 'B2345678', 29, 'Female', 5),
('Mike Johnson', 'C3456789', 40, 'Male', 15);

-- Insert Driver_Involvement
INSERT INTO Driver_Involvement (accident_id, driver_id, vehicle_id, role) VALUES
(1, 1, 1, 'At fault'),
(1, 2, 2, 'Victim'),
(2, 3, 3, 'At fault');

-- Insert Casualties
INSERT INTO Casualties (accident_id, severity, person_type) VALUES
(1, 'Minor', 'Driver'),
(1, 'Serious', 'Passenger'),
(2, 'Minor', 'Pedestrian'),
(3, 'Fatal', 'Driver'),
(3, 'Serious', 'Passenger');

-- Retrieve all accidents with location details
SELECT A.accident_id, A.date_time, L.street, L.city, L.state, L.zip_code, 
       A.weather_condition, A.road_condition, A.accident_severity
FROM Accidents A
JOIN Locations L ON A.location_id = L.location_id;

-- Find all accidents with severe or fatal severity
SELECT * 
FROM Accidents 
WHERE accident_severity IN ('Major', 'Fatal');

-- List vehicles involved in a specific accident
SELECT V.vehicle_id, V.vehicle_type, V.make, V.model, V.year, V.damage_severity
FROM Vehicles V
WHERE V.accident_id = 1;

-- Find drivers involved in an accident along with their role
SELECT D.driver_id, D.name, D.license_number, D.age, D.gender, D.experience_years, DI.role
FROM Drivers D
JOIN Driver_Involvement DI ON D.driver_id = DI.driver_id
WHERE DI.accident_id = 1;

-- Count the number of accidents per severity type
SELECT accident_severity, COUNT(*) AS total_accidents
FROM Accidents
GROUP BY accident_severity;

-- List all casualties with accident details
SELECT C.casualty_id, C.severity, C.person_type, A.date_time, A.accident_severity
FROM Casualties C
JOIN Accidents A ON C.accident_id = A.accident_id;

-- Find the most recent accident
SELECT * 
FROM Accidents
ORDER BY date_time DESC
LIMIT 1;

-- Find drivers who were "At fault" in accidents
SELECT D.driver_id, D.name, DI.accident_id, DI.role
FROM Drivers D
JOIN Driver_Involvement DI ON D.driver_id = DI.driver_id
WHERE DI.role = 'At fault';

-- Count the number of vehicles involved in each accident
SELECT accident_id, COUNT(vehicle_id) AS total_vehicles
FROM Vehicles
GROUP BY accident_id;

-- Find accidents that happened in rainy or snowy weather
SELECT * 
FROM Accidents
WHERE weather_condition IN ('Rainy', 'Snowy');

-- Find the average age of drivers involved in accidents
SELECT AVG(D.age) AS average_driver_age
FROM Drivers D
JOIN Driver_Involvement DI ON D.driver_id = DI.driver_id;

-- List accidents with the number of casualties
SELECT A.accident_id, A.date_time, A.accident_severity, COUNT(C.casualty_id) AS total_casualties
FROM Accidents A
LEFT JOIN Casualties C ON A.accident_id = C.accident_id
GROUP BY A.accident_id, A.date_time, A.accident_severity;

-- Find vehicles with severe damage severity
SELECT * 
FROM Vehicles
WHERE damage_severity = 'Severe';

-- Find cities with the highest number of accidents
SELECT L.city, COUNT(A.accident_id) AS total_accidents
FROM Accidents A
JOIN Locations L ON A.location_id = L.location_id
GROUP BY L.city
ORDER BY total_accidents DESC;