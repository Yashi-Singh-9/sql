-- Project in SQL Lite 
-- Database Creaton 
sqlite3 ev_charging_station.db
USE ev_charging_station

-- Charging stations info
CREATE TABLE stations (
    station_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    location TEXT,
    connector_type TEXT,
    max_kw INTEGER
);

-- EV drivers
CREATE TABLE drivers (
    driver_id INTEGER PRIMARY KEY AUTOINCREMENT,
    full_name TEXT,
    email TEXT UNIQUE,
    registered_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Charging sessions
CREATE TABLE sessions (
    session_id INTEGER PRIMARY KEY AUTOINCREMENT,
    station_id INTEGER,
    driver_id INTEGER,
    start_time DATETIME,
    end_time DATETIME,
    energy_kwh REAL,
    cost_usd REAL,
    FOREIGN KEY (station_id) REFERENCES stations(station_id),
    FOREIGN KEY (driver_id) REFERENCES drivers(driver_id)
);

-- Stations
INSERT INTO stations (name, location, connector_type, max_kw) VALUES
('Station A', 'Downtown LA', 'CCS', 150),
('Station B', 'San Francisco', 'CHAdeMO', 100),
('Station C', 'San Diego', 'Type 2', 50);

-- Drivers
INSERT INTO drivers (full_name, email) VALUES
('Alice Green', 'alice@evmail.com'),
('Bob Watt', 'bob@evmail.com'),
('Charlie Volt', 'charlie@evmail.com');

-- Charging sessions
INSERT INTO sessions (station_id, driver_id, start_time, end_time, energy_kwh, cost_usd) VALUES
(1, 1, '2025-04-08 08:00', '2025-04-08 09:00', 25.5, 8.50),
(2, 2, '2025-04-08 10:15', '2025-04-08 11:00', 18.2, 6.30),
(3, 3, '2025-04-08 12:00', '2025-04-08 13:45', 30.0, 9.90),
(1, 2, '2025-04-09 07:30', '2025-04-09 08:15', 20.0, 6.70),
(2, 1, '2025-04-09 09:00', '2025-04-09 10:00', 22.0, 7.90);

-- Total Energy Usage by Station
SELECT s.name, SUM(sess.energy_kwh) AS total_kwh
FROM sessions sess
JOIN stations s ON sess.station_id = s.station_id
GROUP BY s.name;

-- Most Active Drivers
SELECT d.full_name, COUNT(sess.session_id) AS total_sessions
FROM sessions sess
JOIN drivers d ON sess.driver_id = d.driver_id
GROUP BY d.full_name
ORDER BY total_sessions DESC;

-- Station Utilization Stats
SELECT 
    s.name, 
    COUNT(sess.session_id) AS session_count,
    AVG(sess.energy_kwh) AS avg_kwh,
    MAX(sess.energy_kwh) AS peak_kwh
FROM sessions sess
JOIN stations s ON sess.station_id = s.station_id
GROUP BY s.name;

-- Average Charging Time Per Session
SELECT 
    s.name,
    AVG((JULIANDAY(end_time) - JULIANDAY(start_time)) * 24 * 60) AS avg_minutes
FROM sessions sess
JOIN stations s ON sess.station_id = s.station_id
GROUP BY s.name;

-- Total Cost Incurred by Each Driver
SELECT 
    d.full_name,
    SUM(sess.cost_usd) AS total_cost
FROM sessions sess
JOIN drivers d ON sess.driver_id = d.driver_id
GROUP BY d.full_name
ORDER BY total_cost DESC;

-- Most Popular Charging Station (by number of sessions)
SELECT 
    s.name,
    COUNT(sess.session_id) AS session_count
FROM sessions sess
JOIN stations s ON sess.station_id = s.station_id
GROUP BY s.name
ORDER BY session_count DESC
LIMIT 1;

-- Longest Charging Session
SELECT 
    d.full_name,
    s.name AS station_name,
    start_time,
    end_time,
    (JULIANDAY(end_time) - JULIANDAY(start_time)) * 24 * 60 AS duration_minutes
FROM sessions sess
JOIN drivers d ON sess.driver_id = d.driver_id
JOIN stations s ON sess.station_id = s.station_id
ORDER BY duration_minutes DESC
LIMIT 1;

-- Total Revenue Per Station
SELECT 
    s.name,
    SUM(sess.cost_usd) AS total_revenue
FROM sessions sess
JOIN stations s ON sess.station_id = s.station_id
GROUP BY s.name
ORDER BY total_revenue DESC;

-- Daily Energy Consumption
SELECT 
    DATE(start_time) AS session_date,
    SUM(energy_kwh) AS total_kwh
FROM sessions
GROUP BY session_date
ORDER BY session_date;

-- Efficiency: Cost Per kWh per Station
SELECT 
    s.name,
    SUM(sess.cost_usd) / SUM(sess.energy_kwh) AS cost_per_kwh
FROM sessions sess
JOIN stations s ON sess.station_id = s.station_id
GROUP BY s.name
ORDER BY cost_per_kwh;

-- Station Usage Growth by Day
SELECT 
    s.name,
    DATE(sess.start_time) AS session_day,
    COUNT(sess.session_id) AS sessions
FROM sessions sess
JOIN stations s ON sess.station_id = s.station_id
GROUP BY s.name, session_day
ORDER BY s.name, session_day;

-- Sessions with Above Average Cost
SELECT 
    sess.session_id,
    d.full_name,
    s.name AS station_name,
    sess.cost_usd
FROM sessions sess
JOIN drivers d ON sess.driver_id = d.driver_id
JOIN stations s ON sess.station_id = s.station_id
WHERE sess.cost_usd > (SELECT AVG(cost_usd) FROM sessions)
ORDER BY sess.cost_usd DESC;