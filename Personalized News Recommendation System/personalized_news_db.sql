-- Project in PostgreSQL 
-- Create Database
CREATE DATABASE personalized_news_db;

-- Connect to Database
\c personalized_news_db;

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE
);

CREATE TABLE news_articles (
    article_id SERIAL PRIMARY KEY,
    title VARCHAR(255),
    content TEXT,
    category VARCHAR(50),
    published_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE user_preferences (
    preference_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    category VARCHAR(50)
);

CREATE TABLE user_recommendations (
    recommendation_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    article_id INT REFERENCES news_articles(article_id) ON DELETE CASCADE,
    recommended_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO users (name, email) VALUES
('Alice Johnson', 'alice@example.com'),
('Bob Smith', 'bob@example.com'),
('Charlie Brown', 'charlie@example.com'),
('David Wilson', 'david@example.com');

INSERT INTO news_articles (title, content, category) VALUES
('Tech Innovations in 2025', 'Latest advancements in AI and robotics.', 'Technology'),
('Political Debate Highlights', 'Key takeaways from the recent debate.', 'Politics'),
('Health Benefits of Yoga', 'Why yoga is beneficial for mental and physical health.', 'Health'),
('Stock Market Analysis', 'Current trends and predictions for investors.', 'Finance');

INSERT INTO user_preferences (user_id, category) VALUES
(1, 'Technology'),
(2, 'Politics'),
(3, 'Health'),
(4, 'Finance');

INSERT INTO user_recommendations (user_id, article_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4);

-- 1. Get recommended articles for a specific user
SELECT u.name, n.title, n.category 
FROM user_recommendations ur
JOIN users u ON ur.user_id = u.user_id
JOIN news_articles n ON ur.article_id = n.article_id
WHERE u.user_id = 1;

-- 2. Get all users who prefer a specific category
SELECT u.name, u.email FROM users u
JOIN user_preferences up ON u.user_id = up.user_id
WHERE up.category = 'Technology';

-- 3. Find the most recent articles recommended to users
SELECT u.name, n.title, ur.recommended_at 
FROM user_recommendations ur
JOIN users u ON ur.user_id = u.user_id
JOIN news_articles n ON ur.article_id = n.article_id
ORDER BY ur.recommended_at DESC;

-- 4. Count the number of recommendations per user
SELECT u.name, COUNT(ur.recommendation_id) AS recommendation_count
FROM users u
LEFT JOIN user_recommendations ur ON u.user_id = ur.user_id
GROUP BY u.user_id, u.name
ORDER BY recommendation_count DESC;

-- 5. Retrieve articles by category
SELECT * FROM news_articles WHERE category = 'Technology';

-- 6. Get users who have received at least one recommendation
SELECT DISTINCT u.name, u.email 
FROM users u
JOIN user_recommendations ur ON u.user_id = ur.user_id;

-- 7. Find the most popular category among users
SELECT category, COUNT(*) AS preference_count
FROM user_preferences
GROUP BY category
ORDER BY preference_count DESC;

-- 8. Get the latest published news articles
SELECT * FROM news_articles ORDER BY published_at DESC LIMIT 5;

-- 9. Find the most recommended article
SELECT n.title, COUNT(ur.recommendation_id) AS recommendation_count
FROM news_articles n
JOIN user_recommendations ur ON n.article_id = ur.article_id
GROUP BY n.article_id, n.title
ORDER BY recommendation_count DESC LIMIT 1;

-- 10. Count the number of users per preferred category
SELECT category, COUNT(user_id) AS user_count 
FROM user_preferences 
GROUP BY category 
ORDER BY user_count DESC;

-- 11. Find the most recently published article for each category
SELECT DISTINCT ON (category) category, title, published_at
FROM news_articles
ORDER BY category, published_at DESC;

-- 12. Get the average number of recommendations per user
SELECT AVG(recommendation_count) AS avg_recommendations 
FROM (
    SELECT u.user_id, COUNT(ur.recommendation_id) AS recommendation_count
    FROM users u
    LEFT JOIN user_recommendations ur ON u.user_id = ur.user_id
    GROUP BY u.user_id
) subquery;
