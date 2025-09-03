-- Project in PostgreSQL 
CREATE DATABASE DatingAppInsights;
USE DatingAppInsights;

-- Users Table  
CREATE TABLE users (
  user_id SERIAL PRIMARY KEY,
  user_name VARCHAR(50),
  gender VARCHAR(10) CHECK (gender IN ('Male', 'Female', 'Others')),
  age INT CHECK (age > 0),
  locations VARCHAR(50),
  created_at DATE,
  last_active TIME 
);

-- Profiles Table 
CREATE TABLE profiles (
  profile_id SERIAL PRIMARY KEY,
  user_id INT,
  bio TEXT,
  interests VARCHAR(50),
  profile_picture VARCHAR(100),
  relationship_status VARCHAR(50),
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Matches Table 
CREATE TABLE matches (
  match_id SERIAL PRIMARY KEY,
  user1_id INT,
  user2_id INT,
  matched_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_user1 FOREIGN KEY (user1_id) REFERENCES Users(user_id) ON DELETE CASCADE,
  CONSTRAINT fk_user2 FOREIGN KEY (user2_id) REFERENCES Users(user_id) ON DELETE CASCADE,
  CONSTRAINT unique_match UNIQUE (user1_id, user2_id)
);

-- Messages Table  
CREATE TABLE messages (
    message_id SERIAL PRIMARY KEY,
    sender_id INT NOT NULL,
    receiver_id INT NOT NULL,
    match_id INT NOT NULL,
    messages_text TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_sender FOREIGN KEY (sender_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_receiver FOREIGN KEY (receiver_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_match FOREIGN KEY (match_id) REFERENCES matches(match_id) ON DELETE CASCADE
);

-- Subscriptions Table 
CREATE TABLE subscriptions (
    subscription_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    plan_type VARCHAR(50) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    status VARCHAR(20) NOT NULL,
    CONSTRAINT fk_subscription_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Activity Logs Table 
CREATE TABLE activity_logs (
    log_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    action_type VARCHAR(100) NOT NULL,
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_activity_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Insert sample data into Users Table
INSERT INTO users (user_name, gender, age, locations, created_at, last_active)
VALUES
('Alice', 'Female', 25, 'New York', '2023-01-10', '12:30:00'),
('Bob', 'Male', 30, 'Los Angeles', '2022-12-05', '14:15:00'),
('Charlie', 'Male', 28, 'Chicago', '2023-02-20', '10:45:00'),
('David', 'Male', 32, 'Houston', '2023-03-12', '16:00:00'),
('Eve', 'Female', 27, 'San Francisco', '2023-04-08', '09:30:00'),
('Fay', 'Female', 29, 'Seattle', '2023-05-15', '11:50:00'),
('George', 'Male', 26, 'Miami', '2023-06-20', '18:20:00');

-- Insert sample data into Profiles Table
INSERT INTO profiles (user_id, bio, interests, profile_picture, relationship_status)
VALUES
(1, 'Love traveling and photography.', 'Travel, Photography', 'alice_pic.jpg', 'Single'),
(2, 'Tech enthusiast and gamer.', 'Gaming, Tech', 'bob_pic.jpg', 'Single'),
(3, 'Fitness freak and foodie.', 'Fitness, Food', 'charlie_pic.jpg', 'In a relationship'),
(4, 'Musician and artist.', 'Music, Art', 'david_pic.jpg', 'Single'),
(5, 'Adventurer and bookworm.', 'Adventure, Books', 'eve_pic.jpg', 'Single'),
(6, 'Animal lover and dancer.', 'Animals, Dance', 'fay_pic.jpg', 'Single'),
(7, 'Cyclist and programmer.', 'Cycling, Coding', 'george_pic.jpg', 'Single');

-- Insert sample data into Matches Table
INSERT INTO matches (user1_id, user2_id, matched_at)
VALUES
(1, 2, '2023-07-10 14:00:00'),
(3, 4, '2023-07-12 15:30:00'),
(5, 6, '2023-07-15 18:45:00'),
(1, 5, '2023-07-18 20:10:00'),
(2, 6, '2023-07-20 09:00:00'),
(3, 7, '2023-07-22 13:25:00'),
(4, 5, '2023-07-25 16:40:00');

-- Insert sample data into Messages Table
INSERT INTO messages (sender_id, receiver_id, match_id, messages_text, sent_at)
VALUES
(1, 2, 1, 'Hey Bob! How are you?', '2023-07-10 14:05:00'),
(3, 4, 2, 'Nice to meet you, David!', '2023-07-12 15:35:00'),
(5, 6, 3, 'Let’s go on an adventure!', '2023-07-15 18:50:00'),
(1, 5, 4, 'Do you like traveling?', '2023-07-18 20:15:00'),
(2, 6, 5, 'What’s your favorite dance style?', '2023-07-20 09:05:00'),
(3, 7, 6, 'What coding language do you prefer?', '2023-07-22 13:30:00'),
(4, 5, 7, 'Music or books, what’s your favorite?', '2023-07-25 16:45:00');

-- Insert sample data into Subscriptions Table
INSERT INTO subscriptions (user_id, plan_type, start_date, end_date, status)
VALUES
(1, 'Premium', '2023-06-01', '2023-12-01', 'active'),
(2, 'Basic', '2023-07-10', '2024-01-10', 'active'),
(3, 'Premium', '2023-05-15', '2023-11-15', 'active'),
(4, 'Free', '2023-08-01', NULL, 'active'),
(5, 'Basic', '2023-06-20', '2023-12-20', 'expired'),
(6, 'Premium', '2023-07-25', '2024-01-25', 'active'),
(7, 'Basic', '2023-09-05', '2024-03-05', 'active');

-- Insert sample data into Activity Logs Table
INSERT INTO activity_logs (user_id, action_type, action_time)
VALUES
(1, 'Logged in', '2023-07-10 12:00:00'),
(2, 'Updated profile picture', '2023-07-11 14:30:00'),
(3, 'Sent a message', '2023-07-12 16:00:00'),
(4, 'Matched with a user', '2023-07-15 10:45:00'),
(5, 'Subscribed to Premium', '2023-07-18 08:20:00'),
(6, 'Changed relationship status', '2023-07-20 11:10:00'),
(7, 'Logged out', '2023-07-22 19:30:00');

-- Find the top 4 most active users based on messages sent.
SELECT sender_id, COUNT(*) AS messages_sent
FROM messages
GROUP BY sender_id
ORDER BY messages_sent DESC
LIMIT 4;

-- Retrieve the number of matches each user has.
SELECT u.user_id, u.user_name, 
       (COUNT(m.user1_id) + COUNT(m.user2_id)) AS total_matches
FROM users u
LEFT JOIN matches m ON u.user_id = m.user1_id OR u.user_id = m.user2_id
GROUP BY u.user_id, u.user_name
ORDER BY total_matches DESC;

-- Get the average number of messages exchanged per match.
SELECT AVG(message_count) AS avg_messages_per_match
FROM (
    SELECT match_id, COUNT(*) AS message_count
    FROM messages
    GROUP BY match_id
) AS match_messages;

-- Find all users who have an active subscription.
SELECT u.user_id, u.user_name, s.plan_type, s.status
FROM users u
JOIN subscriptions s ON u.user_id = s.user_id
WHERE s.status = 'active';

-- Find the most common interests among users.
SELECT interests, COUNT(*) AS interest_count
FROM profiles
GROUP BY interests
ORDER BY interest_count DESC
LIMIT 5;

-- Retrieve the percentage of users who have uploaded a profile picture.
SELECT 
    (COUNT(profile_picture) * 100.0 / (SELECT COUNT(*) FROM users)) AS percentage_with_pictures
FROM profiles
WHERE profile_picture IS NOT NULL AND profile_picture <> '';

-- Find users who have sent messages but never received any.
SELECT DISTINCT sender_id 
FROM messages
WHERE sender_id NOT IN (SELECT DISTINCT receiver_id FROM messages);

-- Determine the churn rate by finding users who have not renewed their subscription after expiration.
SELECT COUNT(*) * 100.0 / (SELECT COUNT(*) FROM users) AS churn_rate
FROM subscriptions
WHERE status = 'expired' AND user_id NOT IN (
    SELECT user_id FROM subscriptions WHERE status = 'active'
);

-- Find the match that resulted in the highest number of messages exchanged.
SELECT match_id, COUNT(*) AS message_count
FROM messages
GROUP BY match_id
ORDER BY message_count DESC
LIMIT 1;

-- Find the top 5 users with the highest number of received messages.
SELECT receiver_id, COUNT(*) AS messages_received
FROM messages
GROUP BY receiver_id
ORDER BY messages_received DESC
LIMIT 5;

-- Find the users who have never sent a message.
SELECT user_id, user_name
FROM users
WHERE user_id NOT IN (SELECT DISTINCT sender_id FROM messages);

-- Find users who have received messages but never sent any.
SELECT DISTINCT receiver_id 
FROM messages
WHERE receiver_id NOT IN (SELECT DISTINCT sender_id FROM messages);

-- Find the most active users based on both sent and received messages.
SELECT u.user_id, u.user_name, 
       COUNT(m1.message_id) AS sent_messages, 
       COUNT(m2.message_id) AS received_messages,
       (COUNT(m1.message_id) + COUNT(m2.message_id)) AS total_messages
FROM users u
LEFT JOIN messages m1 ON u.user_id = m1.sender_id
LEFT JOIN messages m2 ON u.user_id = m2.receiver_id
GROUP BY u.user_id, u.user_name
ORDER BY total_messages DESC
LIMIT 3;

-- Find the average age of users based on gender.
SELECT gender, AVG(age) AS avg_age
FROM users
GROUP BY gender;

-- Find users who have the most common interest.
SELECT user_id, interests
FROM profiles
WHERE interests = (SELECT interests FROM profiles 
                   GROUP BY interests 
                   ORDER BY COUNT(*) DESC 
                   LIMIT 1);

-- Retrieve the number of active, expired, and canceled subscriptions.
SELECT status, COUNT(*) AS count
FROM subscriptions
GROUP BY status;

-- Find the top 3 locations with the most users.
SELECT locations, COUNT(*) AS user_count
FROM users
GROUP BY locations
ORDER BY user_count DESC
LIMIT 3;