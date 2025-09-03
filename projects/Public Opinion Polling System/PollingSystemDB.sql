-- Project in PostgreSQL 
-- Create Database
CREATE DATABASE PollingSystemDB;
-- Switch to the new database
\c PollingSystemDB;

-- Users Table
CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Polls Table
CREATE TABLE Polls (
    poll_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    created_by INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(20) CHECK (status IN ('Active', 'Closed')),
    FOREIGN KEY (created_by) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Options Table
CREATE TABLE Options (
    option_id SERIAL PRIMARY KEY,
    poll_id INT NOT NULL,
    option_text VARCHAR(255) NOT NULL,
    FOREIGN KEY (poll_id) REFERENCES Polls(poll_id) ON DELETE CASCADE
);

-- Votes Table
CREATE TABLE Votes (
    vote_id SERIAL PRIMARY KEY,
    poll_id INT NOT NULL,
    option_id INT NOT NULL,
    user_id INT NOT NULL,
    voted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (poll_id) REFERENCES Polls(poll_id) ON DELETE CASCADE,
    FOREIGN KEY (option_id) REFERENCES Options(option_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Results Table
CREATE TABLE Results (
    result_id SERIAL PRIMARY KEY,
    poll_id INT NOT NULL,
    option_id INT NOT NULL,
    vote_count INT DEFAULT 0,
    FOREIGN KEY (poll_id) REFERENCES Polls(poll_id) ON DELETE CASCADE,
    FOREIGN KEY (option_id) REFERENCES Options(option_id) ON DELETE CASCADE
);

-- Insert Users
INSERT INTO Users (name, email, password) VALUES
('Alice Johnson', 'alice@example.com', 'password123'),
('Bob Smith', 'bob@example.com', 'securepass'),
('Charlie Brown', 'charlie@example.com', 'pass123'),
('David Wilson', 'david@example.com', 'davidpass'),
('Emma Thomas', 'emma@example.com', 'emma123');

-- Insert Polls
INSERT INTO Polls (title, description, created_by, start_date, end_date, status) VALUES
('Favorite Programming Language', 'Vote for your favorite language', 1, '2025-03-01', '2025-03-10', 'Active'),
('Best Movie of 2024', 'Choose the best movie released in 2024', 2, '2025-03-01', '2025-03-15', 'Active'),
('Preferred Social Media Platform', 'Vote for your preferred platform', 3, '2025-03-01', '2025-03-12', 'Active'),
('Best Car Brand', 'Pick your favorite car brand', 4, '2025-03-01', '2025-03-20', 'Active'),
('Favorite Music Genre', 'Which music genre do you prefer?', 5, '2025-03-01', '2025-03-25', 'Active');

-- Insert Options
INSERT INTO Options (poll_id, option_text) VALUES
(1, 'Python'), (1, 'JavaScript'), (1, 'Java'), (1, 'C++'), (1, 'Ruby'),
(2, 'Movie A'), (2, 'Movie B'), (2, 'Movie C'), (2, 'Movie D'), (2, 'Movie E'),
(3, 'Facebook'), (3, 'Instagram'), (3, 'Twitter'), (3, 'TikTok'), (3, 'LinkedIn'),
(4, 'Tesla'), (4, 'Ford'), (4, 'BMW'), (4, 'Audi'), (4, 'Mercedes'),
(5, 'Pop'), (5, 'Rock'), (5, 'Jazz'), (5, 'Hip-Hop'), (5, 'Classical');

-- Insert Votes
INSERT INTO Votes (poll_id, option_id, user_id) VALUES
(1, 1, 2), (1, 3, 3), (2, 6, 1), (3, 11, 4), (4, 16, 5);

-- Insert Results (Initial Vote Count)
INSERT INTO Results (poll_id, option_id, vote_count) VALUES
(1, 1, 1), (1, 3, 1), (2, 6, 1), (3, 11, 1), (4, 16, 1);

-- Retrieve all active polls
SELECT * 
FROM Polls 
WHERE status = 'Active';

-- Find total votes for a specific poll
SELECT poll_id, COUNT(*) AS total_votes
FROM Votes
WHERE poll_id = 1
GROUP BY poll_id;

-- Check if a user has already voted in a poll
SELECT COUNT(*) 
FROM Votes 
WHERE user_id = 2 AND poll_id = 1;

-- List all polls created by a specific user
SELECT * 
FROM Polls 
WHERE created_by = 1;

-- Show poll results ordered by highest votes
SELECT Results.poll_id, Options.option_text, Results.vote_count
FROM Results
JOIN Options ON Results.option_id = Options.option_id
ORDER BY Results.vote_count DESC;

-- Count total number of polls created in the last month
SELECT COUNT(*) 
FROM Polls 
WHERE start_date >= NOW() - INTERVAL '1 month';

-- Get details of the poll that received the highest votes overall
SELECT Polls.poll_id, Polls.title, SUM(Results.vote_count) AS total_votes
FROM Results
JOIN Polls ON Results.poll_id = Polls.poll_id
GROUP BY Polls.poll_id, Polls.title
ORDER BY total_votes DESC
LIMIT 1;

-- Identify polls that have no votes yet
SELECT Polls.poll_id, Polls.title
FROM Polls
LEFT JOIN Votes ON Polls.poll_id = Votes.poll_id
WHERE Votes.poll_id IS NULL;

-- Retrieve all polls along with the number of votes they have received
SELECT Polls.poll_id, Polls.title, COUNT(Votes.vote_id) AS total_votes
FROM Polls
LEFT JOIN Votes ON Polls.poll_id = Votes.poll_id
GROUP BY Polls.poll_id, Polls.title
ORDER BY total_votes DESC;

-- Find the percentage of votes each option received in a poll
WITH total AS (
    SELECT COUNT(*) AS total_votes
    FROM Votes
    WHERE poll_id = 1
)
SELECT Options.option_text, COUNT(Votes.vote_id) AS vote_count,
       (COUNT(Votes.vote_id) * 100.0 / total.total_votes) AS percentage
FROM Options
LEFT JOIN Votes ON Options.option_id = Votes.option_id
JOIN total ON TRUE
WHERE Options.poll_id = 1
GROUP BY Options.option_text, total.total_votes
ORDER BY vote_count DESC;

-- Get the most active users (who voted the most times)
SELECT Users.user_id, Users.name, COUNT(Votes.vote_id) AS total_votes
FROM Users
JOIN Votes ON Users.user_id = Votes.user_id
GROUP BY Users.user_id, Users.name
ORDER BY total_votes DESC
LIMIT 5;

-- Retrieve the latest 3 polls that have received votes
SELECT DISTINCT Polls.poll_id, Polls.title, Polls.start_date
FROM Polls
JOIN Votes ON Polls.poll_id = Votes.poll_id
ORDER BY Polls.start_date DESC
LIMIT 3;

-- Find the number of votes each user has cast in different polls
SELECT Users.name, Polls.title, COUNT(Votes.vote_id) AS votes_cast
FROM Users
JOIN Votes ON Users.user_id = Votes.user_id
JOIN Polls ON Votes.poll_id = Polls.poll_id
GROUP BY Users.name, Polls.title
ORDER BY Users.name, votes_cast DESC;

-- Find the poll with the highest number of unique voters
SELECT Polls.poll_id, Polls.title, COUNT(DISTINCT Votes.user_id) AS unique_voters
FROM Polls
JOIN Votes ON Polls.poll_id = Votes.poll_id
GROUP BY Polls.poll_id, Polls.title
ORDER BY unique_voters DESC
LIMIT 1;

-- Retrieve all polls along with the winning option (most votes per poll)
SELECT Polls.poll_id, Polls.title, Options.option_text AS winning_option, MAX(Results.vote_count) AS max_votes
FROM Polls
JOIN Results ON Polls.poll_id = Results.poll_id
JOIN Options ON Results.option_id = Options.option_id
GROUP BY Polls.poll_id, Polls.title, Options.option_text
ORDER BY max_votes DESC;

-- Count how many users voted for each option in a specific poll
SELECT Options.option_text, COUNT(Votes.vote_id) AS total_votes
FROM Options
LEFT JOIN Votes ON Options.option_id = Votes.option_id
WHERE Options.poll_id = 1
GROUP BY Options.option_text
ORDER BY total_votes DESC;

-- List users who voted for a specific option in a poll
SELECT Users.name, Users.email
FROM Users
JOIN Votes ON Users.user_id = Votes.user_id
WHERE Votes.option_id = 1;

-- Find the earliest and latest vote times for each poll
SELECT poll_id, MIN(voted_at) AS first_vote, MAX(voted_at) AS last_vote
FROM Votes
GROUP BY poll_id;