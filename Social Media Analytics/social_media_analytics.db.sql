sqlite3 social_media_analytics.db

-- Users Table
CREATE TABLE users (
  user_id INTEGER PRIMARY KEY,
  username VARCHAR,
  email VARCHAR,
  created_at TIMESTAMP
);

-- Posts Table 
CREATE TABLE posts (
  post_id INTEGER PRIMARY KEy,
  user_id INTEGER,
  content VARCHAR,
  created_at TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);  

-- Likes Table 
CREate TABLE likes(
  like_id INTEGER PRIMARY KEY,
  user_id INTEGER,
  post_id INTEGER,
  created_at TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (post_id) REFERENCES posts(post_id)
);

-- Comments Table 
Create table comments ( 
  comment_id INTEGER PRIMARY KEY,
  post_id INTEGER,
  user_id INTEGER,
  content VARCHAR,
  created_at TIMESTAMP,
  FOREIGN KEY (post_id) REFERENCES posts(post_id),
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Followers Table 
CREATE TABLE followers (
  follower_id INTEGER PRIMARY KEY,
  following_id INTEGER,
  created_at TIMESTAMP
);

-- Tags Table 
CREATE TABLE hash_tags (
  hash_tags_id INTEGER PRIMARY KEY,
  tag_name VARCHAR
);  

-- Post Hash Tags 
CREATE Table post_hash_tags (
  post_id INTEGER,
  hash_tags_id INTEGER,
  FOREIGN KEY (post_id) REFERENCES posts(post_id),
  FOREIGN KEY (hash_tags_id) REFERENCES hash_tags(hash_tags_id)
);

-- Analytics Table 
Create table analytics (
  analytics_id INTEGER PRIMARY KEY,
  post_id INTEGER,
  views INTEGER,
  shares INTEGER,
  impressions INTEGER,
  FOREIGN KEY (post_id) REFERENCES posts(post_id)
);  

INSERT INTO users 
(username, email, created_at) 
VALUES
('john_doe', 'john.doe@example.com', '2024-02-09 10:15:30'),
('jane_smith', 'jane.smith@example.com', '2024-02-08 14:22:10'),
('mike_jones', 'mike.jones@example.com', '2024-02-07 18:45:55'),
('sarah_connor', 'sarah.connor@example.com', '2024-02-06 09:10:20'),
('david_lee', 'david.lee@example.com', '2024-02-05 12:30:40'),
('emma_watson', 'emma.watson@example.com', '2024-02-04 16:50:15'),
('will_smith', 'will.smith@example.com', '2024-02-03 08:20:05'),
('olivia_brown', 'olivia.brown@example.com', '2024-02-02 22:05:45');

INSERT INTO posts 
(user_id, content, created_at) 
VALUES
(3, 'Had a great day at the park!', '2024-02-09 12:30:45'),
(1, 'Just finished reading an amazing book.', '2024-02-09 14:15:20'),
(5, 'Excited for the weekend trip!', '2024-02-08 09:50:10'),
(2, 'Working on a new project, can’t wait to share!', '2024-02-07 18:05:33'),
(3, 'Loving this new coffee place downtown.', '2024-02-06 16:45:55'),
(7, 'Finally hit my fitness goal this month!', '2024-02-06 11:20:40'),
(8, 'Learning a new programming language today.', '2024-02-05 21:10:15'),
(1, 'Movie night with friends!', '2024-02-04 19:30:50'),
(4, 'Just adopted a puppy, so excited!', '2024-02-03 14:05:25'),
(6, 'Exploring photography as a new hobby.', '2024-02-02 08:55:10');

INSERT INTO likes 
(user_id, post_id, created_at) 
VALUES
(1, 3, '2024-02-09 15:10:20'),
(3, 1, '2024-02-09 15:15:35'),
(5, 2, '2024-02-08 10:30:45'),
(2, 4, '2024-02-08 11:45:10'),
(6, 5, '2024-02-07 17:20:25'),
(7, 6, '2024-02-07 18:50:40'),
(8, 7, '2024-02-06 12:10:55'),
(1, 8, '2024-02-05 20:15:30'),
(4, 3, '2024-02-05 22:40:15'),
(2, 5, '2024-02-04 16:05:50'),
(3, 7, '2024-02-03 13:55:10'),
(8, 2, '2024-02-03 09:30:20'),
(5, 9, '2024-02-02 14:25:45'),
(7, 10, '2024-02-02 10:40:35'),
(6, 1, '2024-02-02 08:10:05');

INSERT INTO comments 
(post_id, user_id, content, created_at) 
VALUES
(3, 1, 'That sounds like a fun trip!', '2024-02-09 16:20:30'),
(1, 5, 'I love spending time at the park too!', '2024-02-09 17:05:45'),
(2, 3, 'Which book did you read?', '2024-02-08 12:15:20'),
(4, 7, 'Looking forward to your project!', '2024-02-08 18:30:55'),
(5, 2, 'Coffee places are the best for relaxing!', '2024-02-07 14:10:40'),
(6, 8, 'Congrats on hitting your fitness goal!', '2024-02-07 20:50:15'),
(7, 4, 'Which programming language are you learning?', '2024-02-06 09:30:25'),
(8, 6, 'Movie night is always a great idea!', '2024-02-05 19:45:10'),
(9, 3, 'A puppy! That’s amazing, what breed?', '2024-02-04 15:20:35'),
(10, 1, 'Photography is such a rewarding hobby!', '2024-02-03 11:10:50'),
(3, 7, 'Hope you have a fantastic trip!', '2024-02-03 14:30:20'),
(2, 8, 'Reading is the best escape!', '2024-02-02 10:15:45'),
(5, 4, 'What’s your favorite coffee drink?', '2024-02-02 12:55:35'),
(7, 5, 'Good luck with coding!', '2024-02-02 14:40:10'),
(9, 2, 'That puppy must be adorable!', '2024-02-02 18:20:05');

INSERT INTO Followers (following_id, created_at) VALUES
(3, '2024-02-09 10:15:30'),
(5, '2024-02-09 11:20:10'),
(1, '2024-02-08 14:45:55'),
(2, '2024-02-08 16:30:20'),
(6, '2024-02-07 18:10:40'),
(7, '2024-02-07 19:50:15'),
(8, '2024-02-06 12:25:35'),
(1, '2024-02-05 20:15:10'),
(5, '2024-02-05 22:05:45'),
(7, '2024-02-04 17:30:50'),
(3, '2024-02-03 14:10:20'),
(2, '2024-02-03 09:50:10'),
(6, '2024-02-02 15:25:45'),
(4, '2024-02-02 10:40:35'),
(8, '2024-02-02 08:10:05');

INSERT INTO hash_tags (tag_name) VALUES
('#Travel'),
('#Foodie'),
('#Fitness'),
('#Photography'),
('#Tech'),
('#Music'),
('#Books'),
('#Movies'),
('#Nature'),
('#Gaming');

INSERT INTO post_hash_tags (post_id, hash_tags_id) VALUES
(1, 3),  
(1, 9),  
(2, 7),  
(2, 5), 
(3, 1),  
(3, 9),  
(4, 5),  
(4, 6), 
(5, 2),  
(6, 3), 
(6, 10), 
(7, 4),  
(8, 8),  
(9, 6),  
(9, 5), 
(10, 4),
(10, 1); 

INSERT INTO analytics (post_id, views, shares, impressions) VALUES
(1, 150, 10, 1200),
(2, 300, 25, 2500),
(3, 500, 40, 4500),
(4, 200, 15, 1800),
(5, 350, 20, 3000),
(6, 400, 30, 3500),
(7, 180, 12, 1600),
(8, 600, 50, 5500),
(9, 250, 18, 2100),
(10, 450, 35, 4000);

-- Find the top 5 users with the highest number of followers.
SELECT following_id AS user_id, COUNT(follower_id) AS follower_count
FROM Followers
GROUP BY following_id
ORDER BY follower_count DESC
LIMIT 5;

-- Retrieve the most liked post along with the number of likes.
SELECT post_id, COUNT(like_id) AS like_count
FROM Likes
GROUP BY post_id
ORDER BY like_count DESC
LIMIT 1;

-- Get the top 5 most used hashtags along with their usage count.
SELECT h.hash_tags_id, h.tag_name, COUNT(ph.post_id) AS usage_count
FROM post_hash_tags ph
JOIN hash_tags h ON ph.hash_tags_id = h.hash_tags_id
GROUP BY h.hash_tags_id, h.tag_name
ORDER BY usage_count DESC
LIMIT 5;

-- Count the number of comments each user has made.
SELECT user_id, COUNT(comment_id) AS comment_count
FROM Comments
GROUP BY user_id
ORDER BY comment_count DESC;

-- Find the user who has received the most comments on their posts.
SELECT p.user_id, COUNT(c.comment_id) AS total_comments
FROM Posts p
JOIN Comments c ON p.post_id = c.post_id
GROUP BY p.user_id
ORDER BY total_comments DESC
LIMIT 1;

-- List all users who have liked a specific post.
SELECT u.user_id, u.username, u.email
FROM likes l
JOIN users u ON l.user_id = u.user_id
WHERE l.post_id = 5;

-- Identify posts that have been shared the most based on the Analytics table.
SELECT post_id, shares
FROM Analytics
ORDER BY shares DESC
LIMIT 5;
