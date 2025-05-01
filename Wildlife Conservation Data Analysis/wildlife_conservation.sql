-- Project in PostgreSQL 
-- Create the database
CREATE DATABASE wildlife_conservation;
\c wildlife_conservation; -- Connect to the database

-- Create ENUM types for PostgreSQL
CREATE TYPE conservation_status_enum AS ENUM ('Least Concern', 'Near Threatened', 'Vulnerable', 'Endangered', 'Critically Endangered', 'Extinct in the Wild', 'Extinct');
CREATE TYPE threat_type_enum AS ENUM ('Poaching', 'Deforestation', 'Climate Change', 'Habitat Destruction', 'Pollution', 'Invasive Species', 'Overexploitation', 'Other');
CREATE TYPE impact_level_enum AS ENUM ('High', 'Medium', 'Low');
CREATE TYPE action_type_enum AS ENUM ('Anti-Poaching Patrol', 'Reforestation', 'Habitat Restoration', 'Wildlife Monitoring', 'Legislation & Policy', 'Community Engagement', 'Captive Breeding', 'Other');

-- Species Table
CREATE TABLE species (
  species_id SERIAL PRIMARY KEY,
  common_name VARCHAR(50),
  scientific_name VARCHAR(100) UNIQUE,
  conservation_status conservation_status_enum NOT NULL,
  habitat TEXT,
  population_estimate INT
);

-- Protected Areas Table
CREATE TABLE protected_areas (
  area_id SERIAL PRIMARY KEY,
  area_name VARCHAR(50),
  locations VARCHAR(100),
  size_km2 DECIMAL(10,2),
  protected_since DATE
);

-- Animal Sightings Table
CREATE TABLE animal_sightings (
  sighting_id SERIAL PRIMARY KEY,
  species_id INT REFERENCES species(species_id),
  area_id INT REFERENCES protected_areas(area_id),
  date DATE,
  observer_name VARCHAR(50),
  counts INT
);

-- Threats Table
CREATE TABLE threats (
  threat_id SERIAL PRIMARY KEY,
  threat_type threat_type_enum NOT NULL,
  severity VARCHAR(50),
  description TEXT
);

-- Species Threats Table
CREATE TABLE species_threats (
  species_id INT REFERENCES species(species_id),
  threat_id INT REFERENCES threats(threat_id),
  impact_level impact_level_enum NOT NULL
);

-- Conservation Actions Table
CREATE TABLE conservation_actions (
  action_id SERIAL PRIMARY KEY,
  action_type action_type_enum NOT NULL,
  start_date DATE,
  end_date DATE,
  description TEXT
);

-- Species Actions Table
CREATE TABLE species_actions (
  species_id INT REFERENCES species(species_id),
  action_id INT REFERENCES conservation_actions(action_id)
);

-- Insert Species Data
INSERT INTO species (common_name, scientific_name, conservation_status, habitat, population_estimate)
VALUES
('African Elephant', 'Loxodonta africana', 'Vulnerable', 'Savannahs, forests', 415000),
('Bengal Tiger', 'Panthera tigris tigris', 'Endangered', 'Tropical rainforests, mangroves', 2500),
('Giant Panda', 'Ailuropoda melanoleuca', 'Vulnerable', 'Bamboo forests', 1864),
('Snow Leopard', 'Panthera uncia', 'Vulnerable', 'Mountain ranges', 4000),
('Green Sea Turtle', 'Chelonia mydas', 'Endangered', 'Oceans, beaches', 85000),
('Polar Bear', 'Ursus maritimus', 'Vulnerable', 'Arctic ice', 22000),
('Blue Whale', 'Balaenoptera musculus', 'Endangered', 'Oceans', 10000),
('Komodo Dragon', 'Varanus komodoensis', 'Vulnerable', 'Islands, dry forests', 3000);

