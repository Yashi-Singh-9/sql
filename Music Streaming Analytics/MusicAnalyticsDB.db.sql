-- Music Analytics Database Creation 
sqlite3 MusicAnalyticsDB.db

-- Use of the Database 
USE MusicAnalyticsDB;

PRAGMA foreign_keys = ON;

-- Creation of Table
-- User Table
CREATE TABLE users (
  user_id INTEGER PRIMARY KEY,
  username VARCHAR,
  email VARCHAR,
  subscription_type TEXT CHECK(subscription_type IN ('Free', 'Premium')),
  country VARCHAR,
  date_joined DATE
);

-- Songs Table 
CREATE table songs (
  songs_id INTEGER PRIMARY KEY,
  title VARCHAR,
  artist_id INTEGER,
  album_id INTEGER,
  genre VARCHAR,
  duration_in_seconds INTEGER,
  release_year INTEGER,
  FOREIGN KEY (artist_id) REFERENCES artists(artist_id),
  FOREIGN Key (album_id) REFERENCES albums(album_id)
);

-- Artists Table 
Create TABLE artists (
  artist_id INTEGER PRIMARY KEY,
  name VARCHAR,
  country VARCHAR,
  debut_year INTEGER
);

-- Albums Table 
CREATE TABLE albums (
  album_id INTEGER PRIMARY KEY,
  title VARCHAR,
  artist_id INTEGER,
  releases_year INTEGER,
  FOREIGN KEY (artist_id) REFERENCES artists(artist_id)
);

-- Stream History Table
Create TABLE streaming_history (
  stream_id INTEGER PRIMARY Key,
  user_id INTEGER,
  songs_id INTEGER,
  playback_duration_in_seconds INTEGER,
  time_stamp datetime,
  FOREIGN Key (user_id) REFERENCES users(user_id),
  FOREIGN KEY (songs_id) REFERENCES songs(songs_id)
);

-- Playlists Table 
CREATE Table playlist (
  playlist_id INTEGER PRIMARY Key,
  user_id INTEGER,
  name VARCHAR,
  created_at datetime,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);  

-- Playlist Songs 
CREATE TABLE playlist_songs (
  playlist_id INTEGER,
  songs_id INTEGER,
  FOREIGN Key (playlist_id) REFERENCES playlist(playlist_id),
  FOREIGN Key (songs_id) REFERENCES songs(songs_id)
);  

-- Subscription Table
CREATE TABLE subscription (
  subscription_id INTEGER PRIMARY Key,
  user_id INTEGER,
  subscription_type VARCHAR,
  start_date DATE,
  end_date DATE,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);  

-- Insertion in the Tables 
-- Users Table
INSERT INTO users (username, email, subscription_type, country, date_joined)
VALUES
('john_doe', 'john.doe@example.com', 'Premium', 'USA', '2023-06-15'),
('jane_smith', 'jane.smith@example.com', 'Free', 'UK', '2022-09-20'),
('alex_wong', 'alex.wong@example.com', 'Premium', 'Canada', '2021-12-05'),
('maria_garcia', 'maria.gracia@example.com', 'Free', 'Mexico', '2023-01-11'),
('li_chen', 'li.chen@example.com', 'Premium', 'China', '2022-05-25'),
('kofi_mensah', 'kofi.mensah@example.com', 'Free', 'Ghana', '2023-07-30'),
('emma_johnson', 'emma.johnson@example.com', 'Premium', 'Australia', '2022-11-15'),
('pierre_dubois', 'pierre.dubois@example.com', 'Free', 'France', '2023-04-22'),
('hiro_tanaka', 'hiro.tanaka@example.com', 'Premium', 'Japan', '2022-02-10'),
('fatima_khan', 'fatima.khan@example.com', 'Free', 'India', '2022-02-10');

-- Insert into Artists Table
INSERT INTO artists (name, country, debut_year)
VALUES
('The Weekend', 'Canada', 2010),
('Queen', 'UK', 1970),
('Ed Sheeran', 'UK', 2011),
('Nirvana', 'USA', 1987),
('Eminem', 'USA', 1996),
('Adele', 'UK', 2006),
('Luis Fonsi', 'Puerto Rico', 1998),
('Eagles', 'USA', 1971),
('Bruno Mars', 'USA', 2004),
('Leonard Cohen', 'Canada', 1967);

-- Insert into Albums Table (Using artist_id from previous insertions)
INSERT INTO albums (title, releases_year, artist_id)
VALUES
('After Hours', 2020, 1),
('A Night at the Opera', 1975, 2),
('÷ (Divide)', 2017, 3),
('Nevermind', 1991, 4),
('The Eminem Show', 2002, 5),
('21', 2011, 6),
('Vida', 2019, 7),
('Hotel California', 1976, 8),
('Unorthodox Jukebox', 2012, 9),
('Various Positions', 1984, 10);

