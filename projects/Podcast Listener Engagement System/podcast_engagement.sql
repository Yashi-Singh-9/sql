-- Project In MariaDB 
-- Create database
CREATE DATABASE podcast_engagement;
USE podcast_engagement;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    registered_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE podcasts (
    podcast_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255),
    description TEXT,
    host_name VARCHAR(100),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE episodes (
    episode_id INT AUTO_INCREMENT PRIMARY KEY,
    podcast_id INT,
    title VARCHAR(255),
    duration_minutes INT,
    release_date DATE,
    FOREIGN KEY (podcast_id) REFERENCES podcasts(podcast_id)
);

CREATE TABLE listens (
    listen_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    episode_id INT,
    listened_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    duration_listened_minutes INT,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (episode_id) REFERENCES episodes(episode_id)
);

CREATE TABLE likes (
    like_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    episode_id INT,
    liked_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (episode_id) REFERENCES episodes(episode_id)
);

CREATE TABLE comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    episode_id INT,
    comment_text TEXT,
    commented_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (episode_id) REFERENCES episodes(episode_id)
);

CREATE TABLE ratings (
    rating_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    episode_id INT,
    rating TINYINT CHECK (rating BETWEEN 1 AND 5),
    rated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (episode_id) REFERENCES episodes(episode_id)
);

-- Users
INSERT INTO users (username, email) VALUES 
('alice123', 'alice@podmail.com'),
('bobster', 'bob@podmail.com'),
('charlievibes', 'charlie@podmail.com');

-- Podcasts
INSERT INTO podcasts (title, description, host_name) VALUES
('TechTalks', 'Deep dives into the tech world.', 'Dr. Geek'),
('Mindful Moments', 'Daily mindfulness and mental health.', 'Sarah Peace');

-- Episodes
INSERT INTO episodes (podcast_id, title, duration_minutes, release_date) VALUES
(1, 'AI in 2025', 45, '2025-04-01'),
(1, 'Blockchain Reality', 50, '2025-04-05'),
(2, 'Morning Calm', 10, '2025-04-02');

-- Listens
INSERT INTO listens (user_id, episode_id, duration_listened_minutes) VALUES
(1, 1, 40),
(2, 1, 45),
(1, 2, 20),
(3, 3, 10);

-- Likes
INSERT INTO likes (user_id, episode_id) VALUES
(1, 1), (2, 1), (3, 3);

-- Comments
INSERT INTO comments (user_id, episode_id, comment_text) VALUES
(1, 1, 'Great insights on AI!'),
(3, 3, 'Very soothing episode.');

-- Ratings
INSERT INTO ratings (user_id, episode_id, rating) VALUES
(1, 1, 5),
(2, 1, 4),
(3, 3, 5);

-- Most Popular Episodes (by listens)
SELECT e.title, COUNT(l.listen_id) AS total_listens
FROM episodes e
JOIN listens l ON e.episode_id = l.episode_id
GROUP BY e.title
ORDER BY total_listens DESC;

-- Average Rating per Episode
SELECT e.title, AVG(r.rating) AS avg_rating
FROM ratings r
JOIN episodes e ON r.episode_id = e.episode_id
GROUP BY e.title;

-- Listener Engagement Summary
SELECT 
    u.username,
    COUNT(l.listen_id) AS listens,
    COUNT(DISTINCT c.comment_id) AS comments,
    COUNT(DISTINCT r.rating_id) AS ratings
FROM users u
LEFT JOIN listens l ON u.user_id = l.user_id
LEFT JOIN comments c ON u.user_id = c.user_id
LEFT JOIN ratings r ON u.user_id = r.user_id
GROUP BY u.username;

-- Top Rated Episodes (Min. 2 Ratings)
SELECT 
    e.title,
    COUNT(r.rating_id) AS num_ratings,
    ROUND(AVG(r.rating), 2) AS avg_rating
FROM ratings r
JOIN episodes e ON r.episode_id = e.episode_id
GROUP BY e.title
HAVING num_ratings >= 2
ORDER BY avg_rating DESC;

-- Most Commented Episodes
SELECT 
    e.title,
    COUNT(c.comment_id) AS total_comments
FROM comments c
JOIN episodes e ON c.episode_id = e.episode_id
GROUP BY e.title
ORDER BY total_comments DESC;

-- Most Engaging Podcasts (Total Listens Across Episodes)
SELECT 
    p.title AS podcast_title,
    COUNT(l.listen_id) AS total_listens
FROM podcasts p
JOIN episodes e ON p.podcast_id = e.podcast_id
JOIN listens l ON e.episode_id = l.episode_id
GROUP BY p.title
ORDER BY total_listens DESC;

-- Average Listening Time Per Episode
SELECT 
    e.title,
    AVG(l.duration_listened_minutes) AS avg_listen_time
FROM listens l
JOIN episodes e ON l.episode_id = e.episode_id
GROUP BY e.title
ORDER BY avg_listen_time DESC;

-- Top Active Users (Based on Likes, Comments, Ratings)
SELECT 
    u.username,
    COUNT(DISTINCT l.like_id) AS likes,
    COUNT(DISTINCT c.comment_id) AS comments,
    COUNT(DISTINCT r.rating_id) AS ratings,
    (COUNT(DISTINCT l.like_id) + COUNT(DISTINCT c.comment_id) + COUNT(DISTINCT r.rating_id)) AS engagement_score
FROM users u
LEFT JOIN likes l ON u.user_id = l.user_id
LEFT JOIN comments c ON u.user_id = c.user_id
LEFT JOIN ratings r ON u.user_id = r.user_id
GROUP BY u.username
ORDER BY engagement_score DESC;

-- Daily Listen Trends
SELECT 
    DATE(listened_at) AS listen_date,
    COUNT(*) AS total_listens
FROM listens
GROUP BY listen_date
ORDER BY listen_date;

-- Podcast Hosts and Their Total Episode Count
SELECT 
    host_name,
    COUNT(e.episode_id) AS total_episodes
FROM podcasts p
JOIN episodes e ON p.podcast_id = e.podcast_id
GROUP BY host_name
ORDER BY total_episodes DESC;

-- Episode Completion Rate (%)
SELECT 
    e.title,
    ROUND(AVG(l.duration_listened_minutes / e.duration_minutes) * 100, 2) AS avg_completion_rate
FROM episodes e
JOIN listens l ON e.episode_id = l.episode_id
GROUP BY e.title
ORDER BY avg_completion_rate DESC;

-- User Listening History (Per User)
SELECT 
    u.username,
    e.title AS episode_title,
    l.listened_at,
    l.duration_listened_minutes
FROM listens l
JOIN users u ON l.user_id = u.user_id
JOIN episodes e ON l.episode_id = e.episode_id
ORDER BY u.username, l.listened_at DESC;

-- Recently Released Episodes
SELECT 
    e.title,
    p.title AS podcast,
    e.release_date
FROM episodes e
JOIN podcasts p ON e.podcast_id = p.podcast_id
WHERE e.release_date >= CURDATE() - INTERVAL 7 DAY
ORDER BY e.release_date DESC;