-- Insert Protected Areas Data
INSERT INTO protected_areas (area_name, locations, size_km2, protected_since)
VALUES
('Yellowstone National Park', 'USA', 8983.20, '1872-03-01'),
('Sundarbans National Park', 'India', 1330.10, '1984-05-04'),
('Great Barrier Reef Marine Park', 'Australia', 344400, '1975-06-01'),
('Banff National Park', 'Canada', 6641.00, '1885-11-25'),
('Kruger National Park', 'South Africa', 19485, '1898-05-31'),
('Galápagos National Park', 'Ecuador', 7995.40, '1959-07-04'),
('Serengeti National Park', 'Tanzania', 14763, '1951-06-01'),
('Chitwan National Park', 'Nepal', 952.63, '1973-12-21');

-- Insert Animal Sightings Data
INSERT INTO animal_sightings (species_id, area_id, date, observer_name, counts)
VALUES
(1, 5, '2023-02-15', 'Dr. Jane Smith', 30),
(2, 2, '2023-05-20', 'Ravi Kumar', 4),
(3, 6, '2023-03-10', 'Carlos Mendoza', 15),
(4, 4, '2023-06-18', 'Emily Johnson', 5),
(5, 3, '2023-07-25', 'James Lee', 50),
(6, 1, '2023-08-05', 'Sarah Brown', 2),
(7, 3, '2023-09-30', 'William Turner', 1),
(8, 7, '2023-10-14', 'Anna Schmidt', 12);

-- Insert Threats Data
INSERT INTO threats (threat_type, severity, description)
VALUES
('Poaching', 'High', 'Illegal hunting for tusks and skins'),
('Deforestation', 'Critical', 'Loss of habitat due to tree cutting'),
('Climate Change', 'High', 'Rising temperatures affecting wildlife'),
('Habitat Destruction', 'Medium', 'Urbanization and land conversion'),
('Pollution', 'Moderate', 'Plastic and chemical pollution in oceans'),
('Invasive Species', 'Low', 'Non-native species disrupting ecosystems'),
('Overexploitation', 'High', 'Excessive hunting and fishing'),
('Other', 'Low', 'Miscellaneous threats to biodiversity');

-- Insert Species Threats Data
INSERT INTO species_threats (species_id, threat_id, impact_level)
VALUES
(1, 1, 'High'),
(2, 2, 'Low'),
(3, 3, 'High'),
(4, 4, 'Medium'),
(5, 5, 'Low'),
(6, 3, 'High'),
(7, 6, 'Low'),
(8, 7, 'High');

-- Insert Conservation Actions Data
INSERT INTO conservation_actions (action_type, start_date, end_date, description)
VALUES
('Anti-Poaching Patrol', '2022-01-15', '2025-12-31', 'Deploying rangers to monitor poaching activities'),
('Reforestation', '2021-06-10', NULL, 'Planting trees to restore deforested areas'),
('Habitat Restoration', '2023-03-05', '2026-06-15', 'Rehabilitating damaged ecosystems'),
('Wildlife Monitoring', '2020-07-20', NULL, 'Tracking animal populations and movements'),
('Legislation & Policy', '2019-05-01', NULL, 'Creating laws for wildlife protection'),
('Community Engagement', '2021-09-30', NULL, 'Educating locals on conservation importance'),
('Captive Breeding', '2018-11-10', NULL, 'Breeding endangered species in captivity'),
('Other', '2022-12-01', NULL, 'Miscellaneous conservation efforts');

-- Insert Species Actions Data
INSERT INTO species_actions (species_id, action_id)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8);

-- Find the top 4 species with the lowest population estimates.
SELECT species_id, common_name, scientific_name, population_estimate
FROM species
ORDER BY population_estimate ASC
LIMIT 4;

-- Retrieve all species classified as "Endangered" or "Critically Endangered."
SELECT species_id, common_name, scientific_name, conservation_status
FROM species
WHERE conservation_status IN ('Endangered', 'Critically Endangered');

-- List all protected areas with a size greater than 9000 km².
SELECT area_id, area_name, locations, size_km2
FROM protected_areas
WHERE size_km2 > 9000;

-- Identify which protected area has the highest number of animal sightings.
SELECT pa.area_id, pa.area_name, COUNT(asg.sighting_id) AS total_sightings
FROM protected_areas pa
JOIN animal_sightings asg ON pa.area_id = asg.area_id
GROUP BY pa.area_id, pa.area_name
ORDER BY total_sightings DESC
LIMIT 1;

