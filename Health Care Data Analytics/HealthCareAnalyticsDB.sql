-- Project In MariaDB 
-- Creating the database
CREATE DATABASE HealthCareAnalyticsDB;
USE HealthCareAnalyticsDB;

CREATE TABLE Patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    date_of_birth DATE,
    gender ENUM('Male', 'Female', 'Other'),
    contact_number VARCHAR(15),
    email VARCHAR(100),
    address TEXT,
    insurance_id INT
);

CREATE TABLE Doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    specialization VARCHAR(100),
    phone_number VARCHAR(15),
    email VARCHAR(100)
);

CREATE TABLE Appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    appointment_date DATE,
    appointment_time TIME,
    status ENUM('Scheduled', 'Completed', 'Canceled'),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

CREATE TABLE Medical_Records (
    record_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    diagnosis TEXT,
    treatment TEXT,
    prescription TEXT,
    record_date DATE,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

CREATE TABLE Billing (
    bill_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    appointment_id INT,
    total_amount DECIMAL(10,2),
    insurance_covered DECIMAL(10,2),
    amount_due DECIMAL(10,2),
    payment_status ENUM('Paid', 'Pending'),
    billing_date DATE,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id)
);

CREATE TABLE Insurance (
    insurance_id INT AUTO_INCREMENT PRIMARY KEY,
    insurance_provider VARCHAR(100),
    insurance_type VARCHAR(50),
    coverage_details TEXT
);

CREATE TABLE Medications (
    medication_id INT AUTO_INCREMENT PRIMARY KEY,
    medication_name VARCHAR(100),
    dosage VARCHAR(50),
    side_effects TEXT
);

CREATE TABLE Prescriptions (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    record_id INT,
    medication_id INT,
    dosage_instructions TEXT,
    prescription_date DATE,
    FOREIGN KEY (record_id) REFERENCES Medical_Records(record_id),
    FOREIGN KEY (medication_id) REFERENCES Medications(medication_id)
);

INSERT INTO Patients (first_name, last_name, date_of_birth, gender, contact_number, email, address, insurance_id) VALUES
('John', 'Doe', '1985-06-15', 'Male', '1234567890', 'john.doe@example.com', '123 Main St', 1),
('Jane', 'Smith', '1992-03-25', 'Female', '9876543210', 'jane.smith@example.com', '456 Elm St', 2),
('Robert', 'Brown', '1978-09-12', 'Male', '5556667777', 'robert.brown@example.com', '789 Oak St', 3),
('Emily', 'Davis', '1995-11-30', 'Female', '4445556666', 'emily.davis@example.com', '159 Pine St', 2),
('Michael', 'Wilson', '1989-08-21', 'Male', '7778889999', 'michael.wilson@example.com', '753 Birch St', 1);

INSERT INTO Doctors (first_name, last_name, specialization, phone_number, email) VALUES
('Alice', 'Green', 'Cardiologist', '1112223333', 'alice.green@example.com'),
('Bob', 'White', 'Dermatologist', '4445556666', 'bob.white@example.com'),
('Charlie', 'Black', 'Neurologist', '7778889999', 'charlie.black@example.com');

INSERT INTO Appointments (patient_id, doctor_id, appointment_date, appointment_time, status) VALUES
(1, 1, '2025-01-10', '10:00:00', 'Completed'),
(2, 2, '2025-02-12', '11:30:00', 'Scheduled'),
(3, 1, '2025-01-18', '14:00:00', 'Canceled'),
(4, 3, '2025-03-05', '09:00:00', 'Completed'),
(5, 2, '2025-03-20', '16:45:00', 'Scheduled');

INSERT INTO Medical_Records (patient_id, doctor_id, diagnosis, treatment, prescription, record_date) VALUES
(1, 1, 'Hypertension', 'Medication & Lifestyle Change', 'Aspirin', '2025-01-10'),
(2, 2, 'Skin Rash', 'Topical Cream', 'Hydrocortisone', '2025-02-12'),
(3, 1, 'Migraine', 'Pain Management', 'Ibuprofen', '2025-01-18'),
(4, 3, 'Anxiety', 'Cognitive Therapy', 'Sertraline', '2025-03-05'),
(5, 2, 'Acne', 'Oral Antibiotics', 'Doxycycline', '2025-03-20');

INSERT INTO Billing (patient_id, appointment_id, total_amount, insurance_covered, amount_due, payment_status, billing_date) VALUES
(1, 1, 500.00, 300.00, 200.00, 'Paid', '2025-01-11'),
(2, 2, 200.00, 150.00, 50.00, 'Pending', '2025-02-13'),
(3, 3, 450.00, 350.00, 100.00, 'Paid', '2025-01-19'),
(4, 4, 600.00, 500.00, 100.00, 'Pending', '2025-03-06'),
(5, 5, 150.00, 100.00, 50.00, 'Paid', '2025-03-21');

INSERT INTO Insurance (insurance_provider, insurance_type, coverage_details) VALUES
('Aetna', 'Gold Plan', 'Covers 80% of medical expenses'),
('Blue Cross', 'Silver Plan', 'Covers 70% of medical expenses'),
('Cigna', 'Bronze Plan', 'Covers 60% of medical expenses');

