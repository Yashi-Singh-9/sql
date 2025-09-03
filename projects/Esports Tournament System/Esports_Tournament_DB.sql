-- MS SQL Project
CREATE DATABASE Esports_Tournament_DB;
USE Esports_Tournament_DB;

CREATE TABLE Tournaments (
    tournament_id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    game VARCHAR(100) NOT NULL
);

CREATE TABLE Teams (
    team_id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    region VARCHAR(100) NOT NULL,
    coach_name VARCHAR(255) NOT NULL
);

CREATE TABLE Players (
    player_id INT IDENTITY(1,1) PRIMARY KEY,
    team_id INT,
    nickname VARCHAR(255) NOT NULL,
    real_name VARCHAR(255) NOT NULL,
    age INT NOT NULL,
    FOREIGN KEY (team_id) REFERENCES Teams(team_id)
);

CREATE TABLE Matches (
    match_id INT IDENTITY(1,1) PRIMARY KEY,
    tournament_id INT,
    team1_id INT,
    team2_id INT,
    match_date DATE NOT NULL,
    winner_team_id INT,
    FOREIGN KEY (tournament_id) REFERENCES Tournaments(tournament_id),
    FOREIGN KEY (team1_id) REFERENCES Teams(team_id),
    FOREIGN KEY (team2_id) REFERENCES Teams(team_id),
    FOREIGN KEY (winner_team_id) REFERENCES Teams(team_id)
);

CREATE TABLE Match_Results (
    result_id INT IDENTITY(1,1) PRIMARY KEY,
    match_id INT,
    team_id INT,
    score INT NOT NULL,
    FOREIGN KEY (match_id) REFERENCES Matches(match_id),
    FOREIGN KEY (team_id) REFERENCES Teams(team_id)
);

CREATE TABLE Sponsorships (
    sponsor_id INT IDENTITY(1,1) PRIMARY KEY,
    sponsor_name VARCHAR(255) NOT NULL
);

CREATE TABLE Tournament_Sponsors (
    tournament_id INT,
    sponsor_id INT,
    PRIMARY KEY (tournament_id, sponsor_id),
    FOREIGN KEY (tournament_id) REFERENCES Tournaments(tournament_id),
    FOREIGN KEY (sponsor_id) REFERENCES Sponsorships(sponsor_id)
);

CREATE TABLE Referees (
    referee_id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    experience_years INT NOT NULL
);

CREATE TABLE Match_Referees (
    match_id INT,
    referee_id INT,
    PRIMARY KEY (match_id, referee_id),
    FOREIGN KEY (match_id) REFERENCES Matches(match_id),
    FOREIGN KEY (referee_id) REFERENCES Referees(referee_id)
);

CREATE TABLE Venues (
    venue_id INT IDENTITY(1,1) PRIMARY KEY,
    venue_name VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL
);

CREATE TABLE Tournament_Venues (
    tournament_id INT,
    venue_id INT,
    PRIMARY KEY (tournament_id, venue_id),
    FOREIGN KEY (tournament_id) REFERENCES Tournaments(tournament_id),
    FOREIGN KEY (venue_id) REFERENCES Venues(venue_id)
);

-- Inserting sample data into Tournaments table
INSERT INTO Tournaments (name, start_date, end_date, game)
VALUES 
('Champions League', '2025-03-01', '2025-03-10', 'Football'),
('World Cup', '2025-06-10', '2025-06-20', 'Football'),
('Euro League', '2025-04-05', '2025-04-15', 'Football'),
('Premier League', '2025-08-01', '2025-08-30', 'Football'),
('Asian Cup', '2025-11-01', '2025-11-15', 'Football'),
('Copa America', '2025-07-10', '2025-07-25', 'Football'),
('African Nations', '2025-12-01', '2025-12-10', 'Football'),
('Gold Cup', '2025-09-01', '2025-09-10', 'Football');

-- Inserting sample data into Teams table
INSERT INTO Teams (name, region, coach_name)
VALUES 
('Team A', 'Europe', 'Coach 1'),
('Team B', 'Europe', 'Coach 2'),
('Team C', 'South America', 'Coach 3'),
('Team D', 'Africa', 'Coach 4'),
('Team E', 'Asia', 'Coach 5'),
('Team F', 'North America', 'Coach 6'),
('Team G', 'Oceania', 'Coach 7'),
('Team H', 'Europe', 'Coach 8');

-- Inserting sample data into Players table
INSERT INTO Players (team_id, nickname, real_name, age)
VALUES 
(1, 'PlayerA1', 'John Doe', 25),
(2, 'PlayerB1', 'Jane Smith', 30),
(3, 'PlayerC1', 'Carlos Perez', 28),
(4, 'PlayerD1', 'Samuel L. Jackson', 35),
(5, 'PlayerE1', 'Li Wei', 27),
(6, 'PlayerF1', 'Maria Garcia', 24),
(7, 'PlayerG1', 'Lucas White', 29),
(8, 'PlayerH1', 'David Lee', 31);

-- Inserting sample data into Matches table
INSERT INTO Matches (tournament_id, team1_id, team2_id, match_date, winner_team_id)
VALUES 
(1, 1, 2, '2025-03-02', 1),
(2, 2, 3, '2025-06-12', 2),
(3, 3, 4, '2025-04-06', 3),
(4, 4, 5, '2025-08-02', 4),
(5, 5, 6, '2025-11-05', 5),
(6, 6, 7, '2025-07-12', 6),
(7, 7, 8, '2025-12-03', 7),
(8, 1, 3, '2025-09-02', 3);

