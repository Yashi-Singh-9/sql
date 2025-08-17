CREATE DATABASE FantasySportsDB;
USE FantasySportsDB;

-- Users Table
CREATE TABLE users (
  user_id INT IDENTITY(1,1) PRIMARY KEY,
  username VARCHAR(20) UNIQUE,
  email VARCHAR(20) UNIQUE,
  password TEXT,
  full_name VARCHAR(20),
  join_date DATE
);

-- Leagues Table
CREATE TABLE leagues (
  league_id INT IDENTITY(1,1) PRIMARY KEY,
  league_name VARCHAR(20),
  user_id INT,
  start_date DATE,
  end_date DATE,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Teams Table
CREATE TABLE teams (
  team_id INT IDENTITY(1,1) PRIMARY KEY,
  team_name VARCHAR(20),
  user_id INT,
  league_id INT,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (league_id) REFERENCES leagues(league_id)
);

-- Players Table
CREATE TABLE players (
  player_id INT IDENTITY(1,1) PRIMARY KEY,
  player_name VARCHAR(20),
  team_name VARCHAR(20),
  position INT,
  total_points INT,
  fantasy_value VARCHAR(20)
);

-- Player Selection Table
CREATE TABLE player_selection (
  selection_id INT IDENTITY(1,1) PRIMARY KEY,
  team_id INT,
  player_id INT,
  points_scored INT,
  date_of_selection DATE,
  FOREIGN KEY (team_id) REFERENCES teams(team_id),
  FOREIGN KEY (player_id) REFERENCES players(player_id)
);

-- Player Stats Table
CREATE TABLE player_stats (
  stat_id INT IDENTITY(1,1) PRIMARY KEY,
  player_id INT,
  match_date DATE,
  goals INT,
  assists INT, 
  minutes_played INT,
  yellow_cards INT,
  red_cards INT,
  FOREIGN KEY (player_id) REFERENCES players(player_id)
);

-- Transactions Table
CREATE TABLE transactions (
  transaction_id INT IDENTITY(1,1) PRIMARY KEY,
  team_id_from INT,
  team_id_to INT,
  player_id INT,
  transfer_date DATE,
  FOREIGN KEY (team_id_from) REFERENCES teams(team_id),
  FOREIGN KEY (team_id_to) REFERENCES teams(team_id),
  FOREIGN KEY (player_id) REFERENCES players(player_id)
);

-- Matches Table
CREATE TABLE matches (
  match_id INT IDENTITY(1,1) PRIMARY KEY,
  home_team VARCHAR(50),
  away_team VARCHAR(50),
  match_date DATE,
  home_team_score INT,
  away_team_score INT
);

-- League Standings Table
CREATE TABLE league_standings (
  standing_id INT IDENTITY(1,1) PRIMARY KEY,
  league_id INT,
  team_id INT,
  points INT,
  position INT,
  FOREIGN KEY (league_id) REFERENCES leagues(league_id),
  FOREIGN KEY (team_id) REFERENCES teams(team_id)
);  

-- Users Table
INSERT INTO users (username, email, password, full_name, join_date) VALUES
('john_doe', 'john@example.com', 'password123', 'John Doe', '2025-01-15'),
('jane_doe', 'jane@example.com', 'password456', 'Jane Doe', '2025-01-16'),
('alex_smith', 'alex@example.com', 'password789', 'Alex Smith', '2025-01-17'),
('mary_johnson', 'mary@example.com', 'password012', 'Mary Johnson', '2025-01-18'),
('david_wilson', 'david@example.com', 'password345', 'David Wilson', '2025-01-19'),
('emma_white', 'emma@example.com', 'password678', 'Emma White', '2025-01-20'),
('oliver_brown', 'oliver@example.com', 'password910', 'Oliver Brown', '2025-01-21'),
('sophia_taylor', 'sophia@example.com', 'password112', 'Sophia Taylor', '2025-01-22');

-- Leagues Table
INSERT INTO leagues (league_name, user_id, start_date, end_date) VALUES
('Premier League', 1, '2025-02-01', '2025-05-01'),
('Champions League', 2, '2025-02-05', '2025-05-05'),
('La Liga', 3, '2025-02-10', '2025-05-10'),
('Serie A', 4, '2025-02-15', '2025-05-15'),
('Bundesliga', 5, '2025-02-20', '2025-05-20'),
('Ligue 1', 6, '2025-02-25', '2025-05-25'),
('MLS', 7, '2025-02-28', '2025-05-28'),
('Eredivisie', 8, '2025-03-01', '2025-06-01');

-- Teams Table
INSERT INTO teams (team_name, user_id, league_id) VALUES
('Team A', 1, 1),
('Team B', 1, 2),
('Team C', 2, 3),
('Team D', 2, 4),
('Team E', 3, 5),
('Team F', 4, 6),
('Team G', 5, 7),
('Team H', 6, 8);

-- Players Table
INSERT INTO players (player_name, team_name, position, total_points, fantasy_value) VALUES
('Lionel Messi', 'Team A', 1, 150, 'Expensive'),
('Cristiano Ronaldo', 'Team B', 2, 180, 'Expensive'),
('Kylian Mbappé', 'Team C', 1, 170, 'Expensive'),
('Neymar Jr.', 'Team D', 2, 160, 'Expensive'),
('Kevin De Bruyne', 'Team E', 3, 140, 'Moderate'),
('Virgil van Dijk', 'Team F', 4, 130, 'Moderate'),
('Erling Haaland', 'Team G', 1, 200, 'Very Expensive'),
('Robert Lewandowski', 'Team H', 2, 190, 'Very Expensive');

-- Player Selection Table
INSERT INTO player_selection (team_id, player_id, points_scored, date_of_selection) VALUES
(1, 1, 20, '2025-02-15'),
(1, 2, 30, '2025-02-15'),
(2, 3, 25, '2025-02-16'),
(2, 4, 35, '2025-02-16'),
(3, 5, 40, '2025-02-17'),
(3, 6, 50, '2025-02-17'),
(4, 7, 60, '2025-02-18'),
(4, 8, 45, '2025-02-18');

-- Player Stats Table
INSERT INTO player_stats (player_id, match_date, goals, assists, minutes_played, yellow_cards, red_cards) VALUES
(1, '2025-02-15', 2, 1, 90, 0, 0),
(2, '2025-02-16', 1, 2, 85, 1, 0),
(3, '2025-02-17', 3, 0, 88, 0, 0),
(4, '2025-02-18', 0, 1, 90, 1, 0),
(5, '2025-02-15', 1, 1, 80, 0, 0),
(6, '2025-02-16', 0, 0, 70, 2, 0),
(7, '2025-02-17', 2, 1, 85, 0, 1),
(8, '2025-02-18', 1, 2, 90, 0, 0);

-- Transactions Table
INSERT INTO transactions (team_id_from, team_id_to, player_id, transfer_date) VALUES
(1, 2, 1, '2025-02-10'),
(2, 3, 2, '2025-02-11'),
(3, 4, 3, '2025-02-12'),
(4, 5, 4, '2025-02-13'),
(5, 6, 5, '2025-02-14'),
(6, 7, 6, '2025-02-15'),
(7, 8, 7, '2025-02-16'),
(8, 1, 8, '2025-02-17');

-- Matches Table
INSERT INTO matches (home_team, away_team, match_date, home_team_score, away_team_score) VALUES
('Team A', 'Team B', '2025-02-15', 3, 1),
('Team C', 'Team D', '2025-02-16', 2, 2),
('Team E', 'Team F', '2025-02-17', 1, 0),
('Team G', 'Team H', '2025-02-18', 2, 2),
('Team A', 'Team C', '2025-02-20', 4, 0),
('Team B', 'Team D', '2025-02-21', 3, 3),
('Team E', 'Team G', '2025-02-22', 1, 3),
('Team F', 'Team H', '2025-02-23', 0, 1);

-- League Standings Table
INSERT INTO league_standings (league_id, team_id, points, position) VALUES
(1, 1, 9, 1),
(1, 2, 7, 2),
(2, 3, 6, 3),
(2, 4, 8, 4),
(3, 5, 10, 1),
(3, 6, 5, 2),
(4, 7, 4, 3),
(4, 8, 6, 4);

-- List all users who joined after a specific date.
SELECT * 
FROM Users 
WHERE join_date > '2025-01-17';

-- Find all players selected by a specific team in a given league
SELECT p.player_name, ts.team_name 
FROM Players p 
JOIN Player_Selection ps ON p.player_id = ps.player_id 
JOIN Teams ts ON ts.team_id = ps.team_id 
WHERE ts.league_id = 3;

-- Display the top 5 teams in a league based on the points accumulated in League_Standings.
SELECT TOP 5 ls.league_id, t.team_name, ls.points, ls.position
FROM league_standings ls
JOIN teams t ON ls.team_id = t.team_id
WHERE ls.league_id = 4 
ORDER BY ls.points DESC;

-- Find all transfers made in the last month
SELECT t.transaction_id, t.team_id_from, t.team_id_to, p.player_name, t.transfer_date
FROM transactions t
JOIN players p ON t.player_id = p.player_id
WHERE t.transfer_date >= DATEADD(MONTH, -1, GETDATE())
ORDER BY t.transfer_date DESC;

-- Find the top 5 players by total fantasy points scored across all teams
SELECT TOP 5 player_name, SUM(points_scored) AS total_points 
FROM Player_Selection ps 
JOIN Players p ON ps.player_id = p.player_id 
GROUP BY player_name 
ORDER BY total_points DESC;

-- List all players who have not been selected by any team in a specific league.
SELECT p.player_id, p.player_name, p.team_name
FROM players p
LEFT JOIN player_selection ps ON p.player_id = ps.player_id
LEFT JOIN teams t ON p.team_name = t.team_name
WHERE ps.selection_id IS NULL
AND t.league_id = 1;  

-- Get a list of all matches where a specific player participated
SELECT m.match_id, m.home_team, m.away_team, m.match_date, m.home_team_score, m.away_team_score
FROM player_stats ps
JOIN matches m ON ps.match_date = m.match_date
WHERE ps.player_id = 8 
ORDER BY m.match_date DESC;

-- Find the highest scorer in the league for a specific season.
SELECT TOP 1 ts.team_name, SUM(ps.points_scored) AS total_points 
FROM Player_Selection ps 
JOIN Teams ts ON ps.team_id = ts.team_id 
WHERE ts.league_id = 1 
GROUP BY ts.team_name 
ORDER BY total_points DESC;