-- Find the total number of sightings recorded for each species.
SELECT s.species_id, s.common_name, SUM(asg.counts) AS total_sightings
FROM species s
JOIN animal_sightings asg ON s.species_id = asg.species_id
GROUP BY s.species_id, s.common_name
ORDER BY total_sightings DESC;

-- Determine the most commonly observed species in a given protected area.
SELECT s.species_id, s.common_name, SUM(asg.counts) AS total_sightings
FROM species s
JOIN animal_sightings asg ON s.species_id = asg.species_id
WHERE asg.area_id = 5
GROUP BY s.species_id, s.common_name
ORDER BY total_sightings DESC
LIMIT 1;

-- Find the top 3 threats affecting the most species.
SELECT t.threat_id, t.threat_type, COUNT(st.species_id) AS affected_species_count
FROM threats t
JOIN species_threats st ON t.threat_id = st.threat_id
GROUP BY t.threat_id, t.threat_type
ORDER BY affected_species_count DESC
LIMIT 3;

-- List all species impacted by "Poaching" along with their impact level.
SELECT s.species_id, s.common_name, st.impact_level
FROM species s
JOIN species_threats st ON s.species_id = st.species_id
JOIN threats t ON st.threat_id = t.threat_id
WHERE t.threat_type = 'Poaching';

-- Retrieve all conservation actions that lasted more than 2 years.
SELECT action_id, action_type, start_date, end_date, 
       AGE(end_date, start_date) AS duration
FROM conservation_actions
WHERE end_date IS NOT NULL AND AGE(end_date, start_date) > INTERVAL '2 years';

-- Identify which species are linked to the most conservation actions.
SELECT s.species_id, s.common_name, COUNT(sa.action_id) AS total_actions
FROM species s
JOIN species_actions sa ON s.species_id = sa.species_id
GROUP BY s.species_id, s.common_name
ORDER BY total_actions DESC
LIMIT 1;

-- Find species with a population estimate between 1,000 and 10,000.
SELECT species_id, common_name, scientific_name, population_estimate
FROM species
WHERE population_estimate BETWEEN 1000 AND 10000
ORDER BY population_estimate ASC;

-- Count the number of species per conservation status.
SELECT conservation_status, COUNT(*) AS species_count
FROM species
GROUP BY conservation_status
ORDER BY species_count DESC;

-- Find the average protected area size
SELECT AVG(size_km2) AS avg_protected_area_size
FROM protected_areas;

-- Identify protected areas that were established before the year 2000.
SELECT area_id, area_name, locations, protected_since
FROM protected_areas
WHERE protected_since < '2000-01-01'
ORDER BY protected_since ASC;

-- Find the species with the highest total sightings across all areas
SELECT s.species_id, s.common_name, SUM(asg.counts) AS total_sightings
FROM species s
JOIN animal_sightings asg ON s.species_id = asg.species_id
GROUP BY s.species_id, s.common_name
ORDER BY total_sightings DESC
LIMIT 1;

--  Identify the most severe threat (by frequency of affected species).
SELECT t.threat_type, COUNT(st.species_id) AS affected_species_count
FROM threats t
JOIN species_threats st ON t.threat_id = st.threat_id
GROUP BY t.threat_type
ORDER BY affected_species_count DESC
LIMIT 1;

-- Count the number of conservation actions per species.
SELECT s.species_id, s.common_name, COUNT(sa.action_id) AS conservation_actions_count
FROM species s
JOIN species_actions sa ON s.species_id = sa.species_id
GROUP BY s.species_id, s.common_name
ORDER BY conservation_actions_count DESC;

-- Find the total number of recorded sightings in each protected area.
SELECT pa.area_id, pa.area_name, SUM(asg.counts) AS total_sightings
FROM protected_areas pa
JOIN animal_sightings asg ON pa.area_id = asg.area_id
GROUP BY pa.area_id, pa.area_name
ORDER BY total_sightings DESC;

-- Retrieve the most recent conservation action taken.
SELECT action_id, action_type, start_date, end_date, description
FROM conservation_actions
ORDER BY start_date DESC
LIMIT 1;