sqlite3 AthletePerformanceDB.db

CREATE TABLE Athletes (
    Athlete_ID INT PRIMARY KEY,
    First_Name VARCHAR(50),
    Last_Name VARCHAR(50),
    Gender CHAR(1),
    Birth_Date DATE,
    Nationality VARCHAR(50)
);

-- Creating Training_Sessions Table
CREATE TABLE Training_Sessions (
    Session_ID INT PRIMARY KEY,
    Athlete_ID INT,
    Date DATE,
    Duration INT,
    Type VARCHAR(50),
    Intensity VARCHAR(50),
    FOREIGN KEY (Athlete_ID) REFERENCES Athletes(Athlete_ID)
);

-- Creating Performance_Metrics Table
CREATE TABLE Performance_Metrics (
    Metric_ID INT PRIMARY KEY,
    Session_ID INT,
    Speed FLOAT,
    Heart_Rate INT,
    Distance FLOAT,
    Calories_Burned INT,
    Notes TEXT,
    FOREIGN KEY (Session_ID) REFERENCES Training_Sessions(Session_ID)
);

-- Creating Competitions Table
CREATE TABLE Competitions (
    Competition_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Location VARCHAR(100),
    Date DATE,
    Event_Type VARCHAR(50)
);

-- Creating Athlete_Competitions Table
CREATE TABLE Athlete_Competitions (
    Athlete_Competition_ID INT PRIMARY KEY,
    Athlete_ID INT,
    Competition_ID INT,
    Position INT,
    Time TIME,
    Points INT,
    FOREIGN KEY (Athlete_ID) REFERENCES Athletes(Athlete_ID),
    FOREIGN KEY (Competition_ID) REFERENCES Competitions(Competition_ID)
);

-- Creating Injury_History Table
CREATE TABLE Injury_History (
    Injury_ID INT PRIMARY KEY,
    Athlete_ID INT,
    Injury_Type VARCHAR(100),
    Date_Of_Injury DATE,
    Recovery_Time INT,
    Notes TEXT,
    FOREIGN KEY (Athlete_ID) REFERENCES Athletes(Athlete_ID)
);

-- Creating Nutrition Table
CREATE TABLE Nutrition (
    Nutrition_ID INT PRIMARY KEY,
    Athlete_ID INT,
    Date DATE,
    Calories_Consumed INT,
    Protein FLOAT,
    Carbs FLOAT,
    Fats FLOAT,
    Water_Intake FLOAT,
    FOREIGN KEY (Athlete_ID) REFERENCES Athletes(Athlete_ID)
);

-- Creating Coaches Table
CREATE TABLE Coaches (
    Coach_ID INT PRIMARY KEY,
    First_Name VARCHAR(50),
    Last_Name VARCHAR(50),
    Gender CHAR(1),
    Specialization VARCHAR(100),
    Contact_Info VARCHAR(100)
);

-- Creating Training_Plan Table
CREATE TABLE Training_Plan (
    Plan_ID INT PRIMARY KEY,
    Coach_ID INT,
    Athlete_ID INT,
    Start_Date DATE,
    End_Date DATE,
    Goal VARCHAR(100),
    Description TEXT,
    FOREIGN KEY (Coach_ID) REFERENCES Coaches(Coach_ID),
    FOREIGN KEY (Athlete_ID) REFERENCES Athletes(Athlete_ID)
);

-- Inserting data into Athletes Table
INSERT INTO Athletes (Athlete_ID, First_Name, Last_Name, Gender, Birth_Date, Nationality)
VALUES
(1, 'John', 'Doe', 'M', '1995-05-14', 'USA'),
(2, 'Jane', 'Smith', 'F', '1998-07-22', 'Canada'),
(3, 'Michael', 'Johnson', 'M', '1993-11-30', 'UK'),
(4, 'Emily', 'Davis', 'F', '2000-02-10', 'Australia'),
(5, 'Chris', 'Brown', 'M', '1997-09-18', 'Germany'),
(6, 'Sophia', 'Miller', 'F', '1996-04-05', 'France'),
(7, 'Daniel', 'Wilson', 'M', '1994-12-25', 'Italy'),
(8, 'Olivia', 'Martinez', 'F', '1999-08-15', 'Spain');

