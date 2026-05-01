-- Use DATEPART function in employees table
-- This function is used to extract a specific part of a date or time

-- Table used:
-- employees → stores employee details including joining_date

-- Example table with date column
-- | id | name  | joining_date |
-- | -- | ----- | ------------ |

-- Extract year from date
SELECT name, DATEPART(YEAR, joining_date) AS join_year
FROM employees;

-- Extract month from date
SELECT name, DATEPART(MONTH, joining_date) AS join_month
FROM employees;

-- Extract day from date
SELECT name, DATEPART(DAY, joining_date) AS join_day
FROM employees;

-- Extract hour from datetime
SELECT DATEPART(HOUR, NOW()) AS current_hour;

-- Extract minute from datetime
SELECT DATEPART(MINUTE, NOW()) AS current_minute;

-- Explanation
-- DATEPART() → extracts a specific part of date/time
-- YEAR → returns year
-- MONTH → returns month
-- DAY → returns day
-- HOUR → returns hour
-- MINUTE → returns minute
-- joining_date → column used

-- Important Note:
-- Commonly used in SQL Server
-- In MySQL, use YEAR(), MONTH(), DAY() instead
-- Works with DATE, DATETIME, TIMESTAMP

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

-- Example Output (Month)

-- | name  | join_month |
-- | ----- | ---------- |
-- | Rahul | 1          |
-- | Anita | 3          |