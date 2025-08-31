-- MS SQL Project
CREATE DATABASE gaming_analytics;

-- Users Table 
Create TABLE users (
  user_id INT IDENTITY(1,1) PRIMARY KEY,
  username VARCHAR(50),
  email VARCHAR(50),
  country VARCHAR(50),
  registration_date DATE
);

INSERT INTO users (username, email, country, registration_date) VALUES
('john_doe', 'john.doe@example.com', 'USA', '2024-01-15'),
('alice_smith', 'alice.smith@example.com', 'Canada', '2023-12-20'),
('michael_j', 'michael.j@example.com', 'UK', '2024-02-05'),
('sophia_w', 'sophia.w@example.com', 'Australia', '2024-01-30'),
('david_lee', 'david.lee@example.com', 'Germany', '2023-11-10'),
('emma_b', 'emma.b@example.com', 'France', '2024-02-01'),
('robert_k', 'robert.k@example.com', 'USA', '2023-10-25'),
('olivia_r', 'olivia.r@example.com', 'Spain', '2023-09-18'),
('william_t', 'william.t@example.com', 'Italy', '2024-01-05'),
('amelia_c', 'amelia.c@example.com', 'Netherlands', '2023-12-12');

-- Games Table 
CREATE TABLE games (
  game_id INT IDENTITY(1,1) PRIMARY KEY,
  game_name VARCHAR(50),
  genre VARCHAR(50),
  release_date DATE
);  

INSERT INTO games (game_name, genre, release_date) VALUES
('Elden Ring', 'Action RPG', '2022-02-25'),
('The Witcher 3', 'Action RPG', '2015-05-19'),
('Cyberpunk 2077', 'Action RPG', '2020-12-10'),
('Minecraft', 'Sandbox', '2011-11-18'),
('Grand Theft Auto V', 'Action-Adventure', '2013-09-17'),
('Red Dead Redemption 2', 'Action-Adventure', '2018-10-26'),
('The Legend of Zelda: Breath of the Wild', 'Action-Adventure', '2017-03-03'),
('Call of Duty: Modern Warfare', 'First-Person Shooter', '2019-10-25'),
('Fortnite', 'Battle Royale', '2017-07-21'),
('Among Us', 'Party', '2018-06-15');

-- Sessions Table 
CREATE TABLE sessions (
  session_id INT IDENTITY(1,1) PRIMARY KEY,
  user_id INT,
  game_id INT,
  start_time TIME,
  end_time TIME, 
  score INT,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (game_id) REFERENCES games(game_id)
);  

INSERT INTO sessions (user_id, game_id, start_time, end_time, score) VALUES
(1, 3, '14:00:00', '15:30:00', 1500),
(2, 5, '16:15:00', '18:00:00', 2300),
(3, 1, '19:00:00', '20:45:00', 1800),
(4, 2, '13:30:00', '15:00:00', 2100),
(5, 4, '17:45:00', '19:30:00', 1950),
(6, 6, '20:10:00', '21:40:00', 2750),
(7, 3, '12:00:00', '13:20:00', 1600),
(8, 7, '14:45:00', '16:30:00', 2900),
(9, 8, '15:30:00', '17:10:00', 1400),
(10, 9, '18:25:00', '19:55:00', 2200),
(1, 2, '10:30:00', '12:00:00', 1800),
(3, 5, '09:45:00', '11:15:00', 2600),
(6, 1, '22:00:00', '23:30:00', 3100),
(4, 4, '11:20:00', '12:50:00', 1750),
(7, 10, '13:10:00', '14:40:00', 2050);

-- Transactions Table 
CREATE TABLE transactions (
  transaction_id INT IDENTITY(1,1) PRIMARY KEY,
  user_id INT, 
  game_id INT,
  amount INT, 
  currency VARCHAR(3),
  transaction_date DATE,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (game_id) REFERENCES games(game_id)
);
 
