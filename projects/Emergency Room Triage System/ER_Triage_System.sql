-- Maria DB Project
-- Create Database
CREATE DATABASE ER_Triage_System;
USE ER_Triage_System;

-- Patients Table 
CREATE TABLE patients (
  patient_id INT PRIMARY KEY AUTO_INCREMENT,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  dob DATE,
  gender VARCHAR(10),
  phone BIGINT,
  address TEXT,
  insurance_id VARCHAR(50) NULL
);

-- Staff Table 
CREATE TABLE staff (
  staff_id INT PRIMARY KEY AUTO_INCREMENT,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  role ENUM('Nurse', 'Admin', 'Receptionist'),
  phone BIGINT,
  email VARCHAR(100) UNIQUE
);

-- Triage Table 
CREATE TABLE triage (
  triage_id INT PRIMARY KEY AUTO_INCREMENT,
  patient_id INT,
  arrival_time DATETIME,
  priority_level VARCHAR(10) CHECK (priority_level IN ('Low', 'Medium', 'High', 'Critical')),
  symptoms TEXT,
  blood_pressure VARCHAR(10),
  heart_rate INT,
  temperature DECIMAL(4,2),
  triage_nurse_id INT,
  FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
  FOREIGN KEY (triage_nurse_id) REFERENCES staff(staff_id)
);

-- Doctors Table 
CREATE TABLE doctors (
  doctor_id INT PRIMARY KEY AUTO_INCREMENT,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  specialty VARCHAR(100),
  phone BIGINT,
  email VARCHAR(100) UNIQUE
);

-- Visits Table 
CREATE TABLE visits (
  visit_id INT PRIMARY KEY AUTO_INCREMENT,
  patient_id INT,
  doctor_id INT,
  triage_id INT,
  visit_time DATETIME,
  diagnosis TEXT,
  treatment TEXT,
  FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
  FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id),
  FOREIGN KEY (triage_id) REFERENCES triage(triage_id)
);

-- Medications Table 
CREATE TABLE medications (
  medication_id INT PRIMARY KEY AUTO_INCREMENT,
  med_name VARCHAR(100),
  description TEXT
);

-- Prescriptions Table 
CREATE TABLE prescriptions (
  prescription_id INT PRIMARY KEY AUTO_INCREMENT,
  visit_id INT,
  medication_id INT,
  dosage VARCHAR(50),
  instructions TEXT,
  FOREIGN KEY (visit_id) REFERENCES visits(visit_id),
  FOREIGN KEY (medication_id) REFERENCES medications(medication_id)
);

-- Billing Table  
CREATE TABLE billing (
  bill_id INT PRIMARY KEY AUTO_INCREMENT,
  visit_id INT,
  amount DECIMAL(10,2),
  status ENUM('Paid', 'Unpaid', 'Pending'),
  payment_date DATETIME NULL,
  FOREIGN KEY (visit_id) REFERENCES visits(visit_id)
);

-- Insert Sample Data into Patients Table
INSERT INTO patients (first_name, last_name, dob, gender, phone, address, insurance_id) VALUES
('John', 'Doe', '1985-06-15', 'Male', 1234567890, '123 Main St, NY', 'INS12345'),
('Jane', 'Smith', '1992-09-22', 'Female', 9876543210, '456 Elm St, CA', 'INS67890'),
('Michael', 'Brown', '1978-03-10', 'Male', 1122334455, '789 Oak St, TX', NULL),
('Emily', 'Davis', '2000-12-01', 'Female', 2233445566, '321 Pine St, FL', 'INS34567'),
('David', 'Wilson', '1995-07-07', 'Male', 3344556677, '654 Birch St, WA', NULL),
('Sarah', 'Miller', '1989-11-30', 'Female', 4455667788, '987 Cedar St, NV', 'INS89012');

-- Insert Sample Data into Staff Table
INSERT INTO staff (first_name, last_name, role, phone, email) VALUES
('Alice', 'Johnson', 'Nurse', 5551234567, 'alice.johnson@example.com'),
('Robert', 'Williams', 'Admin', 5559876543, 'robert.williams@example.com'),
('Linda', 'Martinez', 'Receptionist', 5551122334, 'linda.martinez@example.com');

-- Insert Sample Data into Triage Table
INSERT INTO triage (patient_id, arrival_time, priority_level, symptoms, blood_pressure, heart_rate, temperature, triage_nurse_id) VALUES
(1, '2025-02-24 08:30:00', 'High', 'Chest pain, shortness of breath', '140/90', 95, 37.5, 1),
(2, '2025-02-24 09:15:00', 'Medium', 'Fever, headache', '120/80', 88, 38.2, 1),
(3, '2025-02-24 10:00:00', 'Critical', 'Severe bleeding', '110/70', 102, 36.8, 1),
(4, '2025-02-24 10:45:00', 'Low', 'Mild cough', '115/75', 85, 37.0, 1),
(5, '2025-02-24 11:30:00', 'High', 'Difficulty breathing', '130/85', 98, 37.8, 1),
(6, '2025-02-24 12:15:00', 'Medium', 'Dizziness', '118/78', 90, 37.1, 1);

-- Insert Sample Data into Doctors Table
INSERT INTO doctors (first_name, last_name, specialty, phone, email) VALUES
('Dr. James', 'Anderson', 'Cardiology', 6661234567, 'james.anderson@example.com'),
('Dr. Laura', 'Taylor', 'Neurology', 6669876543, 'laura.taylor@example.com');

