-- Use DATEADD function in employees table
-- This function is used to add a specific time interval to a date

-- Table used:
-- employees → stores employee details including joining_date

-- Example table with date column
-- | id | name  | joining_date |
-- | -- | ----- | ------------ |

-- Add 10 days to joining date
SELECT name, DATEADD(DAY, 10, joining_date) AS new_date
FROM employees;

-- Add 2 months to joining date
SELECT name, DATEADD(MONTH, 2, joining_date) AS new_date
FROM employees;

-- Add 1 year to joining date
SELECT name, DATEADD(YEAR, 1, joining_date) AS new_date
FROM employees;

-- Add hours to current datetime
SELECT DATEADD(HOUR, 5, GETDATE()) AS updated_time;

-- Explanation
-- DATEADD() → adds interval to date/time
-- DAY → adds days
-- MONTH → adds months
-- YEAR → adds years
-- HOUR → adds hours
-- joining_date → column used
-- GETDATE() → returns current date and time (SQL Server)

-- Important Note:
-- Commonly used in SQL Server
-- In MySQL, use DATE_ADD() instead
-- Works with DATE, DATETIME, TIMESTAMP

-- Example Table Data

-- | id | name  | joining_date |
-- | -- | ----- | ------------ |
-- | 1  | Rahul | 2022-01-10   |
-- | 2  | Anita | 2023-03-15   |

-- Example Output (Add 10 Days)

-- | name  | new_date   |
-- | ----- | ---------- |
-- | Rahul | 2022-01-20 |
-- | Anita | 2023-03-25 |

-- Example Output (Add 1 Year)

-- | name  | new_date   |
-- | ----- | ---------- |
-- | Rahul | 2023-01-10 |
-- | Anita | 2024-03-15 |