-- MS SQL Project
CREATE DATABASE MovieTracker;

-- Genres Table 
Create TABLE genres (
  genre_id INT IDENTITY(1,1) PRIMARY KEY,
  genre_name VARCHAR(50)
);

-- Directors Table 
CREATE TABLE directors (
  director_id INT IDENTITY(1,1) PRIMARY KEY,
  director_name VARCHAR(50)
);

-- Actors Table 
CREATE TABLE actors (
  actor_id INT IDENTITY(1,1) PRIMARY KEY,
  actor_name VARCHAR(50),
  birth_year DATE,
);

-- Users Table 
CREATE TABLE users (
  user_id INT IDENTITY(1,1) PRIMARY KEY,
  username VARCHAR(50),
  email VARCHAR(50),
);

-- Movies Table 
CREATE TABLE movies (
  movie_id INT IDENTITY(1,1) PRIMARY KEY,
  title VARCHAR(50),
  release_year DATE,
  genre_id INT,
  director_id INT,
  duration INT,
  rating INT CHECK (rating BETWEEN 1 AND 10),
  FOREIGN KEY (genre_id) REFERENCES genres(genre_id),
  FOREIGN KEY (director_id) REFERENCES directors(director_id)
);

-- Movie Actors Table 
CREATE TABLE movie_table (
  movie_id INT,
  actor_id INT,
  FOREIGN KEY (movie_id) REFERENCES movies(movie_id),
  FOREIGN KEY (actor_id) REFERENCES actors(actor_id),
);

-- Watchlist Table 
CREATE TABLE watchlist (
  watchlist_id INT IDENTITY(1,1) PRIMARY KEY,
  user_id INT,
  movie_id INT,
  status VARCHAR(20) CHECK ( status IN ( 'Watching', 'Completed', 'Planned')),
  added_date DATE,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (movie_id) REFERENCES movies(movie_id)
);

-- Reviews Table 
CREATE TABLE reviews (
  review_id INT IDENTITY(1,1) PRIMARY KEY,
  user_id INT,
  movie_id INT,
  rating INT CHECK (rating BETWEEN 1 AND 10),
  review_text text,
  review_date DATE,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (movie_id) REFERENCES movies(movie_id)
);  

-- Insert sample genres
INSERT INTO genres (genre_name) VALUES
('Action'),
('Comedy'),
('Drama'),
('Horror'),
('Sci-Fi');

-- Insert sample directors
INSERT INTO directors (director_name) VALUES
('Steven Spielberg'),
('Christopher Nolan'),
('Quentin Tarantino'),
('Martin Scorsese'),
('James Cameron');

-- Insert sample actors
INSERT INTO actors (actor_name, birth_year) VALUES
('Leonardo DiCaprio', '1974-11-11'),
('Robert Downey Jr.', '1965-04-04'),
('Scarlett Johansson', '1984-11-22'),
('Brad Pitt', '1963-12-18'),
('Tom Hanks', '1956-07-09');

-- Insert sample users
INSERT INTO users (username, email) VALUES
('user1', 'user1@example.com'),
('user2', 'user2@example.com'),
('user3', 'user3@example.com'),
('user4', 'user4@example.com'),
('user5', 'user5@example.com');

-- Insert sample movies
INSERT INTO movies (title, release_year, genre_id, director_id, duration, rating) VALUES
('Inception', '2010-07-16', 5, 2, 148, 9),
('Titanic', '1997-12-19', 3, 5, 195, 8),
('Pulp Fiction', '1994-10-14', 3, 3, 154, 9),
('The Dark Knight', '2008-07-18', 1, 2, 152, 10),
('Jurassic Park', '1993-06-11', 5, 1, 127, 8);

-- Insert sample movie actors
INSERT INTO movie_table (movie_id, actor_id) VALUES
(1, 1),
(2, 1),
(3, 2),
(4, 3),
(5, 4),
(1, 5),
(3, 4),
(2, 3);

-- Insert sample watchlist entries
INSERT INTO watchlist (user_id, movie_id, status, added_date) VALUES
(1, 1, 'Watching', '2024-02-01'),
(2, 3, 'Completed', '2024-01-15'),
(3, 5, 'Planned', '2024-02-05'),
(4, 2, 'Watching', '2024-02-10'),
(5, 4, 'Completed', '2024-02-12');

