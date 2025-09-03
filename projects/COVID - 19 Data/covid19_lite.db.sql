-- Project in SQL LITE 
sqlite3 covid19_lite.db

-- Countries Table  
CREATE TABLE countries (
  country_id INTEGER PRIMARY KEY,
  country_name VARCHAR(100) NOT NULL,
  population BIGINT NULL
);

INSERT INTO countries (country_name, population) VALUES
('United States', 331002651),
('China', 1444216107),
('India', 1393409038),
('Brazil', 213993437),
('Germany', 83240525),
('United Kingdom', 67886011),
('France', 65273511),
('Japan', 126476461),
('Canada', 38005238),
('Australia', 25687041),
('Russia', 145912025),
('South Africa', 59308690);

-- Cases Table 
CREATE TABLE cases (
  case_id INTEGER PRIMARY KEY,
  country_id INTEGER NOT NULL,
  report_date DATE NOT NULL,
  confirmed INT NOT NULL DEFAULT 0,
  deaths INT NOT NULL DEFAULT 0,
  recovered INT NOT NULL DEFAULT 0,
  FOREIGN KEY (country_id) REFERENCES countries(country_id)
);

INSERT INTO cases (country_id, report_date, confirmed, deaths, recovered) VALUES
(1, '2024-02-01', 1500, 25, 900),
(3, '2024-02-02', 2300, 40, 1700),
(5, '2024-02-03', 800, 10, 500),
(7, '2024-02-04', 600, 5, 450),
(1, '2024-02-05', 2100, 30, 1800),
(8, '2024-02-06', 1200, 15, 900),
(2, '2024-02-07', 5000, 80, 4200),
(4, '2024-02-08', 3200, 60, 2900),
(6, '2024-02-09', 1400, 18, 1100),
(3, '2024-02-10', 2600, 50, 2000),
(9, '2024-02-11', 700, 8, 500),
(10, '2024-02-12', 1100, 12, 900);

-- Testing Table  
CREATE TABLE testing (
  test_id INTEGER PRIMARY KEY,
  country_id INTEGER,
  test_date DATE NOT NULL,
  total_tests BIGINT NOT NULL DEFAULT 0,
  positive_tests INT NOT NULL DEFAULT 0,
  FOREIGN KEY (country_id) REFERENCES countries(country_id)
);

INSERT INTO testing (country_id, test_date, total_tests, positive_tests) VALUES
(1, '2024-02-01', 50000, 1500),
(3, '2024-02-02', 75000, 2300),
(5, '2024-02-03', 20000, 800),
(7, '2024-02-04', 18000, 600),
(1, '2024-02-05', 90000, 2100),
(8, '2024-02-06', 25000, 1200),
(2, '2024-02-07', 150000, 5000),
(4, '2024-02-08', 95000, 3200),
(NULL, '2024-02-09', 30000, 1400),  
(3, '2024-02-10', 80000, 2600),
(9, '2024-02-11', 16000, 700),
(10, '2024-02-12', 28000, 1100);

-- Vaccinations Table  
CREATE TABLE vaccinations (
  vaccine_id INTEGER PRIMARY KEY,
  country_id INTEGER,
  vaccine_date DATE NOT NULL,
  total_vaccinations BIGINT NOT NULL DEFAULT 0,
  fully_vaccinated BIGINT NOT NULL DEFAULT 0,
  FOREIGN KEY (country_id) REFERENCES countries(country_id)
);

INSERT INTO vaccinations (country_id, vaccine_date, total_vaccinations, fully_vaccinated) VALUES
(1, '2024-02-01', 500000, 250000),
(3, '2024-02-02', 750000, 400000),
(5, '2024-02-03', 200000, 100000),
(7, '2024-02-04', 180000, 90000),
(1, '2024-02-05', 900000, 500000),
(8, '2024-02-06', 250000, 125000),
(2, '2024-02-07', 1500000, 800000),
(NULL, '2024-02-08', 950000, 480000);

-- Find the total confirmed cases in a specific country.
SELECT country_id, SUM(confirmed) AS total_confirmed_cases
FROM cases
WHERE country_id = 3
GROUP BY country_id;

-- Get the number of deaths on a specific date globally.
SELECT report_date, SUM(deaths) AS total_deaths
FROM cases
WHERE report_date = '2024-02-10'
GROUP BY report_date;

-- Find the country with the highest number of recovered cases.
SELECT country_id, SUM(recovered) AS total_recovered
FROM cases
GROUP BY country_id
ORDER BY total_recovered DESC
LIMIT 1;

