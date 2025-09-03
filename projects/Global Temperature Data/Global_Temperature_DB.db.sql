-- Project in SQL Lite 
sqlite3 Global_Temperature_DB.db

-- Countries Table 
CREATE TABLE countries (
  country_id INTEGER PRIMARY KEY,
  country_name VARCHAR(255) UNIQUE NOT NULL,
  region VARCHAR(255),
  latitude DECIMAL(10,6),
  longitude DECIMAL(10,6)
);

-- Cities Table 
CREATE TABLE cities (
  city_id INTEGER PRIMARY KEY,
  city_name VARCHAR(255),
  country_id INTEGER,
  latitude DECIMAL(10,6),
  longitude DECIMAL(10,6), 
  FOREIGN KEY (country_id) REFERENCES countries(country_id)
);

-- Temperature Records Table 
CREATE TABLE temperature_records (
  record_id INTEGER PRIMARY KEY,
  city_id INTEGER,
  record_date DATE NOT NULL,
  average_temperature DECIMAL(5,2) NOT NULL,
  min_temperature DECIMAL(5,2),
  max_temperature DECIMAL(5,2),
  FOREIGN KEY (city_id) REFERENCES cities(city_id)
);

-- Temperature Anomalies Table
CREATE TABLE temperature_anomalies (
  anomaly_id INTEGER PRIMARY KEY,
  country_id INTEGER,
  year YEAR,
  temperature_anomaly DECIMAL(5,2) NOT NULL,
  FOREIGN KEY (country_id) REFERENCES countries(country_id)
);

-- Insert data into countries table
INSERT INTO countries (country_id, country_name, region, latitude, longitude) VALUES
(1, 'United States', 'North America', 37.0902, -95.7129),
(2, 'India', 'Asia', 20.5937, 78.9629),
(3, 'Germany', 'Europe', 51.1657, 10.4515),
(4, 'Brazil', 'South America', -14.2350, -51.9253),
(5, 'Australia', 'Oceania', -25.2744, 133.7751),
(6, 'Canada', 'North America', 56.1304, -106.3468),
(7, 'China', 'Asia', 35.8617, 104.1954),
(8, 'South Africa', 'Africa', -30.5595, 22.9375);

-- Insert data into cities table
INSERT INTO cities (city_id, city_name, country_id, latitude, longitude) VALUES
(1, 'New York', 1, 40.7128, -74.0060),
(2, 'Mumbai', 2, 19.0760, 72.8777),
(3, 'Berlin', 3, 52.5200, 13.4050),
(4, 'Sao Paulo', 4, -23.5505, -46.6333),
(5, 'Sydney', 5, -33.8688, 151.2093),
(6, 'Toronto', 6, 43.6511, -79.3832),
(7, 'Beijing', 7, 39.9042, 116.4074),
(8, 'Cape Town', 8, -33.9249, 18.4241);

-- Insert data into temperature_records table
INSERT INTO temperature_records (record_id, city_id, record_date, average_temperature, min_temperature, max_temperature) VALUES
(1, 1, '2024-01-15', 5.2, -3.1, 12.4),
(2, 2, '2024-02-10', 28.5, 22.1, 33.8),
(3, 3, '2024-03-05', 10.2, 3.5, 17.8),
(4, 4, '2024-04-20', 22.8, 18.6, 30.1),
(5, 5, '2024-05-30', 24.5, 19.0, 28.9),
(6, 6, '2024-06-15', 18.7, 14.2, 23.4),
(7, 7, '2024-07-25', 31.0, 25.5, 37.2),
(8, 8, '2024-08-10', 16.8, 11.3, 22.4);

-- Insert data into temperature_anomalies table
INSERT INTO temperature_anomalies (anomaly_id, country_id, year, temperature_anomaly) VALUES
(1, 1, 2020, 0.95),
(2, 2, 2021, 1.02),
(3, 3, 2022, 0.89),
(4, 4, 2020, 1.15),
(5, 5, 2021, 0.78),
(6, 6, 2022, 1.03),
(7, 7, 2020, 1.25),
(8, 8, 2021, 0.88);

-- Find the average temperature for each country in a given year.
SELECT c.country_name, strftime('%Y', tr.record_date) AS year, 
       AVG(tr.average_temperature) AS avg_temp
FROM temperature_records tr
JOIN cities ci ON tr.city_id = ci.city_id
JOIN countries c ON ci.country_id = c.country_id
WHERE strftime('%Y', tr.record_date) = '2024' 
GROUP BY c.country_name, year;

-- List cities with the highest recorded temperature in the database.
SELECT ci.city_name, c.country_name, MAX(tr.max_temperature) AS highest_temp
FROM temperature_records tr
JOIN cities ci ON tr.city_id = ci.city_id
JOIN countries c ON ci.country_id = c.country_id
GROUP BY ci.city_name, c.country_name
ORDER BY highest_temp DESC
LIMIT 5;

