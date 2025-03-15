sqlite3 Environmental.db;

USE Environmental;

-- Location Table 
CREATE TABLE Locations (
    location_id INT PRIMARY KEY,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100),
    country VARCHAR(100) NOT NULL,
    latitude DECIMAL(9,6) NOT NULL,
    longitude DECIMAL(9,6) NOT NULL
);

INSERT INTO Locations (location_id, city, state, country, latitude, longitude) VALUES
(101, 'New York', 'New York', 'USA', 40.7128, -74.0060),
(102, 'Los Angeles', 'California', 'USA', 34.0522, -118.2437),
(103, 'Chicago', 'Illinois', 'USA', 41.8781, -87.6298),
(104, 'Houston', 'Texas', 'USA', 29.7604, -95.3698),
(105, 'Miami', 'Florida', 'USA', 25.7617, -80.1918),
(106, 'Toronto', 'Ontario', 'Canada', 43.7001, -79.4163),
(107, 'Vancouver', 'British Columbia', 'Canada', 49.2827, -123.1207),
(108, 'London', 'England', 'UK', 51.5074, -0.1278),
(109, 'Paris', 'Île-de-France', 'France', 48.8566, 2.3522),
(110, 'Berlin', 'Berlin', 'Germany', 52.5200, 13.4050),
(111, 'Tokyo', 'Tokyo', 'Japan', 35.6895, 139.6917),
(112, 'Sydney', 'New South Wales', 'Australia', -33.8688, 151.2093),
(113, 'Mumbai', 'Maharashtra', 'India', 19.0760, 72.8777),
(114, 'São Paulo', 'São Paulo', 'Brazil', -23.5505, -46.6333),
(115, 'Johannesburg', 'Gauteng', 'South Africa', -26.2041, 28.0473);

-- Air Quality Table 
CREATE TABLE Air_Quality (
    id INT PRIMARY KEY,
    location_id INT,
    date DATE NOT NULL,
    PM2_5 DECIMAL(5,2) NOT NULL,
    PM10 DECIMAL(5,2) NOT NULL,
    CO DECIMAL(3,1) NOT NULL,
    NO2 DECIMAL(5,2) NOT NULL,
    SO2 DECIMAL(5,2) NOT NULL,
    O3 DECIMAL(5,2) NOT NULL,
    FOREIGN KEY (location_id) REFERENCES Locations(location_id)
); 

INSERT INTO Air_Quality (id, location_id, date, PM2_5, PM10, CO, NO2, SO2, O3) VALUES
(1, 101, '2024-02-01', 35.2, 58.1, 0.9, 22.5, 6.3, 48.7),
(2, 102, '2024-02-01', 42.5, 75.3, 1.1, 30.2, 7.1, 52.8),
(3, 103, '2024-02-01', 28.7, 50.2, 0.7, 18.4, 5.8, 44.3),
(4, 104, '2024-02-02', 50.1, 85.6, 1.3, 35.0, 8.2, 60.5),
(5, 105, '2024-02-02', 33.5, 62.8, 0.8, 20.1, 6.0, 47.2),
(6, 106, '2024-02-02', 39.1, 65.4, 1.0, 24.3, 6.8, 50.1),
(7, 107, '2024-02-03', 45.3, 80.2, 1.2, 31.8, 7.5, 55.2),
(8, 108, '2024-02-03', 30.5, 53.7, 0.8, 19.7, 6.0, 46.5),
(9, 109, '2024-02-04', 48.2, 88.1, 1.4, 34.2, 8.0, 62.3),
(10, 110, '2024-02-04', 31.9, 59.3, 0.7, 21.5, 5.9, 45.8),
(11, 111, '2024-02-05', 33.9, 60.2, 0.9, 21.1, 6.2, 49.0),
(12, 112, '2024-02-05', 40.8, 78.5, 1.1, 29.5, 7.3, 54.0),
(13, 113, '2024-02-06', 27.3, 48.9, 0.6, 17.6, 5.7, 43.8),
(14, 114, '2024-02-06', 46.5, 86.7, 1.3, 33.5, 7.9, 61.0),
(15, 115, '2024-02-07', 29.8, 55.4, 0.7, 22.0, 6.1, 44.9),
(16, 101, '2024-02-07', 38.4, 64.2, 1.0, 23.8, 6.5, 50.3),
(17, 103, '2024-02-08', 41.2, 72.9, 1.2, 28.4, 7.0, 53.6),
(18, 105, '2024-02-08', 36.7, 66.8, 0.9, 25.1, 6.4, 49.5),
(19, 110, '2024-02-09', 32.1, 57.3, 0.8, 20.7, 5.9, 46.1),
(20, 115, '2024-02-09', 47.6, 82.4, 1.3, 34.7, 8.1, 60.9);

