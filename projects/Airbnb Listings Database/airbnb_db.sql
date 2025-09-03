-- SQL Lite Project
-- Database Creation
sqlite3 airbnb_db.db

-- Use Database
USE airbnb_db;

-- Table Created
CREATE TABLE airbnb_listings (
    id INTEGER PRIMARY KEY,
    city VARCHAR,
    country VARCHAR,
    number_of_rooms INTEGER,
  	year_listed INTEGER
);

-- Instertion in Table
INSERT Into airbnb_listings ( city, country, number_of_rooms, year_listed )
VALUES ( 'New York', 'USA', 2 , 2021 ),
	   ( 'Paris', 'France', 1 , 2020 ),
	   ( 'Tokyo', 'Japan', 3 , 2022 ),
	   ( 'Sydney', 'Australia', 2 , 2019 ),
	   ( 'London', 'UK', 4 , 2023 ),
	   ( 'Berlin', 'Germany', 3 , 2021 ),
	   ( 'Toronto', 'Canada', 2 , 2020 ),
	   ( 'Rome', 'Itlay', 1 , 2022 ),
	   ( 'Amsterdam', 'Netherlands', 4 , 2019 ),
	   ( 'Mumbai', 'India', 2 , 2023 ),
	   ( 'Dubai', 'UAE', 3 , 2022 ),
	   ( 'Bangkok', 'Thailand', 1 , 2021 ),
	   ( 'Madrid', 'Spain', 2 , 2020 ),
	   ( 'Seoul', 'South Korea', 5 , 2018 ),
	   ( 'Los Amgeles', 'USA', 3 , 2023 ),
	   ( 'Singapore', 'Singapore', 2 , 2022 ),
	   ( 'Istanbul', 'Turkey', 4 , 2019 ),       
	   ( 'Rio de Janeiro', 'Brazil', 3 , 2021 ),
	   ( 'Cape Town', 'South Africa', 1 , 2020 ),
	   ( 'Hong Kong', 'China', 2 , 2023 );

-- Get all the columns from a table
SELECT *
FROM airbnb_listings;

-- Get the city column from the table
SELECT city
FROM airbnb_listings;

-- Get the city and year_listed columns from the table
SELECT city, year_listed
FROM airbnb_listings;

-- Get the listing id, city, ordered by the number_of_rooms in ascending order 
SELECT id, city
FROM airbnb_listings
ORDER BY number_of_rooms ASC;

-- Get the listing id, city, ordered by the number_of_rooms in descending order 
SELECT id, city
FROM airbnb_listings
ORDER BY number_of_rooms DESC;

-- Get the first 5 rows from the airbnb_listings table 
SELECT *
FROM airbnb_listings
LIMIT 5;

-- Get a unique list of cities where there are listings 
SELECT DISTINCT city
FROM airbnb_listings;

-- Get all the listings where number_of_rooms is more or equal to 3
SELECT * 
from airbnb_listings
where number_of_rooms >= 3;

-- Get all the listings where number_of_rooms is more than 3
SELECT * 
from airbnb_listings
where number_of_rooms > 3;

-- Get all the listings where number_of_rooms is exactly equal to 3
SELECT * 
from airbnb_listings
where number_of_rooms = 3;

-- Get all the listings where number_of_rooms is lower or equal to 3
SELECT * 
from airbnb_listings
where number_of_rooms <= 3;

-- Get all the listings where number_of_rooms is lower than 3
SELECT * 
from airbnb_listings
where number_of_rooms < 3;

-- Get all the listings with 3 to 6 rooms
SELECT * 
From airbnb_listings
WHERE number_of_rooms BETWEEN 3 AND 6;

-- Get all the listings that are based in 'Paris'
SELECT * 
from airbnb_listings
where city = 'Paris';

-- Get the listings based in the USA and in France
SELECT *
FROM airbnb_listings
where country In ('USA', 'France');

-- Get all the lisitngs where the city starts with 'm' and where the city does not end in 't'
SELECT * 
from airbnb_listings
WHERE city like 'm%' and city NOT like '%t';

-- Get all the listings in 'Paris' where number_of_rooms is bigger than 3
SELECT *
from airbnb_listings
WHERE city = 'Paris' AND number_of_rooms > 3;

-- Get all the listings in 'Paris' OR the ones that were listed after 2012
SELECT *
FROM airbnb_listings
WHERE city = 'Paris' OR year_listed > 2012;

-- Return the listings where number_of_rooms is missing 
SELECT *
from airbnb_listings
where number_of_rooms is NULL;

-- Return the listings where number_of_rooms is not missing 
SELECT *
from airbnb_listings
where number_of_rooms is NOT NULL;

-- Get the total number of rooms available across all listings
SELECT SUM(number_of_rooms)
FROM airbnb_listings;

-- Get the average number of rooms per lisitings across all lisitings 
SELECT AVG(number_of_rooms)
FROM airbnb_listings;

-- Get the listing with the highest number of rooms per lisitings across all lisitings 
SELECT MAX(number_of_rooms)
FROM airbnb_listings;

-- Get the listing with the lowest number of rooms per lisitings across all lisitings 
SELECT MIN(number_of_rooms)
FROM airbnb_listings;

--Get the total number of rooms for each country 
SELECT country, SUM(number_of_rooms)
FROM airbnb_listings
GROUP BY country;

--Get the average number of rooms for each country 
SELECT country, AVG(number_of_rooms)
FROM airbnb_listings
GROUP BY country;

-- For each country, get the average number of rooms per lisiting, sorted by ascending order 
SELECT country, AVG(number_of_rooms) AS avg_rooms 
FROM airbnb_listings
GROUP by country
ORDER BY avg_rooms ASC;

-- GET the listings with the maximum number of rooms per country 
SELECT country, MAX(number_of_rooms) 
FROM airbnb_listings
GROUP by country;

-- GET the listings with the lowest number of rooms per country 
SELECT country, MIN(number_of_rooms) 
FROM airbnb_listings
GROUP by country;

-- For Japan and the USA, get the average number of rooms per lisitings in each country 
SELECT country, MAX(number_of_rooms) 
from airbnb_listings
WHERE country IN ('USA', 'Japan')
GROUP BY country;

-- Get the number of cities per country, where there are listings
SELECT country, COUNT(city) as number_of_cities
FROM airbnb_listings
GROUP BY country;

-- Get all the years where there were more than 100 lisitings per year.
SELECT year_listed 
from airbnb_listings
GROUP by year_listed
HAVING COUNT(id) > 100;

-- Retrieve listings with more than the average number of rooms 
SELECT *
FROM airbnb_listings
WHERE number_of_rooms > 
	( SELECT AVG(number_of_rooms) 
 	FROM airbnb_listings );
    
-- Find all listings that were added in the same year as the most recent listing 
SELECT * 
from airbnb_listings 
WHERE year_listed =
	( SELECT MAX(year_listed)
      FROM airbnb_listings );	
      
-- Get the cities where the number of listings is more than 5. 
SELECT city 
from airbnb_listings
GROUP by city
Having count(*) > 5;

-- Rank the cities by the number of lisitngs (using window functions).
SELECT city, COUNT(*) as toal_listings,
RANK() OVER ( ORDER BY COUNT(*) DESC ) AS rank
from airbnb_listings
GROUP BY city;

-- Find the country with the highest avergae number of rooms per listings 
SELECT country, AVG(number_of_rooms) AS avg_rooms 
FROM airbnb_listings
GROUP BY country
ORDER by avg_rooms DESC LIMIT 1;