-- Insert sample reviews
INSERT INTO reviews (user_id, movie_id, rating, review_text, review_date) VALUES
(1, 1, 9, 'Amazing mind-bending movie.', '2024-02-03'),
(2, 3, 8, 'Classic Tarantino storytelling.', '2024-01-20'),
(3, 5, 7, 'Nostalgic and thrilling.', '2024-02-06'),
(4, 2, 10, 'Heartbreaking love story.', '2024-02-11'),
(5, 4, 9, 'Best Batman movie ever!', '2024-02-13');

-- Find all movies released after the year 2000.
SELECT * FROM movies WHERE release_year > '2000-01-01';

-- Get the top 5 highest-rated movies.
SELECT TOP 5 * FROM movies ORDER BY rating DESC;

-- Retrieve movies that belong to a specific genre (e.g., "Action").
SELECT movies.* FROM movies 
JOIN genres ON movies.genre_id = genres.genre_id 
WHERE genres.genre_name = 'Action';

-- List all movies along with their directors.
SELECT movies.title, directors.director_name FROM movies 
JOIN directors ON movies.director_id = directors.director_id;

-- Find the number of movies for each genre.
SELECT genres.genre_name, COUNT(movies.movie_id) AS movie_count 
FROM genres 
LEFT JOIN movies ON genres.genre_id = movies.genre_id 
GROUP BY genres.genre_name;

-- Get the genre with the most movies.
SELECT TOP 1 genres.genre_name 
FROM genres 
LEFT JOIN movies ON genres.genre_id = movies.genre_id 
GROUP BY genres.genre_name 
ORDER BY COUNT(movies.movie_id) DESC;

-- Retrieve all movies directed by a specific director.
SELECT movies.title FROM movies 
JOIN directors ON movies.director_id = directors.director_id 
WHERE directors.director_name = 'Christopher Nolan';

-- Find directors who have directed more than 1 movies.
SELECT directors.director_name 
FROM directors 
JOIN movies ON directors.director_id = movies.director_id 
GROUP BY directors.director_name 
HAVING COUNT(movies.movie_id) > 1;

-- Find all actors who acted in a specific movie.
SELECT actors.actor_name FROM actors 
JOIN movie_table ON actors.actor_id = movie_table.actor_id 
JOIN movies ON movie_table.movie_id = movies.movie_id 
WHERE movies.title = 'Inception';

-- Retrieve the most frequently appearing actor.
SELECT TOP 1 actors.actor_name FROM actors 
JOIN movie_table ON actors.actor_id = movie_table.actor_id 
GROUP BY actors.actor_name 
ORDER BY COUNT(movie_table.movie_id) DESC;

-- Find all movies where a specific actor has worked.
SELECT movies.title FROM movies 
JOIN movie_table ON movies.movie_id = movie_table.movie_id 
JOIN actors ON movie_table.actor_id = actors.actor_id 
WHERE actors.actor_name = 'Leonardo DiCaprio';

-- Get the count of movies each actor has worked in.
SELECT actors.actor_name, COUNT(movie_table.movie_id) AS movie_count 
FROM actors 
JOIN movie_table ON actors.actor_id = movie_table.actor_id 
GROUP BY actors.actor_name 
ORDER BY movie_count DESC;

-- Get all movies a specific user is currently watching.
SELECT movies.title FROM movies 
JOIN watchlist ON movies.movie_id = watchlist.movie_id 
WHERE watchlist.user_id = 1 AND watchlist.status = 'Watching';

-- Find how many users have completed a specific movie.
SELECT COUNT(user_id) AS completed_users FROM watchlist 
WHERE movie_id = 3 AND status = 'Completed';

-- Retrieve the average rating of a movie.
SELECT movie_id, AVG(rating) AS average_rating FROM reviews 
WHERE movie_id = 1 
GROUP BY movie_id;

-- Find the most reviewed movies
SELECT TOP 3 movie_id, COUNT(review_id) AS review_count FROM reviews 
GROUP BY movie_id 
ORDER BY review_count DESC;
