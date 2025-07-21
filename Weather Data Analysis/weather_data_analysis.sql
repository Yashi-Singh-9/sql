-- Project in PostgreSQL 
-- Create database
CREATE DATABASE weather_data_analysis;
\c weather_data_analysis;

CREATE TABLE locations (
    location_id SERIAL PRIMARY KEY,
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    latitude DECIMAL(8, 6),
    longitude DECIMAL(9, 6)
);

CREATE TABLE weather_observations (
    observation_id SERIAL PRIMARY KEY,
    location_id INT REFERENCES locations(location_id),
    observation_time TIMESTAMP,
    temperature_c DECIMAL(5,2),
    humidity_percent DECIMAL(5,2),
    wind_speed_kph DECIMAL(5,2),
    condition VARCHAR(100) -- e.g., Sunny, Rain, Cloudy
);

CREATE TABLE weather_events (
    event_id SERIAL PRIMARY KEY,
    location_id INT REFERENCES locations(location_id),
    event_type VARCHAR(100), -- e.g., Thunderstorm, Tornado, Snowstorm
    severity VARCHAR(50),
    event_time TIMESTAMP,
    description TEXT
);

INSERT INTO locations (city, state, country, latitude, longitude) VALUES
('New York', 'NY', 'USA', 40.7128, -74.0060),
('Los Angeles', 'CA', 'USA', 34.0522, -118.2437),
('Chicago', 'IL', 'USA', 41.8781, -87.6298),
('London', '', 'UK', 51.5074, -0.1278),
('Tokyo', '', 'Japan', 35.6895, 139.6917);

INSERT INTO weather_observations (location_id, observation_time, temperature_c, humidity_percent, wind_speed_kph, condition) VALUES
(1, '2024-04-07 08:00:00', 12.5, 60.0, 15.0, 'Cloudy'),
(1, '2024-04-07 12:00:00', 15.3, 55.0, 18.0, 'Sunny'),
(2, '2024-04-07 08:00:00', 18.0, 70.0, 10.0, 'Sunny'),
(3, '2024-04-07 09:00:00', 8.2, 80.0, 20.0, 'Rain'),
(4, '2024-04-07 14:00:00', 10.0, 65.0, 12.5, 'Rain'),
(5, '2024-04-07 10:00:00', 17.5, 50.0, 8.5, 'Clear');

INSERT INTO weather_events (location_id, event_type, severity, event_time, description) VALUES
(3, 'Thunderstorm', 'Moderate', '2024-04-07 17:00:00', 'Thunder and light rain reported'),
(1, 'Snowstorm', 'Severe', '2024-01-15 06:00:00', 'Heavy snow with reduced visibility'),
(5, 'Typhoon', 'Severe', '2023-10-12 22:00:00', 'High winds and coastal flooding');

-- Average temperature per city on a given day
SELECT l.city, AVG(w.temperature_c) AS avg_temp
FROM weather_observations w
JOIN locations l ON w.location_id = l.location_id
WHERE DATE(w.observation_time) = '2024-04-07'
GROUP BY l.city;

-- Highest humidity recorded by location
SELECT l.city, MAX(w.humidity_percent) AS max_humidity
FROM weather_observations w
JOIN locations l ON w.location_id = l.location_id
GROUP BY l.city;

-- List of extreme events by severity
SELECT l.city, e.event_type, e.severity, e.event_time
FROM weather_events e
JOIN locations l ON e.location_id = l.location_id
ORDER BY e.severity DESC, e.event_time DESC;

-- Daily temperature variation per city
SELECT 
    l.city,
    DATE(w.observation_time) AS date,
    MAX(w.temperature_c) - MIN(w.temperature_c) AS temp_variation
FROM weather_observations w
JOIN locations l ON w.location_id = l.location_id
GROUP BY l.city, DATE(w.observation_time)
ORDER BY temp_variation DESC;

-- Top 5 windiest observations
SELECT 
    l.city, 
    w.observation_time,
    w.wind_speed_kph
FROM weather_observations w
JOIN locations l ON w.location_id = l.location_id
ORDER BY w.wind_speed_kph DESC
LIMIT 5;

-- Cities that experienced 'Rain' on a specific date
SELECT DISTINCT l.city
FROM weather_observations w
JOIN locations l ON w.location_id = l.location_id
WHERE w.condition = 'Rain' AND DATE(w.observation_time) = '2024-04-07';

-- Average humidity by weather condition
SELECT 
    condition,
    ROUND(AVG(humidity_percent), 2) AS avg_humidity
FROM weather_observations
GROUP BY condition
ORDER BY avg_humidity DESC;

-- Most common weather condition per city
SELECT city, condition
FROM (
    SELECT 
        l.city,
        w.condition,
        COUNT(*) AS frequency,
        RANK() OVER (PARTITION BY l.city ORDER BY COUNT(*) DESC) AS rnk
    FROM weather_observations w
    JOIN locations l ON w.location_id = l.location_id
    GROUP BY l.city, w.condition
) AS ranked_conditions
WHERE rnk = 1;

-- Count of extreme weather events by month
SELECT 
    TO_CHAR(event_time, 'YYYY-MM') AS month,
    COUNT(*) AS event_count
FROM weather_events
GROUP BY month
ORDER BY month DESC;