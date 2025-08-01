-- SQL Lite Project 
sqlite3 social_media_db.db

-- Users Table 
CREATE TABLE users (
  user_id INTEGER PRIMARY KEY,
  username VARCHAR(20) UNIQUE,
  email VARCHAR(50) UNIQUE,
  password TEXT,
  profile_picture VARCHAR(155),
  bio TEXT,
  created_at DATE
);

-- Posts Table  
CREATE TABLE posts (
  post_id INTEGER PRIMARY KEY,
  user_id INTEGER,
  content TEXT,
  image_url TEXT,
  created_at DATETIME,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Comments Table  
CREATE TABLE comments (
  comment_id INTEGER PRIMARY KEY,
  post_id INTEGER,
  user_id INTEGER,
  comment_text TEXT,
  created_at DATE,
  FOREIGN KEY (post_id) REFERENCES posts(post_id),
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Likes Table  
CREATE TABLE likes (
  like_id INTEGER PRIMARY KEY,
  user_id INTEGER,
  post_id INTEGER,
  created_at DATETIME,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (post_id) REFERENCES posts(post_id)
);

-- Friends Table  
CREATE TABLE friends (
  friendship_id INTEGER PRIMARY KEY,
  user_id1 INTEGER,
  user_id2 INTEGER,
  status VARCHAR(10) CHECK (status IN ('Pending', 'Accepted', 'Rejected')),
  created_at DATETIME,
  FOREIGN KEY (user_id1) REFERENCES users(user_id),
  FOREIGN KEY (user_id2) REFERENCES users(user_id)
);  

-- Messages Table  
CREATE TABLE messages (
  message_id INTEGER PRIMARY KEY,
  sender_id INTEGER,
  receiver_id INTEGER,
  message_text TEXT,
  sent_at DATETIME,
  is_read BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (sender_id) REFERENCES users(user_id),
  FOREIGN KEY (receiver_id) REFERENCES users(user_id)
);

-- Notifications Table  
CREATE Table notifications (
  notification_id INTEGER PRIMARY KEY,
  user_id INTEGER,
  type VARCHAR(15) CHECK (type IN ('Like', 'Comment', 'friend_request')),
  message TEXT,
  is_read BOOLEAN DEFAULT FALSE,
  created_at DATETIME,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);  

-- Insert sample users
INSERT INTO users (username, email, password, profile_picture, bio, created_at) VALUES
('user1', 'user1@example.com', 'pass123', 'pic1.jpg', 'Bio for user1', '2024-01-01'),
('user2', 'user2@example.com', 'pass123', 'pic2.jpg', 'Bio for user2', '2024-01-02'),
('user3', 'user3@example.com', 'pass123', 'pic3.jpg', 'Bio for user3', '2024-01-03'),
('user4', 'user4@example.com', 'pass123', 'pic4.jpg', 'Bio for user4', '2024-01-04'),
('user5', 'user5@example.com', 'pass123', 'pic5.jpg', 'Bio for user5', '2024-01-05'),
('user6', 'user6@example.com', 'pass123', 'pic6.jpg', 'Bio for user6', '2024-01-06'),
('user7', 'user7@example.com', 'pass123', 'pic7.jpg', 'Bio for user7', '2024-01-07');

-- Insert sample posts
INSERT INTO posts (user_id, content, image_url, created_at) VALUES
(1, 'Post from user1', 'post1.jpg', '2024-02-01 10:00:00'),
(2, 'Post from user2', 'post2.jpg', '2024-02-02 11:00:00'),
(3, 'Post from user3', 'post3.jpg', '2024-02-03 12:00:00'),
(4, 'Post from user4', 'post4.jpg', '2024-02-04 13:00:00'),
(5, 'Post from user5', 'post5.jpg', '2024-02-05 14:00:00'),
(6, 'Post from user6', 'post6.jpg', '2024-02-06 15:00:00'),
(7, 'Post from user7', 'post7.jpg', '2024-02-07 16:00:00');

-- Insert sample comments
INSERT INTO comments (post_id, user_id, comment_text, created_at) VALUES
(1, 2, 'Nice post!', '2024-02-01'),
(2, 3, 'Great content!', '2024-02-02'),
(3, 4, 'Love this!', '2024-02-03'),
(4, 5, 'Awesome!', '2024-02-04'),
(5, 6, 'Very cool!', '2024-02-05'),
(6, 7, 'Interesting!', '2024-02-06'),
(7, 1, 'Keep it up!', '2024-02-07');

-- Insert sample likes
INSERT INTO likes (user_id, post_id, created_at) VALUES
(1, 2, '2024-02-01 10:10:00'),
(2, 3, '2024-02-02 11:10:00'),
(3, 4, '2024-02-03 12:10:00'),
(4, 5, '2024-02-04 13:10:00'),
(5, 6, '2024-02-05 14:10:00'),
(6, 7, '2024-02-06 15:10:00'),
(7, 1, '2024-02-07 16:10:00');

-- Insert sample friendships
INSERT INTO friends (user_id1, user_id2, status, created_at) VALUES
(1, 2, 'Accepted', '2024-02-01 09:00:00'),
(2, 3, 'Pending', '2024-02-02 09:30:00'),
(3, 4, 'Accepted', '2024-02-03 10:00:00'),
(4, 5, 'Rejected', '2024-02-04 10:30:00'),
(5, 6, 'Accepted', '2024-02-05 11:00:00'),
(6, 7, 'Pending', '2024-02-06 11:30:00'),
(7, 1, 'Accepted', '2024-02-07 12:00:00');

-- Insert sample messages
INSERT INTO messages (sender_id, receiver_id, message_text, sent_at, is_read) VALUES
(1, 2, 'Hey there!', '2024-02-01 09:15:00', FALSE),
(2, 3, 'How are you?', '2024-02-02 09:45:00', TRUE),
(3, 4, 'What''s up?', '2024-02-03 10:15:00', FALSE),
(4, 5, 'Nice to meet you!', '2024-02-04 10:45:00', TRUE),
(5, 6, 'Good morning!', '2024-02-05 11:15:00', FALSE),
(6, 7, 'See you soon!', '2024-02-06 11:45:00', TRUE),
(7, 1, 'Take care!', '2024-02-07 12:15:00', FALSE);

-- Insert sample notifications
INSERT INTO notifications (user_id, type, message, is_read, created_at) VALUES
(1, 'Like', 'User2 liked your post.', FALSE, '2024-02-01 10:20:00'),
(2, 'Comment', 'User3 commented on your post.', TRUE, '2024-02-02 11:20:00'),
(3, 'friend_request', 'User4 sent you a friend request.', FALSE, '2024-02-03 12:20:00'),
(4, 'Like', 'User5 liked your post.', TRUE, '2024-02-04 13:20:00'),
(5, 'Comment', 'User6 commented on your post.', FALSE, '2024-02-05 14:20:00'),
(6, 'friend_request', 'User7 sent you a friend request.', TRUE, '2024-02-06 15:20:00'),
(7, 'Like', 'User1 liked your post.', FALSE, '2024-02-07 16:20:00');

-- Retrieve all posts made by a specific user (e.g., user_id = 5).
SELECT * 
FROM posts 
WHERE user_id = 5;

-- Find the top 5 most liked posts.
SELECT posts.post_id, posts.content, COUNT(likes.like_id) AS like_count
FROM posts
LEFT JOIN likes ON posts.post_id = likes.post_id
GROUP BY posts.post_id
ORDER BY like_count DESC
LIMIT 5;

-- Get all comments on a specific post (e.g., post_id = 7).
SELECT * 
FROM comments 
WHERE post_id = 7;

-- List all users who liked a particular post.
SELECT users.user_id, users.username
FROM likes
JOIN users ON likes.user_id = users.user_id
WHERE likes.post_id = 6;

-- Find all pending friend requests for a specific user.
SELECT * 
FROM friends 
WHERE user_id2 = 3 AND status = 'Pending';

-- Get a list of friends for a given user.
SELECT users.user_id, users.username
FROM friends
JOIN users ON users.user_id = friends.user_id2
WHERE friends.user_id1 = 5 AND friends.status = 'Accepted'
UNION
SELECT users.user_id, users.username
FROM friends
JOIN users ON users.user_id = friends.user_id1
WHERE friends.user_id2 = 5 AND friends.status = 'Accepted';

-- Retrieve the number of posts each user has made, ordered by the most posts.
SELECT users.username, COUNT(posts.post_id) AS post_count
FROM users
LEFT JOIN posts ON users.user_id = posts.user_id
GROUP BY users.user_id
ORDER BY post_count DESC;

-- Find the user with the most friends.
SELECT users.username, COUNT(friends.friendship_id) AS friend_count
FROM users
JOIN friends ON users.user_id = friends.user_id1 OR users.user_id = friends.user_id2
WHERE friends.status = 'Accepted'
GROUP BY users.user_id
ORDER BY friend_count DESC
LIMIT 1;

-- Get all unread notifications for a given user.
SELECT * 
FROM notifications
WHERE user_id = 5 AND is_read = FALSE;

-- Retrieve the top 4 most recently created user accounts.
SELECT * 
FROM users 
ORDER BY created_at DESC 
LIMIT 4;

-- Get a list of users who haven't logged in for the last 30 days.
SELECT * 
FROM users 
WHERE created_at < DATE('now', '-30 days');

-- Find all users who have the word "user3" in their username.
SELECT * 
FROM users 
WHERE username LIKE '%user3%';

-- Retrieve the user who has received the most total likes on all of their posts.
SELECT users.user_id, users.username, COUNT(likes.like_id) AS total_likes
FROM users
JOIN posts ON users.user_id = posts.user_id
LEFT JOIN likes ON posts.post_id = likes.post_id
GROUP BY users.user_id
ORDER BY total_likes DESC
LIMIT 1;

-- List all users who have accepted at least 1 friend requests.
SELECT users.user_id, users.username, COUNT(friends.friendship_id) AS accepted_count
FROM users
JOIN friends ON users.user_id = friends.user_id2
WHERE friends.status = 'Accepted'
GROUP BY users.user_id
HAVING accepted_count >= 1;

-- Get a list of friend requests sent but not yet accepted.
SELECT * 
FROM friends 
WHERE status = 'Pending';

-- Find all users who have more than 1 friends.
SELECT users.user_id, users.username, COUNT(friends.friendship_id) AS friend_count
FROM users
JOIN friends ON users.user_id = friends.user_id1 OR users.user_id = friends.user_id2
WHERE friends.status = 'Accepted'
GROUP BY users.user_id
HAVING friend_count > 1;

-- Find the average number of comments per post for each user.
SELECT users.user_id, users.username, 
       AVG(comment_count) AS avg_comments_per_post
FROM (
    SELECT posts.user_id, COUNT(comments.comment_id) AS comment_count
    FROM posts
    LEFT JOIN comments ON posts.post_id = comments.post_id
    GROUP BY posts.user_id, posts.post_id
) AS post_comments
JOIN users ON post_comments.user_id = users.user_id
GROUP BY users.user_id;

-- Get the ratio of likes to comments for each post.
SELECT posts.post_id, posts.content, 
       COUNT(DISTINCT likes.like_id) * 1.0 / NULLIF(COUNT(DISTINCT comments.comment_id), 0) AS like_comment_ratio
FROM posts
LEFT JOIN likes ON posts.post_id = likes.post_id
LEFT JOIN comments ON posts.post_id = comments.post_id
GROUP BY posts.post_id;

-- Identify inactive users who haven't posted, commented, or liked anything in the last 3 months.
SELECT users.user_id, users.username
FROM users
LEFT JOIN posts ON users.user_id = posts.user_id AND posts.created_at >= DATE('now', '-3 months')
LEFT JOIN comments ON users.user_id = comments.user_id AND comments.created_at >= DATE('now', '-3 months')
LEFT JOIN likes ON users.user_id = likes.user_id AND likes.created_at >= DATE('now', '-3 months')
WHERE posts.user_id IS NULL 
  AND comments.user_id IS NULL 
  AND likes.user_id IS NULL;

-- Find the most active user based on total posts, comments, and likes.
SELECT users.user_id, users.username,
       COUNT(DISTINCT posts.post_id) AS total_posts,
       COUNT(DISTINCT comments.comment_id) AS total_comments,
       COUNT(DISTINCT likes.like_id) AS total_likes,
       (COUNT(DISTINCT posts.post_id) + COUNT(DISTINCT comments.comment_id) + COUNT(DISTINCT likes.like_id)) AS activity_score
FROM users
LEFT JOIN posts ON users.user_id = posts.user_id
LEFT JOIN comments ON users.user_id = comments.user_id
LEFT JOIN likes ON users.user_id = likes.user_id
GROUP BY users.user_id
ORDER BY activity_score DESC
LIMIT 1;

-- Retrieve the top 5 most engaging users (based on total likes received on their posts).
SELECT users.user_id, users.username, COUNT(likes.like_id) AS total_likes_received
FROM users
JOIN posts ON users.user_id = posts.user_id
LEFT JOIN likes ON posts.post_id = likes.post_id
GROUP BY users.user_id
ORDER BY total_likes_received DESC
LIMIT 5;