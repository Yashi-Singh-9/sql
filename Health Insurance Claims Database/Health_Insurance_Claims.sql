-- Project in PostgreSQL 
-- Create the database
CREATE DATABASE Health_Insurance_Claims;
\c Health_Insurance_Claims;

-- Patients Table  
CREATE TABLE patients (
  PatientID SERIAL PRIMARY KEY,
  FirstName VARCHAR(50) NOT NULL,
  LastName VARCHAR(50) NOT NULL,
  DateOfBirth DATE NOT NULL,
  Gender VARCHAR(6) CHECK (Gender IN ('Male', 'Female', 'Others')),
  ContactNumber VARCHAR(15),
  Address VARCHAR(100)
);

-- Providers Table 
CREATE TABLE providers (
  ProviderID SERIAL PRIMARY KEY,
  ProviderName VARCHAR(50) NOT NULL,
  Specialty VARCHAR(50),
  Locations VARCHAR(100),
  ContactNumber VARCHAR(15)
);

-- Policies Table 
CREATE TABLE policies (
  PolicyID SERIAL PRIMARY KEY,
  PatientID INT NOT NULL,
  PolicyNumber VARCHAR(20) UNIQUE NOT NULL,
  ProviderName VARCHAR(50),
  CoverageType VARCHAR(50),
  StartDate DATE NOT NULL,
  EndDate DATE NOT NULL,
  FOREIGN KEY (PatientID) REFERENCES patients(PatientID) ON DELETE CASCADE
);

-- Claims Table 
CREATE TABLE claims (
  ClaimID SERIAL PRIMARY KEY,
  PatientID INT NOT NULL,
  ProviderID INT NOT NULL,
  PolicyID INT NOT NULL,
  ClaimDate DATE NOT NULL DEFAULT CURRENT_DATE,
  TotalAmount DECIMAL(10,2) CHECK (TotalAmount > 0),
  ClaimStatus VARCHAR(8) CHECK (ClaimStatus IN ('Pending', 'Approved', 'Rejected')),
  FOREIGN KEY (PatientID) REFERENCES patients(PatientID) ON DELETE CASCADE,
  FOREIGN KEY (ProviderID) REFERENCES providers(ProviderID) ON DELETE CASCADE,
  FOREIGN KEY (PolicyID) REFERENCES policies(PolicyID) ON DELETE CASCADE
);

-- Diagnosis Table 
CREATE TABLE diagnosis (
  DiagnosisID SERIAL PRIMARY KEY,
  ClaimID INT NOT NULL,
  DiagnosisCode VARCHAR(10) NOT NULL,
  Description TEXT NOT NULL,
  FOREIGN KEY (ClaimID) REFERENCES claims(ClaimID) ON DELETE CASCADE
);

-- Procedures Table 
CREATE TABLE procedures (
  ProcedureID SERIAL PRIMARY KEY,
  ClaimID INT NOT NULL,
  ProcedureCode VARCHAR(10) NOT NULL,
  Description TEXT NOT NULL,
  Costs DECIMAL(10,2) CHECK (Costs > 0),
  FOREIGN KEY (ClaimID) REFERENCES claims(ClaimID) ON DELETE CASCADE
);

-- Billing Table 
CREATE TABLE billing (
  BillID SERIAL PRIMARY KEY,
  ClaimID INT NOT NULL,
  TotalBilledAmount DECIMAL(10,2) CHECK (TotalBilledAmount > 0),
  InsuranceCoveredAmount DECIMAL(10,2) CHECK (InsuranceCoveredAmount >= 0),
  PatientPaidAmount DECIMAL(10,2) CHECK (PatientPaidAmount >= 0),
  FOREIGN KEY (ClaimID) REFERENCES claims(ClaimID) ON DELETE CASCADE
);

