sqlite3 music_recommendation.db

-- Users Table 
create table users (
  user_id INTEGER PRIMARY KEY,
  username VARCHAR(50),
  email VARCHAR(50),
  date_joined DATE
);

-- Songs Table
create table songs (
  song_id INTEGER PRIMARY KEY,
  title VARCHAR(50),
  artist_id INTEGER,
  album_id INTEGER,
  genre_id INTEGER,
  release_date DATE,
  duration INTEGER,
  FOREIGN KEY (artist_id) REFERENCES artists(artist_id),
  FOREIGN KEY (album_id) REFERENCES albums(album_id),
  FOREIGN KEY (genre_id) REFERENCES genres(genre_id)
);  

-- Artists Table
create table artists (
  artist_id INTEGER PRIMARY KEY,
  artist_name VARCHAR(50),
  country VARCHAR(50)
);

-- Albums Table
CREATE TABLE albums (
  album_id INTEGER PRIMARY KEY,
  album_name VARCHAR(50),
  release_year DATE,
  artist_id INTEGER,
  FOREIGN KEY (artist_id) REFERENCES artists(artist_id)
);  
 
-- Genres Table
CREATE TABLE genres (
  genre_id INTEGER PRIMARY KEY,
  genre_name VARCHAR(50)
);  

-- Playlists Table
create table playlists (
  playlist_id INTEGER PRIMARY KEY,
  playlist_name VARCHAR,
  user_id INTEGER,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);  

-- Playlist Songs Table 
create table playlists_songs (
  playlist_id INTEGER,
  song_id INTEGER,
  FOREIGN KEY (playlist_id) REFERENCES playlists(playlist_id),
  FOREIGN KEY (song_id) REFERENCES songs(song_id)
);

-- User History 
create table user_history(
  history_id INTEGER PRIMARY KEY,
  user_id INTEGER,
  song_id INTEGER,
  timestamp TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (song_id) REFERENCES songs(song_id)
);  

-- Recommendations Table
CREATE table recommendation (
  rec_id INTEGER PRIMARY KEY,
  user_id INTEGER,
  song_id INTEGER,
  reason VARCHAR,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (song_id) REFERENCES sonngs(song_id)
);  

INSERT INTO users (user_id, username, email, date_joined) VALUES
(1, 'jdoe', 'jdoe@example.com', '2023-01-15'),
(2, 'asmith', 'asmith@example.com', '2023-02-20'),
(3, 'mjones', 'mjones@example.com', '2023-03-05'),
(4, 'kbrown', 'kbrown@example.com', '2023-04-10'),
(5, 'lwilson', 'lwilson@example.com', '2023-05-22');

INSERT INTO artists (artist_id, artist_name, country) VALUES
(101, 'The Weekend', 'Canada'),
(102, 'Adele', 'UK'),
(103, 'Drake', 'Canada'),
(104, 'Beyoncé', 'USA'),
(105, 'Ed Sheeran', 'UK'),
(106, 'Taylor Swift', 'USA'),
(107, 'Post Malone', 'USA');

INSERT INTO albums (album_id, album_name, release_year, artist_id) VALUES
(201, 'After Hours', 2020, 101),
(202, '30', 2021, 102),
(203, 'Certified Lover Boy', 2021, 103),
(204, 'Renaissance', 2022, 104),
(205, 'Divide', 2017, 105),
(206, 'Lover', 2019, 106),
(207, 'Hollywood’s Bleeding', 2019, 107),
(208, 'Starboy', 2016, 101);

INSERT INTO genres (genre_id, genre_name) VALUES
(301, 'Pop'),
(302, 'R&B'),
(303, 'Hip-Hop'),
(304, 'Rock'),
(305, 'Electronic'),
(306, 'Jazz'),
(307, 'Country');

INSERT INTO songs (song_id, title, artist_id, album_id, genre_id, release_date, duration) VALUES
(401, 'Blinding Lights', 101, 201, 301, '2020-03-20', '3:20'),
(402, 'Easy On Me', 102, 202, 301, '2021-10-15', '3:44'),
(403, 'God’s Plan', 103, 203, 303, '2018-01-19', '3:18'),
(404, 'Break My Soul', 104, 204, 302, '2022-06-21', '4:38'),
(405, 'Shape of You', 105, 205, 301, '2017-01-06', '3:53'),
(406, 'Circles', 107, 207, 305, '2019-08-30', '3:35'),
(407, 'Can’t Feel My Face', 101, 208, 302, '2015-06-08', '3:33'),
(408, 'Lover', 106, 206, 307, '2019-08-23', '3:41'),
(409, 'Take Care', 103, 203, 303, '2011-11-15', '4:37'),
(410, 'Starboy', 101, 208, 305, '2016-09-22', '3:50');

INSERT INTO playlists (playlist_id, playlist_name, user_id) VALUES
(501, 'Chill Vibes', 1),
(502, 'Workout Mix', 2),
(503, 'Party Hits', 3),
(504, 'Relax & Unwind', 4),
(505, 'Top 2023', 5),
(506, 'Morning Boost', 1),
(507, 'Late Night Jams', 3),
(508, 'Throwback Classics', 4),
(509, 'Indie Vibes', 2),
(510, 'Road Trip Mix', 5);

