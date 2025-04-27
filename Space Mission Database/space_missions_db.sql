-- MS SQL Project 
CREATE DATABASE space_missions_db;
USE space_missions_db;

-- Agencies Table  
CREATE TABLE agencies (
  agency_id INT IDENTITY(1,1) PRIMARY KEY,
  agency_name VARCHAR(50),
  country VARCHAR(50),
  founded_year INT
);

-- Vehicles Table  
CREATE TABLE vehicles (
  vehicle_id INT IDENTITY(1,1) PRIMARY KEY,
  vehicle_name VARCHAR(50),
  manufacturer VARCHAR(50),
  thrust_power INT,
  fuel_type VARCHAR(50)
);

-- Destinations Table  
CREATE TABLE destinations (
  destination_id INT IDENTITY(1,1) PRIMARY KEY,
  destination_name VARCHAR(50),
  type VARCHAR(14) CHECK (type IN ('Planet', 'Moon', 'Space Station', 'Asteroid')),
  distance_from_earth_km INT
);

-- Astronauts Table  
CREATE TABLE astronauts (
  astronaut_id INT IDENTITY(1,1) PRIMARY KEY,
  astronaut_name VARCHAR(50),
  date_of_birth DATE,
  nationality VARCHAR(50),
  missions_participated INT
);

-- Missions Table  
CREATE TABLE missions (
  mission_id INT IDENTITY(1,1) PRIMARY KEY,
  mission_name VARCHAR(50),
  launch_date DATE,
  agency_id INT,
  vehicle_id INT,
  destination_id INT,
  status VARCHAR(7) CHECK (status IN ('Success', 'Failure', 'Ongoing')),
  FOREIGN KEY (agency_id) REFERENCES agencies(agency_id),
  FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id),
  FOREIGN KEY (destination_id) REFERENCES destinations(destination_id)
);

-- Mission Crew Table 
CREATE TABLE mission_crew (
  mission_id INT,
  astronaut_id INT,
  role VARCHAR(10) CHECK (role IN ('Commander', 'Pilot', 'Engineer', 'Scientist')),
  FOREIGN KEY (mission_id) REFERENCES missions(mission_id),
  FOREIGN KEY (astronaut_id) REFERENCES astronauts(astronaut_id)
);  

-- Insert data into agencies table
INSERT INTO agencies (agency_name, country, founded_year) VALUES
('NASA', 'USA', 1958),
('ESA', 'Europe', 1975),
('Roscosmos', 'Russia', 1992),
('ISRO', 'India', 1969),
('CNSA', 'China', 1993),
('JAXA', 'Japan', 2003),
('SpaceX', 'USA', 2002);

-- Insert data into vehicles table
INSERT INTO vehicles (vehicle_name, manufacturer, thrust_power, fuel_type) VALUES
('Falcon 9', 'SpaceX', 7607, 'Liquid'),
('Saturn V', 'NASA', 34000, 'Liquid'),
('Soyuz-FG', 'Roscosmos', 7920, 'Liquid'),
('GSLV Mk III', 'ISRO', 7600, 'Solid & Liquid'),
('Ariane 5', 'ESA', 13900, 'Liquid & Solid'),
('Long March 5', 'CNSA', 10600, 'Liquid'),
('H-IIA', 'JAXA', 9800, 'Liquid');

-- Insert data into destinations table
INSERT INTO destinations (destination_name, type, distance_from_earth_km) VALUES
('Moon', 'Moon', 384400),
('International Space Station', 'Space Station', 400),
('Mars', 'Planet', 225000000),
('Jupiter', 'Planet', 778500000),
('Asteroid Bennu', 'Asteroid', 110000000),
('Venus', 'Planet', 41000000),
('Europa', 'Moon', 628300000);

-- Insert data into astronauts table
INSERT INTO astronauts (astronaut_name, date_of_birth, nationality, missions_participated) VALUES
('Neil Armstrong', '1930-08-05', 'American', 2),
('Yuri Gagarin', '1934-03-09', 'Russian', 1),
('Chris Hadfield', '1959-08-29', 'Canadian', 3),
('Kalpana Chawla', '1961-03-17', 'Indian-American', 2),
('Buzz Aldrin', '1930-01-20', 'American', 2),
('Valentina Tereshkova', '1937-03-06', 'Russian', 1),
('Yang Liwei', '1965-06-21', 'Chinese', 1);

