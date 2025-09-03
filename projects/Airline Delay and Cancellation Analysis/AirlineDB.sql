-- MS SQL Project
-- Create Database
CREATE DATABASE AirlineDB;

CREATE TABLE Airlines (
    airline_id INT PRIMARY KEY,
    airline_name VARCHAR(255) NOT NULL,
    iata_code VARCHAR(10) UNIQUE NOT NULL,
    icao_code VARCHAR(10) UNIQUE NOT NULL
);

CREATE TABLE Airports (
    airport_id INT PRIMARY KEY,
    airport_name VARCHAR(255) NOT NULL,
    iata_code VARCHAR(10) UNIQUE NOT NULL,
    icao_code VARCHAR(10) UNIQUE NOT NULL,
    city VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL
);

CREATE TABLE Flights (
    flight_id INT PRIMARY KEY,
    airline_id INT,
    flight_number VARCHAR(50) NOT NULL,
    origin_airport_id INT,
    destination_airport_id INT,
    departure_date DATE NOT NULL,
    scheduled_departure DATETIME NOT NULL,
    actual_departure DATETIME NULL,
    scheduled_arrival DATETIME NOT NULL,
    actual_arrival DATETIME NULL,
    flight_status VARCHAR(50) NOT NULL,
    FOREIGN KEY (airline_id) REFERENCES Airlines(airline_id),
    FOREIGN KEY (origin_airport_id) REFERENCES Airports(airport_id),
    FOREIGN KEY (destination_airport_id) REFERENCES Airports(airport_id)
);

CREATE TABLE Delays (
    delay_id INT PRIMARY KEY,
    flight_id INT,
    departure_delay INT NOT NULL,
    arrival_delay INT NOT NULL,
    weather_delay INT NULL,
    air_traffic_delay INT NULL,
    security_delay INT NULL,
    carrier_delay INT NULL,
    late_aircraft_delay INT NULL,
    FOREIGN KEY (flight_id) REFERENCES Flights(flight_id)
);

CREATE TABLE Cancellations (
    cancellation_id INT PRIMARY KEY,
    flight_id INT,
    cancellation_reason VARCHAR(255) NOT NULL,
    cancellation_date DATE NOT NULL,
    FOREIGN KEY (flight_id) REFERENCES Flights(flight_id)
);

-- Insert data into Airlines
INSERT INTO Airlines (airline_id, airline_name, iata_code, icao_code) VALUES
(1, 'American Airlines', 'AA', 'AAL'),
(2, 'Delta Airlines', 'DL', 'DAL'),
(3, 'United Airlines', 'UA', 'UAL'),
(4, 'Southwest Airlines', 'WN', 'SWA'),
(5, 'British Airways', 'BA', 'BAW');

-- Insert data into Airports
INSERT INTO Airports (airport_id, airport_name, iata_code, icao_code, city, country) VALUES
(1, 'Los Angeles International Airport', 'LAX', 'KLAX', 'Los Angeles', 'USA'),
(2, 'John F. Kennedy International Airport', 'JFK', 'KJFK', 'New York', 'USA'),
(3, 'O''Hare International Airport', 'ORD', 'KORD', 'Chicago', 'USA'),
(4, 'Dallas/Fort Worth International Airport', 'DFW', 'KDFW', 'Dallas', 'USA'),
(5, 'London Heathrow Airport', 'LHR', 'EGLL', 'London', 'UK');

-- Insert data into Flights
INSERT INTO Flights (flight_id, airline_id, flight_number, origin_airport_id, destination_airport_id, departure_date, scheduled_departure, actual_departure, scheduled_arrival, actual_arrival, flight_status) VALUES
(1, 1, 'AA100', 1, 2, '2025-02-14', '2025-02-14 08:00:00', '2025-02-14 08:10:00', '2025-02-14 12:00:00', '2025-02-14 12:05:00', 'Arrived'),
(2, 2, 'DL200', 2, 3, '2025-02-14', '2025-02-14 09:30:00', '2025-02-14 09:45:00', '2025-02-14 11:30:00', '2025-02-14 11:40:00', 'Arrived'),
(3, 3, 'UA300', 3, 4, '2025-02-14', '2025-02-14 11:00:00', NULL, '2025-02-14 14:00:00', NULL, 'Scheduled'),
(4, 4, 'WN400', 4, 5, '2025-02-14', '2025-02-14 12:45:00', '2025-02-14 12:55:00', '2025-02-14 20:00:00', '2025-02-14 20:20:00', 'Arrived'),
(5, 5, 'BA500', 5, 1, '2025-02-14', '2025-02-14 15:00:00', NULL, '2025-02-14 18:30:00', NULL, 'Cancelled');

-- Insert data into Delays
INSERT INTO Delays (delay_id, flight_id, departure_delay, arrival_delay, weather_delay, air_traffic_delay, security_delay, carrier_delay, late_aircraft_delay) VALUES
(1, 1, 10, 5, NULL, NULL, NULL, NULL, NULL),
(2, 2, 15, 10, 5, NULL, NULL, 10, NULL),
(3, 4, 10, 20, NULL, 10, NULL, NULL, NULL);

-- Insert data into Cancellations
INSERT INTO Cancellations (cancellation_id, flight_id, cancellation_reason, cancellation_date) VALUES
(1, 5, 'Technical Issues', '2025-02-14');

-- Total number of flights per airline.
SELECT a.airline_name, COUNT(f.flight_id) AS total_flights
FROM Flights f
JOIN Airlines a ON f.airline_id = a.airline_id
GROUP BY a.airline_name;

