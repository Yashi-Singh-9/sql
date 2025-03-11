-- Create Database for entertainment franchises
sqlite3 entertainment_franchise.db

-- Use the created Database
USE entertainment_franchise;

-- Create a table to store franchise details
CREATE TABLE franchises (
    franchise VARCHAR(255) PRIMARY KEY,
    inception_year INT,
    total_revenue_busd DECIMAL(10,2),
    original_medium VARCHAR(50),
    owner VARCHAR(255),
    n_movies INT
);

-- Insert franchise data into the table
INSERT INTO franchises (franchise, inception_year, total_revenue_busd, original_medium, owner, n_movies)  
VALUES  
    ('Star Wars', 1977, 46.7, 'movie', 'The Walt Disney Company', 12),  
    ('Mickey Mouse and Friends', 1928, 52.2, 'cartoon', 'The Walt Disney Company', NULL),  
    ('Anpanman', 1973, 38.4, 'book', 'Froebel-kan', 33),  
    ('Winnie the Pooh', 1924, 48.5, 'book', 'The Walt Disney Company', 6),  
    ('Pokémon', 1996, 88.0, 'video game', 'The Pokémon Company', 24),  
    ('Disney Princess', 2000, 45.4, 'movie', 'The Walt Disney Company', NULL),  
    ('Marvel Cinematic Universe', 2008, 40.0, 'comic', 'The Walt Disney Company', 32),  
    ('Harry Potter', 1997, 39.8, 'book', 'Warner Bros.', 11),  
    ('Spider-Man', 1962, 31.8, 'comic', 'The Walt Disney Company', 10),  
    ('Batman', 1939, 29.0, 'comic', 'Warner Bros.', 14),  
    ('Super Mario', 1985, 38.0, 'video game', 'Nintendo', 3),  
    ('The Lord of the Rings', 1954, 30.0, 'book', 'Warner Bros.', 6),  
    ('Transformers', 1984, 29.6, 'toy', 'Hasbro', 7),  
    ('James Bond', 1953, 19.9, 'book', 'Eon Productions', 27),  
    ('Frozen', 2013, 18.0, 'movie', 'The Walt Disney Company', 2),
    ('The Simpsons', 1987, 15.0, 'TV Show', '20th Television', NULL),  
    ('SpongeBob SquarePants', 1999, 20.0, 'TV Show', 'Nickelodeon', 3),  
    ('The Legend of Zelda', 1986, 10.3, 'video game', 'Nintendo', NULL);   
        
-- Retrieve all columns from the table
SELECT * FROM franchises;

-- Retrieve only the franchise column
SELECT franchise FROM franchises;

-- Retrieve specific columns: franchise and inception_year
SELECT franchise, inception_year FROM franchises;

-- Rename inception_year as creation_year
SELECT franchise, inception_year AS creation_year FROM franchises;

-- Sort franchises by inception_year in ascending order
SELECT franchise, inception_year FROM franchises ORDER BY inception_year ASC;

-- Sort franchises by inception_year in descending order
SELECT franchise, inception_year FROM franchises ORDER BY inception_year DESC;

-- Retrieve the first 3 rows
SELECT * FROM franchises LIMIT 3;

-- Get franchises where inception_year is greater than 1928
SELECT franchise, inception_year FROM franchises WHERE inception_year > 1928;

-- Get franchises where inception_year is greater than or equal to 1928
SELECT franchise, inception_year FROM franchises WHERE inception_year >= 1928;

-- Get franchises where inception_year is less than 1977
SELECT franchise, inception_year FROM franchises WHERE inception_year < 1977;

-- Get franchises where inception_year is less than or equal to 1977
SELECT franchise, inception_year FROM franchises WHERE inception_year <= 1977;

-- Get franchises where inception_year is equal to 1996
SELECT franchise, inception_year FROM franchises WHERE inception_year = 1996;

-- Get franchises where inception_year is not equal to 1996
SELECT franchise, inception_year FROM franchises WHERE inception_year <> 1996;

-- Get franchises with inception_year between 1928 and 1977 (inclusive)
SELECT franchise, inception_year FROM franchises WHERE inception_year BETWEEN 1928 AND 1977;

-- Get franchises where original_medium is 'book'
SELECT franchise, original_medium FROM franchises WHERE original_medium = 'book';

-- Get franchises where original_medium is either 'movie' or 'video game'
SELECT franchise, original_medium FROM franchises WHERE original_medium IN ('movie', 'video game');

-- Get franchises where original_medium contains 'oo'
SELECT franchise, original_medium FROM franchises WHERE original_medium LIKE '%oo%';

-- Get franchises where inception_year is less than 1950 and total_revenue_busd is more than 50
SELECT franchise, inception_year, total_revenue_busd FROM franchises WHERE inception_year < 1950 AND total_revenue_busd > 50;

-- Get franchises where n_movies is NULL
SELECT franchise, n_movies FROM franchises WHERE n_movies IS NULL;

-- Get franchises where n_movies is NOT NULL
SELECT franchise, n_movies FROM franchises WHERE n_movies IS NOT NULL;

-- Count total franchises
SELECT COUNT(*) FROM franchises;

-- Sum of total revenue across all franchises
SELECT SUM(total_revenue_busd) FROM franchises;

-- Calculate the average total revenue of all franchises
SELECT AVG(total_revenue_busd) FROM franchises;

-- Get the maximum total revenue among all franchises
SELECT MAX(total_revenue_busd) FROM franchises;

-- Count franchises by owner
SELECT owner, COUNT(*) FROM franchises GROUP BY owner;

-- Get the total number of movies produced for each original medium
SELECT original_medium, SUM(n_movies) AS total_movies FROM franchises GROUP BY original_medium ORDER BY total_movies DESC;

-- Get the total number of movies for each original medium where total_movies is greater than 10
SELECT original_medium, SUM(n_movies) AS total_movies FROM franchises GROUP BY original_medium HAVING total_movies > 10 ORDER BY total_movies DESC;

-- Get the total number of movies for each original medium owned by The Walt Disney Company where total_movies is greater than 10
SELECT original_medium, SUM(n_movies) AS total_movies FROM franchises WHERE owner = 'The Walt Disney Company' GROUP BY original_medium HAVING total_movies > 10 ORDER BY total_movies DESC;