-- Inserting data into Training_Sessions Table
INSERT INTO Training_Sessions (Session_ID, Athlete_ID, Date, Duration, Type, Intensity)
VALUES
(1, 1, '2024-02-10', 60, 'Cardio', 'High'),
(2, 2, '2024-02-11', 45, 'Strength', 'Medium'),
(3, 3, '2024-02-12', 90, 'Endurance', 'High'),
(4, 4, '2024-02-13', 30, 'Flexibility', 'Low'),
(5, 5, '2024-02-14', 75, 'Strength', 'High'),
(6, 1, '2024-02-15', 60, 'Cardio', 'Medium'),
(7, 2, '2024-02-16', 50, 'Endurance', 'Medium'),
(8, 3, '2024-02-17', 80, 'Cardio', 'High');

-- Inserting data into Performance_Metrics Table
INSERT INTO Performance_Metrics (Metric_ID, Session_ID, Speed, Heart_Rate, Distance, Calories_Burned, Notes)
VALUES
(1, 1, 12.5, 150, 5.2, 400, 'Good performance'),
(2, 2, 9.0, 140, 2.8, 350, 'Needs improvement'),
(3, 3, 14.2, 160, 7.1, 500, 'Excellent stamina'),
(4, 4, 8.5, 130, 3.0, 280, 'Steady pace'),
(5, 5, 10.0, 145, 4.5, 370, 'Consistent effort'),
(6, 6, 12.0, 155, 5.0, 420, 'Slight fatigue'),
(7, 7, 9.5, 138, 3.2, 300, 'Maintained pace well'),
(8, 8, 13.0, 158, 6.0, 450, 'Strong sprinting');

-- Inserting data into Competitions Table
INSERT INTO Competitions (Competition_ID, Name, Location, Date, Event_Type)
VALUES
(1, 'National Sprint', 'New York', '2024-03-01', 'Sprint'),
(2, 'City Marathon', 'Toronto', '2024-04-15', 'Marathon'),
(3, 'European Championship', 'Berlin', '2024-05-20', 'Track'),
(4, 'Olympic Trials', 'Sydney', '2024-06-10', 'Mixed');

-- Inserting data into Athlete_Competitions Table
INSERT INTO Athlete_Competitions (Athlete_Competition_ID, Athlete_ID, Competition_ID, Position, Time, Points)
VALUES
(1, 1, 1, 2, '00:10:15', 90),
(2, 2, 2, 5, '02:30:20', 50),
(3, 3, 3, 1, '00:49:30', 100),
(4, 4, 4, 3, '00:55:12', 80),
(5, 5, 1, 4, '00:10:50', 70),
(6, 6, 2, 6, '02:45:10', 40),
(7, 7, 3, 2, '00:50:00', 95),
(8, 8, 4, 1, '00:54:10', 100);

-- Inserting data into Injury_History Table
INSERT INTO Injury_History (Injury_ID, Athlete_ID, Injury_Type, Date_Of_Injury, Recovery_Time, Notes)
VALUES
(1, 1, 'Knee Sprain', '2023-12-10', 30, 'Under rehabilitation'),
(2, 2, 'Hamstring Strain', '2023-11-22', 20, 'Recovered well'),
(3, 3, 'Ankle Fracture', '2023-10-15', 60, 'Severe injury'),
(4, 4, 'Shoulder Dislocation', '2023-09-05', 45, 'Required therapy'),
(5, 5, 'Wrist Sprain', '2023-08-18', 15, 'Minor issue'),
(6, 6, 'Groin Strain', '2023-07-22', 25, 'Recovered'),
(7, 7, 'Calf Strain', '2023-06-12', 18, 'Back to training'),
(8, 8, 'Shin Splints', '2023-05-30', 10, 'Mild pain persists');

