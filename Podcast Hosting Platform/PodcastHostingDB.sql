-- MS SQL Project
CREATE DATABASE PodcastHostingDB;
USE PodcastHostingDB;

-- Users Table
CREATE TABLE users (
  user_id INT IDENTITY(1,1) PRIMARY KEY,
  username VARCHAR(50) UNIQUE,
  email VARCHAR(50) UNIQUE,
  password TEXT,
  created_at DATETIME
);

-- Podcasts Table
CREATE TABLE podcasts (
  podcast_id INT IDENTITY(1,1) PRIMARY KEY,
  title VARCHAR(50),
  description TEXT,
  host_ids INT,
  created_at DATETIME,
  FOREIGN KEY (host_ids) REFERENCES users(user_id)
);

-- Episodes Table
CREATE TABLE episodes (
  episode_id INT IDENTITY(1,1) PRIMARY KEY,
  podcast_id INT,
  title VARCHAR(50),
  description TEXT,
  audio_url VARCHAR(50),
  release_date DATE,
  FOREIGN KEY (podcast_id) REFERENCES podcasts(podcast_id)
);

-- Listeners Table
CREATE TABLE listeners (
  listener_id INT IDENTITY(1,1) PRIMARY KEY,
  user_id INT,
  subscription_date DATETIME,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Subscriptions Table
CREATE TABLE subscriptions (
  subscription_id INT IDENTITY(1,1) PRIMARY KEY,
  user_id INT,
  podcast_id INT,
  subscribed_at DATETIME,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (podcast_id) REFERENCES podcasts(podcast_id)
);

-- Reviews Table
CREATE TABLE reviews (
  review_id INT IDENTITY(1,1) PRIMARY KEY,
  user_id INT,
  podcast_id INT,
  rating INT CHECK (rating BETWEEN 1 AND 5),
  review_text TEXT,
  created_at DATETIME,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (podcast_id) REFERENCES podcasts(podcast_id)
);

-- Insert Users
INSERT INTO users (username, email, password, created_at) VALUES
('john_doe', 'john@example.com', 'hashed_password1', '2024-02-16 10:00:00'),
('jane_smith', 'jane@example.com', 'hashed_password2', '2024-02-16 11:00:00'),
('alex_johnson', 'alex@example.com', 'hashed_password3', '2024-02-16 12:00:00'),
('mary_williams', 'mary@example.com', 'hashed_password4', '2024-02-16 13:00:00'),
('chris_evans', 'chris@example.com', 'hashed_password5', '2024-02-16 14:00:00'),
('emily_davis', 'emily@example.com', 'hashed_password6', '2024-02-16 15:00:00'),
('david_clark', 'david@example.com', 'hashed_password7', '2024-02-16 16:00:00'),
('sophia_miller', 'sophia@example.com', 'hashed_password8', '2024-02-16 17:00:00');

-- Insert Podcasts
INSERT INTO podcasts (title, description, host_ids, created_at) VALUES
('Tech Talk', 'A podcast about the latest in tech.', 1, '2024-02-16 10:30:00'),
('Health & Wellness', 'Tips for a healthier life.', 2, '2024-02-16 11:30:00'),
('History Uncovered', 'Deep dives into historical events.', 3, '2024-02-16 12:30:00'),
('Finance Explained', 'Breaking down financial concepts.', 4, '2024-02-16 13:30:00'),
('Space & Beyond', 'Exploring the mysteries of space.', 5, '2024-02-16 14:30:00'),
('Music Masters', 'Discussions with top musicians.', 6, '2024-02-16 15:30:00'),
('Gaming Universe', 'Everything about video games.', 7, '2024-02-16 16:30:00'),
('True Crime Daily', 'True crime stories and analysis.', 8, '2024-02-16 17:30:00');

-- Insert Episodes
INSERT INTO episodes (podcast_id, title, description, audio_url, release_date) VALUES
(1, 'AI Revolution', 'Discussing the rise of AI.', 'ai_episode1.mp3', '2024-02-17'),
(2, 'Healthy Eating', 'Benefits of a balanced diet.', 'health_episode1.mp3', '2024-02-18'),
(3, 'World War II', 'Uncovering hidden WWII facts.', 'history_episode1.mp3', '2024-02-19'),
(4, 'Stock Market Basics', 'Intro to investing.', 'finance_episode1.mp3', '2024-02-20'),
(5, 'Black Holes', 'Exploring the unknown.', 'space_episode1.mp3', '2024-02-21'),
(6, 'Rock Music Evolution', 'How rock music changed.', 'music_episode1.mp3', '2024-02-22'),
(7, 'Esports Growth', 'The rise of competitive gaming.', 'gaming_episode1.mp3', '2024-02-23'),
(8, 'Famous Crime Cases', 'Investigating famous cases.', 'crime_episode1.mp3', '2024-02-24');

-- Insert Listeners
INSERT INTO listeners (user_id, subscription_date) VALUES
(1, '2024-02-16 10:00:00'),
(2, '2024-02-16 11:00:00'),
(3, '2024-02-16 12:00:00'),
(4, '2024-02-16 13:00:00'),
(5, '2024-02-16 14:00:00'),
(6, '2024-02-16 15:00:00'),
(7, '2024-02-16 16:00:00'),
(8, '2024-02-16 17:00:00');

-- Insert Subscriptions
INSERT INTO subscriptions (user_id, podcast_id, subscribed_at) VALUES
(1, 1, '2024-02-17 09:00:00'),
(2, 2, '2024-02-18 09:00:00'),
(3, 3, '2024-02-19 09:00:00'),
(4, 4, '2024-02-20 09:00:00'),
(5, 5, '2024-02-21 09:00:00'),
(6, 6, '2024-02-22 09:00:00'),
(7, 7, '2024-02-23 09:00:00'),
(8, 8, '2024-02-24 09:00:00');

-- Insert Reviews
INSERT INTO reviews (user_id, podcast_id, rating, review_text, created_at) VALUES
(1, 1, 5, 'Amazing insights on tech!', '2024-02-17 10:00:00'),
(2, 2, 4, 'Great tips for a healthy lifestyle.', '2024-02-18 11:00:00'),
(3, 3, 5, 'Very informative history podcast.', '2024-02-19 12:00:00'),
(4, 4, 3, 'Decent finance content.', '2024-02-20 13:00:00'),
(5, 5, 5, 'Loved the discussion on space.', '2024-02-21 14:00:00'),
(6, 6, 4, 'Cool music interviews!', '2024-02-22 15:00:00'),
(7, 7, 5, 'Best gaming podcast ever!', '2024-02-23 16:00:00'),
(8, 8, 4, 'Fascinating true crime stories.', '2024-02-24 17:00:00');

-- Retrieve all podcasts hosted by a specific user.
SELECT * 
FROM podcasts 
WHERE host_ids = 1;

-- Find the top 5 most subscribed podcasts.
SELECT TOP 5 p.podcast_id, p.title, COUNT(s.subscription_id) AS subscription_count
FROM podcasts p
JOIN subscriptions s ON p.podcast_id = s.podcast_id
GROUP BY p.podcast_id, p.title
ORDER BY subscription_count DESC;

-- Get all episodes of a specific podcast, sorted by release date.
SELECT * 
FROM episodes 
WHERE podcast_id = 2
ORDER BY release_date ASC;

-- Find users who have subscribed to more than 5 podcasts.
SELECT user_id, COUNT(podcast_id) AS subscription_count
FROM subscriptions
GROUP BY user_id
HAVING COUNT(podcast_id) > 5;

-- Retrieve the average rating of each podcast.
SELECT podcast_id, AVG(rating) AS avg_rating
FROM reviews
GROUP BY podcast_id;

-- List the listeners who have written at least one review.
SELECT DISTINCT l.listener_id, l.user_id
FROM listeners l
JOIN reviews r ON l.user_id = r.user_id;

-- Find podcasts with no reviews.
SELECT p.podcast_id, p.title
FROM podcasts p
LEFT JOIN reviews r ON p.podcast_id = r.podcast_id
WHERE r.review_id IS NULL;

-- Get the latest episode from each podcast.
SELECT e.*
FROM episodes e
JOIN (
    SELECT podcast_id, MAX(release_date) AS latest_release
    FROM episodes
    GROUP BY podcast_id
) latest ON e.podcast_id = latest.podcast_id AND e.release_date = latest.latest_release;

-- Find users who have never subscribed to any podcast.
SELECT u.user_id, u.username
FROM users u
LEFT JOIN subscriptions s ON u.user_id = s.user_id
WHERE s.subscription_id IS NULL;

-- Retrieve the most active listeners based on the number of subscriptions.
SELECT TOP 5 user_id, COUNT(subscription_id) AS total_subscriptions
FROM subscriptions
GROUP BY user_id
ORDER BY total_subscriptions DESC;
