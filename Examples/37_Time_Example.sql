-- Use TIME functions in employees table
-- These functions are used to work with time values

-- Table used:
-- employees → stores employee details including login_time

-- Example table with time column
-- | id | name  | login_time |
-- | -- | ----- | ---------- |

-- Get current time
SELECT CURRENT_TIME AS current_time;

-- Get current date and time
SELECT NOW() AS current_datetime;

-- Extract hour from time
SELECT name, HOUR(login_time) AS login_hour
FROM employees;

-- Extract minutes from time
SELECT name, MINUTE(login_time) AS login_minute
FROM employees;

-- Extract seconds from time
SELECT name, SECOND(login_time) AS login_second
FROM employees;

-- Add time interval
SELECT ADDTIME(login_time, '01:30:00') AS updated_time
FROM employees;

-- Time difference
SELECT TIMEDIFF(NOW(), login_time) AS time_difference
FROM employees;

-- Explanation
-- CURRENT_TIME → returns current time
-- NOW() → returns current date and time
-- HOUR() → extracts hour from time
-- MINUTE() → extracts minutes
-- SECOND() → extracts seconds
-- ADDTIME() → adds time interval
-- TIMEDIFF() → finds difference between two times

-- Important Note:
-- Works on TIME and DATETIME data types
-- Format usually: HH:MM:SS
-- Functions may vary slightly by database

-- Example Table Data

-- | id | name  | login_time |
-- | -- | ----- | ---------- |
-- | 1  | Rahul | 09:30:00   |
-- | 2  | Anita | 10:15:30   |

-- Example Output (Hour)

-- | name  | login_hour |
-- | ----- | ---------- |
-- | Rahul | 9          |
-- | Anita | 10         |

-- Example Output (Time Difference)

-- | time_difference |
-- | --------------- |
-- | (depends on current time) |