-- MS SQL Project 
CREATE DATABASE OlympicsDB;
USE OlympicsDB;

-- Countries Table 
CREATE TABLE countries (
  country_id INT IDENTITY(1,1) PRIMARY KEY,
  country_name VARCHAR(50),
  continent VARCHAR(50)
);

-- Athletes Table  
CREATE TABLE athletes (
  athlete_id INT IDENTITY(1,1) PRIMARY KEY,
  name VARCHAR(50),
  gender VARCHAR(6) CHECK (gender IN ('Male', 'Female', 'Others')),
  dob DATE,
  country_id INT,
  FOREIGN KEY (country_id) REFERENCES countries(country_id)
);  

-- Sports Table 
CREATE TABLE sports (
  sport_id INT IDENTITY(1,1) PRIMARY KEY,
  sport_name VARCHAR(50)
);

-- Events Table  
CREATE TABLE events (
  event_id INT IDENTITY(1,1) PRIMARY KEY,
  event_name VARCHAR(50),
  sport_id INT,
  FOREIGN KEY (sport_id) REFERENCES sports(sport_id)
);

-- Games Table 
CREATE TABLE games (
  game_id INT IDENTITY(1,1) PRIMARY KEY,
  year INT,
  season VARCHAR(11) CHECK (season IN ('Spring', 'Summer', 'Monsoon', 'Autumn', 'Pre Winter', 'Winter')),
  host_country_id INT,
  FOREIGN KEY (host_country_id) REFERENCES countries(country_id)
);

-- Results Table  
CREATE TABLE results (
  result_id INT IDENTITY(1,1) PRIMARY KEY,
  athlete_id INT,
  event_id INT,
  game_id INT,
  medal VARCHAR(6) CHECK (medal IN ('Gold', 'Silver', 'Bronze', 'None')),
  FOREIGN KEY (athlete_id) REFERENCES athletes(athlete_id),
  FOREIGN KEY (event_id) REFERENCES events(event_id),
  FOREIGN KEY (game_id) REFERENCES games(game_id)
);

-- Insert Countries
INSERT INTO countries (country_name, continent) VALUES 
('USA', 'North America'),
('China', 'Asia'),
('India', 'Asia'),
('Germany', 'Europe'),
('Brazil', 'South America');

-- Insert Sports
INSERT INTO sports (sport_name) VALUES 
('Athletics'),
('Swimming'),
('Gymnastics'),
('Football'),
('Tennis');

-- Insert Events
INSERT INTO events (event_name, sport_id) VALUES 
('100m Sprint', 1),
('Long Jump', 1),
('200m Freestyle', 2),
('Balance Beam', 3),
('Football Finals', 4),
('Men Singles', 5);

-- Insert Games
INSERT INTO games (year, season, host_country_id) VALUES 
(2000, 'Summer', 1),
(2004, 'Winter', 4),
(2008, 'Summer', 2),
(2012, 'Autumn', 3),
(2016, 'Summer', 5),
(2020, 'Winter', 1);

-- Insert Athletes 
INSERT INTO athletes (name, gender, dob, country_id) VALUES 
('John Doe', 'Male', '1990-05-15', 1),
('Jane Smith', 'Female', '1992-07-21', 2),
('David Johnson', 'Male', '1988-09-10', 3),
('Emily Davis', 'Female', '1995-03-30', 4),
('Michael Brown', 'Male', '1991-12-25', 5),
('Sarah Lee', 'Female', '1993-06-14', 1),
('Chris Evans', 'Male', '1987-04-07', 2),
('Olivia Martin', 'Female', '1996-08-19', 3),
('Daniel Wilson', 'Male', '1989-11-05', 4),
('Sophia Taylor', 'Female', '1997-02-11', 5),
('Robert White', 'Male', '1994-10-29', 1),
('Isabella Harris', 'Female', '1990-12-13', 2),
('Ethan Thomas', 'Male', '1998-01-25', 3),
('Mia Robinson', 'Female', '1991-09-30', 4);