-- Inserting data into Nutrition Table
INSERT INTO Nutrition (Nutrition_ID, Athlete_ID, Date, Calories_Consumed, Protein, Carbs, Fats, Water_Intake)
VALUES
(1, 1, '2024-02-10', 2500, 150, 300, 70, 3.5),
(2, 2, '2024-02-11', 2300, 120, 280, 65, 3.0),
(3, 3, '2024-02-12', 2700, 160, 320, 80, 4.0),
(4, 4, '2024-02-13', 2200, 110, 260, 60, 2.8),
(5, 5, '2024-02-14', 2600, 140, 310, 75, 3.8),
(6, 6, '2024-02-15', 2400, 130, 290, 68, 3.2),
(7, 7, '2024-02-16', 2800, 170, 330, 85, 4.2),
(8, 8, '2024-02-17', 2100, 100, 250, 55, 2.5);

-- Inserting data into Coaches Table
INSERT INTO Coaches (Coach_ID, First_Name, Last_Name, Gender, Specialization, Contact_Info)
VALUES
(1, 'Robert', 'Anderson', 'M', 'Sprint Training', 'robert@coach.com'),
(2, 'Laura', 'Harris', 'F', 'Endurance Coaching', 'laura@coach.com'),
(3, 'James', 'Taylor', 'M', 'Strength & Conditioning', 'james@coach.com'),
(4, 'Emma', 'White', 'F', 'Nutrition & Recovery', 'emma@coach.com');

-- Inserting data into Training_Plan Table
INSERT INTO Training_Plan (Plan_ID, Coach_ID, Athlete_ID, Start_Date, End_Date, Goal, Description)
VALUES
(1, 1, 1, '2024-02-01', '2024-05-01', 'Increase Sprint Speed', 'Focused on explosive starts and endurance'),
(2, 2, 2, '2024-02-15', '2024-06-15', 'Improve Marathon Stamina', 'Long distance endurance runs'),
(3, 3, 3, '2024-03-01', '2024-07-01', 'Build Strength', 'Heavy lifting and power workouts'),
(4, 4, 4, '2024-04-01', '2024-08-01', 'Improve Flexibility', 'Yoga and stretching routines');

-- Retrieve the personal details of all athletes who participated in a competition held in a specific location
SELECT a.First_Name, a.Last_Name, a.Nationality
FROM Athletes a
JOIN Athlete_Competitions ac ON a.Athlete_ID = ac.Athlete_ID
JOIN Competitions c ON ac.Competition_ID = c.Competition_ID
WHERE c.Location = 'Berlin';

-- Find the average distance covered by each athlete across all training sessions
SELECT a.First_Name, a.Last_Name, AVG(pm.Distance) AS Avg_Distance
FROM Athletes a
JOIN Training_Sessions ts ON a.Athlete_ID = ts.Athlete_ID
JOIN Performance_Metrics pm ON ts.Session_ID = pm.Session_ID
GROUP BY a.Athlete_ID;

-- List the athletes who have never been injured
SELECT a.First_Name, a.Last_Name
FROM Athletes a
LEFT JOIN Injury_History ih ON a.Athlete_ID = ih.Athlete_ID
WHERE ih.Injury_ID IS NULL;

-- Show the top 5 athletes with the highest positions in a specific competition (e.g., "100m Sprint")
SELECT A.Athlete_ID, A.First_Name, A.Last_Name, AC.Position, C.Name AS Competition_Name
FROM Athletes A
JOIN Athlete_Competitions AC ON A.Athlete_ID = AC.Athlete_ID
JOIN Competitions C ON AC.Competition_ID = C.Competition_ID
WHERE C.Name = 'National Sprint'
ORDER BY AC.Position ASC
LIMIT 5;

-- Find all the training sessions where an athlete’s heart rate exceeded a certain threshold (e.g., 150 bpm):
SELECT TS.Session_ID, TS.Athlete_ID, TS.Date, TS.Duration, TS.Type, TS.Intensity, PM.Heart_Rate
FROM Training_Sessions TS
JOIN Performance_Metrics PM ON TS.Session_ID = PM.Session_ID
WHERE PM.Heart_Rate > 150;

