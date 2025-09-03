-- SQL Lite Project
-- Create Database 
sqlite3 SuperCars.db

-- Use of Database 
USE SuperCars;

-- Creation of Table 
CREATE TABLE cars (
    id INTEGER PRIMARY KEY,
    make VARCHAR(50),
    model VARCHAR(100),
    year INTEGER,
    propulsion_type VARCHAR(50),
    time_to_60_mph_s DECIMAL(3,2),
    limited_production_count INTEGER
);

-- Insertion in Table 
INSERT INTO cars (make, model, year, propulsion_type, time_to_60_mph_s, limited_production_count) 
VALUES
('Lamborghini', 'Huracán Performante', 2018, 'ICE', 2.2, NULL),
('Ferrari', 'SF90 Stradale', 2021, 'Hybrid', 2.0, NULL),
('Tesla', 'Model S Plaid', 2021, 'Electric', 1.98, NULL),
('Porsche', '918 Spyder', 2015, 'Hybrid', 2.1, 918),
('Rimac', 'Nevera', 2021, 'Electric', 1.74, 150),
('Porsche', '911 Turbo S (992)', 2020, 'ICE', 2.1, NULL),
('Bugatti', 'Chiron Super Sport 300+', 2019, 'ICE', 2.3, 30),
('McLaren', 'P1', 2013, 'Hybrid', 2.6, 375),
('Koenigsegg', 'Jesko', 2021, 'ICE', 2.5, 125),
('Aston Martin', 'Valkyrie', 2022, 'Hybrid', 2.5, 150),
('Pagani', 'Huayra BC', 2016, 'ICE', 2.8, 20),
('Chevrolet', 'Corvette Z06 (C8)', 2023, 'ICE', 2.6, NULL),
('Dodge', 'Challenger SRT Demon 170', 2023, 'ICE', 1.66, 3000),
('Lotus', 'Evija', 2023, 'Electric', 2.0, 130),
('Ferrari', 'LaFerrari', 2013, 'Hybrid', 2.6, 499),
('Hennessey', 'Venom F5', 2023, 'ICE', 2.0, 24),
('SSC', 'Tuatara', 2020, 'ICE', 2.5, 100),
('Lucid', 'Air Sapphire', 2023, 'Electric', 1.89, NULL);

-- Get all the columns from a table
SELECT * 
From cars;

-- Get the model column from the table 
SELECT model 
from cars;

-- Get the make and model column from the table 
SELECT make, model 
from cars;

-- Get the make, modal, propupropulsion_type as engine type column from the table 
Select make, model, propulsion_type AS engine_type
from cars;

-- Get the model, make, time_to_60_mph_s ordered by the time_to_60_mph_s in ascending order 
SELECT model, make, time_to_60_mph_s
FROM cars 
ORDER by time_to_60_mph_s ASC;

-- Get the model, make, time_to_60_mph_s ordered by the time_to_60_mph_s in descending order 
SELECT model, make, time_to_60_mph_s
FROM cars 
ORDER by time_to_60_mph_s DESC;

-- Get the first 2 rows from the cars table 
SELECT * 
FROM cars
LIMIT 2;

-- Get a unique list of propropulsion_type where there are cars 
SELECT DISTINCT propulsion_type
FROM cars;

-- Get rows of make, model, time_to_60_mph_s where time_to_60_mph_s is greater than 2.1
SELECT make, model, time_to_60_mph_s
from cars 
WHERE time_to_60_mph_s > 2.1;

-- Get rows of make, model, time_to_60_mph_s where time_to_60_mph_s is greater than or equal to 2.1
SELECT make, model, time_to_60_mph_s
from cars 
WHERE time_to_60_mph_s >= 2.1;

-- Get rows of make, model, time_to_60_mph_s where time_to_60_mph_s is less than 2.1
SELECT make, model, time_to_60_mph_s
from cars 
WHERE time_to_60_mph_s < 2.1;

-- Get rows of make, model, time_to_60_mph_s where time_to_60_mph_s is less than or equal to 2.1
SELECT make, model, time_to_60_mph_s
from cars 
WHERE time_to_60_mph_s <= 2.1;

-- Get rows of make, model, time_to_60_mph_s where time_to_60_mph_s is to equal to 2.1
SELECT make, model, time_to_60_mph_s
from cars 
WHERE time_to_60_mph_s = 2.1;

-- Get rows of make, model, time_to_60_mph_s where time_to_60_mph_s is to not equal to 2.1
SELECT make, model, time_to_60_mph_s
from cars 
WHERE time_to_60_mph_s <> 2.1;

-- Get make, model, time_to_60_mph_s between 1.9 and 2.1
SELECT make, model, time_to_60_mph_s
from cars 
WHERE time_to_60_mph_s BETWEEN 1.9 AND 2.1;

-- Get make, model, propulsion_type where proppropulsion_type are based in hybrid 
SELECT make, model, propulsion_type
from cars
WHERE propulsion_type = 'Hybrid';

-- Get make, model, propulsion_type where proppropulsion_type are based in electric and in hybrid 
SELECT make, model, propulsion_type
from cars
WHERE propulsion_type IN ('Electric', 'Hybrid');

-- Get make, model, propulsion_type in hybrid and where model year is less than 2020 
SELECT make, model, propulsion_type
FROM cars 
WHERE propulsion_type = 'Hybrid' and year > 2020;

-- Get make, model, propulsion_type in hybrid or the ones that were year is less than 2020 
SELECT make, model, propulsion_type
FROM cars 
WHERE propulsion_type = 'Hybrid' OR year > 2020;

-- Return the model, make, limited_production_count where limited_production_count is missing 
SELECT make, model, limited_production_count
from cars 
WHERE limited_production_count is NULL;

-- Return the model, make, limited_production_count where limited_production_count is not missing 
SELECT make, model, limited_production_count
from cars 
WHERE limited_production_count is NOT NULL;

-- Get all the total number of rows 
SELECT COUNT(*)
FROM cars;

-- Get all the total value of a limited_production_count 
SELECT SUM(limited_production_count)
from cars;

-- Get the average of time_to_60_mph_s
SELECT AVG(time_to_60_mph_s)
FROM cars;

-- Get the minimum of the time_to_60_mph_s
SELECT MIN(time_to_60_mph_s)
From cars;

-- Get the maximum of the time_to_60_mph_s
SELECT MAX(time_to_60_mph_s)
From cars;

-- Count the number of cars for each propulsion type (ICE, Hybrid, Electric)
SELECT propulsion_type, COUNT(*)
FROM cars
GROUP by propulsion_type;

-- Calculate the average 0-60 mph time for each propulsion type and sorting the results in ascending order
SELECT propulsion_type, AVG(time_to_60_mph_s) as mean_time
FROM cars 
group by propulsion_type
order by mean_time;