-- Water Quality Table  
CREATE TABLE Water_Quality (
    id INT PRIMARY KEY,
    location_id INT,
    date DATE NOT NULL,
    pH DECIMAL(3,1) NOT NULL,
    turbidity DECIMAL(4,2) NOT NULL,
    dissolved_oxygen DECIMAL(4,2) NOT NULL,
    contaminants VARCHAR(100) NOT NULL,
    FOREIGN KEY (location_id) REFERENCES Locations(location_id)
);

INSERT INTO Water_Quality (id, location_id, date, pH, turbidity, dissolved_oxygen, contaminants) VALUES
(1, 101, '2024-02-01', 7.2, 3.5, 8.1, 'Lead'),
(2, 102, '2024-02-01', 6.8, 4.2, 7.8, 'Nitrates'),
(3, 103, '2024-02-01', 7.5, 2.9, 8.5, 'None'),
(4, 104, '2024-02-02', 6.9, 5.1, 7.6, 'Chlorine'),
(5, 105, '2024-02-02', 7.0, 3.8, 8.0, 'Fluoride'),
(6, 106, '2024-02-02', 7.3, 4.5, 8.2, 'None'),
(7, 107, '2024-02-03', 6.7, 5.8, 7.3, 'Mercury'),
(8, 108, '2024-02-03', 7.4, 3.2, 8.4, 'None'),
(9, 109, '2024-02-04', 7.1, 4.6, 8.0, 'Nitrates'),
(10, 110, '2024-02-04', 7.2, 3.9, 7.9, 'Lead'),
(11, 111, '2024-02-05', 6.8, 5.3, 7.4, 'Pesticides'),
(12, 112, '2024-02-05', 7.5, 2.7, 8.6, 'None'),
(13, 113, '2024-02-06', 6.9, 5.5, 7.5, 'Arsenic'),
(14, 114, '2024-02-06', 7.3, 3.6, 8.3, 'None'),
(15, 115, '2024-02-07', 7.0, 4.4, 8.1, 'Chlorine'),
(16, 101, '2024-02-07', 7.1, 3.7, 8.0, 'None'),
(17, 103, '2024-02-08', 6.9, 5.2, 7.7, 'Lead'),
(18, 105, '2024-02-08', 7.4, 3.1, 8.5, 'None'),
(19, 110, '2024-02-09', 7.0, 4.3, 8.0, 'Pesticides'),
(20, 115, '2024-02-09', 6.8, 5.6, 7.2, 'Mercury');
  
-- Weather Data Table 
CREATE TABLE Weather_Data (
    id INT PRIMARY KEY,
    location_id INT,
    date DATE NOT NULL,
    temperature DECIMAL(5,2) NOT NULL,
    humidity INT NOT NULL,
    precipitation DECIMAL(5,2) NOT NULL,
    wind_speed DECIMAL(5,2) NOT NULL,
    FOREIGN KEY (location_id) REFERENCES Locations(location_id)
);
  
INSERT INTO Weather_Data (id, location_id, date, temperature, humidity, precipitation, wind_speed) VALUES
(1, 101, '2024-02-01', 5.2, 65, 12.3, 15.4),
(2, 102, '2024-02-01', 18.5, 50, 0.0, 10.2),
(3, 103, '2024-02-01', -2.7, 80, 5.2, 20.1),
(4, 104, '2024-02-02', 22.1, 45, 0.0, 8.5),
(5, 105, '2024-02-02', 25.3, 55, 3.4, 12.7),
(6, 106, '2024-02-02', -6.1, 85, 7.8, 18.3),
(7, 107, '2024-02-03', 10.7, 75, 2.1, 9.8),
(8, 108, '2024-02-03', 8.4, 70, 14.2, 17.5),
(9, 109, '2024-02-04', 12.2, 65, 6.7, 13.0),
(10, 110, '2024-02-04', 4.3, 82, 10.1, 21.2),
(11, 111, '2024-02-05', 15.9, 60, 0.0, 7.6),
(12, 112, '2024-02-05', 26.4, 50, 1.2, 14.5),
(13, 113, '2024-02-06', 30.7, 40, 0.0, 10.9),
(14, 114, '2024-02-06', 28.1, 55, 4.5, 12.3),
(15, 115, '2024-02-07', 20.6, 65, 8.3, 16.1),
(16, 101, '2024-02-07', 6.8, 78, 11.7, 18.9),
(17, 103, '2024-02-08', -3.5, 85, 9.6, 22.0),
(18, 105, '2024-02-08', 24.1, 58, 2.8, 11.4),
(19, 110, '2024-02-09', 3.2, 88, 13.5, 19.7),
(20, 115, '2024-02-09', 21.9, 63, 5.7, 14.8);
  
