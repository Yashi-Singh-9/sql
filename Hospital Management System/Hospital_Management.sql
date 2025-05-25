-- Project In MariaDB 
-- Creating the database
CREATE DATABASE Hospital_Management;
USE Hospital_Management;

-- Create Patients Table
CREATE TABLE Patients (
    PatientID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DOB DATE,
    Gender ENUM('Male', 'Female', 'Other'),
    ContactNumber VARCHAR(15),
    Address TEXT,
    BloodGroup VARCHAR(5),
    MedicalHistory TEXT
);

-- Create Doctors Table
CREATE TABLE Doctors (
    DoctorID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Specialization VARCHAR(100),
    Phone VARCHAR(15),
    Email VARCHAR(100),
    ExperienceYears INT
);

-- Create Appointments Table
CREATE TABLE Appointments (
    AppointmentID INT PRIMARY KEY AUTO_INCREMENT,
    PatientID INT,
    DoctorID INT,
    AppointmentDate DATETIME,
    Status ENUM('Pending', 'Completed', 'Cancelled'),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

-- Create Departments Table
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY AUTO_INCREMENT,
    DepartmentName VARCHAR(100),
    HeadDoctorID INT,
    FOREIGN KEY (HeadDoctorID) REFERENCES Doctors(DoctorID)
);

-- Create Staff Table
CREATE TABLE Staff (
    StaffID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Role VARCHAR(50),
    Phone VARCHAR(15),
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Create Rooms Table
CREATE TABLE Rooms (
    RoomID INT PRIMARY KEY AUTO_INCREMENT,
    RoomType ENUM('ICU', 'General', 'Private'),
    Capacity INT,
    OccupiedStatus ENUM('Occupied', 'Available')
);

-- Create Admissions Table
CREATE TABLE Admissions (
    AdmissionID INT PRIMARY KEY AUTO_INCREMENT,
    PatientID INT,
    RoomID INT,
    DoctorID INT,
    AdmissionDate DATETIME,
    DischargeDate DATETIME,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

-- Create Bills Table
CREATE TABLE Bills (
    BillID INT PRIMARY KEY AUTO_INCREMENT,
    PatientID INT,
    TotalAmount DECIMAL(10,2),
    PaymentStatus ENUM('Paid', 'Unpaid', 'Pending'),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID)
);

-- Create Medications Table
CREATE TABLE Medications (
    MedicationID INT PRIMARY KEY AUTO_INCREMENT,
    MedicationName VARCHAR(100),
    Dosage VARCHAR(50),
    SideEffects TEXT
);

-- Create Prescriptions Table
CREATE TABLE Prescriptions (
    PrescriptionID INT PRIMARY KEY AUTO_INCREMENT,
    PatientID INT,
    DoctorID INT,
    MedicationID INT,
    DosageInstructions TEXT,
    IssuedDate DATETIME,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID),
    FOREIGN KEY (MedicationID) REFERENCES Medications(MedicationID)
);

-- Insert Sample Data for Patients
INSERT INTO Patients (FirstName, LastName, DOB, Gender, ContactNumber, Address, BloodGroup, MedicalHistory) VALUES
('John', 'Doe', '1985-06-15', 'Male', '1234567890', '123 Main St', 'O+', 'Diabetes'),
('Jane', 'Smith', '1992-08-22', 'Female', '0987654321', '456 Elm St', 'A-', 'Hypertension'),
('Alice', 'Brown', '1990-12-10', 'Female', '9876543210', '789 Pine St', 'B+', 'None'),
('Robert', 'Johnson', '1975-04-05', 'Male', '5678901234', '321 Oak St', 'AB-', 'Asthma'),
('Emily', 'Davis', '2000-11-30', 'Female', '6789012345', '654 Maple St', 'O-', 'None');

