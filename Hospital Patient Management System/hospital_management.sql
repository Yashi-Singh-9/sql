-- Project in PostgreSQL 
-- Create Database
CREATE DATABASE hospital_management;

-- Connect to Database
\c hospital_management;

-- Create Patients Table
CREATE TABLE Patients (
    patient_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    age INT,
    gender VARCHAR(10),
    contact VARCHAR(15),
    address TEXT
);

-- Create Doctors Table
CREATE TABLE Doctors (
    doctor_id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    specialization VARCHAR(50),
    contact VARCHAR(15)
);

-- Create Appointments Table
CREATE TABLE Appointments (
    appointment_id SERIAL PRIMARY KEY,
    patient_id INT REFERENCES Patients(patient_id),
    doctor_id INT REFERENCES Doctors(doctor_id),
    appointment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) CHECK (status IN ('Scheduled', 'Completed', 'Cancelled'))
);

-- Insert Data into Patients
INSERT INTO Patients (first_name, last_name, age, gender, contact, address) VALUES
('John', 'Doe', 30, 'Male', '1234567890', '123 Main St'),
('Alice', 'Smith', 25, 'Female', '2345678901', '456 Park Ave'),
('Robert', 'Brown', 40, 'Male', '3456789012', '789 Elm St'),
('Emma', 'Davis', 28, 'Female', '4567890123', '321 Oak St'),
('Michael', 'Wilson', 50, 'Male', '5678901234', '567 Pine St');

-- Insert Data into Doctors
INSERT INTO Doctors (name, specialization, contact) VALUES
('Dr. Sarah Johnson', 'Cardiologist', '1111111111'),
('Dr. James Miller', 'Neurologist', '2222222222'),
('Dr. Laura White', 'Pediatrician', '3333333333'),
('Dr. David Anderson', 'Dermatologist', '4444444444'),
('Dr. Susan Martin', 'Orthopedic', '5555555555');

-- Insert Data into Appointments
INSERT INTO Appointments (patient_id, doctor_id, appointment_date, status) VALUES
(1, 1, '2025-03-05 10:00:00', 'Scheduled'),
(2, 3, '2025-03-06 14:30:00', 'Completed'),
(3, 2, '2025-03-07 11:00:00', 'Scheduled'),
(4, 5, '2025-03-08 15:00:00', 'Cancelled'),
(5, 4, '2025-03-09 09:00:00', 'Scheduled');

-- Retrieve All Patients
SELECT * FROM Patients;

-- List All Doctors and Their Specializations
SELECT name, specialization FROM Doctors;

-- Show Scheduled Appointments with Patient and Doctor Names
SELECT a.appointment_id, p.first_name || ' ' || p.last_name AS patient_name, 
       d.name AS doctor_name, a.appointment_date, a.status
FROM Appointments a
JOIN Patients p ON a.patient_id = p.patient_id
JOIN Doctors d ON a.doctor_id = d.doctor_id
WHERE a.status = 'Scheduled';

-- Count the Number of Appointments per Doctor
SELECT d.name AS doctor_name, COUNT(a.appointment_id) AS total_appointments
FROM Doctors d
LEFT JOIN Appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.name;

-- Find Patients Who Have an Appointment with a Specific Doctor (e.g., Dr. James Miller)
SELECT p.first_name, p.last_name, a.appointment_date
FROM Patients p
JOIN Appointments a ON p.patient_id = a.patient_id
JOIN Doctors d ON a.doctor_id = d.doctor_id
WHERE d.name = 'Dr. James Miller';

-- Retrieve All Female Patients
SELECT * FROM Patients WHERE gender = 'Female';

-- Get the Total Number of Patients
SELECT COUNT(*) AS total_patients FROM Patients;

-- Retrieve Patients Assigned to a Specific Doctor (e.g., Dr. Laura White)
SELECT p.first_name, p.last_name, d.name AS doctor_name
FROM Patients p
JOIN Appointments a ON p.patient_id = a.patient_id
JOIN Doctors d ON a.doctor_id = d.doctor_id
WHERE d.name = 'Dr. Laura White';

-- Show the Number of Appointments Per Status
SELECT status, COUNT(*) AS count FROM Appointments GROUP BY status;

-- Find the Next Upcoming Appointments
SELECT * FROM Appointments WHERE appointment_date > NOW() ORDER BY appointment_date ASC LIMIT 5;

-- Get the Most Frequent Doctor (Doctor with Most Appointments)
SELECT d.name, d.specialization, COUNT(a.appointment_id) AS total_appointments
FROM Doctors d
JOIN Appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id
ORDER BY total_appointments DESC
LIMIT 1;

-- Retrieve Appointments Between Two Dates
SELECT * FROM Appointments 
WHERE appointment_date BETWEEN '2025-03-01' AND '2025-03-10';

-- Get the Average Age of Patients
SELECT AVG(age) AS average_age FROM Patients;

-- Show All Doctors Along with the Number of Patients They Have Treated
SELECT d.name AS doctor_name, d.specialization, COUNT(a.patient_id) AS total_patients 
FROM Doctors d 
LEFT JOIN Appointments a ON d.doctor_id = a.doctor_id 
GROUP BY d.doctor_id;

-- Find the Doctor Who Has Treated the Most Patients
SELECT d.name, d.specialization, COUNT(a.patient_id) AS total_patients
FROM Doctors d
JOIN Appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id
ORDER BY total_patients DESC
LIMIT 1;

-- Display the Last 5 Completed Appointments
SELECT * FROM Appointments 
WHERE status = 'Completed' 
ORDER BY appointment_date DESC 
LIMIT 5;

-- Show the List of Patients Who Have Missed (Cancelled) Their Appointments
SELECT p.first_name, p.last_name, a.appointment_date 
FROM Patients p
JOIN Appointments a ON p.patient_id = a.patient_id
WHERE a.status = 'Cancelled';