-- Percentage of flights delayed per airline.
SELECT a.airline_name, 
       ROUND((COUNT(d.flight_id) * 100.0) / COUNT(f.flight_id), 2) AS percentage_delayed
FROM Flights f
LEFT JOIN Delays d ON f.flight_id = d.flight_id
JOIN Airlines a ON f.airline_id = a.airline_id
GROUP BY a.airline_name;

-- Flights that got delayed by more than 30 minutes.
SELECT f.flight_id, f.flight_number, a.airline_name, d.departure_delay, d.arrival_delay
FROM Flights f
JOIN Delays d ON f.flight_id = d.flight_id
JOIN Airlines a ON f.airline_id = a.airline_id
WHERE d.departure_delay > 30 OR d.arrival_delay > 30;

-- Top 2 airports with the most delays.
SELECT TOP 2 ap.airport_name, COUNT(d.flight_id) AS total_delays
FROM Flights f
JOIN Delays d ON f.flight_id = d.flight_id
JOIN Airports ap ON f.origin_airport_id = ap.airport_id
GROUP BY ap.airport_name
ORDER BY total_delays DESC;

-- Average delay time by airline.
SELECT a.airline_name, ROUND(AVG(d.departure_delay + d.arrival_delay), 2) AS avg_delay_minutes
FROM Delays d
JOIN Flights f ON d.flight_id = f.flight_id
JOIN Airlines a ON f.airline_id = a.airline_id
GROUP BY a.airline_name;

-- Flights that were canceled and their reasons.
SELECT f.flight_number, a.airline_name, c.cancellation_reason
FROM Cancellations c
JOIN Flights f ON c.flight_id = f.flight_id
JOIN Airlines a ON f.airline_id = a.airline_id;

-- Airports with the most cancellations.
SELECT ap.airport_name, COUNT(c.flight_id) AS total_cancellations
FROM Flights f
JOIN Cancellations c ON f.flight_id = c.flight_id
JOIN Airports ap ON f.origin_airport_id = ap.airport_id
GROUP BY ap.airport_name
ORDER BY total_cancellations DESC;

-- Flights that were delayed due to weather conditions.
SELECT f.flight_number, a.airline_name, d.weather_delay
FROM Flights f
JOIN Delays d ON f.flight_id = d.flight_id
JOIN Airlines a ON f.airline_id = a.airline_id
WHERE d.weather_delay > 0;

-- Airline with the highest cancellation rate.
SELECT TOP 1 a.airline_name, 
       ROUND((COUNT(c.flight_id) * 100.0) / COUNT(f.flight_id), 2) AS cancellation_rate
FROM Flights f
LEFT JOIN Cancellations c ON f.flight_id = c.flight_id
JOIN Airlines a ON f.airline_id = a.airline_id
GROUP BY a.airline_name
ORDER BY cancellation_rate DESC;

-- Total delay minutes per airline for a given month.
SELECT 
    a.airline_name, 
    SUM(d.departure_delay + d.arrival_delay) AS total_delay_minutes
FROM Flights f
JOIN Delays d ON f.flight_id = d.flight_id
JOIN Airlines a ON f.airline_id = a.airline_id
WHERE FORMAT(f.departure_date, 'yyyy-MM') = '2025-02'
GROUP BY a.airline_name;

-- Flights that were delayed at both departure and arrival.
SELECT f.flight_number, a.airline_name, d.departure_delay, d.arrival_delay
FROM Flights f
JOIN Delays d ON f.flight_id = d.flight_id
JOIN Airlines a ON f.airline_id = a.airline_id
WHERE d.departure_delay > 0 AND d.arrival_delay > 0;

-- Most common cause of flight delays.
SELECT TOP 1 'Weather Delay' AS delay_type, COUNT(weather_delay) AS occurrences FROM Delays WHERE weather_delay > 0
UNION ALL
SELECT 'Air Traffic Delay', COUNT(air_traffic_delay) FROM Delays WHERE air_traffic_delay > 0
UNION ALL
SELECT 'Security Delay', COUNT(security_delay) FROM Delays WHERE security_delay > 0
UNION ALL
SELECT 'Carrier Delay', COUNT(carrier_delay) FROM Delays WHERE carrier_delay > 0
UNION ALL
SELECT 'Late Aircraft Delay', COUNT(late_aircraft_delay) FROM Delays WHERE late_aircraft_delay > 0
ORDER BY occurrences DESC;

-- Which day of the week has the highest delays?
SELECT TOP 1
    DATEPART(WEEKDAY, f.departure_date) AS day_of_week, 
    COUNT(d.flight_id) AS total_delays
FROM Flights f
JOIN Delays d ON f.flight_id = d.flight_id
GROUP BY DATEPART(WEEKDAY, f.departure_date)
ORDER BY total_delays DESC;

-- Average delay time at peak hours (8 AM - 8 PM).
SELECT ROUND(AVG(d.departure_delay + d.arrival_delay), 2) AS avg_delay_minutes
FROM Flights f
JOIN Delays d ON f.flight_id = d.flight_id
WHERE DATEPART(HOUR, f.scheduled_departure) BETWEEN 8 AND 20;

-- Flights that arrived earlier than scheduled.
SELECT 
    f.flight_number, 
    a.airline_name, 
    DATEDIFF(MINUTE, f.actual_arrival, f.scheduled_arrival) AS early_minutes
FROM Flights f
JOIN Airlines a ON f.airline_id = a.airline_id
WHERE f.actual_arrival < f.scheduled_arrival;