-- Insert Sample Data for Doctors
INSERT INTO Doctors (FirstName, LastName, Specialization, Phone, Email, ExperienceYears) VALUES
('Dr. Adam', 'White', 'Cardiology', '1112223333', 'adam.white@example.com', 10),
('Dr. Eve', 'Black', 'Neurology', '2223334444', 'eve.black@example.com', 8),
('Dr. Chris', 'Green', 'Pediatrics', '3334445555', 'chris.green@example.com', 12),
('Dr. Lisa', 'Brown', 'Dermatology', '4445556666', 'lisa.brown@example.com', 6),
('Dr. Mark', 'Taylor', 'Orthopedics', '5556667777', 'mark.taylor@example.com', 15);

-- Insert Sample Data for Appointments
INSERT INTO Appointments (PatientID, DoctorID, AppointmentDate, Status) VALUES
(1, 1, '2025-02-20 10:00:00', 'Pending'),
(2, 2, '2025-02-21 11:30:00', 'Completed'),
(3, 3, '2025-02-22 09:15:00', 'Cancelled'),
(4, 4, '2025-02-23 14:00:00', 'Pending'),
(5, 5, '2025-02-24 16:45:00', 'Completed');

-- Insert Sample Data for Departments
INSERT INTO Departments (DepartmentName, HeadDoctorID) VALUES
('Cardiology', 1),
('Neurology', 2),
('Pediatrics', 3),
('Dermatology', 4),
('Orthopedics', 5);

-- Insert Sample Data for Staff
INSERT INTO Staff (FirstName, LastName, Role, Phone, DepartmentID) VALUES
('Michael', 'Scott', 'Nurse', '6667778888', 1),
('Dwight', 'Schrute', 'Technician', '7778889999', 2),
('Pam', 'Beesly', 'Receptionist', '8889990000', 3),
('Jim', 'Halpert', 'Pharmacist', '9990001111', 4),
('Stanley', 'Hudson', 'Therapist', '0001112222', 5);

-- Insert Sample Data for Rooms
INSERT INTO Rooms (RoomType, Capacity, OccupiedStatus) VALUES
('ICU', 1, 'Occupied'),
('General', 3, 'Available'),
('Private', 2, 'Occupied'),
('ICU', 1, 'Available'),
('General', 4, 'Occupied');

-- Insert Sample Data for Admissions
INSERT INTO Admissions (PatientID, RoomID, DoctorID, AdmissionDate, DischargeDate) VALUES
(1, 1, 1, '2025-02-10 08:00:00', '2025-02-15 10:00:00'),
(2, 3, 2, '2025-02-12 12:30:00', NULL),
(3, 2, 3, '2025-02-14 09:00:00', '2025-02-18 14:00:00'),
(4, 5, 4, '2025-02-16 16:45:00', NULL),
(5, 4, 5, '2025-02-18 11:15:00', '2025-02-22 08:00:00');

-- Insert Sample Data for Bills
INSERT INTO Bills (PatientID, TotalAmount, PaymentStatus) VALUES
(1, 5000.00, 'Paid'),
(2, 3200.50, 'Unpaid'),
(3, 4500.75, 'Pending'),
(4, 2700.00, 'Paid'),
(5, 6000.00, 'Unpaid');

-- Insert Sample Data for Medications
INSERT INTO Medications (MedicationName, Dosage, SideEffects) VALUES
('Aspirin', '75mg', 'Nausea, Dizziness'),
('Metformin', '500mg', 'Stomach pain, Diarrhea'),
('Ibuprofen', '400mg', 'Stomach upset, Headache'),
('Atorvastatin', '20mg', 'Muscle pain, Weakness'),
('Amoxicillin', '250mg', 'Rash, Vomiting');

-- Insert Sample Data for Prescriptions
INSERT INTO Prescriptions (PatientID, DoctorID, MedicationID, DosageInstructions, IssuedDate) VALUES
(1, 1, 2, 'Take 1 tablet twice daily after meals', '2025-02-20 09:00:00'),
(2, 2, 4, 'Take 1 tablet before bedtime', '2025-02-21 10:30:00'),
(3, 3, 5, 'Take 1 capsule every 8 hours', '2025-02-22 08:15:00'),
(4, 4, 1, 'Take 1 tablet every morning', '2025-02-23 13:00:00'),
(5, 5, 3, 'Take 2 tablets every 6 hours', '2025-02-24 15:45:00');