-- Insert Results 
INSERT INTO results (athlete_id, event_id, game_id, medal) VALUES 
(1, 1, 1, 'Gold'),
(2, 2, 2, 'Silver'),
(3, 3, 3, 'Bronze'),
(4, 4, 4, 'None'),
(5, 5, 5, 'Gold'),
(6, 6, 6, 'Silver'),
(7, 1, 1, 'Bronze'),
(8, 2, 2, 'None'),
(9, 3, 3, 'Gold'),
(10, 4, 4, 'Silver'),
(11, 5, 5, 'None'),
(12, 6, 6, 'Gold'),
(13, 1, 1, 'Silver'),
(14, 2, 2, 'Bronze');

-- Additional Random Results 
INSERT INTO results (athlete_id, event_id, game_id, medal) VALUES 
(1, 3, 2, 'Silver'),
(2, 4, 3, 'None'),
(3, 5, 4, 'Bronze'),
(4, 6, 5, 'Gold'),
(5, 1, 6, 'Silver'),
(6, 2, 1, 'None'),
(7, 3, 2, 'Gold'),
(8, 4, 3, 'Silver'),
(9, 5, 4, 'None'),
(10, 6, 5, 'Bronze'),
(11, 1, 6, 'Gold'),
(12, 2, 1, 'Silver'),
(13, 3, 2, 'None'),
(14, 4, 3, 'Gold');

-- List all athletes who have won a gold medal.
SELECT DISTINCT a.athlete_id, a.name, c.country_name
FROM athletes a
JOIN results r ON a.athlete_id = r.athlete_id
JOIN countries c ON a.country_id = c.country_id
WHERE r.medal = 'Gold';

-- Find the total number of medals won by each country.
SELECT c.country_name, COUNT(r.medal) AS total_medals
FROM results r
JOIN athletes a ON r.athlete_id = a.athlete_id
JOIN countries c ON a.country_id = c.country_id
WHERE r.medal != 'None'
GROUP BY c.country_name
ORDER BY total_medals DESC;

-- Retrieve all events for a specific Olympic year.
SELECT DISTINCT e.event_name, s.sport_name
FROM events e
JOIN results r ON e.event_id = r.event_id
JOIN games g ON r.game_id = g.game_id
JOIN sports s ON e.sport_id = s.sport_id
WHERE g.year = 2016;

-- Find the athlete who has won the most medals.
SELECT TOP 1 a.athlete_id, a.name, c.country_name, COUNT(r.medal) AS total_medals
FROM athletes a
JOIN results r ON a.athlete_id = r.athlete_id
JOIN countries c ON a.country_id = c.country_id
WHERE r.medal != 'None'
GROUP BY a.athlete_id, a.name, c.country_name
ORDER BY total_medals DESC;

-- List all sports that have been played in the Winter Olympics.
SELECT DISTINCT s.sport_name
FROM sports s
JOIN events e ON s.sport_id = e.sport_id
JOIN results r ON e.event_id = r.event_id
JOIN games g ON r.game_id = g.game_id
WHERE g.season = 'Winter';

-- Get the top 5 countries with the most gold medals.
SELECT TOP 5 c.country_name, COUNT(r.medal) AS gold_medals
FROM results r
JOIN athletes a ON r.athlete_id = a.athlete_id
JOIN countries c ON a.country_id = c.country_id
WHERE r.medal = 'Gold'
GROUP BY c.country_name
ORDER BY gold_medals DESC;

-- Retrieve all athletes from a specific country.
SELECT athlete_id, name, gender, dob
FROM athletes
WHERE country_id = (SELECT country_id FROM countries WHERE country_name = 'USA');

-- Find all events where no medals were awarded.
SELECT DISTINCT e.event_name, s.sport_name
FROM events e
JOIN results r ON e.event_id = r.event_id
JOIN sports s ON e.sport_id = s.sport_id
WHERE r.medal = 'None';

-- List all Olympic Games hosted by a specific country.
SELECT g.year, g.season
FROM games g
JOIN countries c ON g.host_country_id = c.country_id
WHERE c.country_name = 'Germany';