-- Insert data into patients
INSERT INTO patients (FirstName, LastName, DateOfBirth, Gender, ContactNumber, Address) VALUES
('John', 'Doe', '1985-06-15', 'Male', '1234567890', '123 Main St, NY'),
('Jane', 'Smith', '1990-08-20', 'Female', '9876543210', '456 Oak St, CA'),
('Emily', 'Johnson', '1978-04-10', 'Female', '5678901234', '789 Pine St, TX'),
('Michael', 'Brown', '1995-12-25', 'Male', '3456789012', '321 Cedar St, FL'),
('David', 'Wilson', '1982-09-05', 'Male', '6789012345', '654 Elm St, WA'),
('Emma', 'Davis', '2000-07-30', 'Female', '4321098765', '987 Birch St, IL');

-- Insert data into providers
INSERT INTO providers (ProviderName, Specialty, Locations, ContactNumber) VALUES
('Dr. Williams', 'Cardiology', 'New York, NY', '2123456789'),
('Dr. Patel', 'Dermatology', 'Los Angeles, CA', '3109876543'),
('Dr. Kim', 'Neurology', 'Houston, TX', '7134567890'),
('Dr. Lee', 'Pediatrics', 'Miami, FL', '3055678901'),
('Dr. Anderson', 'Orthopedics', 'Seattle, WA', '2066789012'),
('Dr. Johnson', 'General Medicine', 'Chicago, IL', '3127890123');

-- Insert data into policies
INSERT INTO policies (PatientID, PolicyNumber, ProviderName, CoverageType, StartDate, EndDate) VALUES
(1, 'POL123456', 'Dr. Williams', 'Full Coverage', '2023-01-01', '2025-01-01'),
(2, 'POL234567', 'Dr. Patel', 'Partial Coverage', '2022-06-15', '2024-06-15'),
(3, 'POL345678', 'Dr. Kim', 'Full Coverage', '2021-09-10', '2023-09-10'),
(4, 'POL456789', 'Dr. Lee', 'Basic Coverage', '2023-03-20', '2025-03-20'),
(5, 'POL567890', 'Dr. Anderson', 'Full Coverage', '2022-12-01', '2024-12-01'),
(6, 'POL678901', 'Dr. Johnson', 'Partial Coverage', '2023-08-10', '2025-08-10');

-- Insert data into claims
INSERT INTO claims (PatientID, ProviderID, PolicyID, ClaimDate, TotalAmount, ClaimStatus) VALUES
(1, 1, 1, '2023-10-01', 1200.00, 'Approved'),
(2, 2, 2, '2023-11-05', 800.50, 'Pending'),
(3, 3, 3, '2023-09-15', 1500.75, 'Rejected'),
(4, 4, 4, '2023-12-20', 600.25, 'Approved'),
(5, 5, 5, '2023-07-18', 950.00, 'Pending'),
(6, 6, 6, '2023-06-30', 1100.00, 'Approved');

-- Insert data into diagnosis
INSERT INTO diagnosis (ClaimID, DiagnosisCode, Description) VALUES
(1, 'C34.1', 'Lung Cancer'),
(2, 'E11.9', 'Type 2 Diabetes'),
(3, 'I10', 'Hypertension'),
(4, 'M54.5', 'Lower Back Pain'),
(5, 'J45.909', 'Asthma'),
(6, 'K21.9', 'GERD');

-- Insert data into procedures
INSERT INTO procedures (ClaimID, ProcedureCode, Description, Costs) VALUES
(1, '12345', 'CT Scan', 500.00),
(2, '23456', 'Skin Biopsy', 300.00),
(3, '34567', 'MRI Scan', 700.00),
(4, '45678', 'X-Ray', 200.00),
(5, '56789', 'Physical Therapy', 400.00),
(6, '67890', 'Endoscopy', 600.00);

-- Insert data into billing
INSERT INTO billing (ClaimID, TotalBilledAmount, InsuranceCoveredAmount, PatientPaidAmount) VALUES
(1, 1200.00, 1000.00, 200.00),
(2, 800.50, 600.00, 200.50),
(3, 1500.75, 0.00, 1500.75),
(4, 600.25, 500.00, 100.25),
(5, 950.00, 700.00, 250.00),
(6, 1100.00, 900.00, 200.00);

