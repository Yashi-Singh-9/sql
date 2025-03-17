sqlite3 social_media_analytics.db

-- Users Table
CREATE TABLE users(
  user_id INTEGER PRIMARY KEY,
  name VARCHAR(50),
  email VARCHAR(50),
  join_date DATE
);

-- Books Table 
create TABLE books (
  book_id INTEGER PRIMARY KEY,
  title VARCHAR(50),
  author VARCHAR(50),
  genre VARCHAR(50),
  published_year DATE
);

-- Ratings Table 
CREATE Table ratings (
  rating_id INTEGER PRIMARY KEY,
  user_id INTEGER,
  book_id INTEGER,
  rating INTEGER,
  review VARCHAR,
  FOREIGN Key (user_id) REFERENCES users(user_id),
  FOREIGN Key (book_id) REFERENCES books(book_id)
);  

-- Recommendations Table 
CREATE TABLE recommendations (
  rec_id INTEGER Primary Key,
  user_id INTEGER,
  book_id INTEGER,
  recommended_by INTEGER,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (book_id) REFERENCES books(book_id)
);

INSERT INTO users (user_id, name, email, join_date) VALUES
(1, 'Alice Johnson', 'alice@example.com', '2023-05-12'),
(2, 'Bob Smith', 'bob.smith@example.com', '2022-11-08'),
(3, 'Charlie Brown', 'charlie@example.com', '2024-01-20'),
(4, 'Diana Miller', 'diana.m@example.com', '2023-07-15'),
(5, 'Edward Wilson', 'edward.w@example.com', '2022-09-30'),
(6, 'Fiona Davis', 'fiona.d@example.com', '2023-03-22'),
(7, 'George Clark', 'george.c@example.com', '2024-02-10'),
(8, 'Hannah Lewis', 'hannah.l@example.com', '2021-12-05'),
(9, 'Ian Roberts', 'ian.r@example.com', '2023-08-17'),
(10, 'Jessica Martinez', 'jessica.m@example.com', '2022-06-25');

INSERT INTO books (book_id, title, author, genre, published_year) VALUES
(1, 'To Kill a Mockingbird', 'Harper Lee', 'Fiction', 1960),
(2, '1984', 'George Orwell', 'Dystopian', 1949),
(3, 'Pride and Prejudice', 'Jane Austen', 'Romance', 1813),
(4, 'The Great Gatsby', 'F. Scott Fitzgerald', 'Classic', 1925),
(5, 'Moby-Dick', 'Herman Melville', 'Adventure', 1851),
(6, 'War and Peace', 'Leo Tolstoy', 'Historical', 1869),
(7, 'The Catcher in the Rye', 'J.D. Salinger', 'Fiction', 1951),
(8, 'Brave New World', 'Aldous Huxley', 'Science Fiction', 1932),
(9, 'The Hobbit', 'J.R.R. Tolkien', 'Fantasy', 1937),
(10, 'Crime and Punishment', 'Fyodor Dostoevsky', 'Psychological Fiction', 1866);

INSERT INTO ratings (rating_id, user_id, book_id, rating, review) VALUES
(1, 1, 3, 5, 'An absolute classic! Loved every page.'),
(2, 2, 5, 4, 'A bit long but a great adventure.'),
(3, 3, 2, 5, 'Thought-provoking and chilling. A must-read.'),
(4, 4, 1, 5, 'A masterpiece that stays with you forever.'),
(5, 5, 4, 3, 'Well-written, but not my style.'),
(6, 1, 7, 4, 'Interesting characters and storyline.'),
(7, 3, 9, 5, 'One of my favorite fantasy books!'),
(8, 6, 6, 4, 'A deep and complex novel, worth the read.'),
(9, 7, 8, 5, 'A fascinating take on the future.'),
(10, 8, 10, 5, 'Dostoevsky at his best!'),
(11, 2, 2, 4, 'Really makes you think about society.'),
(12, 4, 9, 5, 'Tolkien’s storytelling is magical.'),
(13, 5, 1, 5, 'A must-read classic with deep themes.'),
(14, 6, 3, 4, 'Loved the romance and witty dialogues.'),
(15, 9, 7, 3, 'Did not connect with the main character.'),
(16, 10, 10, 5, 'One of the greatest novels ever written.'),
(17, 1, 4, 4, 'A great look into the roaring twenties.'),
(18, 2, 5, 2, 'Found it too slow and wordy.'),
(19, 3, 8, 5, 'A visionary and unsettling book.'),
(20, 7, 6, 4, 'Historical fiction at its finest.'),
(21, 8, 3, 5, 'An amazing read, full of deep themes.'),
(22, 9, 1, 4, 'Timeless and beautifully written.'),
(23, 10, 9, 5, 'Brilliant world-building and storytelling.'),
(24, 3, 5, 3, 'A bit overrated in my opinion.'),
(25, 5, 8, 4, 'A fantastic piece of literature.'),
(26, 6, 2, 5, 'Still relevant after all these years.'),
(27, 7, 4, 3, 'Did not enjoy it as much as I hoped.'),
(28, 8, 7, 4, 'A great fantasy novel with rich lore.'),
(29, 9, 10, 5, 'Dostoevsky’s depth is unmatched.'),
(30, 10, 6, 4, 'A well-written historical drama.');

