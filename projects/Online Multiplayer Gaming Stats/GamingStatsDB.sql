-- Project In MariaDB 
-- Creating the database
CREATE DATABASE GamingStatsDB;
USE GamingStatsDB;

-- Users Table
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    join_date DATE NOT NULL
);

-- Games Table
CREATE TABLE Games (
    game_id INT AUTO_INCREMENT PRIMARY KEY,
    game_name VARCHAR(100) UNIQUE NOT NULL,
    release_date DATE NOT NULL
);

-- Matches Table
CREATE TABLE Matches (
    match_id INT AUTO_INCREMENT PRIMARY KEY,
    game_id INT NOT NULL,
    match_date DATETIME NOT NULL,
    FOREIGN KEY (game_id) REFERENCES Games(game_id) ON DELETE CASCADE
);

-- PlayerStats Table
CREATE TABLE PlayerStats (
    stat_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    match_id INT NOT NULL,
    score INT NOT NULL,
    kills INT NOT NULL,
    deaths INT NOT NULL,
    assists INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (match_id) REFERENCES Matches(match_id) ON DELETE CASCADE
);

-- Teams Table
CREATE TABLE Teams (
    team_id INT AUTO_INCREMENT PRIMARY KEY,
    team_name VARCHAR(100) UNIQUE NOT NULL
);

-- UserTeams Table (Mapping users to teams)
CREATE TABLE UserTeams (
    user_team_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    team_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (team_id) REFERENCES Teams(team_id) ON DELETE CASCADE
);