-- Find the daily increase in confirmed cases for a country.
SELECT report_date, confirmed - LAG(confirmed, 1, 0) OVER (ORDER BY report_date) AS daily_increase
FROM cases
WHERE country_id = 3;

-- Calculate the mortality rate (deaths/confirmed cases) for each country.
SELECT country_id, 
       SUM(deaths) AS total_deaths, 
       SUM(confirmed) AS total_confirmed, 
       (SUM(deaths) * 100.0 / NULLIF(SUM(confirmed), 0)) AS mortality_rate
FROM cases
GROUP BY country_id;

-- Get the percentage of population tested in each country.
SELECT t.country_id, 
       c.population, 
       SUM(t.total_tests) AS total_tests,
       (SUM(t.total_tests) * 100.0 / NULLIF(c.population, 0)) AS percent_population_tested
FROM testing t
JOIN countries c ON t.country_id = c.country_id
GROUP BY t.country_id, c.population;

-- Find the country with the highest vaccination rate (fully vaccinated/population).
SELECT v.country_id, 
       c.population, 
       SUM(v.fully_vaccinated) AS total_fully_vaccinated,
       (SUM(v.fully_vaccinated) * 100.0 / NULLIF(c.population, 0)) AS vaccination_rate
FROM vaccinations v
JOIN countries c ON v.country_id = c.country_id
GROUP BY v.country_id, c.population
ORDER BY vaccination_rate DESC
LIMIT 1;

-- Compare the number of tests performed with the number of confirmed cases per country.
SELECT t.country_id, 
       SUM(t.total_tests) AS total_tests, 
       SUM(c.confirmed) AS total_confirmed_cases,
       (SUM(c.confirmed) * 100.0 / NULLIF(SUM(t.total_tests), 0)) AS test_positive_rate
FROM testing t
JOIN cases c ON t.country_id = c.country_id
GROUP BY t.country_id;

-- Identify countries where the death rate is increasing over time.
WITH death_trend AS (
    SELECT country_id, report_date, deaths,
           deaths - LAG(deaths, 1, 0) OVER (PARTITION BY country_id ORDER BY report_date) AS daily_death_increase
    FROM cases
)
SELECT country_id, report_date, deaths, daily_death_increase
FROM death_trend
WHERE daily_death_increase > 0;

-- Find the top 5 countries with the highest total confirmed cases
SELECT country_id, SUM(confirmed) AS total_confirmed
FROM cases
GROUP BY country_id
ORDER BY total_confirmed DESC
LIMIT 5;

-- Get the average number of daily confirmed cases for a country
SELECT country_id, AVG(confirmed) AS avg_daily_cases
FROM cases
WHERE country_id = 3;

-- Find the cumulative confirmed cases for each country over time
SELECT country_id, report_date, 
       SUM(confirmed) OVER (PARTITION BY country_id ORDER BY report_date) AS cumulative_cases
FROM cases;

-- Identify countries where testing is increasing over time
WITH test_trend AS (
    SELECT country_id, test_date, total_tests,
           total_tests - LAG(total_tests, 1, 0) OVER (PARTITION BY country_id ORDER BY test_date) AS daily_test_increase
    FROM testing
)
SELECT country_id, test_date, total_tests, daily_test_increase
FROM test_trend
WHERE daily_test_increase > 0;

-- Find the daily positivity rate (positive_tests / total_tests * 100) for each country
SELECT country_id, test_date, 
       (positive_tests * 100.0 / NULLIF(total_tests, 0)) AS positivity_rate
FROM testing;

-- Identify countries where vaccinations are outpacing new cases
SELECT v.country_id, 
       SUM(v.fully_vaccinated) AS total_vaccinated, 
       SUM(c.confirmed) AS total_confirmed_cases,
       (SUM(v.fully_vaccinated) - SUM(c.confirmed)) AS vax_vs_cases
FROM vaccinations v
JOIN cases c ON v.country_id = c.country_id
GROUP BY v.country_id
ORDER BY vax_vs_cases DESC;

-- Get the daily increase in vaccinations for each country
WITH vax_trend AS (
    SELECT country_id, vaccine_date, total_vaccinations,
           total_vaccinations - LAG(total_vaccinations, 1, 0) OVER (PARTITION BY country_id ORDER BY vaccine_date) AS daily_vax_increase
    FROM vaccinations
)
SELECT country_id, vaccine_date, daily_vax_increase
FROM vax_trend
WHERE daily_vax_increase > 0;
