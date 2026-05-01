-- Use DATE functions in employees table
-- These functions are used to work with date and time values

-- Table used:
-- employees → stores employee details including joining_date

-- Example table with date column
-- | id | name  | joining_date |
-- | -- | ----- | ------------ |

-- Get current date
SELECT CURRENT_DATE AS today_date;

-- Get current date and time
SELECT NOW() AS current_datetime;

-- Extract year from date
SELECT name, YEAR(joining_date) AS join_year
FROM employees;

-- Extract month from date
SELECT name, MONTH(joining_date) AS join_month
FROM employees;

-- Extract day from date
SELECT name, DAY(joining_date) AS join_day
FROM employees;

-- Date difference (number of days)
SELECT DATEDIFF(CURRENT_DATE, joining_date) AS days_worked
FROM employees;

-- Add days to a date
SELECT DATE_ADD(joining_date, INTERVAL 10 DAY) AS new_date
FROM employees;

-- Explanation
-- CURRENT_DATE → returns current date
-- NOW() → returns current date and time
-- YEAR() → extracts year from date
-- MONTH() → extracts month
-- DAY() → extracts day
-- DATEDIFF() → calculates difference between two dates
-- DATE_ADD() → adds interval to date

-- Important Note:
-- Works on DATE, DATETIME data types
-- Format usually: YYYY-MM-DD
-- Functions may vary slightly by database

-- Example Table Data

-- | id | name  | joining_date |
-- | -- | ----- | ------------ |
-- | 1  | Rahul | 2022-01-10   |
-- | 2  | Anita | 2023-03-15   |

-- Example Output (Year)

-- | name  | join_year |
-- | ----- | --------- |
-- | Rahul | 2022      |
-- | Anita | 2023      |

-- Example Output (Date Difference)

-- | days_worked |
-- | ----------- |
-- | (depends on current date) |