INSERT INTO transactions (user_id, game_id, amount, currency, transaction_date) VALUES
(1, 3, 1, 'USD', '2024-02-05'),
(2, 5, 2, 'EUR', '2024-01-20'),
(3, 1, 1, 'GBP', '2024-02-10'),
(4, 2, 1, 'USD', '2024-01-15'),
(5, 4, 3, 'CAD', '2024-02-01'),
(6, 6, 2, 'USD', '2024-01-25'),
(7, 3, 1, 'EUR', '2024-02-03'),
(8, 7, 1, 'GBP', '2024-01-30'),
(9, 8, 2, 'USD', '2024-02-08'),
(10, 9, 1, 'CAD', '2024-01-18'),
(1, 2, 3, 'USD', '2024-01-28'),
(3, 5, 2, 'EUR', '2024-02-06'),
(6, 1, 1, 'GBP', '2024-01-22'),
(4, 4, 1, 'USD', '2024-02-04'),
(7, 10, 2, 'EUR', '2024-01-31'),
(2, 7, 1, 'USD', '2024-02-07'),
(9, 3, 3, 'CAD', '2024-01-29'),
(5, 8, 2, 'EUR', '2024-02-02'),
(8, 6, 1, 'GBP', '2024-01-27'),
(10, 9, 1, 'USD', '2024-02-09');

-- Achievements Table 
create TABLE achievements (
  achievement_id INT IDENTITY(1,1) PRIMARY KEY,
  user_id INT, 
  game_id INT,
  achievement_name VARCHAR(50),
  achievement_date DATE,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (game_id) REFERENCES games(game_id)
);

INSERT INTO achievements (user_id, game_id, achievement_name, achievement_date) VALUES
(1, 3, 'First Blood', '2024-02-05'),
(2, 5, 'Sharpshooter', '2024-01-20'),
(3, 1, 'Speed Runner', '2024-02-10'),
(4, 2, 'Survivor', '2024-01-15'),
(5, 4, 'Treasure Hunter', '2024-02-01'),
(6, 6, 'Master Strategist', '2024-01-25'),
(7, 3, 'Hidden Gem', '2024-02-03'),
(8, 7, 'Unstoppable', '2024-01-30'),
(9, 8, 'Elite Player', '2024-02-08'),
(10, 9, 'Conqueror', '2024-01-18'),
(1, 2, 'MVP', '2024-01-28'),
(3, 5, 'Legendary', '2024-02-06'),
(6, 1, 'Invincible', '2024-01-22'),
(4, 4, 'Puzzle Master', '2024-02-04'),
(7, 10, 'Rookie of the Year', '2024-01-31'),
(2, 7, 'Ghost Mode', '2024-02-07'),
(9, 3, 'Dark Horse', '2024-01-29'),
(5, 8, 'Speed Demon', '2024-02-02'),
(8, 6, 'Tactician', '2024-01-27'),
(10, 9, 'Stealth Assassin', '2024-02-09'),
(1, 3, 'Completionist', '2024-02-05'),
(2, 5, 'Arena King', '2024-01-21'),
(3, 1, 'Marathon Runner', '2024-02-11'),
(4, 2, 'Last Survivor', '2024-01-16'),
(5, 4, 'Explorer', '2024-02-02'),
(6, 6, 'God Mode', '2024-01-26'),
(7, 3, 'Speedy Gonzales', '2024-02-04'),
(8, 7, 'Dominant', '2024-01-31'),
(9, 8, 'Champion', '2024-02-09'),
(10, 9, 'Warlord', '2024-01-19');

-- Find the total number of users registered in the last 6 months.
SELECT COUNT(*) AS total_users
FROM users
WHERE registration_date >= DATEADD(MONTH, -6, GETDATE());

-- Retrieve users who have played more than 1 different games.
SELECT s.user_id, u.username, COUNT(DISTINCT s.game_id) AS games_played
FROM sessions s
JOIN users u ON s.user_id = u.user_id
GROUP BY s.user_id, u.username
HAVING COUNT(DISTINCT s.game_id) > 1;

