-- MS SQL Project
CREATE DATABASE sports_stats_db 

-- Teams Table
CREATE TABLE teams (
  team_id INT IDENTITY(1,1) PRIMARY KEY,
  team_name VARCHAR(20),
  city VARCHAR(20),
  founded_year DATE
);

-- Players Table
CREATE TABLE players (
  player_id INT IDENTITY(1,1) PRIMARY KEY,
  first_name VARCHAR(20),
  last_name VARCHAR(20),
  date_of_birth DATE,
  nationality VARCHAR(20),
  team_id INT,
  position VARCHAR(20),
  FOREIGN KEY (team_id) REFERENCES teams(team_id)
);

-- Matches Table
CREATE TABLE matches (
    match_id INT IDENTITY(1,1) PRIMARY KEY,
    home_team_id INT,
    away_team_id INT,
    match_date DATE,
    stadium_name VARCHAR(100),
    home_team_score INT,
    away_team_score INT,
    FOREIGN KEY (home_team_id) REFERENCES Teams(team_id),
    FOREIGN KEY (away_team_id) REFERENCES Teams(team_id)
);

-- Player Stats Table
CREATE TABLE player_stats (
  stat_id INT IDENTITY(1,1) PRIMARY KEY,
  match_id INT,
  player_id INT,
  goals_scored INT,
  assists INT,
  yellow_cards INT,
  red_cards INT,
  minutes_played INT,
  FOREIGN KEY (match_id) REFERENCES matches(match_id),
  FOREIGN KEY (player_id) REFERENCES players(player_id)
);

-- Standings Table
CREATE TABLE standings (
  standing_id INT IDENTITY(1,1) PRIMARY KEY,
  team_id INT,
  matches_played INT,
  wins INT,
  losses INT,
  draws INT,
  points INT,
  FOREIGN KEY (team_id) REFERENCES teams(team_id)
);  

-- Insert Sample Data into Teams Table
INSERT INTO teams (team_name, city, founded_year) VALUES 
('Red Warriors', 'New York', '1990-05-15'),
('Blue Hawks', 'Los Angeles', '1985-08-22'),
('Green Titans', 'Chicago', '2000-03-10'),
('Yellow Strikers', 'Miami', '1995-11-30');

-- Insert Sample Data into Players Table
INSERT INTO players (first_name, last_name, date_of_birth, nationality, team_id, position) VALUES
('John', 'Doe', '1995-07-12', 'USA', 1, 'Forward'),
('Mike', 'Smith', '1998-09-24', 'USA', 2, 'Midfielder'),
('Carlos', 'Gomez', '1992-04-03', 'Mexico', 3, 'Defender'),
('David', 'Brown', '2000-06-14', 'Canada', 4, 'Goalkeeper');

-- Insert Sample Data into Matches Table
INSERT INTO matches (home_team_id, away_team_id, match_date, stadium_name, home_team_score, away_team_score) VALUES
(1, 2, '2024-02-01', 'Red Warriors Stadium', 3, 2),
(3, 4, '2024-02-05', 'Green Titans Arena', 1, 1),
(2, 3, '2024-02-10', 'Blue Hawks Field', 0, 2),
(4, 1, '2024-02-15', 'Yellow Strikers Park', 2, 3);

-- Insert Sample Data into Player Stats Table
INSERT INTO player_stats (match_id, player_id, goals_scored, assists, yellow_cards, red_cards, minutes_played) VALUES
(1, 1, 2, 1, 0, 0, 90),
(1, 2, 1, 0, 1, 0, 85),
(2, 3, 0, 1, 0, 0, 90),
(2, 4, 0, 0, 0, 0, 90),
(3, 2, 0, 0, 1, 0, 88),
(4, 1, 1, 0, 0, 0, 90);

-- Insert Sample Data into Standings Table
INSERT INTO standings (team_id, matches_played, wins, losses, draws, points) VALUES
(1, 2, 2, 0, 0, 6),
(2, 2, 0, 2, 0, 0),
(3, 2, 1, 0, 1, 4),
(4, 2, 0, 1, 1, 1);

-- List all players along with their team names.
SELECT p.player_id, p.first_name, p.last_name, t.team_name
FROM players p
JOIN teams t ON p.team_id = t.team_id;

-- Find the top 2 players who have scored the most goals in all matches.
SELECT TOP 2 p.player_id, p.first_name, p.last_name, SUM(ps.goals_scored) AS total_goals
FROM player_stats ps
JOIN players p ON ps.player_id = p.player_id
GROUP BY p.player_id, p.first_name, p.last_name
ORDER BY total_goals DESC;

-- Retrieve all matches where a particular team played as either home or away.
SELECT * 
FROM matches
WHERE home_team_id = 1 OR away_team_id = 1; 

-- Get the total number of goals scored by each team.
SELECT t.team_name, 
       COALESCE(SUM(CASE WHEN m.home_team_id = t.team_id THEN m.home_team_score ELSE 0 END), 0) +
       COALESCE(SUM(CASE WHEN m.away_team_id = t.team_id THEN m.away_team_score ELSE 0 END), 0) AS total_goals
FROM teams t
LEFT JOIN matches m ON t.team_id = m.home_team_id OR t.team_id = m.away_team_id
GROUP BY t.team_name;

-- Find the players who have received the most yellow cards.
SELECT TOP 1 p.player_id, p.first_name, p.last_name, SUM(ps.yellow_cards) AS total_yellow_cards
FROM player_stats ps
JOIN players p ON ps.player_id = p.player_id
GROUP BY p.player_id, p.first_name, p.last_name
ORDER BY total_yellow_cards DESC;

-- Get the standings of teams ordered by points in descending order.
SELECT t.team_name, s.matches_played, s.wins, s.losses, s.draws, s.points
FROM standings s
JOIN teams t ON s.team_id = t.team_id
ORDER BY s.points DESC;

-- Retrieve matches where the home team won.
SELECT * 
FROM matches 
WHERE home_team_score > away_team_score;

-- Find the average goals scored per match.
SELECT AVG(home_team_score + away_team_score) AS avg_goals_per_match
FROM matches;

-- List all teams along with the number of matches they have played.
SELECT t.team_name, 
       COUNT(m.match_id) AS matches_played
FROM teams t
LEFT JOIN matches m ON t.team_id = m.home_team_id OR t.team_id = m.away_team_id
GROUP BY t.team_name;

-- Find the player with the highest assists in a single match.
SELECT TOP 1 p.player_id, p.first_name, p.last_name, ps.match_id, ps.assists
FROM player_stats ps
JOIN players p ON ps.player_id = p.player_id
ORDER BY ps.assists DESC;
