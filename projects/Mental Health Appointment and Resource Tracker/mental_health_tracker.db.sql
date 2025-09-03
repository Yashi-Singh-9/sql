-- Project in SQL Lite 
-- Database Creaton 
sqlite3 mental_health_tracker.db
USE mental_health_tracker

-- Table: Patients
CREATE TABLE patients (
    patient_id INTEGER PRIMARY KEY AUTOINCREMENT,
    full_name TEXT NOT NULL,
    email TEXT UNIQUE,
    phone TEXT,
    date_of_birth DATE,
    registered_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Table: Therapists
CREATE TABLE therapists (
    therapist_id INTEGER PRIMARY KEY AUTOINCREMENT,
    full_name TEXT NOT NULL,
    specialization TEXT,
    email TEXT,
    phone TEXT
);

-- Table: Appointments
CREATE TABLE appointments (
    appointment_id INTEGER PRIMARY KEY AUTOINCREMENT,
    patient_id INTEGER,
    therapist_id INTEGER,
    appointment_date DATETIME,
    notes TEXT,
    FOREIGN KEY(patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY(therapist_id) REFERENCES therapists(therapist_id)
);

-- Table: Mental Health Assessments
CREATE TABLE assessments (
    assessment_id INTEGER PRIMARY KEY AUTOINCREMENT,
    patient_id INTEGER,
    assessment_date DATE,
    anxiety_score INTEGER,
    depression_score INTEGER,
    notes TEXT,
    FOREIGN KEY(patient_id) REFERENCES patients(patient_id)
);

-- Table: Resources Shared
CREATE TABLE resources (
    resource_id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT,
    description TEXT,
    link TEXT
);

-- Table: Patient Resource Tracking
CREATE TABLE patient_resources (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    patient_id INTEGER,
    resource_id INTEGER,
    shared_date DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY(patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY(resource_id) REFERENCES resources(resource_id)
);

-- Patients
INSERT INTO patients (full_name, email, phone, date_of_birth) VALUES
('Alex Morgan', 'alex@example.com', '555-2001', '1990-03-15'),
('Jamie Lee', 'jamie@example.com', '555-2002', '1985-07-20');

-- Therapists
INSERT INTO therapists (full_name, specialization, email, phone) VALUES
('Dr. Sara Collins', 'Anxiety', 'sara@clinic.com', '555-3001'),
('Dr. Ken Murray', 'Depression', 'ken@clinic.com', '555-3002');

-- Appointments
INSERT INTO appointments (patient_id, therapist_id, appointment_date, notes) VALUES
(1, 1, '2025-04-10 10:00:00', 'Initial consultation. Mild anxiety symptoms.'),
(2, 2, '2025-04-11 14:30:00', 'Discussed recent depressive episodes.');

-- Assessments
INSERT INTO assessments (patient_id, assessment_date, anxiety_score, depression_score, notes) VALUES
(1, '2025-04-10', 6, 3, 'Moderate anxiety, no depression.'),
(2, '2025-04-11', 2, 7, 'Severe depression, mild anxiety.');

-- Resources
INSERT INTO resources (title, description, link) VALUES
('Mindfulness Guide', 'Beginner techniques for mindfulness.', 'http://mentalhealth.org/mindfulness'),
('Depression Support App', 'Mobile app for journaling and mood tracking.', 'http://mentalhealth.org/depression-app');

-- Shared resources
INSERT INTO patient_resources (patient_id, resource_id) VALUES
(1, 1),
(2, 2);

-- List all upcoming appointments
SELECT a.appointment_date, p.full_name AS patient, t.full_name AS therapist
FROM appointments a
JOIN patients p ON a.patient_id = p.patient_id
JOIN therapists t ON a.therapist_id = t.therapist_id
WHERE a.appointment_date >= datetime('now')
ORDER BY a.appointment_date;

-- View assessment history for a patient
SELECT assessment_date, anxiety_score, depression_score, notes
FROM assessments
WHERE patient_id = 1
ORDER BY assessment_date DESC;

-- Resources shared with each patient
SELECT p.full_name, r.title, pr.shared_date
FROM patient_resources pr
JOIN patients p ON pr.patient_id = p.patient_id
JOIN resources r ON pr.resource_id = r.resource_id;

-- Top patients with high depression scores
SELECT p.full_name, a.depression_score
FROM assessments a
JOIN patients p ON a.patient_id = p.patient_id
WHERE a.depression_score >= 6
ORDER BY a.depression_score DESC;

-- Average Anxiety and Depression Score per Patient
SELECT 
    p.full_name,
    ROUND(AVG(a.anxiety_score), 2) AS avg_anxiety,
    ROUND(AVG(a.depression_score), 2) AS avg_depression
FROM patients p
JOIN assessments a ON p.patient_id = a.patient_id
GROUP BY p.full_name
ORDER BY avg_depression DESC;

-- Most Frequently Shared Resources
SELECT 
    r.title,
    COUNT(pr.id) AS times_shared
FROM resources r
JOIN patient_resources pr ON r.resource_id = pr.resource_id
GROUP BY r.title
ORDER BY times_shared DESC;

-- Therapist Workload Overview
SELECT 
    t.full_name AS therapist,
    COUNT(a.appointment_id) AS total_appointments
FROM therapists t
LEFT JOIN appointments a ON t.therapist_id = a.therapist_id
GROUP BY t.full_name
ORDER BY total_appointments DESC;

-- Most Recent Assessment for Each Patient
SELECT 
    p.full_name,
    a.assessment_date,
    a.anxiety_score,
    a.depression_score
FROM assessments a
JOIN patients p ON a.patient_id = p.patient_id
WHERE a.assessment_date = (
    SELECT MAX(assessment_date) 
    FROM assessments 
    WHERE patient_id = p.patient_id
);

-- Appointment Count by Month (Current Year)
SELECT 
    strftime('%Y-%m', appointment_date) AS month,
    COUNT(*) AS total_appointments
FROM appointments
WHERE strftime('%Y', appointment_date) = strftime('%Y', 'now')
GROUP BY month
ORDER BY month;

-- Trend: Anxiety Score Change Over Time for a Patient
SELECT 
    assessment_date,
    anxiety_score
FROM assessments
WHERE patient_id = 1
ORDER BY assessment_date;

-- Patients Who Have Received Multiple Resources
SELECT 
    p.full_name,
    COUNT(pr.resource_id) AS resources_shared
FROM patients p
JOIN patient_resources pr ON p.patient_id = pr.patient_id
GROUP BY p.full_name
HAVING COUNT(pr.resource_id) > 1;

-- Detailed Appointment History for a Given Therapist
SELECT 
    a.appointment_date,
    p.full_name AS patient,
    a.notes
FROM appointments a
JOIN patients p ON a.patient_id = p.patient_id
WHERE a.therapist_id = 1  
ORDER BY a.appointment_date DESC;