-- Get the top 5 countries with the highest number of registered users.
SELECT country, COUNT(*) AS user_count
FROM users
GROUP BY country
ORDER BY user_count DESC
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;

-- Find the most popular game based on the number of sessions.
SELECT TOP 1 g.game_id, g.game_name, COUNT(s.session_id) AS total_sessions
FROM sessions s
JOIN games g ON s.game_id = g.game_id
GROUP BY g.game_id, g.game_name
ORDER BY total_sessions DESC;

-- List all games released after 2020 in the "Action" genre.
SELECT game_id, game_name, genre, release_date
FROM games
WHERE release_date > '2020-01-01'
AND genre LIKE '%Action%';

-- Get the game with the highest total revenue from transactions.
SELECT TOP 1 g.game_id, g.game_name, SUM(t.amount) AS total_revenue
FROM transactions t
JOIN games g ON t.game_id = g.game_id
GROUP BY g.game_id, g.game_name
ORDER BY total_revenue DESC;

-- Calculate the average session duration per game.
SELECT g.game_id, g.game_name, 
       AVG(DATEDIFF(MINUTE, s.start_time, s.end_time)) AS avg_session_duration_minutes
FROM sessions s
JOIN games g ON s.game_id = g.game_id
GROUP BY g.game_id, g.game_name
ORDER BY avg_session_duration_minutes DESC;

-- Find users who have played the longest session in a single game.
SELECT TOP 1 s.user_id, u.username, s.game_id, g.game_name, 
       DATEDIFF(MINUTE, s.start_time, s.end_time) AS session_duration_minutes
FROM sessions s
JOIN users u ON s.user_id = u.user_id
JOIN games g ON s.game_id = g.game_id
ORDER BY session_duration_minutes DESC;

-- List the top 3 players with the highest total score across all games.
SELECT TOP 3 s.user_id, u.username, SUM(s.score) AS total_score
FROM sessions s
JOIN users u ON s.user_id = u.user_id
GROUP BY s.user_id, u.username
ORDER BY total_score DESC;

-- Find the total revenue generated in the last month.
SELECT SUM(amount) AS total_revenue
FROM transactions
WHERE transaction_date >= DATEADD(MONTH, -1, GETDATE());

-- Identify the users who have spent more than $500 in total.
SELECT t.user_id, u.username, SUM(t.amount) AS total_spent
FROM transactions t
JOIN users u ON t.user_id = u.user_id
GROUP BY t.user_id, u.username
HAVING SUM(t.amount) > 500
ORDER BY total_spent DESC;

-- Get the top 3 games generating the highest revenue.
SELECT TOP 3 t.game_id, g.game_name, SUM(t.amount) AS total_revenue
FROM transactions t
JOIN games g ON t.game_id = g.game_id
GROUP BY t.game_id, g.game_name
ORDER BY total_revenue DESC;

-- Find the most commonly unlocked achievement.
SELECT TOP 1 achievement_name, COUNT(*) AS unlock_count
FROM achievements
GROUP BY achievement_name
ORDER BY unlock_count DESC;

-- Get the total number of achievements earned by each user.
SELECT a.user_id, u.username, COUNT(*) AS total_achievements
FROM achievements a
JOIN users u ON a.user_id = u.user_id
GROUP BY a.user_id, u.username
ORDER BY total_achievements DESC;

-- List players who have earned more than 10 achievements in a single game.
SELECT a.user_id, u.username, a.game_id, g.game_name, COUNT(*) AS achievements_earned
FROM achievements a
JOIN users u ON a.user_id = u.user_id
JOIN games g ON a.game_id = g.game_id
GROUP BY a.user_id, u.username, a.game_id, g.game_name
HAVING COUNT(*) > 10
ORDER BY achievements_earned DESC;