-- Insert into Songs Table (Using artist_id and album_id from the previous insertions)
INSERT INTO songs (title, genre, duration_in_seconds, release_year, artist_id, album_id)
VALUES
('Blinding Lights', 'Pop', 200, 2019, 1, 1),
('Bohemian Rhapsody', 'Rock', 354, 1975, 2, 2),
('Shape of You', 'Pop', 233, 2017, 3, 3),
('Smells like Teen Spirit', 'Grunge', 301, 1991, 4, 4),
('Lose Yourself', 'Hip Hop', 326, 2002, 5, 5),
('Rolling in the Deep', 'Soul', 228, 2010, 6, 6),
('Despacito', 'Reggaeton', 229, 2017, 7, 7),
('Hotel California', 'Rock', 390, 1976, 8, 8),
('Uptown Funk', 'Funk', 270, 2014, 9, 9),
('Hallelujah', 'Folk', 280, 1984, 10, 10);

-- Insert into Streaming History Table (Using user_id and songs_id dynamically)
INSERT INTO streaming_history (user_id, songs_id, playback_duration_in_seconds, time_stamp)
VALUES
(1, 1, 180, '2024-02-01 12:30:45'),
(2, 2, 240, '2024-02-01 14:05:22'),
(3, 3, 150, '2024-02-02 09:15:10'),
(4, 4, 300, '2024-02-02 18:45:33'),
(5, 5, 210, '2024-02-03 07:25:50'),
(6, 6, 120, '2024-02-03 22:10:15'),
(7, 7, 195, '2024-02-04 15:55:40'),
(8, 8, 275, '2024-02-04 20:20:05'),
(9, 9, 310, '2024-02-05 10:05:55'),
(10, 10, 260, '2024-02-05 16:40:30');

-- Insert into Playlist Table (Using user_id dynamically)
INSERT INTO playlist (user_id, name, created_at)
VALUES
(1, 'Top Hits 2024', '2024-01-10 14:30:00'),
(2, 'Chill Vibes', '2023-12-05 09:15:20'),
(3, 'Workout Mix', '2024-02-01 06:45:10'),
(4, 'Throwback Classics', '2023-11-20 18:25:35'),
(5, 'Road Trip Tunes', '2024-01-25 12:00:50'),
(6, 'Relax & Unwind', '2023-10-15 22:40:05'),
(7, 'Party Bangers', '2024-02-03 20:15:45'),
(8, 'Acoustic Sessions', '2023-09-30 16:50:30'),
(9, 'Hip Hop Essentials', '2024-01-05 11:05:15'),
(10, 'Indie Favorites', '2023-12-18 08:35:55');

-- Insert into Playlist Songs Table (Using playlist_id and songs_id dynamically)
INSERT INTO playlist_songs (playlist_id, songs_id)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);

-- Insert into Subscription Table (Using user_id dynamically)
INSERT INTO subscription (user_id, subscription_type, start_date, end_date)
VALUES
(1, 'Free', '2024-01-10', NULL),
(2, 'Premium', '2023-12-05', '2024-12-05'),
(3, 'Free', '2024-02-01', NULL),
(4, 'Premium', '2023-11-20', '2024-11-20'),
(5, 'Premium', '2024-01-25', '2025-01-25'),
(6, 'Free', '2023-10-15', NULL),
(7, 'Premium', '2024-02-03', '2025-02-03'),
(8, 'Free', '2023-09-30', NULL),
(9, 'Premium', '2024-01-05', '2025-01-05'),
(10, 'Free', '2023-12-18', NULL);

-- Find the total number of active users.
SELECT COUNT(DISTINCT user_id) AS active_users  
FROM Streaming_History;

-- List the top 5 most active users based on their streaming history.
SELECT user_id, count(stream_id) as total_stream
from streaming_history
GROUP by user_id
order by total_stream DESC
LIMIT 5;

-- Find out which country has the most number of users.
SELECT country, COUNT(user_id) AS total_users  
FROM Users  
GROUP BY country  
ORDER BY total_users DESC  
LIMIT 1;

-- Identify users who have never played a song.
SELECT u.user_id, u.username  
FROM Users u  
LEFT JOIN Streaming_History sh ON u.user_id = sh.user_id  
WHERE sh.user_id IS NULL;

-- Identify the top 10 most streamed songs.
SELECT s.songs_id, s.title, COUNT(sh.stream_id) AS total_streams  
FROM songs s  
JOIN streaming_history sh ON s.songs_id = sh.songs_id  
GROUP BY s.songs_id, s.title  
ORDER BY total_streams DESC  
LIMIT 10;

-- Identify the most common cancellation month for premium users.
SELECT strftime('%m', end_date) AS cancellation_month, COUNT(*) AS cancellations  
FROM subscription  
WHERE subscription_type = 'Premium'  
GROUP BY cancellation_month  
ORDER BY cancellations DESC  
LIMIT 1;

-- Find the most popular day of the week for streaming.
SELECT strftime('%w', time_stamp) AS day_of_week, COUNT(*) AS total_streams  
FROM streaming_history  
GROUP BY day_of_week  
ORDER BY total_streams DESC  
LIMIT 1;

