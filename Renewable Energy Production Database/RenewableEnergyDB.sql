CREATE DATABASE RenewableEnergyDB;
USE RenewableEnergyDB;

-- Power Plant Table 
CREATE TABLE powerplant (
  plant_id INT IDENTITY(1,1) PRIMARY KEY,
  name VARCHAR(20),
  location TEXT,
  capacity_mw DECIMAL(10,2),
  energy_type VARCHAR(20) CHECK (energy_type IN ('Solar', 'Wind', 'Hydro', 'Nuclear', 'Coal', 'Gas', 'Geothermal', 'Biomass')),
  commissioned_date DATE
);

-- Energy Production Table 
CREATE TABLE energy_production (
  production_id INT IDENTITY(1,1) PRIMARY KEY,
  plant_id INT,
  date DATE,
  energy_generated_mwh DECIMAL(10,2),
  FOREIGN KEY (plant_id) REFERENCES powerplant(plant_id)
);

-- Weather Data Table 
CREATE TABLE WeatherData (
    weather_id INT IDENTITY(1,1) PRIMARY KEY,
    plant_id INT,
    date DATE,
    temperature_celsius DECIMAL(5,2),
    wind_speed_mps DECIMAL(5,2),
    solar_irradiance_wm2 DECIMAL(10,2),
    FOREIGN KEY (plant_id) REFERENCES PowerPlant(plant_id)
);

-- Maintenance Records Table 
CREATE TABLE maintenance_records (
  maintenance_id INT IDENTITY(1,1) PRIMARY KEY,
  plant_id INT,
  date DATE,
  description TEXT,
  cost DECIMAL(10,2),
  FOREIGN KEY (plant_id) REFERENCES PowerPlant(plant_id)
);  

-- Energy Consumption Table 
CREATE TABLE energy_consumption (
  consumption_id INT IDENTITY(1,1) PRIMARY KEY,
  plant_id INT,
  date DATE,
  energy_used_mwh DECIMAL(10,2),
  FOREIGN KEY (plant_id) REFERENCES PowerPlant(plant_id)
);

-- Government Subsidies Table 
CREATE TABLE goverment_subsidies (
  subsidy_id INT IDENTITY(1,1) PRIMARY KEY,
  plant_id INT,
  amount DECIMAL(12,2),
  date_received DATE,
  FOREIGN KEY (plant_id) REFERENCES PowerPlant(plant_id)
);

-- Insert sample data into powerplant table
INSERT INTO powerplant (name, location, capacity_mw, energy_type, commissioned_date) VALUES
('SolarOne', 'California', 100.50, 'Solar', '2015-06-12'),
('WindFarmX', 'Texas', 200.75, 'Wind', '2017-09-23'),
('HydroPower1', 'Washington', 500.30, 'Hydro', '2010-04-15'),
('GeoTherm', 'Nevada', 75.20, 'Geothermal', '2018-11-05'),
('BioMassGen', 'Oregon', 120.10, 'Biomass', '2016-07-22'),
('NukePowerA', 'New York', 900.00, 'Nuclear', '2005-12-01'),
('CoalGenB', 'Ohio', 1500.00, 'Coal', '2003-05-18'),
('GasPlantC', 'Florida', 850.40, 'Gas', '2012-08-30');

-- Insert sample data into energy_production table
INSERT INTO energy_production (plant_id, date, energy_generated_mwh) VALUES
(1, '2024-02-01', 95.50),
(3, '2024-02-02', 480.30),
(5, '2024-02-03', 110.75),
(2, '2024-02-04', 190.20),
(4, '2024-02-05', 72.60),
(6, '2024-02-06', 875.40),
(7, '2024-02-07', 1450.30),
(8, '2024-02-08', 830.10);

-- Insert sample data into WeatherData table
INSERT INTO WeatherData (plant_id, date, temperature_celsius, wind_speed_mps, solar_irradiance_wm2) VALUES
(1, '2024-02-01', 30.5, 5.2, 800.4),
(2, '2024-02-02', 28.1, 6.8, 750.0),
(3, '2024-02-03', 15.2, 2.4, 300.6),
(4, '2024-02-04', 20.8, 3.1, 500.8),
(5, '2024-02-05', 22.5, 4.7, 600.9),
(6, '2024-02-06', 18.3, 3.5, 550.2),
(7, '2024-02-07', 10.0, 1.8, 200.5),
(8, '2024-02-08', 35.2, 7.0, 900.7);