-- Retrieve the total number of calories burned by each athlete across all training sessions:
SELECT a.First_Name, a.Last_Name, SUM(pm.Calories_Burned) AS Total_Calories_Burned
FROM Athletes a
JOIN Training_Sessions ts ON a.Athlete_ID = ts.Athlete_ID
JOIN Performance_Metrics pm ON ts.Session_ID = pm.Session_ID
GROUP BY a.Athlete_ID;

-- List all the athletes and their coaches for a specific training plan
SELECT a.First_Name, a.Last_Name, c.First_Name AS Coach_First_Name, c.Last_Name AS Coach_Last_Name
FROM Athletes a
JOIN Training_Plan tp ON a.Athlete_ID = tp.Athlete_ID
JOIN Coaches c ON tp.Coach_ID = c.Coach_ID
WHERE tp.Plan_ID = 3;

-- Get the list of all competitions that an athlete has participated in and their performance (position and time)
SELECT a.First_Name, a.Last_Name, c.Name AS Competition_Name, ac.Position, ac.Time
FROM Athletes a
JOIN Athlete_Competitions ac ON a.Athlete_ID = ac.Athlete_ID
JOIN Competitions c ON ac.Competition_ID = c.Competition_ID
WHERE a.Athlete_ID = 5;

-- Get the list of athletes with the highest average speed during their training sessions
SELECT a.First_Name, a.Last_Name, AVG(pm.Speed) AS Avg_Speed
FROM Athletes a
JOIN Training_Sessions ts ON a.Athlete_ID = ts.Athlete_ID
JOIN Performance_Metrics pm ON ts.Session_ID = pm.Session_ID
GROUP BY a.Athlete_ID
ORDER BY Avg_Speed DESC
LIMIT 5;

-- Retrieve the details of all athletes who have participated in at least 1 different competitions
SELECT a.First_Name, a.Last_Name, COUNT(DISTINCT ac.Competition_ID) AS Competitions_Participated
FROM Athletes a
JOIN Athlete_Competitions ac ON a.Athlete_ID = ac.Athlete_ID
GROUP BY a.Athlete_ID
HAVING COUNT(DISTINCT ac.Competition_ID) >= 1;

-- List the athletes who have participated in a competition and are also part of a training plan with a specific coach
SELECT A.Athlete_ID, A.First_Name, A.Last_Name, A.Gender, A.Birth_Date, A.Nationality
FROM Athletes A
JOIN Athlete_Competitions AC ON A.Athlete_ID = AC.Athlete_ID
JOIN Competitions C ON AC.Competition_ID = C.Competition_ID
JOIN Training_Plan TP ON A.Athlete_ID = TP.Athlete_ID
WHERE TP.Coach_ID = 3;

-- Calculate the total recovery time for all injuries of an athlete
SELECT a.First_Name, a.Last_Name, SUM(ih.Recovery_Time) AS Total_Recovery_Time
FROM Athletes a
JOIN Injury_History ih ON a.Athlete_ID = ih.Athlete_ID
WHERE a.Athlete_ID = 1
GROUP BY a.Athlete_ID;

-- Find the average calories consumed per day by each athlete (based on nutrition records)
SELECT a.First_Name, a.Last_Name, AVG(n.Calories_Consumed) AS Avg_Calories_Consumed
FROM Athletes a
JOIN Nutrition n ON a.Athlete_ID = n.Athlete_ID
GROUP BY a.Athlete_ID;

-- List all the athletes who participated in a specific competition and finished in the top 3
SELECT A.Athlete_ID, A.First_Name, A.Last_Name, AC.Position, C.Name AS Competition_Name
FROM Athletes A
JOIN Athlete_Competitions AC ON A.Athlete_ID = AC.Athlete_ID
JOIN Competitions C ON AC.Competition_ID = C.Competition_ID
WHERE C.Name = 'National Sprint'
AND AC.Position <= 3;

-- Find the best athlete (based on position) in each competition
SELECT c.Name AS Competition_Name, a.First_Name, a.Last_Name, ac.Position
FROM Competitions c
JOIN Athlete_Competitions ac ON c.Competition_ID = ac.Competition_ID
JOIN Athletes a ON ac.Athlete_ID = a.Athlete_ID
WHERE ac.Position = 1;