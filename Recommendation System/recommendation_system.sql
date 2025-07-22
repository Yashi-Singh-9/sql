-- Project In MariaDB 
-- Create database
CREATE DATABASE recommendation_system;
USE recommendation_system;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE,
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255),
    category VARCHAR(100),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ratings (
    rating_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    item_id INT,
    rating DECIMAL(2,1), -- 1.0 to 5.0
    rated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (item_id) REFERENCES items(item_id)
);

CREATE TABLE item_similarity (
    item_id_1 INT,
    item_id_2 INT,
    similarity_score DECIMAL(5,4), -- 0 to 1
    PRIMARY KEY (item_id_1, item_id_2),
    FOREIGN KEY (item_id_1) REFERENCES items(item_id),
    FOREIGN KEY (item_id_2) REFERENCES items(item_id)
);

INSERT INTO users (username, email) VALUES
('alice', 'alice@rec.com'),
('bob', 'bob@rec.com'),
('charlie', 'charlie@rec.com');

INSERT INTO items (title, category, description) VALUES
('Inception', 'Sci-Fi', 'A mind-bending thriller.'),
('The Matrix', 'Sci-Fi', 'Virtual reality and rebellion.'),
('The Godfather', 'Crime', 'Mafia family legacy.'),
('Titanic', 'Romance', 'Love story on a sinking ship.'),
('Interstellar', 'Sci-Fi', 'Space travel to save humanity.');

INSERT INTO ratings (user_id, item_id, rating) VALUES
(1, 1, 5.0),
(1, 2, 4.5),
(1, 5, 4.8),
(2, 1, 4.0),
(2, 3, 5.0),
(3, 4, 3.5),
(3, 2, 4.2);

INSERT INTO item_similarity (item_id_1, item_id_2, similarity_score) VALUES
(1, 2, 0.92),
(1, 5, 0.87),
(2, 5, 0.89),
(3, 4, 0.30),
(3, 1, 0.25);

-- Top rated items (globally)
SELECT i.title, AVG(r.rating) AS avg_rating
FROM ratings r
JOIN items i ON r.item_id = i.item_id
GROUP BY i.title
ORDER BY avg_rating DESC
LIMIT 3;

-- Get items similar to ‘Inception’ (item_id = 1)
SELECT i2.title, s.similarity_score
FROM item_similarity s
JOIN items i2 ON s.item_id_2 = i2.item_id
WHERE s.item_id_1 = 1
ORDER BY s.similarity_score DESC;

-- Users who rated the same item
SELECT 
    i.title,
    u1.username AS user_1,
    u2.username AS user_2
FROM ratings r1
JOIN ratings r2 ON r1.item_id = r2.item_id AND r1.user_id < r2.user_id
JOIN users u1 ON r1.user_id = u1.user_id
JOIN users u2 ON r2.user_id = u2.user_id
JOIN items i ON r1.item_id = i.item_id
ORDER BY i.title;

-- Recommend items to a user based on similar items they rated highly
SELECT DISTINCT i2.title, s.similarity_score
FROM ratings r
JOIN item_similarity s ON r.item_id = s.item_id_1
JOIN items i2 ON s.item_id_2 = i2.item_id
WHERE r.user_id = 1 AND r.rating >= 4.5
ORDER BY s.similarity_score DESC;

-- Average rating per category
SELECT 
    i.category,
    ROUND(AVG(r.rating), 2) AS avg_category_rating
FROM ratings r
JOIN items i ON r.item_id = i.item_id
GROUP BY i.category
ORDER BY avg_category_rating DESC;

-- Most recently rated items
SELECT 
    u.username,
    i.title,
    r.rating,
    r.rated_at
FROM ratings r
JOIN users u ON r.user_id = u.user_id
JOIN items i ON r.item_id = i.item_id
ORDER BY r.rated_at DESC
LIMIT 3;

-- Mutual high ratings between users (≥ 4.0)
SELECT 
    u1.username AS user_1,
    u2.username AS user_2,
    i.title
FROM ratings r1
JOIN ratings r2 ON r1.item_id = r2.item_id AND r1.user_id < r2.user_id
JOIN users u1 ON r1.user_id = u1.user_id
JOIN users u2 ON r2.user_id = u2.user_id
JOIN items i ON r1.item_id = i.item_id
WHERE r1.rating >= 4.0 AND r2.rating >= 4.0;

-- Top similar item pairs
SELECT 
    i1.title AS item_1,
    i2.title AS item_2,
    s.similarity_score
FROM item_similarity s
JOIN items i1 ON s.item_id_1 = i1.item_id
JOIN items i2 ON s.item_id_2 = i2.item_id
ORDER BY s.similarity_score DESC
LIMIT 5;