-- Insert sample data into maintenance_records table
INSERT INTO maintenance_records (plant_id, date, description, cost) VALUES
(2, '2024-01-10', 'Turbine blade replacement', 15000.00),
(4, '2024-01-12', 'Geothermal pump repair', 7500.00),
(6, '2024-01-15', 'Reactor cooling system maintenance', 20000.00),
(8, '2024-01-18', 'Gas turbine overhaul', 18000.00),
(1, '2024-01-20', 'Solar panel cleaning', 5000.00),
(3, '2024-01-22', 'Hydroelectric generator service', 12000.00),
(5, '2024-01-25', 'Biomass fuel system check', 8000.00),
(7, '2024-01-28', 'Coal conveyor system inspection', 13000.00);

-- Insert sample data into energy_consumption table
INSERT INTO energy_consumption (plant_id, date, energy_used_mwh) VALUES
(1, '2024-02-01', 80.40),
(3, '2024-02-02', 450.20),
(5, '2024-02-03', 100.50),
(2, '2024-02-04', 180.10),
(4, '2024-02-05', 65.30),
(6, '2024-02-06', 820.90),
(7, '2024-02-07', 1400.00),
(8, '2024-02-08', 800.70);

-- Insert sample data into goverment_subsidies table
INSERT INTO goverment_subsidies (plant_id, amount, date_received) VALUES
(1, 500000.00, '2024-01-05'),
(3, 1200000.00, '2024-01-10'),
(5, 750000.00, '2024-01-15'),
(2, 950000.00, '2024-01-20'),
(4, 500000.00, '2024-01-25'),
(6, 2000000.00, '2024-01-30'),
(7, 1800000.00, '2024-02-04'),
(8, 850000.00, '2024-02-08');

-- Retrieve the total energy production for each power plant in a given year.
SELECT plant_id, SUM(energy_generated_mwh) AS total_energy_production
FROM energy_production
WHERE YEAR(date) = 2024
GROUP BY plant_id;

-- Find the power plants that generated the most and least energy in a given month.
SELECT plant_id, SUM(energy_generated_mwh) AS total_energy_production
FROM energy_production
WHERE YEAR(date) = 2024 AND MONTH(date) = 2
GROUP BY plant_id
ORDER BY total_energy_production DESC;

-- Identify which power plants had the most maintenance costs in the last year.
SELECT plant_id, SUM(cost) AS total_maintenance_cost
FROM maintenance_records
WHERE date >= DATEADD(YEAR, -1, GETDATE())
GROUP BY plant_id
ORDER BY total_maintenance_cost DESC;

-- Compare energy production with weather conditions (e.g., solar plants with solar irradiance).
SELECT ep.plant_id, SUM(ep.energy_generated_mwh) AS total_energy, AVG(wd.solar_irradiance_wm2) AS avg_solar_irradiance
FROM energy_production ep
JOIN WeatherData wd ON ep.plant_id = wd.plant_id AND ep.date = wd.date
WHERE ep.plant_id IN (SELECT plant_id FROM powerplant WHERE energy_type = 'Solar')
GROUP BY ep.plant_id;

-- Calculate the average energy consumption per power plant.
SELECT plant_id, AVG(energy_used_mwh) AS avg_energy_consumption
FROM energy_consumption
GROUP BY plant_id;

-- List the power plants that received the highest government subsidies.
SELECT plant_id, SUM(amount) AS total_subsidies
FROM goverment_subsidies
GROUP BY plant_id
ORDER BY total_subsidies DESC;

-- Retrieve the top 3 power plants with the highest energy efficiency (Energy Produced / Capacity).
SELECT TOP 3 ep.plant_id, SUM(ep.energy_generated_mwh) / p.capacity_mw AS energy_efficiency
FROM energy_production ep
JOIN powerplant p ON ep.plant_id = p.plant_id
GROUP BY ep.plant_id, p.capacity_mw
ORDER BY energy_efficiency DESC;

-- Find plants that experienced a drop in energy production compared to the previous month.
SELECT ep1.plant_id
FROM energy_production ep1
JOIN energy_production ep2 ON ep1.plant_id = ep2.plant_id AND MONTH(ep1.date) = MONTH(ep2.date) + 1
WHERE ep1.energy_generated_mwh < ep2.energy_generated_mwh
GROUP BY ep1.plant_id;

-- Identify the months where energy consumption exceeded energy production for any plant.
SELECT ec.plant_id, ec.date
FROM energy_consumption ec
JOIN energy_production ep ON ec.plant_id = ep.plant_id AND ec.date = ep.date
WHERE ec.energy_used_mwh > ep.energy_generated_mwh;

-- List power plants that have been operational for more than 10 years.
SELECT plant_id, name, commissioned_date
FROM powerplant
WHERE DATEDIFF(YEAR, commissioned_date, GETDATE()) > 10;