INSERT INTO playlists_songs (playlist_id, song_id) VALUES
(501, 401), (501, 402), (501, 403),
(502, 404), (502, 405), (502, 401),
(503, 402), (503, 406), (503, 407),
(504, 408), (504, 409), (504, 410),
(505, 403), (505, 406), (505, 407),
(506, 401), (506, 405), (506, 408),
(507, 409), (507, 410), (507, 403),
(508, 402), (508, 404), (508, 407),
(509, 408), (509, 406), (509, 410),
(510, 403), (510, 405), (510, 407);

INSERT INTO user_history (history_id, user_id, song_id, timestamp) VALUES
(601, 1, 401, '2024-02-01 12:30:45'),
(602, 2, 402, '2024-02-02 14:15:30'),
(603, 3, 403, '2024-02-03 16:45:10'),
(604, 4, 404, '2024-02-04 18:20:55'),
(605, 5, 405, '2024-02-05 20:10:05'),
(606, 1, 406, '2024-02-06 21:15:30'),
(607, 2, 407, '2024-02-07 23:00:10'),
(608, 3, 408, '2024-02-08 01:05:45'),
(609, 4, 409, '2024-02-09 02:40:20'),
(610, 5, 410, '2024-02-10 04:55:30'),
(611, 1, 401, '2024-02-11 10:20:15'),
(612, 3, 403, '2024-02-12 11:45:00');

INSERT INTO recommendation (rec_id, user_id, song_id, reason) VALUES
(701, 1, 403, 'Based on your recent listens'),
(702, 2, 404, 'Similar to your favorite genre'),
(703, 3, 401, 'Trending in your area'),
(704, 4, 405, 'Because you liked Ed Sheeran'),
(705, 5, 402, 'Most played this week'),
(706, 1, 406, 'Suggested by friends'),
(707, 2, 407, 'Top rated by critics'),
(708, 3, 408, 'Viral on social media'),
(709, 4, 409, 'Best of 2024'),
(710, 5, 410, 'Award-winning hit'),
(711, 1, 401, 'Personalized for you'),
(712, 3, 403, 'Great match for your taste');

-- Find the top 5 most played songs.
SELECT s.song_id, s.title, COUNT(uh.song_id) AS play_count
FROM User_History uh
JOIN Songs s ON uh.song_id = s.song_id
GROUP BY s.song_id, s.title
ORDER BY play_count DESC
LIMIT 5;

-- Retrieve the most popular artist based on song plays.
SELECT a.artist_id, a.artist_name, COUNT(uh.song_id) AS total_plays
FROM User_History uh
JOIN Songs s ON uh.song_id = s.song_id
JOIN Artists a ON s.artist_id = a.artist_id
GROUP BY a.artist_id, a.artist_name
ORDER BY total_plays DESC
LIMIT 1;

-- Get all songs recommended for a specific user.
SELECT r.user_id, s.song_id, s.title, s.artist_id, a.artist_name, r.reason
FROM recommendation r
JOIN Songs s ON r.song_id = s.song_id
JOIN Artists a ON s.artist_id = a.artist_id
WHERE r.user_id = 5;

-- Find all playlists that contain a specific song.
SELECT ps.song_id, s.title, p.playlist_id, p.playlist_name, p.user_id
FROM playlists_songs ps
JOIN Playlists p ON ps.playlist_id = p.playlist_id
JOIN Songs s ON ps.song_id = s.song_id
WHERE ps.song_id = 2;

-- Find all songs by a specific artist.
SELECT s.song_id, s.title, s.album_id, a.album_name, s.genre_id, g.genre_name, s.release_date, s.duration
FROM Songs s
JOIN Albums a ON s.album_id = a.album_id
JOIN Genres g ON s.genre_id = g.genre_id
WHERE s.artist_id = 102;

-- Get the latest songs added to the database.
SELECT s.song_id, s.title, s.artist_id, a.artist_name, s.album_id, al.album_name, s.genre_id, g.genre_name, s.release_date, s.duration
FROM Songs s
JOIN Artists a ON s.artist_id = a.artist_id
JOIN Albums al ON s.album_id = al.album_id
JOIN Genres g ON s.genre_id = g.genre_id
ORDER BY s.release_date DESC
LIMIT 6;

-- Retrieve all songs from a specific album.
SELECT s.song_id, s.title, s.artist_id, a.artist_name, s.genre_id, g.genre_name, s.release_date, s.duration
FROM Songs s
JOIN Artists a ON s.artist_id = a.artist_id
JOIN Genres g ON s.genre_id = g.genre_id
WHERE s.album_id = 203;

-- Find users who have similar music tastes (users with the most common song history).
SELECT uh1.user_id AS user1, uh2.user_id AS user2, COUNT(uh1.song_id) AS common_songs
FROM User_History uh1
JOIN User_History uh2 ON uh1.song_id = uh2.song_id AND uh1.user_id < uh2.user_id
GROUP BY uh1.user_id, uh2.user_id
ORDER BY common_songs DESC;