-- Insert data into missions table
INSERT INTO missions (mission_name, launch_date, agency_id, vehicle_id, destination_id, status) VALUES
('Apollo 11', '1969-07-16', 1, 2, 1, 'Success'),
('Vostok 1', '1961-04-12', 3, 3, 2, 'Success'),
('Mars Rover', '2012-08-06', 1, 1, 3, 'Success'),
('Chandrayaan-2', '2019-07-22', 4, 4, 1, 'Failure'),
('Tianwen-1', '2020-07-23', 5, 6, 3, 'Success'),
('Juno', '2011-08-05', 1, 2, 4, 'Success'),
('Hayabusa2', '2014-12-03', 6, 7, 5, 'Success');

-- Insert data into mission_crew table
INSERT INTO mission_crew (mission_id, astronaut_id, role) VALUES
(1, 1, 'Commander'),
(1, 5, 'Pilot'),
(2, 2, 'Commander'),
(3, 3, 'Engineer'),
(4, 4, 'Scientist'),
(5, 7, 'Pilot'),
(6, 6, 'Commander');

-- 1. Retrieve all missions that were launched by NASA.
SELECT m.*
FROM missions m
JOIN agencies a ON m.agency_id = a.agency_id
WHERE a.agency_name = 'NASA';

-- 2. List all astronauts who participated in more than 2 missions.
SELECT astronaut_name
FROM astronauts
WHERE missions_participated > 2;

-- 3. Find the names of vehicles that have been used in failed missions.
SELECT DISTINCT v.vehicle_name
FROM missions m
JOIN vehicles v ON m.vehicle_id = v.vehicle_id
WHERE m.status = 'Failure';

-- 4. Retrieve the total number of missions each space agency has conducted.
SELECT a.agency_name, COUNT(m.mission_id) AS total_missions
FROM missions m
JOIN agencies a ON m.agency_id = a.agency_id
GROUP BY a.agency_name;

-- 5. List all destinations along with the number of missions sent to each.
SELECT d.destination_name, COUNT(m.mission_id) AS mission_count
FROM missions m
JOIN destinations d ON m.destination_id = d.destination_id
GROUP BY d.destination_name;

-- 6. Find the most frequently used launch vehicle.
SELECT TOP 1 v.vehicle_name, COUNT(m.mission_id) AS usage_count
FROM missions m
JOIN vehicles v ON m.vehicle_id = v.vehicle_id
GROUP BY v.vehicle_name
ORDER BY usage_count DESC;

-- 7. Retrieve the astronaut(s) who have participated in the most missions.
SELECT TOP 1 astronaut_name, missions_participated
FROM astronauts
ORDER BY missions_participated DESC;

-- 8. List all astronauts who have been on missions to Mars.
SELECT DISTINCT a.astronaut_name
FROM mission_crew mc
JOIN missions m ON mc.mission_id = m.mission_id
JOIN destinations d ON m.destination_id = d.destination_id
JOIN astronauts a ON mc.astronaut_id = a.astronaut_id
WHERE d.destination_name = 'Mars';

-- 9. Find missions that had more than 1 crew members.
SELECT m.mission_name, COUNT(mc.astronaut_id) AS crew_count
FROM mission_crew mc
JOIN missions m ON mc.mission_id = m.mission_id
GROUP BY m.mission_name
HAVING COUNT(mc.astronaut_id) > 1;

-- 10. Retrieve all missions that occurred between 2000 and 2020 and were successful.
SELECT *
FROM missions
WHERE launch_date BETWEEN '2000-01-01' AND '2020-12-31' AND status = 'Success';

-- 11. Find the country with the highest number of space missions.
SELECT TOP 1 a.country, COUNT(m.mission_id) AS total_missions
FROM missions m
JOIN agencies a ON m.agency_id = a.agency_id
GROUP BY a.country
ORDER BY total_missions DESC;

-- 12. Retrieve all missions where the destination is more than 500,000 km away from Earth.
SELECT m.*
FROM missions m
JOIN destinations d ON m.destination_id = d.destination_id
WHERE d.distance_from_earth_km > 500000;

-- 13. List all agencies and the number of astronauts they have sent to space.
SELECT a.agency_name, COUNT(DISTINCT mc.astronaut_id) AS astronauts_count
FROM mission_crew mc
JOIN missions m ON mc.mission_id = m.mission_id
JOIN agencies a ON m.agency_id = a.agency_id
GROUP BY a.agency_name;