-- Inserting sample data into Match_Results table
INSERT INTO Match_Results (match_id, team_id, score)
VALUES 
(1, 1, 3),
(1, 2, 1),
(2, 2, 2),
(2, 3, 3),
(3, 3, 2),
(3, 4, 1),
(4, 4, 3),
(4, 5, 2);

-- Inserting sample data into Sponsorships table
INSERT INTO Sponsorships (sponsor_name)
VALUES 
('Sponsor 1'),
('Sponsor 2'),
('Sponsor 3'),
('Sponsor 4'),
('Sponsor 5'),
('Sponsor 6'),
('Sponsor 7'),
('Sponsor 8');

-- Inserting sample data into Tournament_Sponsors table
INSERT INTO Tournament_Sponsors (tournament_id, sponsor_id)
VALUES 
(1, 1),
(1, 2),
(2, 3),
(2, 4),
(3, 5),
(3, 6),
(4, 7),
(4, 8);

-- Inserting sample data into Referees table
INSERT INTO Referees (name, experience_years)
VALUES 
('Referee 1', 10),
('Referee 2', 15),
('Referee 3', 12),
('Referee 4', 20),
('Referee 5', 5),
('Referee 6', 8),
('Referee 7', 17),
('Referee 8', 25);

-- Inserting sample data into Match_Referees table
INSERT INTO Match_Referees (match_id, referee_id)
VALUES 
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8);

-- Inserting sample data into Venues table
INSERT INTO Venues (venue_name, location)
VALUES 
('Stadium 1', 'City A'),
('Stadium 2', 'City B'),
('Stadium 3', 'City C'),
('Stadium 4', 'City D'),
('Stadium 5', 'City E'),
('Stadium 6', 'City F'),
('Stadium 7', 'City G'),
('Stadium 8', 'City H');

-- Inserting sample data into Tournament_Venues table
INSERT INTO Tournament_Venues (tournament_id, venue_id)
VALUES 
(1, 1),
(1, 2),
(2, 3),
(2, 4),
(3, 5),
(3, 6),
(4, 7),
(4, 8);

-- Retrieve all tournaments along with the number of teams participating.
SELECT t.tournament_id, t.name AS tournament_name, COUNT(DISTINCT m.team1_id) + COUNT(DISTINCT m.team2_id) AS num_teams
FROM Tournaments t
JOIN Matches m ON t.tournament_id = m.tournament_id
GROUP BY t.tournament_id, t.name;

-- Find the total number of matches played in a specific tournament.
SELECT COUNT(*) AS total_matches
FROM Matches
WHERE tournament_id = 4;

-- List all matches where a specific team was the winner.
SELECT m.match_id, m.tournament_id, m.team1_id, m.team2_id, m.match_date, m.winner_team_id
FROM Matches m
WHERE m.winner_team_id = 2;

-- Get the top 3 teams with the highest average score in matches.
SELECT TOP 3 
    mr.team_id, 
    AVG(mr.score) AS average_score
FROM Match_Results mr
JOIN Matches m ON mr.match_id = m.match_id
WHERE mr.team_id = m.team1_id OR mr.team_id = m.team2_id
GROUP BY mr.team_id
ORDER BY average_score DESC;

-- Show the list of players along with their teams participating in a specific tournament.
SELECT p.nickname, p.real_name, p.age, t.name AS team_name
FROM Players p
JOIN Teams t ON p.team_id = t.team_id
JOIN Matches m ON t.team_id = m.team1_id OR t.team_id = m.team2_id
WHERE m.tournament_id = 6;

-- Find all referees who have officiated more than 5 matches.
SELECT r.referee_id, r.name, COUNT(mr.match_id) AS matches_officiated
FROM Referees r
JOIN Match_Referees mr ON r.referee_id = mr.referee_id
GROUP BY r.referee_id, r.name
HAVING COUNT(mr.match_id) > 5;

-- Get a list of tournaments with their sponsors.
SELECT t.name AS tournament_name, s.sponsor_name
FROM Tournaments t
JOIN Tournament_Sponsors ts ON t.tournament_id = ts.tournament_id
JOIN Sponsorships s ON ts.sponsor_id = s.sponsor_id;

-- Find the match with the highest score difference.
SELECT TOP 1 m.match_id, m.team1_id, m.team2_id, 
    ABS(mr1.score - mr2.score) AS score_difference
FROM Matches m
JOIN Match_Results mr1 ON m.match_id = mr1.match_id AND m.team1_id = mr1.team_id
JOIN Match_Results mr2 ON m.match_id = mr2.match_id AND m.team2_id = mr2.team_id
ORDER BY score_difference DESC;

-- Retrieve all teams who have participated in more than 2 tournaments.
SELECT t.team_id, t.name
FROM Teams t
JOIN Matches m ON t.team_id = m.team1_id OR t.team_id = m.team2_id
GROUP BY t.team_id, t.name
HAVING COUNT(DISTINCT m.tournament_id) > 2;

-- List all players who are younger than 25 and the teams they belong to.
SELECT p.nickname, p.real_name, p.age, t.name AS team_name
FROM Players p
JOIN Teams t ON p.team_id = t.team_id
WHERE p.age < 25;
