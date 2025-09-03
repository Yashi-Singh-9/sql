-- MS SQL Project 
CREATE DATABASE SocialMediaTrendsDB;
USE SocialMediaTrendsDB;

-- Users Table 
CREATE TABLE users (
  user_id INT IDENTITY(1,1) PRIMARY KEY,
  username VARCHAR(50) UNIQUE,
  email VARCHAR(50) UNIQUE,
  created_at DATE,
  location VARCHAR(50)
);

-- Posts Table  
CREATE TABLE posts (
  post_id INT IDENTITY(1,1) PRIMARY KEY,
  user_id INT,
  content TEXT,
  created_at DATETIME,
  likes_count INT,
  shares_count INT,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Hashtags Table  
CREATE TABLE hashtags (
  hashtag_id INT IDENTITY(1,1) PRIMARY KEY,
  hashtag_name VARCHAR(50) UNIQUE
);

-- Post Hashtags Table 
CREATE TABLE post_hashtags (
  post_id INT,
  FOREIGN KEY (post_id) REFERENCES posts(post_id),
  hashtag_id INT,
  FOREIGN KEY (hashtag_id) REFERENCES hashtags(hashtag_id)
);

-- Trends Table 
CREATE TABLE trends (
  trend_id INT IDENTITY(1,1) PRIMARY KEY,
  hashtag_id INT,
  FOREIGN KEY (hashtag_id) REFERENCES hashtags(hashtag_id),
  start_date DATE,
  end_date DATE,
  total_mentions INT 
);

-- Engagements Table 
CREATE TABLE engagements (
  engagement_id INT IDENTITY(1,1) PRIMARY KEY,
  post_id INT,
  FOREIGN KEY (post_id) REFERENCES posts(post_id),
  user_id INT,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  engagement_type VARCHAR(7) CHECK (engagement_type IN ('Like', 'Share', 'Comment')),
  engaged_at DATE
);  

-- Insert Users 
INSERT INTO users (username, email, created_at, location) VALUES 
('john_doe', 'john@example.com', '2024-02-01', 'New York'),
('jane_smith', 'jane@example.com', '2024-02-02', 'Los Angeles'),
('mike_jordan', 'mike@example.com', '2024-02-03', 'Chicago'),
('lisa_ray', 'lisa@example.com', '2024-02-04', 'Houston'),
('david_clark', 'david@example.com', '2024-02-05', 'Miami'),
('emma_watson', 'emma@example.com', '2024-02-06', 'Seattle'),
('ryan_gosling', 'ryan@example.com', '2024-02-07', 'San Francisco'),
('sophia_turner', 'sophia@example.com', '2024-02-08', 'Boston');

-- Insert Posts 
INSERT INTO posts (user_id, content, created_at, likes_count, shares_count) VALUES 
(1, 'Loving the new AI updates!', '2024-02-10 10:00:00', 50, 10),
(2, 'Sunsets in LA are amazing! #BeautifulSunset', '2024-02-11 18:30:00', 80, 20),
(3, 'Big game tonight! Who are you supporting? #SportsFan', '2024-02-12 19:45:00', 60, 15),
(4, 'New blog post about productivity hacks. #WorkSmart', '2024-02-13 08:15:00', 45, 12),
(5, 'Excited for the weekend getaway! #TravelTime', '2024-02-14 12:00:00', 70, 18),
(6, 'Coffee and coding - best combo! #DeveloperLife', '2024-02-15 09:30:00', 55, 14),
(7, 'Let’s spread positivity today! #GoodVibesOnly', '2024-02-16 11:00:00', 90, 30),
(8, 'Reading a great book. Any recommendations? #BookLover', '2024-02-17 20:45:00', 65, 22);

-- Insert Hashtags 
INSERT INTO hashtags (hashtag_name) VALUES 
('#BeautifulSunset'),
('#SportsFan'),
('#WorkSmart'),
('#TravelTime'),
('#DeveloperLife'),
('#GoodVibesOnly'),
('#BookLover'),
('#TrendingNow');

-- Insert Post Hashtags 
INSERT INTO post_hashtags (post_id, hashtag_id) VALUES 
(2, 1), 
(3, 2), 
(4, 3),
(5, 4), 
(6, 5), 
(7, 6), 
(8, 7), 
(1, 8); 

-- Insert Trends 
INSERT INTO trends (hashtag_id, start_date, end_date, total_mentions) VALUES 
(1, '2024-02-10', '2024-02-12', 200),
(2, '2024-02-11', '2024-02-13', 180),
(3, '2024-02-12', '2024-02-14', 150),
(4, '2024-02-13', '2024-02-15', 170),
(5, '2024-02-14', '2024-02-16', 190),
(6, '2024-02-15', '2024-02-17', 220),
(7, '2024-02-16', '2024-02-18', 160),
(8, '2024-02-17', '2024-02-19', 250);

-- Insert Engagements 
INSERT INTO engagements (post_id, user_id, engagement_type, engaged_at) VALUES 
(1, 2, 'Like', '2024-02-10'),
(2, 3, 'Share', '2024-02-11'),
(3, 4, 'Comment', '2024-02-12'),
(4, 5, 'Like', '2024-02-13'),
(5, 6, 'Share', '2024-02-14'),
(6, 7, 'Comment', '2024-02-15'),
(7, 8, 'Like', '2024-02-16'),
(8, 1, 'Share', '2024-02-17');

-- Find the top 5 trending hashtags based on the number of mentions in posts.
SELECT TOP 5 h.hashtag_name, COUNT(ph.post_id) AS total_mentions
FROM hashtags h
JOIN post_hashtags ph ON h.hashtag_id = ph.hashtag_id
GROUP BY h.hashtag_name
ORDER BY total_mentions DESC;

-- Retrieve the total number of posts made by each user, ordered by the highest number.
SELECT u.username, COUNT(p.post_id) AS total_posts
FROM users u
LEFT JOIN posts p ON u.user_id = p.user_id
GROUP BY u.username
ORDER BY total_posts DESC;

-- Identify the users who have engaged (liked/shared/commented) with the most posts.
SELECT u.username, COUNT(e.engagement_id) AS total_engagements
FROM users u
JOIN engagements e ON u.user_id = e.user_id
GROUP BY u.username
ORDER BY total_engagements DESC;

-- Retrieve the posts that contain a specific hashtag (e.g., #AI).
SELECT p.post_id, p.content, p.created_at
FROM posts p
JOIN post_hashtags ph ON p.post_id = ph.post_id
JOIN hashtags h ON ph.hashtag_id = h.hashtag_id
WHERE h.hashtag_name = '#TravelTime';

-- Get a list of users who have not posted anything in the last 30 days.
SELECT u.username
FROM users u
LEFT JOIN posts p ON u.user_id = p.user_id 
      AND p.created_at >= DATEADD(DAY, -30, GETDATE())
WHERE p.post_id IS NULL;

-- Find the trend that lasted the longest in the database.
SELECT TOP 1 h.hashtag_name, t.start_date, t.end_date, DATEDIFF(DAY, t.start_date, t.end_date) AS duration_days
FROM trends t
JOIN hashtags h ON t.hashtag_id = h.hashtag_id
ORDER BY duration_days DESC;

-- Retrieve the top 5 locations with the highest number of active users.
SELECT TOP 5 u.location, COUNT(DISTINCT u.user_id) AS active_users
FROM users u
JOIN posts p ON u.user_id = p.user_id
GROUP BY u.location
ORDER BY active_users DESC;

-- Get the average number of likes per post for each user.
SELECT u.username, AVG(p.likes_count) AS avg_likes_per_post
FROM users u
JOIN posts p ON u.user_id = p.user_id
GROUP BY u.username
ORDER BY avg_likes_per_post DESC;

-- Identify hashtags that have appeared in at least 1000 posts.
SELECT h.hashtag_name, COUNT(ph.post_id) AS total_posts
FROM hashtags h
JOIN post_hashtags ph ON h.hashtag_id = ph.hashtag_id
GROUP BY h.hashtag_name
HAVING COUNT(ph.post_id) >= 1;

-- Retrieve the most engaged user based on total engagements (likes, comments, shares).
SELECT TOP 1 u.username, COUNT(e.engagement_id) AS total_engagements
FROM users u
JOIN engagements e ON u.user_id = e.user_id
GROUP BY u.username
ORDER BY total_engagements DESC;

-- Find the top 3 users who received the most likes on their posts.
SELECT TOP 3 u.username, SUM(p.likes_count) AS total_likes
FROM users u
JOIN posts p ON u.user_id = p.user_id
GROUP BY u.username
ORDER BY total_likes DESC;

-- Get the percentage of engagement type (likes, shares, comments) across all engagements.
SELECT engagement_type, 
       COUNT(*) AS total_engagements, 
       (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM engagements)) AS percentage
FROM engagements
GROUP BY engagement_type;

-- Find the users who engaged the most with a specific user’s posts (e.g., 'john_doe').
SELECT e.user_id, u.username, COUNT(e.engagement_id) AS total_engagements
FROM engagements e
JOIN posts p ON e.post_id = p.post_id
JOIN users u ON e.user_id = u.user_id
WHERE p.user_id = (SELECT user_id FROM users WHERE username = 'john_doe')
GROUP BY e.user_id, u.username
ORDER BY total_engagements DESC;

-- Retrieve the percentage of posts that contain at least one hashtag
SELECT 
    (SELECT COUNT(DISTINCT post_id) FROM post_hashtags) * 100.0 / COUNT(*) AS percentage_with_hashtag
FROM posts;

-- Find the user who posted the most unique hashtags.
SELECT TOP 1 u.username, COUNT(DISTINCT ph.hashtag_id) AS unique_hashtags_used
FROM users u
JOIN posts p ON u.user_id = p.user_id
JOIN post_hashtags ph ON p.post_id = ph.post_id
GROUP BY u.username
ORDER BY unique_hashtags_used DESC;