-- 14. Find the youngest astronaut to participate in a space mission.
SELECT TOP 1 a.astronaut_name, a.date_of_birth
FROM mission_crew mc
JOIN astronauts a ON mc.astronaut_id = a.astronaut_id
ORDER BY a.date_of_birth DESC;

-- 15. Retrieve the name of the astronaut who has traveled to the most destinations.
SELECT TOP 1 a.astronaut_name, COUNT(DISTINCT m.destination_id) AS destinations_visited
FROM mission_crew mc
JOIN missions m ON mc.mission_id = m.mission_id
JOIN astronauts a ON mc.astronaut_id = a.astronaut_id
GROUP BY a.astronaut_name
ORDER BY destinations_visited DESC;

-- 16. Find the average number of missions conducted per space agency.
SELECT AVG(mission_count) AS avg_missions_per_agency
FROM (
    SELECT a.agency_name, COUNT(m.mission_id) AS mission_count
    FROM missions m
    JOIN agencies a ON m.agency_id = a.agency_id
    GROUP BY a.agency_name
) AS mission_counts;

-- 17. Retrieve all astronauts who have participated in at least one failed mission.
SELECT DISTINCT a.astronaut_name
FROM mission_crew mc
JOIN missions m ON mc.mission_id = m.mission_id
JOIN astronauts a ON mc.astronaut_id = a.astronaut_id
WHERE m.status = 'Failure';

-- 18. Find the mission with the longest distance traveled from Earth.
SELECT TOP 1 m.mission_name, d.destination_name, d.distance_from_earth_km
FROM missions m
JOIN destinations d ON m.destination_id = d.destination_id
ORDER BY d.distance_from_earth_km DESC;

-- 19. Retrieve the top 3 space agencies with the most missions.
SELECT TOP 3 a.agency_name, COUNT(m.mission_id) AS total_missions
FROM missions m
JOIN agencies a ON m.agency_id = a.agency_id
GROUP BY a.agency_name
ORDER BY total_missions DESC;

-- 20. Find all missions that used the same launch vehicle more than once.
SELECT v.vehicle_name, COUNT(m.mission_id) AS mission_count
FROM missions m
JOIN vehicles v ON m.vehicle_id = v.vehicle_id
GROUP BY v.vehicle_name
HAVING COUNT(m.mission_id) > 1;

-- 21. Retrieve all missions where at least one astronaut was a Commander.
SELECT DISTINCT m.mission_name
FROM mission_crew mc
JOIN missions m ON mc.mission_id = m.mission_id
WHERE mc.role = 'Commander';

-- 22. Find the most experienced astronaut (who participated in the most missions).
SELECT TOP 1 astronaut_name, missions_participated
FROM astronauts
ORDER BY missions_participated DESC;

-- 23. List the number of missions for each type of destination.
SELECT d.type, COUNT(m.mission_id) AS total_missions
FROM missions m
JOIN destinations d ON m.destination_id = d.destination_id
GROUP BY d.type;

-- 24. Retrieve the number of failed missions for each space agency.
SELECT a.agency_name, COUNT(m.mission_id) AS failed_missions
FROM missions m
JOIN agencies a ON m.agency_id = a.agency_id
WHERE m.status = 'Failure'
GROUP BY a.agency_name;

-- 25. Find astronauts who have only participated in successful missions.
SELECT a.astronaut_name
FROM astronauts a
WHERE a.astronaut_id NOT IN (
    SELECT DISTINCT mc.astronaut_id
    FROM mission_crew mc
    JOIN missions m ON mc.mission_id = m.mission_id
    WHERE m.status = 'Failure'
);

-- 26. Find the most commonly assigned astronaut role in missions.
SELECT TOP 1 mc.role, COUNT(*) AS role_count
FROM mission_crew mc
GROUP BY mc.role
ORDER BY role_count DESC;

-- 27. List the number of astronauts each space agency has sent on missions.
SELECT a.agency_name, COUNT(DISTINCT mc.astronaut_id) AS astronaut_count
FROM mission_crew mc
JOIN missions m ON mc.mission_id = m.mission_id
JOIN agencies a ON m.agency_id = a.agency_id
GROUP BY a.agency_name;