-- Retrieve all doctors specialized in "Cardiology."
SELECT * 
FROM Doctors 
WHERE Specialization = 'Cardiology';

-- List all patients admitted to the hospital in the last 30 days.
SELECT * 
FROM Admissions 
WHERE AdmissionDate >= NOW() - INTERVAL 30 DAY;

-- Find the total number of available rooms in the hospital.
SELECT COUNT(*) AS AvailableRooms 
FROM Rooms 
WHERE OccupiedStatus = 'Available';

-- Show all appointments scheduled for a specific doctor on a given date.
SELECT * 
FROM Appointments
WHERE DoctorID = 2 AND DATE(AppointmentDate) = '2025-02-21';

-- Retrieve patient details along with their assigned doctor.
SELECT p.*, d.FirstName AS DoctorFirstName, d.LastName AS DoctorLastName, d.Specialization 
FROM Patients p
JOIN Appointments a ON p.PatientID = a.PatientID
JOIN Doctors d ON a.DoctorID = d.DoctorID;

-- Find the total revenue generated by the hospital from patient bills.
SELECT SUM(TotalAmount) AS TotalRevenue 
FROM Bills 
WHERE PaymentStatus = 'Paid';

-- Retrieve a list of doctors along with the number of patients they have treated.
SELECT d.DoctorID, d.FirstName, d.LastName, COUNT(a.PatientID) AS PatientsTreated
FROM Doctors d
JOIN Appointments a ON d.DoctorID = a.DoctorID
GROUP BY d.DoctorID, d.FirstName, d.LastName;

-- Get a list of staff working in a specific department.
SELECT * 
FROM Staff 
WHERE DepartmentID = 3;

-- Show all prescriptions issued by a specific doctor.
SELECT * 
FROM Prescriptions 
WHERE DoctorID = 5;

-- Find patients who have been prescribed a specific medication.
SELECT p.* FROM Patients p
JOIN Prescriptions pr ON p.PatientID = pr.PatientID
WHERE pr.MedicationID = 1;

-- Find the department with the highest number of staff members.
SELECT d.DepartmentID, d.DepartmentName, COUNT(s.StaffID) AS StaffCount
FROM Departments d
JOIN Staff s ON d.DepartmentID = s.DepartmentID
GROUP BY d.DepartmentID, d.DepartmentName
ORDER BY StaffCount DESC
LIMIT 1;

-- Show a summary of room occupancy (number of occupied vs. available rooms).
SELECT OccupiedStatus, COUNT(*) AS RoomCount 
FROM Rooms 
GROUP BY OccupiedStatus;

-- Find the top 5 patients with the highest total billing amount.
SELECT p.PatientID, p.FirstName, p.LastName, SUM(b.TotalAmount) AS TotalBilling
FROM Patients p
JOIN Bills b ON p.PatientID = b.PatientID
GROUP BY p.PatientID, p.FirstName, p.LastName
ORDER BY TotalBilling DESC
LIMIT 3;

-- Retrieve patient details along with their assigned doctor
SELECT p.PatientID, p.FirstName, p.LastName, d.FirstName AS DoctorFirstName, d.LastName AS DoctorLastName, a.AdmissionDate 
FROM Patients p
JOIN Admissions a ON p.PatientID = a.PatientID
JOIN Doctors d ON a.DoctorID = d.DoctorID;

-- Find the total revenue generated by the hospital from patient bills
SELECT SUM(TotalAmount) AS TotalRevenue 
FROM Bills 
WHERE PaymentStatus = 'Paid';

-- Get a list of doctors along with the number of patients they have treated
SELECT d.DoctorID, d.FirstName, d.LastName, COUNT(a.PatientID) AS PatientsTreated 
FROM Doctors d
LEFT JOIN Admissions a ON d.DoctorID = a.DoctorID
GROUP BY d.DoctorID, d.FirstName, d.LastName;

-- Retrieve all patients admitted in the last 30 days
SELECT * 
FROM Admissions 
WHERE AdmissionDate >= NOW() - INTERVAL 30 DAY;
