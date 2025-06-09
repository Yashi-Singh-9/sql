-- Project In MariaDB 
-- Creating the database
CREATE DATABASE PetAdoptionDB;
USE PetAdoptionDB;

CREATE TABLE Users (
    UserID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(20),
    Address TEXT
);

CREATE TABLE Pets (
    PetID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(50),
    Species VARCHAR(50), 
    Breed VARCHAR(50),
    Age INT,
    Gender VARCHAR(10),
    HealthStatus TEXT,
    Available BOOLEAN DEFAULT TRUE
);

CREATE TABLE Adoptions (
    AdoptionID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT,
    PetID INT,
    AdoptionDate DATE DEFAULT CURDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (PetID) REFERENCES Pets(PetID) ON DELETE CASCADE
);

CREATE TABLE Shelters (
    ShelterID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100),
    Location VARCHAR(255),
    ContactNumber VARCHAR(20)
);

CREATE TABLE Pet_Shelter (
    PetID INT,
    ShelterID INT,
    PRIMARY KEY (PetID, ShelterID),
    FOREIGN KEY (PetID) REFERENCES Pets(PetID) ON DELETE CASCADE,
    FOREIGN KEY (ShelterID) REFERENCES Shelters(ShelterID) ON DELETE CASCADE
);

INSERT INTO Users (FirstName, LastName, Email, Phone, Address) VALUES
('John', 'Doe', 'john.doe@email.com', '1234567890', '123 Elm St, NY'),
('Alice', 'Smith', 'alice.smith@email.com', '0987654321', '456 Oak St, LA'),
('Bob', 'Johnson', 'bob.johnson@email.com', '1122334455', '789 Pine St, TX'),
('Emma', 'Brown', 'emma.brown@email.com', '5566778899', '101 Maple St, IL'),
('David', 'Wilson', 'david.wilson@email.com', '6677889900', '222 Cedar St, FL');

INSERT INTO Shelters (Name, Location, ContactNumber) VALUES
('Happy Tails Shelter', 'New York, NY', '555-1234'),
('Paws & Claws Rescue', 'Los Angeles, CA', '555-5678'),
('Furry Friends Home', 'Chicago, IL', '555-9012');

INSERT INTO Pets (Name, Species, Breed, Age, Gender, HealthStatus, Available) VALUES
('Buddy', 'Dog', 'Labrador', 2, 'Male', 'Healthy', TRUE),
('Luna', 'Cat', 'Siamese', 3, 'Female', 'Vaccinated', TRUE),
('Max', 'Dog', 'Golden Retriever', 4, 'Male', 'Healthy', TRUE),
('Coco', 'Rabbit', 'Holland Lop', 1, 'Female', 'Healthy', TRUE),
('Bella', 'Dog', 'Beagle', 2, 'Female', 'Vaccinated', TRUE),
('Lily', 'Dog', 'German Sherpherd', 5, 'Male', 'Healthy', FALSE);

INSERT INTO Pet_Shelter (PetID, ShelterID) VALUES
(1, 1),  
(2, 2), 
(3, 1),  
(4, 3),  
(5, 2);  

INSERT INTO Adoptions (UserID, PetID, AdoptionDate) VALUES
(1, 1, '2024-01-10'),  
(2, 3, '2024-02-15'), 
(3, 5, '2024-03-20'), 
(4, 2, '2024-04-05'),
(1, 4, '2024-05-10');  

-- Find all available pets that are not adopted yet
SELECT * 
FROM Pets 
WHERE Available = TRUE;

-- Count of available pets grouped by species
SELECT Species, COUNT(*) AS TotalAvailablePets
FROM Pets 
WHERE Available = TRUE
GROUP BY Species;

-- Find users who have adopted more than one pet
SELECT Users.UserID, Users.FirstName, Users.LastName, COUNT(Adoptions.PetID) AS AdoptedPets
FROM Users
JOIN Adoptions ON Users.UserID = Adoptions.UserID
GROUP BY Users.UserID
HAVING COUNT(Adoptions.PetID) > 1;

-- List all pets with adopters (if adopted)
SELECT Pets.Name AS PetName, Users.FirstName AS AdopterName, Users.LastName AS AdopterLastName
FROM Pets
LEFT JOIN Adoptions ON Pets.PetID = Adoptions.PetID
LEFT JOIN Users ON Adoptions.UserID = Users.UserID;

-- Find the most popular pet species based on adoption count
SELECT Pets.Species, COUNT(Adoptions.PetID) AS AdoptionCount
FROM Adoptions
JOIN Pets ON Adoptions.PetID = Pets.PetID
GROUP BY Pets.Species
ORDER BY AdoptionCount DESC
LIMIT 1;

-- Get shelters and count of pets they currently have
SELECT Shelters.Name AS ShelterName, COUNT(Pet_Shelter.PetID) AS TotalPets
FROM Shelters
JOIN Pet_Shelter ON Shelters.ShelterID = Pet_Shelter.ShelterID
GROUP BY Shelters.ShelterID;

-- Find all pets belonging to a specific shelter
SELECT Pets.Name AS PetName, Pets.Species, Pets.Breed
FROM Pets
JOIN Pet_Shelter ON Pets.PetID = Pet_Shelter.PetID
JOIN Shelters ON Pet_Shelter.ShelterID = Shelters.ShelterID
WHERE Shelters.Name = 'Happy Tails Shelter';

-- Retrieve the adoption history of a specific pet
SELECT Users.FirstName, Users.LastName, Adoptions.AdoptionDate
FROM Adoptions
JOIN Users ON Adoptions.UserID = Users.UserID
JOIN Pets ON Adoptions.PetID = Pets.PetID
WHERE Pets.Name = 'Buddy';

-- Find users who haven't adopted any pets 
SELECT Users.FirstName, Users.LastName
FROM Users
LEFT JOIN Adoptions ON Users.UserID = Adoptions.UserID
WHERE Adoptions.UserID IS NULL;

-- List pets that were adopted along with the shelters they came from
SELECT Pets.Name AS PetName, Shelters.Name AS ShelterName, Users.FirstName AS AdopterName
FROM Pets
JOIN Pet_Shelter ON Pets.PetID = Pet_Shelter.PetID
JOIN Shelters ON Pet_Shelter.ShelterID = Shelters.ShelterID
JOIN Adoptions ON Pets.PetID = Adoptions.PetID
JOIN Users ON Adoptions.UserID = Users.UserID;

-- Count total adoptions per shelter
SELECT Shelters.Name AS ShelterName, COUNT(Adoptions.PetID) AS TotalAdoptions
FROM Shelters
JOIN Pet_Shelter ON Shelters.ShelterID = Pet_Shelter.ShelterID
JOIN Adoptions ON Pet_Shelter.PetID = Adoptions.PetID
GROUP BY Shelters.ShelterID
ORDER BY TotalAdoptions DESC;
