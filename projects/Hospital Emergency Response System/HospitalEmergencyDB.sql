-- Project in PostgreSQL 
-- Create Database
CREATE DATABASE HospitalEmergencyDB;
-- Switch to the new database
\c HospitalEmergencyDB;

-- Hospitals Table
CREATE TABLE Hospitals (
    hospital_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location TEXT NOT NULL,
    capacity INT NOT NULL
);

-- Patients Table
CREATE TABLE Patients (
    patient_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    gender VARCHAR(10) NOT NULL,
    contact_info VARCHAR(50),
    emergency_case_id INT REFERENCES EmergencyCases(emergency_case_id) ON DELETE SET NULL
);

-- Emergency Cases Table
CREATE TABLE EmergencyCases (
    emergency_case_id SERIAL PRIMARY KEY,
    case_type VARCHAR(50) NOT NULL,
    severity_level VARCHAR(20) CHECK (severity_level IN ('Low', 'Medium', 'High', 'Critical')),
    status VARCHAR(20) CHECK (status IN ('Pending', 'Ongoing', 'Resolved')) NOT NULL,
    reported_time TIMESTAMP DEFAULT NOW(),
    hospital_id INT REFERENCES Hospitals(hospital_id) ON DELETE CASCADE
);

-- Medical Staff Table
CREATE TABLE MedicalStaff (
    staff_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    specialization VARCHAR(50),
    contact_info VARCHAR(50),
    hospital_id INT REFERENCES Hospitals(hospital_id) ON DELETE CASCADE
);

-- Ambulances Table
CREATE TABLE Ambulances (
    ambulance_id SERIAL PRIMARY KEY,
    plate_number VARCHAR(20) UNIQUE NOT NULL,
    status VARCHAR(20) CHECK (status IN ('Available', 'Busy', 'Maintenance')),
    hospital_id INT REFERENCES Hospitals(hospital_id) ON DELETE CASCADE
);

-- Emergency Response Table
CREATE TABLE EmergencyResponse (
    response_id SERIAL PRIMARY KEY,
    emergency_case_id INT REFERENCES EmergencyCases(emergency_case_id) ON DELETE CASCADE,
    staff_id INT REFERENCES MedicalStaff(staff_id) ON DELETE SET NULL,
    ambulance_id INT REFERENCES Ambulances(ambulance_id) ON DELETE SET NULL,
    response_time TIMESTAMP DEFAULT NOW()
);

-- Insert into Hospitals
INSERT INTO Hospitals (name, location, capacity) VALUES
('City Hospital', 'New York', 200),
('Green Valley Hospital', 'Los Angeles', 150),
('Sunrise Medical Center', 'Chicago', 180),
('Metro Health', 'Houston', 220);

-- Insert into EmergencyCases
INSERT INTO EmergencyCases (case_type, severity_level, status, hospital_id) VALUES
('Cardiac Arrest', 'Critical', 'Ongoing', 1),
('Road Accident', 'High', 'Pending', 2),
('Fire Injury', 'Medium', 'Resolved', 3),
('Stroke', 'Critical', 'Ongoing', 4);

-- Insert into Patients
INSERT INTO Patients (name, age, gender, contact_info, emergency_case_id) VALUES
('John Doe', 45, 'Male', '1234567890', 1),
('Jane Smith', 30, 'Female', '9876543210', 2),
('Robert Johnson', 50, 'Male', '5678901234', 3),
('Emily Davis', 25, 'Female', '4567890123', 4);

-- Insert into MedicalStaff
INSERT INTO MedicalStaff (name, specialization, contact_info, hospital_id) VALUES
('Dr. Allen', 'Cardiology', 'allen@hospital.com', 1),
('Dr. Miller', 'Trauma Surgery', 'miller@hospital.com', 2),
('Dr. Brown', 'Burn Specialist', 'brown@hospital.com', 3),
('Dr. Wilson', 'Neurology', 'wilson@hospital.com', 4);

-- Insert into Ambulances
INSERT INTO Ambulances (plate_number, status, hospital_id) VALUES
('NY-1234', 'Available', 1),
('LA-5678', 'Busy', 2),
('CH-9101', 'Available', 3),
('TX-1122', 'Maintenance', 4);

-- Insert into EmergencyResponse
INSERT INTO EmergencyResponse (emergency_case_id, staff_id, ambulance_id) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4);

-- Retrieve all patients assigned to a specific emergency case
SELECT * 
FROM Patients 
WHERE emergency_case_id = 1;

-- Find the number of emergency cases handled by each hospital
SELECT h.name AS hospital_name, COUNT(ec.emergency_case_id) AS total_cases
FROM Hospitals h
LEFT JOIN EmergencyCases ec ON h.hospital_id = ec.hospital_id
GROUP BY h.name;

-- List all available ambulances at a particular hospital
SELECT * 
FROM Ambulances 
WHERE hospital_id = 1 AND status = 'Available';

-- Find all medical staff specialized in "Emergency Medicine" in a given hospital
SELECT * 
FROM MedicalStaff 
WHERE specialization = 'Trauma Surgery' AND hospital_id = 2;

-- Get details of the latest emergency case assigned to a hospital
SELECT * FROM EmergencyCases 
WHERE hospital_id = 3 
ORDER BY reported_time DESC 
LIMIT 1;

-- Find which staff member responded to the most emergency cases
SELECT ms.name, COUNT(er.response_id) AS response_count
FROM MedicalStaff ms
JOIN EmergencyResponse er ON ms.staff_id = er.staff_id
GROUP BY ms.name
ORDER BY response_count DESC
LIMIT 1;

-- Check how many emergency cases are still "Pending" in each hospital
SELECT h.name AS hospital_name, COUNT(ec.emergency_case_id) AS pending_cases
FROM Hospitals h
JOIN EmergencyCases ec ON h.hospital_id = ec.hospital_id
WHERE ec.status = 'Pending'
GROUP BY h.name;

-- Find the average age of patients for each severity level
SELECT ec.severity_level, AVG(p.age) AS average_age
FROM Patients p
JOIN EmergencyCases ec ON p.emergency_case_id = ec.emergency_case_id
GROUP BY ec.severity_level;

-- Find the most common type of emergency case
SELECT case_type, COUNT(*) AS case_count
FROM EmergencyCases
GROUP BY case_type
ORDER BY case_count DESC
LIMIT 1;

-- Retrieve details of the busiest ambulance (the one assigned to the most emergency responses)
SELECT a.plate_number, COUNT(er.response_id) AS total_responses
FROM Ambulances a
JOIN EmergencyResponse er ON a.ambulance_id = er.ambulance_id
GROUP BY a.plate_number
ORDER BY total_responses DESC
LIMIT 1;

-- Find the response time for each emergency case (difference between response time and reported time)
SELECT ec.emergency_case_id, ec.case_type, 
       ec.reported_time, er.response_time, 
       AGE(er.response_time, ec.reported_time) AS response_duration
FROM EmergencyCases ec
JOIN EmergencyResponse er ON ec.emergency_case_id = er.emergency_case_id;

-- Find hospitals with the highest number of available ambulances
SELECT h.name AS hospital_name, COUNT(a.ambulance_id) AS available_ambulances
FROM Hospitals h
JOIN Ambulances a ON h.hospital_id = a.hospital_id
WHERE a.status = 'Available'
GROUP BY h.name
ORDER BY available_ambulances DESC
LIMIT 1;