INSERT INTO Medications (medication_name, dosage, side_effects) VALUES
('Aspirin', '75mg daily', 'Nausea, stomach pain'),
('Hydrocortisone', 'Apply twice daily', 'Skin irritation'),
('Ibuprofen', '200mg every 6 hours', 'Drowsiness, headache'),
('Sertraline', '50mg daily', 'Dizziness, dry mouth'),
('Doxycycline', '100mg once daily', 'Nausea, sensitivity to sunlight');

INSERT INTO Prescriptions (record_id, medication_id, dosage_instructions, prescription_date) VALUES
(1, 1, 'Take one tablet daily after meal', '2025-01-10'),
(2, 2, 'Apply cream twice a day', '2025-02-12'),
(3, 3, 'Take one tablet every 6 hours', '2025-01-18'),
(4, 4, 'Take one tablet daily in the morning', '2025-03-05'),
(5, 5, 'Take one capsule daily after breakfast', '2025-03-20');

-- Find the number of appointments each doctor has in a given month.
SELECT d.doctor_id, d.first_name, d.last_name, COUNT(a.appointment_id) AS total_appointments
FROM Appointments a
JOIN Doctors d ON a.doctor_id = d.doctor_id
WHERE MONTH(a.appointment_date) = 1 AND YEAR(a.appointment_date) = 2025
GROUP BY d.doctor_id;

-- List all patients who have unpaid bills.
SELECT p.patient_id, p.first_name, p.last_name, b.amount_due
FROM Billing b
JOIN Patients p ON b.patient_id = p.patient_id
WHERE b.payment_status = 'Pending';

-- Retrieve the details of all appointments for a particular patient
SELECT a.appointment_id, p.first_name, p.last_name, d.first_name AS doctor_name, 
       a.appointment_date, a.status
FROM Appointments a
JOIN Patients p ON a.patient_id = p.patient_id
JOIN Doctors d ON a.doctor_id = d.doctor_id
WHERE a.patient_id = 1;

-- Find the total revenue generated by each doctor based on completed appointments.
SELECT d.doctor_id, d.first_name, d.last_name, SUM(b.total_amount) AS total_revenue
FROM Billing b
JOIN Appointments a ON b.appointment_id = a.appointment_id
JOIN Doctors d ON a.doctor_id = d.doctor_id
WHERE a.status = 'Completed'
GROUP BY d.doctor_id;

-- Find the most common diagnosis given by a specific doctor
SELECT diagnosis, COUNT(*) AS count
FROM Medical_Records
WHERE doctor_id = 1
GROUP BY diagnosis
ORDER BY count DESC
LIMIT 1;

-- Retrieve all patients who have been prescribed a specific medication
SELECT p.patient_id, p.first_name, p.last_name, m.medication_name
FROM Prescriptions pr
JOIN Medical_Records mr ON pr.record_id = mr.record_id
JOIN Patients p ON mr.patient_id = p.patient_id
JOIN Medications m ON pr.medication_id = m.medication_id
WHERE pr.medication_id = 1;

-- Find patients whose insurance does not cover their total bill
SELECT p.patient_id, p.first_name, p.last_name, b.total_amount, b.insurance_covered, b.amount_due
FROM Billing b
JOIN Patients p ON b.patient_id = p.patient_id
WHERE b.insurance_covered < b.total_amount;

-- Identify doctors with the highest number of consultations in the last 6 months.
SELECT d.doctor_id, d.first_name, d.last_name, COUNT(a.appointment_id) AS total_consultations
FROM Appointments a
JOIN Doctors d ON a.doctor_id = d.doctor_id
WHERE a.appointment_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY d.doctor_id
ORDER BY total_consultations DESC
LIMIT 3;

-- List the top 5 most prescribed medications.
SELECT m.medication_name, COUNT(pr.prescription_id) AS times_prescribed
FROM Prescriptions pr
JOIN Medications m ON pr.medication_id = m.medication_id
GROUP BY m.medication_name
ORDER BY times_prescribed DESC
LIMIT 5;

-- Find the average bill amount per patient.
SELECT p.patient_id, p.first_name, p.last_name, AVG(b.total_amount) AS avg_bill_amount
FROM Billing b
JOIN Patients p ON b.patient_id = p.patient_id
GROUP BY p.patient_id
ORDER BY avg_bill_amount DESC;

-- Identify the doctor who has handled the most appointments.
SELECT d.doctor_id, d.first_name, d.last_name, COUNT(a.appointment_id) AS total_appointments
FROM Appointments a
JOIN Doctors d ON a.doctor_id = d.doctor_id
GROUP BY d.doctor_id
ORDER BY total_appointments DESC
LIMIT 1;

-- List all patients who have never missed an appointment 
SELECT p.patient_id, p.first_name, p.last_name
FROM Patients p
WHERE p.patient_id NOT IN (
    SELECT DISTINCT a.patient_id 
    FROM Appointments a 
    WHERE a.status = 'Canceled'
);

-- Find the percentage of completed, scheduled, and canceled appointments.
SELECT status, 
       COUNT(*) AS total_count, 
       ROUND((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM Appointments), 2) AS percentage
FROM Appointments
GROUP BY status;

-- Get a list of all medications along with the number of times they have been prescribed.
SELECT m.medication_name, COUNT(pr.prescription_id) AS total_prescribed
FROM Prescriptions pr
JOIN Medications m ON pr.medication_id = m.medication_id
GROUP BY m.medication_name
ORDER BY total_prescribed DESC;
