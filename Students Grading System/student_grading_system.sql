-- Project In MariaDB 
-- Create Database
CREATE DATABASE student_grading_system;
USE student_grading_system;

CREATE TABLE Students (
    StudentID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Age INT,
    Gender ENUM('Male', 'Female', 'Other'),
    Class VARCHAR(10)
);

CREATE TABLE Subjects (
    SubjectID INT PRIMARY KEY AUTO_INCREMENT,
    SubjectName VARCHAR(100) NOT NULL
);

CREATE TABLE Grades (
    GradeID INT PRIMARY KEY AUTO_INCREMENT,
    StudentID INT,
    SubjectID INT,
    Marks INT,
    Grade CHAR(2),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID) ON DELETE CASCADE,
    FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID) ON DELETE CASCADE
);

INSERT INTO Students (Name, Age, Gender, Class) VALUES
('John Doe', 18, 'Male', '12A'),
('Jane Smith', 17, 'Female', '12B'),
('Alice Johnson', 18, 'Female', '12A'),
('Bob Brown', 17, 'Male', '12C');

INSERT INTO Subjects (SubjectName) VALUES
('Mathematics'),
('Science'),
('History'),
('English');

INSERT INTO Grades (StudentID, SubjectID, Marks, Grade) VALUES
(1, 1, 85, 'B'),
(1, 2, 92, 'A'),
(2, 3, 78, 'C'),
(2, 4, 88, 'B'),
(3, 1, 90, 'A'),
(3, 2, 76, 'C'),
(4, 3, 95, 'A'),
(4, 4, 89, 'B');

-- Retrieve All Students
SELECT * FROM Students;

-- Get Student Grades
SELECT s.Name, sub.SubjectName, g.Marks, g.Grade
FROM Grades g
JOIN Students s ON g.StudentID = s.StudentID
JOIN Subjects sub ON g.SubjectID = sub.SubjectID;

-- Find Students Who Scored More Than 80 Marks
SELECT s.Name, g.Marks, g.Grade
FROM Grades g
JOIN Students s ON g.StudentID = s.StudentID
WHERE g.Marks > 80;

-- Calculate Average Marks per Student
SELECT s.Name, AVG(g.Marks) AS Average_Marks
FROM Grades g
JOIN Students s ON g.StudentID = s.StudentID
GROUP BY s.Name;

-- Find Top Scoring Student
SELECT s.Name, SUM(g.Marks) AS Total_Marks
FROM Grades g
JOIN Students s ON g.StudentID = s.StudentID
GROUP BY s.Name
ORDER BY Total_Marks DESC
LIMIT 1;

-- Count the Number of Students in Each Class
SELECT Class, COUNT(*) AS Total_Students
FROM Students
GROUP BY Class;

-- Find the Highest Marks in Each Subject
SELECT sub.SubjectName, MAX(g.Marks) AS Highest_Marks
FROM Grades g
JOIN Subjects sub ON g.SubjectID = sub.SubjectID
GROUP BY sub.SubjectName;

-- Find Students Who Scored the Highest Marks in a Subject
SELECT s.Name, sub.SubjectName, g.Marks
FROM Grades g
JOIN Students s ON g.StudentID = s.StudentID
JOIN Subjects sub ON g.SubjectID = sub.SubjectID
WHERE g.Marks = (SELECT MAX(Marks) FROM Grades WHERE SubjectID = g.SubjectID);

-- Find the Average Marks for Each Subject
SELECT sub.SubjectName, AVG(g.Marks) AS Average_Marks
FROM Grades g
JOIN Subjects sub ON g.SubjectID = sub.SubjectID
GROUP BY sub.SubjectName;

-- Find Students Who Got ‘A’ Grade
SELECT s.Name, sub.SubjectName, g.Marks, g.Grade
FROM Grades g
JOIN Students s ON g.StudentID = s.StudentID
JOIN Subjects sub ON g.SubjectID = sub.SubjectID
WHERE g.Grade = 'A';

-- Retrieve Students and Their Total Marks
SELECT s.Name, SUM(g.Marks) AS Total_Marks
FROM Grades g
JOIN Students s ON g.StudentID = s.StudentID
GROUP BY s.Name;

-- Retrieve Students Who Have Scored Below the Average Marks
SELECT s.Name, g.Marks, sub.SubjectName
FROM Grades g
JOIN Students s ON g.StudentID = s.StudentID
JOIN Subjects sub ON g.SubjectID = sub.SubjectID
WHERE g.Marks < (SELECT AVG(Marks) FROM Grades);

-- Get the List of Subjects a Student is Studying
SELECT s.Name, sub.SubjectName
FROM Grades g
JOIN Students s ON g.StudentID = s.StudentID
JOIN Subjects sub ON g.SubjectID = sub.SubjectID
WHERE s.Name = 'John Doe';
