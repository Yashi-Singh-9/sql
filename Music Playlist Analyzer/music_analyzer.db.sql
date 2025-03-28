sqlite3 music_analyzer.db

USE music_analyzer;

-- Users Table 
CREATE TABLE users (
  user_id INTEGER PRIMARY KEY,
  username VARCHAR(20) UNIQUE,
  email VARCHAR(20) UNIQUE,
  created_at DATE
);

-- Artists Table 
CREATE TABLE artists (
  artist_id INTEGER PRIMARY KEY,
  name VARCHAR(20),
  genre VARCHAR(20)
);

-- Albums Table 
CREATE TABLE albums (
  album_id INTEGER PRIMARY KEY,
  title VARCHAR(10),
  release_year DATE,
  artist_id INTEGER,
  FOREIGN KEY (artist_id) REFERENCES artists(artist_id)
);

-- Songs Table 
CREATE TABLE songs (
  song_id INTEGER PRIMARY KEY,
  title VARCHAR(10),
  duration INTEGER,
  album_id INTEGER,
  artist_id INTEGER,
  FOREIGN KEY (album_id) REFERENCES albums(album_id),
  FOREIGN KEY (artist_id) REFERENCES artists(artist_id)
);

-- Playlists Table 
CREATE Table playlists (
  playlist_id INTEGER PRIMARY KEY,
  name VARCHAR(10),
  user_id INTEGER,
  created_at DATE,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Playlist Songs Table
CREATE TABLE playlist_songs (
  playlist_id INTEGER,
  song_id INTEGER,
  FOREIGN KEY (playlist_id) REFERENCES playlists(playlist_id),
  FOREIGN KEY (song_id) REFERENCES songs(song_id)
);

-- Playback History Table 
CREATE TABLE playback_history (
  history_id INTEGER PRIMARY KEY,
  user_id INTEGER,
  song_id INTEGER,
  played_at DATE,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (song_id) REFERENCES songs(song_id)
);  

-- Insert Users
INSERT INTO users (username, email, created_at) VALUES
('john_doe', 'john@example.com', '2023-01-15'),
('alice_wonder', 'alice@example.com', '2023-02-10'),
('mike_smith', 'mike@example.com', '2023-03-05'),
('sara_connor', 'sara@example.com', '2023-04-20'),
('bob_marley', 'bob@example.com', '2023-05-30'),
('lisa_black', 'lisa@example.com', '2023-06-15'),
('tom_hardy', 'tom@example.com', '2023-07-22');

-- Insert Artists
INSERT INTO artists (name, genre) VALUES
('The Beatles', 'Rock'),
('Drake', 'Hip-Hop'),
('Adele', 'Pop'),
('Eminem', 'Rap'),
('Coldplay', 'Alternative'),
('Beyoncé', 'R&B'),
('Ed Sheeran', 'Pop');

-- Insert Albums
INSERT INTO albums (title, release_year, artist_id) VALUES
('Revolver', '1966-08-05', 1),
('Scorpion', '2018-06-29', 2),
('25', '2015-11-20', 3),
('The Eminem Show', '2002-05-26', 4),
('Parachutes', '2000-07-10', 5),
('Lemonade', '2016-04-23', 6),
('Divide', '2017-03-03', 7);

-- Insert Songs
INSERT INTO songs (title, duration, album_id, artist_id) VALUES
('Yesterday', 125, 1, 1),
('Gods Plan', 198, 2, 2),
('Hello', 300, 3, 3),
('Without Me', 290, 4, 4),
('Yellow', 250, 5, 5),
('Formation', 220, 6, 6),
('Shape of You', 240, 7, 7),
('In My Feelings', 215, 2, 2),
('Someone Like You', 285, 3, 3);

-- Insert Playlists
INSERT INTO playlists (name, user_id, created_at) VALUES
('Rock Hits', 1, '2023-08-01'),
('Chill Vibes', 2, '2023-08-15'),
('Hip-Hop Mix', 3, '2023-09-01'),
('Classic Pop', 4, '2023-09-10'),
('Workout Tunes', 5, '2023-10-05'),
('Throwback', 6, '2023-11-12'),
('Party Jams', 7, '2023-12-01');

-- Insert Playlist Songs
INSERT INTO playlist_songs (playlist_id, song_id) VALUES
(1, 1), (1, 5), (1, 7),
(2, 2), (2, 3), (2, 6),
(3, 4), (3, 8), (3, 2),
(4, 9), (4, 1), (4, 3),
(5, 6), (5, 7), (5, 4),
(6, 2), (6, 8), (6, 9),
(7, 5), (7, 1), (7, 6);

-- Insert Playback History
INSERT INTO playback_history (user_id, song_id, played_at) VALUES
(1, 2, '2024-01-01'),
(2, 3, '2024-01-02'),
(3, 4, '2024-01-03'),
(4, 5, '2024-01-04'),
(5, 6, '2024-01-05'),
(6, 7, '2024-01-06'),
(7, 8, '2024-01-07'),
(1, 9, '2024-01-08'),
(2, 1, '2024-01-09'),
(3, 5, '2024-01-10');

-- Find the top 5 most played songs in playback history.
SELECT s.title, COUNT(ph.song_id) AS play_count
FROM playback_history ph
JOIN songs s ON ph.song_id = s.song_id
GROUP BY s.title
ORDER BY play_count DESC
LIMIT 5;

-- Get the total duration of all songs in a specific playlist.
SELECT p.name AS playlist_name, SUM(s.duration) AS total_duration
FROM playlists p
JOIN playlist_songs ps ON p.playlist_id = ps.playlist_id
JOIN songs s ON ps.song_id = s.song_id
WHERE p.playlist_id = 1 
GROUP BY p.name;

-- Find the most popular artist based on the number of times their songs were played.
SELECT a.name AS artist_name, COUNT(ph.song_id) AS play_count
FROM playback_history ph
JOIN songs s ON ph.song_id = s.song_id
JOIN artists a ON s.artist_id = a.artist_id
GROUP BY a.name
ORDER BY play_count DESC
LIMIT 1;

-- Retrieve all songs in a user’s playlist sorted by duration.
SELECT s.title, s.duration
FROM playlists p
JOIN playlist_songs ps ON p.playlist_id = ps.playlist_id
JOIN songs s ON ps.song_id = s.song_id
WHERE p.user_id = 1 
ORDER BY s.duration ASC;

-- Find the total number of playlists created by each user.
SELECT u.username, COUNT(p.playlist_id) AS total_playlists
FROM users u
LEFT JOIN playlists p ON u.user_id = p.user_id
GROUP BY u.username;

-- List all songs that appear in more than one playlist.
SELECT s.title, COUNT(ps.playlist_id) AS playlist_count
FROM playlist_songs ps
JOIN songs s ON ps.song_id = s.song_id
GROUP BY s.title
HAVING COUNT(ps.playlist_id) > 1;

-- Get the user who has played the most unique songs.
SELECT u.username, COUNT(DISTINCT ph.song_id) AS unique_songs_played
FROM users u
JOIN playback_history ph ON u.user_id = ph.user_id
GROUP BY u.username
ORDER BY unique_songs_played DESC
LIMIT 1;

-- Find the average duration of songs in each playlist.
SELECT p.name AS playlist_name, AVG(s.duration) AS avg_duration
FROM playlists p
JOIN playlist_songs ps ON p.playlist_id = ps.playlist_id
JOIN songs s ON ps.song_id = s.song_id
GROUP BY p.name;

-- List all artists who have songs in a specific user's playlist.
SELECT DISTINCT a.name AS artist_name
FROM playlists p
JOIN playlist_songs ps ON p.playlist_id = ps.playlist_id
JOIN songs s ON ps.song_id = s.song_id
JOIN artists a ON s.artist_id = a.artist_id
WHERE p.user_id = 1; 

-- Get the most recently played song for each user.
SELECT u.username, s.title, MAX(ph.played_at) AS last_played
FROM users u
JOIN playback_history ph ON u.user_id = ph.user_id
JOIN songs s ON ph.song_id = s.song_id
GROUP BY u.username, s.title
ORDER BY last_played DESC;
