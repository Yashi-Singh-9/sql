-- MS SQL Project 
CREATE DATABASE PetMedicalRecords;
USE PetMedicalRecords;

CREATE TABLE owners (
    owner_id INT IDENTITY PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    address VARCHAR(255)
);

CREATE TABLE pets (
    pet_id INT IDENTITY PRIMARY KEY,
    owner_id INT FOREIGN KEY REFERENCES owners(owner_id),
    pet_name VARCHAR(100),
    species VARCHAR(50), -- e.g., Dog, Cat
    breed VARCHAR(100),
    gender VARCHAR(10),
    birth_date DATE
);

CREATE TABLE vets (
    vet_id INT IDENTITY PRIMARY KEY,
    vet_name VARCHAR(100),
    specialization VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100)
);

CREATE TABLE visits (
    visit_id INT IDENTITY PRIMARY KEY,
    pet_id INT FOREIGN KEY REFERENCES pets(pet_id),
    vet_id INT FOREIGN KEY REFERENCES vets(vet_id),
    visit_date DATETIME DEFAULT GETDATE(),
    reason VARCHAR(255),
    notes TEXT
);

CREATE TABLE diagnoses (
    diagnosis_id INT IDENTITY PRIMARY KEY,
    visit_id INT FOREIGN KEY REFERENCES visits(visit_id),
    condition_name VARCHAR(100),
    severity VARCHAR(50),
    diagnosis_notes TEXT
);

CREATE TABLE treatments (
    treatment_id INT IDENTITY PRIMARY KEY,
    visit_id INT FOREIGN KEY REFERENCES visits(visit_id),
    treatment_description TEXT,
    medication VARCHAR(100),
    dosage VARCHAR(50),
    duration_days INT
);

CREATE TABLE vaccinations (
    vaccination_id INT IDENTITY PRIMARY KEY,
    pet_id INT FOREIGN KEY REFERENCES pets(pet_id),
    vaccine_name VARCHAR(100),
    vaccination_date DATE,
    next_due_date DATE,
    vet_id INT FOREIGN KEY REFERENCES vets(vet_id)
);

-- Owners
INSERT INTO owners (full_name, email, phone, address) VALUES
('Alice Johnson', 'alice@gmail.com', '555-1001', '123 Pet Lane'),
('Bob Lee', 'bob@gmail.com', '555-1002', '456 Cat Street');

-- Pets
INSERT INTO pets (owner_id, pet_name, species, breed, gender, birth_date) VALUES
(1, 'Buddy', 'Dog', 'Golden Retriever', 'Male', '2019-05-10'),
(2, 'Whiskers', 'Cat', 'Persian', 'Female', '2020-08-23');

-- Vets
INSERT INTO vets (vet_name, specialization, phone, email) VALUES
('Dr. Emily Ross', 'General', '555-2001', 'emily@clinic.com'),
('Dr. Max Hill', 'Dermatology', '555-2002', 'max@clinic.com');

-- Visits
INSERT INTO visits (pet_id, vet_id, visit_date, reason, notes) VALUES
(1, 1, '2024-12-01 10:30:00', 'Annual checkup', 'Healthy overall. Slight tartar buildup.'),
(2, 2, '2025-01-15 14:00:00', 'Itchy skin', 'Prescribed anti-itch medication.');

-- Diagnoses
INSERT INTO diagnoses (visit_id, condition_name, severity, diagnosis_notes) VALUES
(2, 'Skin allergy', 'Moderate', 'Likely seasonal. Monitor for worsening.');

-- Treatments
INSERT INTO treatments (visit_id, treatment_description, medication, dosage, duration_days) VALUES
(2, 'Antihistamine prescription', 'Cetirizine', '5mg', 10);

-- Vaccinations
INSERT INTO vaccinations (pet_id, vaccine_name, vaccination_date, next_due_date, vet_id) VALUES
(1, 'Rabies', '2024-11-01', '2025-11-01', 1),
(2, 'FVRCP', '2025-01-10', '2026-01-10', 2);

-- Upcoming vaccination due dates
SELECT p.pet_name, v.vaccine_name, v.next_due_date
FROM vaccinations v
JOIN pets p ON v.pet_id = p.pet_id
WHERE v.next_due_date > GETDATE()
ORDER BY v.next_due_date;

-- Full medical history for a pet
SELECT v.visit_date, v.reason, d.condition_name, t.medication
FROM visits v
LEFT JOIN diagnoses d ON v.visit_id = d.visit_id
LEFT JOIN treatments t ON v.visit_id = t.visit_id
WHERE v.pet_id = 1
ORDER BY v.visit_date DESC;