-- Retrieve all claims for a given patient in a specific time range.
SELECT * 
FROM claims 
WHERE PatientID = 3 
AND ClaimDate BETWEEN '2023-01-01' AND '2023-12-31';

-- Find the total amount billed for each patient in a given year.
SELECT c.PatientID, p.FirstName, p.LastName, SUM(b.TotalBilledAmount) AS TotalBilled
FROM billing b
JOIN claims c ON b.ClaimID = c.ClaimID
JOIN patients p ON c.PatientID = p.PatientID
WHERE EXTRACT(YEAR FROM c.ClaimDate) = 2023
GROUP BY c.PatientID, p.FirstName, p.LastName;

-- Get a list of providers who have the highest number of claims.
SELECT pr.ProviderID, pr.ProviderName, COUNT(c.ClaimID) AS ClaimCount
FROM claims c
JOIN providers pr ON c.ProviderID = pr.ProviderID
GROUP BY pr.ProviderID, pr.ProviderName
ORDER BY ClaimCount DESC
LIMIT 5;

-- Find all claims that are still pending.
SELECT * 
FROM claims 
WHERE ClaimStatus = 'Pending';

-- Retrieve all procedures performed for a particular claim.
SELECT * 
FROM procedures 
WHERE ClaimID = 2;

-- Find the top 5 most common diagnoses made by providers.
SELECT d.DiagnosisCode, d.Description, COUNT(d.DiagnosisID) AS DiagnosisCount
FROM diagnosis d
GROUP BY d.DiagnosisCode, d.Description
ORDER BY DiagnosisCount DESC
LIMIT 5;

-- Calculate the total amount covered by insurance for each policyholder.
SELECT c.PatientID, p.FirstName, p.LastName, SUM(b.InsuranceCoveredAmount) AS TotalCovered
FROM billing b
JOIN claims c ON b.ClaimID = c.ClaimID
JOIN patients p ON c.PatientID = p.PatientID
GROUP BY c.PatientID, p.FirstName, p.LastName;

-- Find the patients who have the highest out-of-pocket expenses.
SELECT c.PatientID, p.FirstName, p.LastName, SUM(b.PatientPaidAmount) AS TotalOutOfPocket
FROM billing b
JOIN claims c ON b.ClaimID = c.ClaimID
JOIN patients p ON c.PatientID = p.PatientID
GROUP BY c.PatientID, p.FirstName, p.LastName
ORDER BY TotalOutOfPocket DESC
LIMIT 5;

-- List all providers along with the total amount they have billed in a given year.
SELECT pr.ProviderID, pr.ProviderName, SUM(b.TotalBilledAmount) AS TotalBilled
FROM billing b
JOIN claims c ON b.ClaimID = c.ClaimID
JOIN providers pr ON c.ProviderID = pr.ProviderID
WHERE EXTRACT(YEAR FROM c.ClaimDate) = 2023
GROUP BY pr.ProviderID, pr.ProviderName;

-- Retrieve policies that are expired but still have pending claims.
SELECT po.*
FROM policies po
JOIN claims c ON po.PolicyID = c.PolicyID
WHERE po.EndDate < CURRENT_DATE AND c.ClaimStatus = 'Pending';

-- Determine the percentage of claims that get approved versus rejected.
SELECT 
  (COUNT(CASE WHEN ClaimStatus = 'Approved' THEN 1 END) * 100.0 / COUNT(*)) AS ApprovedPercentage,
  (COUNT(CASE WHEN ClaimStatus = 'Rejected' THEN 1 END) * 100.0 / COUNT(*)) AS RejectedPercentage
FROM claims;

-- Find the most common procedure codes performed in claims
SELECT p.ProcedureCode, p.Description, COUNT(p.ProcedureID) AS TotalPerformed
FROM procedures p
GROUP BY p.ProcedureCode, p.Description
ORDER BY TotalPerformed DESC
LIMIT 5;