-- Pollution Sources Table 
CREATE TABLE Pollution_Sources (
    id INT PRIMARY KEY,
    source_name VARCHAR(255) NOT NULL,
    type VARCHAR(100) NOT NULL,
    emission_level DECIMAL(5,2) NOT NULL,
    location_id INT,
    FOREIGN KEY (location_id) REFERENCES Locations(location_id)
);

INSERT INTO Pollution_Sources (id, source_name, type, emission_level, location_id) VALUES
(1, 'Coal Power Plant', 'Energy', 95.4, 101),
(2, 'Highway Traffic', 'Transport', 78.2, 102),
(3, 'Steel Manufacturing', 'Industrial', 88.7, 103),
(4, 'Oil Refinery', 'Industrial', 92.1, 104),
(5, 'Diesel Truck Emissions', 'Transport', 80.6, 105),
(6, 'Cement Factory', 'Construction', 85.3, 106),
(7, 'Agricultural Burning', 'Agriculture', 76.8, 107),
(8, 'Garbage Incineration', 'Waste Management', 82.9, 108),
(9, 'Mining Operations', 'Mining', 89.5, 109),
(10, 'Airport Runway Emissions', 'Transport', 81.2, 110),
(11, 'Residential Wood Stoves', 'Residential', 74.3, 111),
(12, 'Chemical Manufacturing Plant', 'Industrial', 90.7, 112),
(13, 'Shipping Port Operations', 'Transport', 79.1, 113),
(14, 'Textile Factory', 'Industrial', 84.2, 114),
(15, 'Large Landfill Site', 'Waste Management', 87.6, 115),
(16, 'Petroleum Refinery', 'Industrial', 93.4, 101),
(17, 'Urban Traffic Congestion', 'Transport', 75.9, 103),
(18, 'Plastic Manufacturing Plant', 'Industrial', 86.5, 105),
(19, 'Nuclear Power Facility', 'Energy', 71.8, 110),
(20, 'Paper Mill Factory', 'Industrial', 78.4, 115);

-- Retrieve the top 10 most polluted cities based on PM2.5 levels in the last one year.
SELECT L.city, AVG(AQ.PM2_5) AS avg_PM25
FROM Air_Quality AQ
JOIN Locations L ON AQ.location_id = L.location_id
WHERE AQ.date >= DATE('now', '-1 year')  
GROUP BY L.city
ORDER BY avg_PM25 DESC
LIMIT 10;

-- Identify locations where water pH levels are below the safe threshold.
SELECT 
    l.city, 
    l.state, 
    l.country, 
    w.location_id, 
    w.pH 
FROM Water_Quality w
JOIN Locations l ON w.location_id = l.location_id
WHERE w.pH < 6.5 OR w.pH > 8.5
ORDER BY w.pH ASC;

-- Retrieve the top 5 industrial sources contributing to air pollution in each city.
WITH RankedSources AS (
    SELECT 
        l.city, 
        l.state, 
        l.country, 
        p.source_name, 
        p.emission_level, 
        RANK() OVER (PARTITION BY l.city ORDER BY p.emission_level DESC) AS rank
    FROM Pollution_Sources p
    JOIN Locations l ON p.location_id = l.location_id
    WHERE p.type = 'Industrial'
)
SELECT city, state, country, source_name, emission_level
FROM RankedSources
WHERE rank <= 5;

-- Determine the seasonal variations in pollutant levels across different regions.
WITH SeasonalData AS (
    SELECT 
        l.city,
        l.state,
        l.country,
        CASE 
            WHEN strftime('%m', aq.date) IN ('12', '01', '02') THEN 'Winter'
            WHEN strftime('%m', aq.date) IN ('03', '04', '05') THEN 'Spring'
            WHEN strftime('%m', aq.date) IN ('06', '07', '08') THEN 'Summer'
            ELSE 'Fall'
        END AS season,
        AVG(aq.PM2_5) AS avg_PM2_5,
        AVG(aq.PM10) AS avg_PM10,
        AVG(aq.CO) AS avg_CO,
        AVG(aq.NO2) AS avg_NO2,
        AVG(aq.SO2) AS avg_SO2,
        AVG(aq.O3) AS avg_O3
    FROM Air_Quality aq
    JOIN Locations l ON aq.location_id = l.location_id
    GROUP BY l.city, l.state, l.country, season
)
SELECT * FROM SeasonalData
ORDER BY country, state, city, season;

-- Find the correlation between air pollution and temperature changes over time.
SELECT 
    aq.date,
    l.city,
    l.state,
    l.country,
    w.temperature,
    aq.PM2_5,
    aq.PM10,
    aq.CO,
    aq.NO2,
    aq.SO2,
    aq.O3
FROM Air_Quality aq
JOIN Locations l ON aq.location_id = l.location_id
JOIN Weather_Data w ON aq.date = w.date AND aq.location_id = w.location_id
ORDER BY l.country, l.state, l.city, aq.date;