-- Pets treated by a specific vet
SELECT DISTINCT p.pet_name, p.species
FROM visits v
JOIN pets p ON v.pet_id = p.pet_id
WHERE v.vet_id = 1;

-- Owner and Pet Summary
SELECT 
    o.full_name AS owner_name,
    o.phone,
    p.pet_name,
    p.species,
    p.breed,
    p.birth_date
FROM owners o
JOIN pets p ON o.owner_id = p.owner_id
ORDER BY o.full_name;

--  Diagnoses by Severity Count
SELECT 
    severity,
    COUNT(*) AS diagnosis_count
FROM diagnoses
GROUP BY severity
ORDER BY diagnosis_count DESC;

-- Vet Activity Report
SELECT 
    vets.vet_name,
    COUNT(DISTINCT v.visit_id) AS total_visits,
    COUNT(DISTINCT vac.vaccination_id) AS vaccinations_given
FROM vets
LEFT JOIN visits v ON vets.vet_id = v.vet_id
LEFT JOIN vaccinations vac ON vets.vet_id = vac.vet_id
GROUP BY vets.vet_name
ORDER BY total_visits DESC;

-- Vaccination Schedule for All Pets
SELECT 
    p.pet_name,
    vac.vaccine_name,
    vac.vaccination_date,
    vac.next_due_date,
    vets.vet_name
FROM vaccinations vac
JOIN pets p ON vac.pet_id = p.pet_id
JOIN vets ON vac.vet_id = vets.vet_id
ORDER BY vac.next_due_date;

-- Total Number of Visits per Pet
SELECT 
    p.pet_name,
    COUNT(v.visit_id) AS total_visits
FROM visits v
JOIN pets p ON v.pet_id = p.pet_id
GROUP BY p.pet_name
ORDER BY total_visits DESC;

-- Most Common Diagnosed Conditions
SELECT 
    condition_name,
    COUNT(*) AS frequency
FROM diagnoses
GROUP BY condition_name
ORDER BY frequency DESC;

-- Vaccination Coverage per Pet
SELECT 
    p.pet_name,
    COUNT(vac.vaccine_name) AS total_vaccines
FROM pets p
LEFT JOIN vaccinations vac ON p.pet_id = vac.pet_id
GROUP BY p.pet_name
ORDER BY total_vaccines DESC;

-- Detailed Visit Report
SELECT 
    v.visit_date,
    p.pet_name,
    o.full_name AS owner_name,
    vets.vet_name,
    v.reason,
    d.condition_name,
    t.medication
FROM visits v
JOIN pets p ON v.pet_id = p.pet_id
JOIN owners o ON p.owner_id = o.owner_id
JOIN vets ON v.vet_id = vets.vet_id
LEFT JOIN diagnoses d ON v.visit_id = d.visit_id
LEFT JOIN treatments t ON v.visit_id = t.visit_id
ORDER BY v.visit_date DESC;

-- Most Active Vets by Visits
SELECT 
    vet_name,
    COUNT(visit_id) AS total_visits
FROM visits
JOIN vets ON visits.vet_id = vets.vet_id
GROUP BY vet_name
ORDER BY total_visits DESC;

-- Monthly Visit Summary (Current Year)
SELECT 
    FORMAT(visit_date, 'yyyy-MM') AS visit_month,
    COUNT(*) AS total_visits
FROM visits
WHERE YEAR(visit_date) = YEAR(GETDATE())
GROUP BY FORMAT(visit_date, 'yyyy-MM')
ORDER BY visit_month;

-- Most Frequently Used Medications
SELECT 
    medication,
    COUNT(*) AS usage_count
FROM treatments
WHERE medication IS NOT NULL
GROUP BY medication
ORDER BY usage_count DESC;

-- Owner Contact List With Number of Pets
SELECT 
    o.full_name,
    o.email,
    o.phone,
    COUNT(p.pet_id) AS pet_count
FROM owners o
LEFT JOIN pets p ON o.owner_id = p.owner_id
GROUP BY o.full_name, o.email, o.phone
ORDER BY pet_count DESC;

-- Detailed Vaccination History by Pet
SELECT 
    p.pet_name,
    vac.vaccine_name,
    vac.vaccination_date,
    vac.next_due_date,
    v.vet_name
FROM vaccinations vac
JOIN pets p ON vac.pet_id = p.pet_id
JOIN vets v ON vac.vet_id = v.vet_id
ORDER BY p.pet_name, vac.vaccination_date DESC;
