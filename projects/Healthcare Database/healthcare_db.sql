-- Project In MariaDB 
-- Create database
CREATE DATABASE healthcare_db;
USE healthcare_db;

CREATE TABLE patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    date_of_birth DATE,
    gender ENUM('Male', 'Female', 'Other'),
    phone VARCHAR(20),
    email VARCHAR(100),
    address VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE departments (
    dept_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    location VARCHAR(100)
);

CREATE TABLE doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    specialty VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100),
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

CREATE TABLE appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    appointment_date DATETIME,
    reason VARCHAR(255),
    status ENUM('Scheduled', 'Completed', 'Canceled') DEFAULT 'Scheduled',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

CREATE TABLE medical_records (
    record_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    visit_date DATE,
    diagnosis TEXT,
    treatment_details TEXT,
    notes TEXT,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

CREATE TABLE prescriptions (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    record_id INT,
    medication VARCHAR(100),
    dosage VARCHAR(50),
    duration VARCHAR(50),  -- E.g., "7 days", "2 weeks"
    instructions TEXT,
    FOREIGN KEY (record_id) REFERENCES medical_records(record_id)
);

CREATE TABLE billing (
    bill_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT,
    amount DECIMAL(10,2),
    status ENUM('Paid', 'Due') DEFAULT 'Due',
    bill_date DATE,
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
);

INSERT INTO departments (name, location) VALUES
('Cardiology', 'Building A, Floor 2'),
('Neurology', 'Building B, Floor 3'),
('General Medicine', 'Building C, Floor 1');

INSERT INTO doctors (first_name, last_name, specialty, phone, email, dept_id) VALUES
('John', 'Doe', 'Cardiologist', '555-1001', 'john.doe@hospital.com', 1),
('Jane', 'Smith', 'Neurologist', '555-1002', 'jane.smith@hospital.com', 2),
('Emily', 'Brown', 'General Practitioner', '555-1003', 'emily.brown@hospital.com', 3);

INSERT INTO patients (first_name, last_name, date_of_birth, gender, phone, email, address) VALUES
('Alice', 'Johnson', '1985-06-15', 'Female', '555-2001', 'alice.johnson@example.com', '123 Elm St'),
('Bob', 'Williams', '1978-11-22', 'Male', '555-2002', 'bob.williams@example.com', '456 Maple Ave'),
('Charlie', 'Davis', '1992-02-10', 'Other', '555-2003', 'charlie.davis@example.com', '789 Oak Dr');

INSERT INTO appointments (patient_id, doctor_id, appointment_date, reason) VALUES
(1, 1, '2025-05-10 10:00:00', 'Chest pain and shortness of breath'),
(2, 2, '2025-05-11 11:30:00', 'Frequent headaches and dizziness'),
(3, 3, '2025-05-12 09:00:00', 'General check-up');

INSERT INTO medical_records (patient_id, doctor_id, visit_date, diagnosis, treatment_details, notes) VALUES
(1, 1, '2025-05-10', 'Mild Arrhythmia', 'Prescribed beta blockers', 'Follow-up in 2 weeks'),
(2, 2, '2025-05-11', 'Migraine', 'Advised lifestyle changes and pain relievers', 'Monitor headache frequency');

INSERT INTO prescriptions (record_id, medication, dosage, duration, instructions) VALUES
(1, 'Metoprolol', '50mg', '30 days', 'Once daily in the morning'),
(2, 'Sumatriptan', '100mg', 'As needed', 'Take at onset of migraine');

INSERT INTO billing (appointment_id, amount, status, bill_date) VALUES
(1, 250.00, 'Due', '2025-05-10'),
(2, 180.00, 'Paid', '2025-05-11');

-- Retrieve All Scheduled Appointments
SELECT a.appointment_id, p.first_name, p.last_name, d.first_name AS doctor_first, d.last_name AS doctor_last, a.appointment_date, a.reason
FROM appointments a
JOIN patients p ON a.patient_id = p.patient_id
JOIN doctors d ON a.doctor_id = d.doctor_id
WHERE a.status = 'Scheduled';

-- Get Patient Medical History (for a given patient)
SELECT mr.record_id, mr.visit_date, mr.diagnosis, mr.treatment_details, mr.notes
FROM medical_records mr
WHERE mr.patient_id = 1
ORDER BY mr.visit_date DESC;

-- List Outstanding Bills
SELECT b.bill_id, b.amount, b.bill_date, p.first_name, p.last_name
FROM billing b
JOIN appointments a ON b.appointment_id = a.appointment_id
JOIN patients p ON a.patient_id = p.patient_id
WHERE b.status = 'Due';

-- Find Prescriptions for a Specific Medical Record
SELECT medication, dosage, duration, instructions
FROM prescriptions
WHERE record_id = 1;

-- List of Doctors by Department
SELECT d.name AS department, doc.first_name, doc.last_name, doc.specialty
FROM doctors doc
JOIN departments d ON doc.dept_id = d.dept_id
ORDER BY d.name, doc.last_name;

-- Billing Summary for a Patient
SELECT b.bill_id, b.amount, b.status, b.bill_date
FROM billing b
JOIN appointments a ON b.appointment_id = a.appointment_id
WHERE a.patient_id = 1
ORDER BY b.bill_date DESC;

-- Total Revenue Generated
SELECT SUM(amount) AS total_revenue
FROM billing
WHERE status = 'Paid';

-- Count of Appointments Per Department
SELECT dep.name AS department, COUNT(a.appointment_id) AS total_appointments
FROM appointments a
JOIN doctors doc ON a.doctor_id = doc.doctor_id
JOIN departments dep ON doc.dept_id = dep.dept_id
GROUP BY dep.name;

-- Top Diagnosed Conditions
SELECT diagnosis, COUNT(*) AS count
FROM medical_records
GROUP BY diagnosis
ORDER BY count DESC
LIMIT 1;

-- Monthly Appointment Count
SELECT DATE_FORMAT(appointment_date, '%Y-%m') AS month, COUNT(*) AS appointments
FROM appointments
GROUP BY month
ORDER BY month DESC;