INSERT INTO recommendations (rec_id, user_id, book_id, recommended_by) VALUES
(1, 1, 3, 'Bob Smith'),
(2, 2, 5, 'Alice Johnson'),
(3, 3, 2, 'Diana Miller'),
(4, 4, 1, 'Edward Wilson'),
(5, 5, 4, 'Charlie Brown'),
(6, 6, 7, 'Bob Smith'),
(7, 7, 9, 'Hannah Lewis'),
(8, 8, 6, 'George Clark'),
(9, 9, 8, 'Jessica Martinez'),
(10, 10, 10, 'Fiona Davis'),
(11, 1, 2, 'Charlie Brown'),
(12, 2, 9, 'Edward Wilson'),
(13, 3, 1, 'Hannah Lewis'),
(14, 4, 3, 'George Clark'),
(15, 5, 7, 'Ian Roberts'),
(16, 6, 10, 'Diana Miller'),
(17, 7, 4, 'Bob Smith'),
(18, 8, 5, 'Alice Johnson'),
(19, 9, 8, 'Charlie Brown'),
(20, 10, 6, 'Edward Wilson'),
(21, 1, 8, 'Fiona Davis'),
(22, 2, 3, 'Hannah Lewis'),
(23, 3, 5, 'Ian Roberts'),
(24, 4, 7, 'Jessica Martinez'),
(25, 5, 2, 'Alice Johnson'),
(26, 6, 9, 'Charlie Brown'),
(27, 7, 1, 'Hannah Lewis'),
(28, 8, 4, 'Bob Smith'),
(29, 9, 10, 'Jessica Martinez'),
(30, 10, 6, 'Diana Miller');

-- Find all books in the "Science Fiction" genre.
SELECT * 
from books
WHERE genre = 'Science Fiction';

-- Get the top 5 highest-rated books.
SELECT book_id, title, AVG(rating) AS avg_rating
FROM Ratings
JOIN Books USING (book_id)
GROUP BY book_id, title
ORDER BY avg_rating DESC
LIMIT 5;

-- Find users who have rated at least 3 books.
SELECT user_id, COUNT(rating_id) AS total_ratings
FROM Ratings
GROUP BY user_id
HAVING COUNT(rating_id) >= 3;

-- List all books along with their average ratings.
SELECT b.book_id, b.title, COALESCE(AVG(r.rating), 0) AS avg_rating
FROM Books b
LEFT JOIN Ratings r ON b.book_id = r.book_id
GROUP BY b.book_id, b.title
ORDER BY avg_rating DESC;

-- Get a list of books recommended by a specific user.
SELECT b.book_id, b.title, b.author
FROM Recommendations r
JOIN Books b ON r.book_id = b.book_id
JOIN Users u ON r.recommended_by = u.name
WHERE u.name = 'Alice Johnson';

-- Find the genre with the highest number of books.
SELECT genre, COUNT(book_id) AS book_count
FROM Books
GROUP BY genre
ORDER BY book_count DESC
LIMIT 1;

-- Get the most active user (who has given the most ratings).
SELECT user_id, COUNT(rating_id) AS total_ratings
FROM Ratings
GROUP BY user_id
ORDER BY total_ratings DESC
LIMIT 1;

-- Find users who have rated all books of a specific author.
SELECT r.user_id
FROM Ratings r
JOIN Books b ON r.book_id = b.book_id
WHERE b.author = 'George Orwell'
GROUP BY r.user_id
HAVING COUNT(DISTINCT r.book_id) = (  
    SELECT COUNT(*)  
    FROM Books  
    WHERE author = 'George Orwell'  
);