-- Leaderboard Table
CREATE TABLE Leaderboard (
    leaderboard_id INT AUTO_INCREMENT PRIMARY KEY,
    game_id INT NOT NULL,
    user_id INT NOT NULL,
    rank INT NOT NULL,
    total_score INT NOT NULL,
    FOREIGN KEY (game_id) REFERENCES Games(game_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

INSERT INTO Users (username, email, password_hash, join_date) VALUES
('PlayerOne', 'playerone@example.com', 'hashedpass1', '2024-01-10'),
('GamerX', 'gamerx@example.com', 'hashedpass2', '2023-12-15'),
('ProKiller', 'prokiller@example.com', 'hashedpass3', '2024-02-01'),
('ShadowNinja', 'shadowninja@example.com', 'hashedpass4', '2023-11-20'),
('Legend27', 'legend27@example.com', 'hashedpass5', '2023-10-05');

INSERT INTO Games (game_name, release_date) VALUES
('Battle Royale X', '2022-06-15'),
('Arena Shooter', '2023-01-25'),
('Zombie Apocalypse', '2021-11-10'),
('Racing Rivals', '2020-08-30'),
('Space War 3000', '2023-09-17');

INSERT INTO Matches (game_id, match_date) VALUES
(1, '2024-02-10 15:30:00'),
(2, '2024-02-12 18:00:00'),
(3, '2024-02-15 20:45:00'),
(4, '2024-02-18 22:10:00'),
(5, '2024-02-20 14:00:00');

INSERT INTO PlayerStats (user_id, match_id, score, kills, deaths, assists) VALUES
(1, 1, 2500, 15, 3, 5),
(2, 2, 1800, 10, 5, 7),
(3, 3, 3200, 20, 2, 8),
(4, 4, 1500, 8, 6, 4),
(5, 5, 2700, 18, 4, 6);

INSERT INTO Teams (team_name) VALUES
('Warriors'),
('SniperSquad'),
('StealthKillers'),
('DeathBringers'),
('FireStorm');

INSERT INTO UserTeams (user_id, team_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

INSERT INTO Leaderboard (game_id, user_id, rank, total_score) VALUES
(1, 1, 1, 5000),
(2, 2, 2, 4000),
(3, 3, 3, 6000),
(4, 4, 4, 3500),
(5, 5, 5, 4700);

-- Retrieve the top 2 players from the leaderboard for a specific game
SELECT u.username, l.total_score, l.rank
FROM Leaderboard l
JOIN Users u ON l.user_id = u.user_id
WHERE l.game_id = 1
ORDER BY l.total_score DESC
LIMIT 2;

-- Find the highest-scoring match in a given game
SELECT m.match_id, g.game_name, MAX(p.score) AS highest_score
FROM Matches m
JOIN PlayerStats p ON m.match_id = p.match_id
JOIN Games g ON m.game_id = g.game_id
WHERE g.game_id = 1
GROUP BY m.match_id, g.game_name
ORDER BY highest_score DESC
LIMIT 1;

-- List all matches where a particular user participated
SELECT m.match_id, g.game_name, m.match_date
FROM Matches m
JOIN PlayerStats p ON m.match_id = p.match_id
JOIN Games g ON m.game_id = g.game_id
WHERE p.user_id = 2;

-- Calculate the average kills per match for each user
SELECT u.username, AVG(p.kills) AS avg_kills
FROM PlayerStats p
JOIN Users u ON p.user_id = u.user_id
GROUP BY u.username
ORDER BY avg_kills DESC;

-- Find the most played game (game with the most matches played)
SELECT g.game_name, COUNT(m.match_id) AS total_matches
FROM Matches m
JOIN Games g ON m.game_id = g.game_id
GROUP BY g.game_name
ORDER BY total_matches DESC
LIMIT 1;

-- Find the top 3 players with the highest kill-to-death ratio
SELECT u.username, 
       SUM(p.kills) / NULLIF(SUM(p.deaths), 0) AS kill_death_ratio
FROM PlayerStats p
JOIN Users u ON p.user_id = u.user_id
GROUP BY u.username
ORDER BY kill_death_ratio DESC
LIMIT 3;

-- Get the total number of matches played by each user
SELECT u.username, COUNT(p.match_id) AS total_matches
FROM Users u
LEFT JOIN PlayerStats p ON u.user_id = p.user_id
GROUP BY u.username
ORDER BY total_matches DESC;

-- Retrieve the highest score achieved in a single match
SELECT u.username, m.match_id, MAX(p.score) AS highest_score
FROM PlayerStats p
JOIN Users u ON p.user_id = u.user_id
JOIN Matches m ON p.match_id = m.match_id
GROUP BY u.username, m.match_id
ORDER BY highest_score DESC
LIMIT 1;

-- Get the average number of assists per match for each user
SELECT u.username, ROUND(AVG(p.assists), 2) AS avg_assists
FROM PlayerStats p
JOIN Users u ON p.user_id = u.user_id
GROUP BY u.username
ORDER BY avg_assists DESC;

-- List all users along with their total kills, deaths, and assists
SELECT u.username, 
       SUM(p.kills) AS total_kills, 
       SUM(p.deaths) AS total_deaths, 
       SUM(p.assists) AS total_assists
FROM PlayerStats p
JOIN Users u ON p.user_id = u.user_id
GROUP BY u.username
ORDER BY total_kills DESC;

-- Find the team with the highest total score
SELECT t.team_name, SUM(l.total_score) AS team_total_score
FROM UserTeams ut
JOIN Teams t ON ut.team_id = t.team_id
JOIN Leaderboard l ON ut.user_id = l.user_id
GROUP BY t.team_name
ORDER BY team_total_score DESC
LIMIT 1;

-- Get the number of matches played in each month of the year
SELECT DATE_FORMAT(match_date, '%Y-%m') AS match_month, COUNT(*) AS total_matches
FROM Matches
GROUP BY match_month
ORDER BY match_month;

-- List the top 3 teams with the highest average player score
SELECT t.team_name, ROUND(AVG(p.score), 2) AS avg_team_score
FROM UserTeams ut
JOIN Teams t ON ut.team_id = t.team_id
JOIN PlayerStats p ON ut.user_id = p.user_id
GROUP BY t.team_name
ORDER BY avg_team_score DESC
LIMIT 3;

-- Find all matches where a specific user participated and rank them by score
SELECT m.match_id, g.game_name, p.score
FROM PlayerStats p
JOIN Matches m ON p.match_id = m.match_id
JOIN Games g ON m.game_id = g.game_id
WHERE p.user_id = 3 
ORDER BY p.score DESC;

-- Show the top 3 matches with the most players participating
SELECT p.match_id, COUNT(p.user_id) AS total_players
FROM PlayerStats p
GROUP BY p.match_id
ORDER BY total_players DESC
LIMIT 3;
