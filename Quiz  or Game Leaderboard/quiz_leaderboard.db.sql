CREATE DATABASE quiz_leaderboard 

-- Users Table 
CREATE TABLE users (
  user_id INT IDENTITY(1,1) PRIMARY KEY,
  username VARCHAR(20) UNIQUE,
  email VARCHAR(20) UNIQUE,
  created_at TIMESTAMP
);

-- Games Table 
CREATE TABLE games (
  game_id INT IDENTITY(1,1) PRIMARY KEY,
  game_name VARCHAR(20),
  created_at TIMESTAMP
);

-- Questions Table 
CREATE TABLE questions (
  question_id INT IDENTITY(1,1) PRIMARY KEY,
  game_id INT,
  question_text text,
  correct_answer VARCHAR(20),
  FOREIGN KEY (game_id) REFERENCES games(game_id)
);  

-- Users Answer 
CREATE TABLE users_answer (
  answer_id INT IDENTITY(1,1) PRIMARY KEY,
  user_id INT,
  question_id INT,
  selected_answer VARCHAR(20),
  is_correct BIT,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (question_id) REFERENCES questions(question_id)
);

-- Scores Table 
CREATE TABLE scores (
  score_id INT IDENTITY(1,1) PRIMARY KEY,
  user_id INT,
  game_id INT,
  score INT,
  played_at TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (game_id) REFERENCES games(game_id)
);

-- Leaderboard Table
CREATE TABLE leaderboard (
  leaderboard_id INT IDENTITY(1,1) PRIMARY KEY,
  user_id INT,
  game_id INT,
  rank_position INT,
  total_score INT,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (game_id) REFERENCES games(game_id)
);  

-- Insert sample users
INSERT INTO users (username, email, created_at) VALUES
('john_doe', 'john@example.com', DEFAULT),
('jane_smith', 'jane@example.com', DEFAULT),
('mike_jones', 'mike@example.com', DEFAULT);

-- Insert sample games
INSERT INTO games (game_name, created_at) VALUES
('General Knowledge', DEFAULT),
('Science Quiz', DEFAULT),
('History Challenge', DEFAULT);

-- Insert sample questions
INSERT INTO questions (game_id, question_text, correct_answer) VALUES
(1, 'What is the capital of France?', 'Paris'),
(1, 'What is 2 + 2?', '4'),
(2, 'What planet is known as the Red Planet?', 'Mars'),
(2, 'What is the chemical symbol for water?', 'H2O'),
(3, 'Who was the first president of the United States?', 'George Washington'),
(3, 'What year did World War II end?', '1945');

-- Insert sample user answers
INSERT INTO users_answer (user_id, question_id, selected_answer, is_correct) VALUES
(1, 1, 'Paris', 1),
(1, 2, '4', 1),
(2, 3, 'Mars', 1),
(2, 4, 'H2O', 1),
(3, 5, 'Abraham Lincoln', 0),
(3, 6, '1945', 1);

-- Insert sample scores
INSERT INTO scores (user_id, game_id, score, played_at) VALUES
(1, 1, 10, DEFAULT),
(2, 2, 8, DEFAULT),
(3, 3, 5, DEFAULT);

-- Insert sample leaderboard rankings
INSERT INTO leaderboard (user_id, game_id, rank_position, total_score) VALUES
(1, 1, 1, 10),
(2, 2, 1, 8),
(3, 3, 1, 5);

-- Find the top 2 players for a specific game based on scores.
SELECT TOP 2 u.user_id, u.username, s.score
FROM scores s
JOIN users u ON s.user_id = u.user_id
WHERE s.game_id = 2 
ORDER BY s.score DESC;

-- Retrieve the total number of games played by each user.
SELECT u.user_id, u.username, COUNT(s.game_id) AS total_games_played
FROM users u
LEFT JOIN scores s ON u.user_id = s.user_id
GROUP BY u.user_id, u.username;

-- Get the highest score achieved by each user.
SELECT u.user_id, u.username, MAX(s.score) AS highest_score
FROM users u
LEFT JOIN scores s ON u.user_id = s.user_id
GROUP BY u.user_id, u.username;

-- List users who have never played a game.
SELECT u.user_id, u.username
FROM users u
LEFT JOIN scores s ON u.user_id = s.user_id
WHERE s.user_id IS NULL;

-- Show the average score for each game.
SELECT g.game_id, g.game_name, AVG(s.score) AS avg_score
FROM games g
LEFT JOIN scores s ON g.game_id = s.game_id
GROUP BY g.game_id, g.game_name;

-- Find the last played game for a specific user.
SELECT TOP 1 g.game_id, g.game_name, s.played_at
FROM scores s
JOIN games g ON s.game_id = g.game_id
WHERE s.user_id = 3  
ORDER BY s.played_at DESC;

-- Rank users based on their total scores across all games.
SELECT u.user_id, u.username, SUM(s.score) AS total_score,
       RANK() OVER (ORDER BY SUM(s.score) DESC) AS rank_position
FROM users u
JOIN scores s ON u.user_id = s.user_id
GROUP BY u.user_id, u.username
ORDER BY total_score DESC;

-- Identify the game with the highest number of participants.
SELECT TOP 1 g.game_id, g.game_name, COUNT(DISTINCT s.user_id) AS participant_count
FROM games g
JOIN scores s ON g.game_id = s.game_id
GROUP BY g.game_id, g.game_name
ORDER BY participant_count DESC;