-- Find the top 5 countries with the largest temperature anomalies over the last 50 years.
SELECT c.country_name, SUM(ta.temperature_anomaly) AS total_anomaly
FROM temperature_anomalies ta
JOIN countries c ON ta.country_id = c.country_id
WHERE ta.year >= strftime('%Y', 'now') - 50
GROUP BY c.country_name
ORDER BY total_anomaly DESC
LIMIT 5;

-- Find the coldest recorded temperature in each region.
SELECT c.region, MIN(tr.min_temperature) AS coldest_temp
FROM temperature_records tr
JOIN cities ci ON tr.city_id = ci.city_id
JOIN countries c ON ci.country_id = c.country_id
GROUP BY c.region;

-- Get the total number of temperature records stored for each country.
SELECT c.country_name, COUNT(tr.record_id) AS total_records
FROM temperature_records tr
JOIN cities ci ON tr.city_id = ci.city_id
JOIN countries c ON ci.country_id = c.country_id
GROUP BY c.country_name;

-- Find the hottest month on record for each country.
SELECT c.country_name, strftime('%m', tr.record_date) AS month, MAX(tr.max_temperature) AS highest_temp
FROM temperature_records tr
JOIN cities ci ON tr.city_id = ci.city_id
JOIN countries c ON ci.country_id = c.country_id
GROUP BY c.country_name, month
ORDER BY highest_temp DESC;

-- Find the top 5 hottest cities based on average temperature
SELECT ci.city_name, c.country_name, AVG(tr.average_temperature) AS avg_temp
FROM temperature_records tr
JOIN cities ci ON tr.city_id = ci.city_id
JOIN countries c ON ci.country_id = c.country_id
GROUP BY ci.city_name, c.country_name
ORDER BY avg_temp DESC
LIMIT 5;

-- Find the top 5 coldest cities based on average temperature
SELECT ci.city_name, c.country_name, AVG(tr.average_temperature) AS avg_temp
FROM temperature_records tr
JOIN cities ci ON tr.city_id = ci.city_id
JOIN countries c ON ci.country_id = c.country_id
GROUP BY ci.city_name, c.country_name
ORDER BY avg_temp ASC
LIMIT 5;

-- Find the year with the highest recorded global temperature
SELECT strftime('%Y', record_date) AS year, AVG(average_temperature) AS avg_temp
FROM temperature_records
GROUP BY year
ORDER BY avg_temp DESC
LIMIT 1;

-- Get the number of temperature records stored per city
SELECT ci.city_name, c.country_name, COUNT(tr.record_id) AS record_count
FROM temperature_records tr
JOIN cities ci ON tr.city_id = ci.city_id
JOIN countries c ON ci.country_id = c.country_id
GROUP BY ci.city_name, c.country_name
ORDER BY record_count DESC;

-- Find the month with the highest average temperature globally
SELECT strftime('%m', record_date) AS month, AVG(average_temperature) AS avg_temp
FROM temperature_records
GROUP BY month
ORDER BY avg_temp DESC
LIMIT 1;

-- Find the city with the most temperature records in the database
SELECT ci.city_name, c.country_name, COUNT(tr.record_id) AS record_count
FROM temperature_records tr
JOIN cities ci ON tr.city_id = ci.city_id
JOIN countries c ON ci.country_id = c.country_id
GROUP BY ci.city_name, c.country_name
ORDER BY record_count DESC
LIMIT 1;

-- Get the average temperature difference between winter and summer for each country
SELECT c.country_name, 
       AVG(CASE WHEN strftime('%m', tr.record_date) IN ('12', '01', '02') THEN tr.average_temperature END) AS winter_avg_temp,
       AVG(CASE WHEN strftime('%m', tr.record_date) IN ('06', '07', '08') THEN tr.average_temperature END) AS summer_avg_temp,
       (AVG(CASE WHEN strftime('%m', tr.record_date) IN ('06', '07', '08') THEN tr.average_temperature END) -
        AVG(CASE WHEN strftime('%m', tr.record_date) IN ('12', '01', '02') THEN tr.average_temperature END)) AS temp_difference
FROM temperature_records tr
JOIN cities ci ON tr.city_id = ci.city_id
JOIN countries c ON ci.country_id = c.country_id
GROUP BY c.country_name;

-- Find the highest temperature recorded in each country
SELECT c.country_name, MAX(tr.max_temperature) AS highest_temp
FROM temperature_records tr
JOIN cities ci ON tr.city_id = ci.city_id
JOIN countries c ON ci.country_id = c.country_id
GROUP BY c.country_name
ORDER BY highest_temp DESC;