-- Find the total number of athletes from each country.
SELECT c.country_name, COUNT(a.athlete_id) AS total_athletes
FROM athletes a
JOIN countries c ON a.country_id = c.country_id
GROUP BY c.country_name
ORDER BY total_athletes DESC;

-- Retrieve all athletes who have never won a medal
SELECT a.athlete_id, a.name, c.country_name
FROM athletes a
LEFT JOIN results r ON a.athlete_id = r.athlete_id
JOIN countries c ON a.country_id = c.country_id
WHERE r.medal IS NULL OR r.medal = 'None';

-- Find the country that has hosted the most Olympic Games
SELECT TOP 1 c.country_name, COUNT(g.game_id) AS times_hosted
FROM games g
JOIN countries c ON g.host_country_id = c.country_id
GROUP BY c.country_name
ORDER BY times_hosted DESC;

-- List all athletes who have participated in a specific sport
SELECT DISTINCT a.athlete_id, a.name, c.country_name
FROM athletes a
JOIN results r ON a.athlete_id = r.athlete_id
JOIN events e ON r.event_id = e.event_id
JOIN sports s ON e.sport_id = s.sport_id
JOIN countries c ON a.country_id = c.country_id
WHERE s.sport_name = 'Football';

-- Find the youngest athletes who have won a medal
SELECT TOP 1 a.athlete_id, a.name, a.dob, c.country_name, DATEDIFF(YEAR, a.dob, GETDATE()) AS age
FROM athletes a
JOIN results r ON a.athlete_id = r.athlete_id
JOIN countries c ON a.country_id = c.country_id
WHERE r.medal != 'None'
ORDER BY a.dob DESC;

-- Find the oldest athletes who have won a medal
SELECT TOP 1 a.athlete_id, a.name, a.dob, c.country_name, DATEDIFF(YEAR, a.dob, GETDATE()) AS age
FROM athletes a
JOIN results r ON a.athlete_id = r.athlete_id
JOIN countries c ON a.country_id = c.country_id
WHERE r.medal != 'None'
ORDER BY a.dob ASC;  

-- Find the most popular event (most participated)
SELECT TOP 1 e.event_name, s.sport_name, COUNT(r.athlete_id) AS num_participants
FROM results r
JOIN events e ON r.event_id = e.event_id
JOIN sports s ON e.sport_id = s.sport_id
GROUP BY e.event_name, s.sport_name
ORDER BY num_participants DESC;

-- Retrieve all female athletes who have won at least one gold medal
SELECT DISTINCT a.athlete_id, a.name, c.country_name
FROM athletes a
JOIN results r ON a.athlete_id = r.athlete_id
JOIN countries c ON a.country_id = c.country_id
WHERE a.gender = 'Female' AND r.medal = 'Gold';

-- Find the sport with the most gold medals awarded
SELECT TOP 1 s.sport_name, COUNT(r.medal) AS gold_medals
FROM results r
JOIN events e ON r.event_id = e.event_id
JOIN sports s ON e.sport_id = s.sport_id
WHERE r.medal = 'Gold'
GROUP BY s.sport_name
ORDER BY gold_medals DESC;

-- Find all athletes who have won at least one medal in every Olympic Games they participated in
SELECT a.athlete_id, a.name, c.country_name
FROM athletes a
JOIN results r ON a.athlete_id = r.athlete_id
JOIN countries c ON a.country_id = c.country_id
WHERE r.medal != 'None'
GROUP BY a.athlete_id, a.name, c.country_name
HAVING COUNT(DISTINCT r.game_id) = (SELECT COUNT(DISTINCT game_id) FROM results WHERE athlete_id = a.athlete_id);

-- Find the year when the highest number of gold medals were awarded
SELECT TOP 1 g.year, g.season, COUNT(r.medal) AS gold_medals
FROM results r
JOIN games g ON r.game_id = g.game_id
WHERE r.medal = 'Gold'
GROUP BY g.year, g.season
ORDER BY gold_medals DESC;