-- Insert Sample Data into Visits Table
INSERT INTO visits (patient_id, doctor_id, triage_id, visit_time, diagnosis, treatment) VALUES
(1, 1, 1, '2025-02-24 09:00:00', 'Heart attack', 'Administer oxygen, medication'),
(2, 2, 2, '2025-02-24 09:45:00', 'Viral infection', 'Prescribed antiviral medication'),
(3, 1, 3, '2025-02-24 10:30:00', 'Severe trauma', 'Surgery required'),
(4, 2, 4, '2025-02-24 11:15:00', 'Common cold', 'Rest and fluids'),
(5, 1, 5, '2025-02-24 12:00:00', 'Asthma attack', 'Nebulization and steroids'),
(6, 2, 6, '2025-02-24 12:45:00', 'Vertigo', 'Prescribed dizziness medication');

-- Insert Sample Data into Medications Table
INSERT INTO medications (med_name, description) VALUES
('Aspirin', 'Pain reliever and anti-inflammatory'),
('Ibuprofen', 'Used for pain relief and fever reduction'),
('Paracetamol', 'Commonly used for pain and fever'),
('Antiviral Med A', 'Used to treat viral infections'),
('Steroid B', 'Used for inflammation and immune response'),
('Dizziness Med C', 'Used to treat vertigo and dizziness');

-- Insert Sample Data into Prescriptions Table
INSERT INTO prescriptions (visit_id, medication_id, dosage, instructions) VALUES
(1, 1, '100mg', 'Take once daily after food'),
(2, 4, '250mg', 'Take twice daily for 5 days'),
(3, 2, '200mg', 'Every 6 hours as needed'),
(4, 3, '500mg', 'Once daily for 7 days'),
(5, 5, '50mg', 'Take as directed by doctor'),
(6, 6, '10mg', 'Before bed for dizziness relief');

-- Insert Sample Data into Billing Table
INSERT INTO billing (visit_id, amount, status, payment_date) VALUES
(1, 500.00, 'Paid', '2025-02-24 10:00:00'),
(2, 200.00, 'Unpaid', NULL),
(3, 1500.00, 'Pending', NULL),
(4, 50.00, 'Paid', '2025-02-24 11:30:00'),
(5, 300.00, 'Unpaid', NULL),
(6, 100.00, 'Paid', '2025-02-24 13:00:00');

-- Find the number of patients assigned a "Critical" priority in the last 24 hours.
SELECT COUNT(*) AS critical_patients
FROM triage
WHERE priority_level = 'Critical' 
AND arrival_time >= NOW() - INTERVAL 1 DAY;

-- List all patients who have been seen by a specific doctor (doctor_id = X) along with their diagnoses.
SELECT p.patient_id, p.first_name, p.last_name, v.diagnosis
FROM visits v
JOIN patients p ON v.patient_id = p.patient_id
WHERE v.doctor_id = 2;

-- Find the average wait time between triage and doctor visit.
SELECT AVG(TIMESTAMPDIFF(MINUTE, t.arrival_time, v.visit_time)) AS avg_wait_time_minutes
FROM triage t
JOIN visits v ON t.triage_id = v.triage_id;

-- List all prescriptions given for a particular medication (medication_id = X).
SELECT pr.prescription_id, pr.dosage, pr.instructions, v.visit_time, p.first_name, p.last_name
FROM prescriptions pr
JOIN visits v ON pr.visit_id = v.visit_id
JOIN patients p ON v.patient_id = p.patient_id
WHERE pr.medication_id = 4;

-- Show total revenue from all hospital visits in the last month.
SELECT SUM(amount) AS total_revenue
FROM billing
WHERE payment_date >= NOW() - INTERVAL 1 MONTH;

-- Find doctors who have seen more than 2 patients in the past week.
SELECT d.doctor_id, d.first_name, d.last_name, COUNT(v.visit_id) AS patient_count
FROM visits v
JOIN doctors d ON v.doctor_id = d.doctor_id
WHERE v.visit_time >= NOW() - INTERVAL 7 DAY
GROUP BY d.doctor_id
HAVING COUNT(v.visit_id) > 2;

-- Retrieve the top 3 most common diagnoses recorded in the system.
SELECT diagnosis, COUNT(*) AS diagnosis_count
FROM visits
GROUP BY diagnosis
ORDER BY diagnosis_count DESC
LIMIT 3;

-- List all unpaid bills along with patient names and contact details.
SELECT b.bill_id, p.first_name, p.last_name, p.phone, b.amount, b.status
FROM billing b
JOIN visits v ON b.visit_id = v.visit_id
JOIN patients p ON v.patient_id = p.patient_id
WHERE b.status = 'Unpaid';

-- Find out which staff member has handled the most triage cases.
SELECT s.staff_id, s.first_name, s.last_name, COUNT(t.triage_id) AS triage_count
FROM triage t
JOIN staff s ON t.triage_nurse_id = s.staff_id
GROUP BY s.staff_id
ORDER BY triage_count DESC
LIMIT 1;

-- Find the busiest hour of the day based on patient arrivals in triage
SELECT HOUR(arrival_time) AS hour_of_day, COUNT(*) AS patient_count
FROM triage
GROUP BY hour_of_day
ORDER BY patient_count DESC
LIMIT 1;

-- Retrieve a list of patients with the highest number of visits
SELECT p.patient_id, p.first_name, p.last_name, COUNT(v.visit_id) AS visit_count
FROM visits v
JOIN patients p ON v.patient_id = p.patient_id
GROUP BY p.patient_id
ORDER BY visit_count DESC
LIMIT 3;

-- Find the most common symptoms reported during triage
SELECT symptoms, COUNT(*) AS symptom_count
FROM triage
GROUP BY symptoms
ORDER BY symptom_count DESC
LIMIT 4;
