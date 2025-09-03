-- Project In MariaDB 
-- Create Database
CREATE DATABASE chatbot_analysis;
USE chatbot_analysis;

-- User info table
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50),
    email VARCHAR(100),
    registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Conversation sessions
CREATE TABLE sessions (
    session_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ended_at TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Messages exchanged between user and bot
CREATE TABLE messages (
    message_id INT AUTO_INCREMENT PRIMARY KEY,
    session_id INT,
    sender ENUM('user', 'bot'),
    message_text TEXT,
    message_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (session_id) REFERENCES sessions(session_id)
);

-- Intent detection results
CREATE TABLE intents (
    intent_id INT AUTO_INCREMENT PRIMARY KEY,
    message_id INT,
    detected_intent VARCHAR(100),
    confidence_score DECIMAL(5,2),
    FOREIGN KEY (message_id) REFERENCES messages(message_id)
);

-- Sentiment analysis results
CREATE TABLE sentiments (
    sentiment_id INT AUTO_INCREMENT PRIMARY KEY,
    message_id INT,
    sentiment ENUM('positive', 'neutral', 'negative'),
    sentiment_score DECIMAL(4,2),
    FOREIGN KEY (message_id) REFERENCES messages(message_id)
);

-- Response time tracking
CREATE TABLE response_times (
    response_id INT AUTO_INCREMENT PRIMARY KEY,
    user_message_id INT,
    bot_message_id INT,
    response_delay_seconds DECIMAL(5,2),
    FOREIGN KEY (user_message_id) REFERENCES messages(message_id),
    FOREIGN KEY (bot_message_id) REFERENCES messages(message_id)
);

INSERT INTO users (username, email) VALUES 
('alice123', 'alice@example.com'),
('bob_the_chat', 'bob@example.com');

INSERT INTO sessions (user_id) VALUES (1), (2);

INSERT INTO messages (session_id, sender, message_text) VALUES
(1, 'user', 'Hi there!'),
(1, 'bot', 'Hello! How can I help you?'),
(1, 'user', 'I need help with my order.'),
(1, 'bot', 'Sure! What seems to be the issue?'),
(2, 'user', 'What are your store hours?'),
(2, 'bot', 'We are open from 9 AM to 5 PM, Monday to Friday.');

INSERT INTO intents (message_id, detected_intent, confidence_score) VALUES
(3, 'order_support', 0.91),
(5, 'store_hours_query', 0.88);

INSERT INTO sentiments (message_id, sentiment, sentiment_score) VALUES
(1, 'positive', 0.75),
(3, 'neutral', 0.60),
(5, 'positive', 0.85);

INSERT INTO response_times (user_message_id, bot_message_id, response_delay_seconds) VALUES
(1, 2, 1.23),
(3, 4, 2.05),
(5, 6, 1.10);

-- Average bot response time
SELECT ROUND(AVG(response_delay_seconds), 2) AS avg_response_time
FROM response_times;

-- Sentiment distribution in user messages
SELECT sentiment, COUNT(*) AS count
FROM sentiments
GROUP BY sentiment;

-- Most common user intents
SELECT detected_intent, COUNT(*) AS intent_count
FROM intents
GROUP BY detected_intent
ORDER BY intent_count DESC;

-- User with most chatbot sessions
SELECT u.username, COUNT(*) AS session_count
FROM sessions s
JOIN users u ON s.user_id = u.user_id
GROUP BY u.username
ORDER BY session_count DESC;

-- Intent confidence over time
SELECT m.message_time, i.detected_intent, i.confidence_score
FROM intents i
JOIN messages m ON i.message_id = m.message_id
ORDER BY m.message_time;

-- Average bot response time per session
SELECT 
    s.session_id,
    u.username,
    ROUND(AVG(r.response_delay_seconds), 2) AS avg_response_time
FROM response_times r
JOIN messages m ON r.user_message_id = m.message_id
JOIN sessions s ON m.session_id = s.session_id
JOIN users u ON s.user_id = u.user_id
GROUP BY s.session_id, u.username;

-- Most common detected intent
SELECT 
    detected_intent, 
    COUNT(*) AS frequency
FROM intents
GROUP BY detected_intent
ORDER BY frequency DESC
LIMIT 1;

-- Sentiment distribution for all user messages
SELECT 
    sentiment, 
    COUNT(*) AS count
FROM sentiments
GROUP BY sentiment;