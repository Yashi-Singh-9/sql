-- Use Scalar functions in employees table
-- Scalar functions return a single value for each row

-- Table used:
-- employees → stores employee details like id, name, department, salary

-- Example: Convert name to uppercase
SELECT UPPER(name) AS upper_name
FROM employees;

-- Example: Convert name to lowercase
SELECT LOWER(name) AS lower_name
FROM employees;

-- Example: Get length of name
SELECT name, LENGTH(name) AS name_length
FROM employees;

-- Example: Round salary
SELECT salary, ROUND(salary, 2) AS rounded_salary
FROM employees;

-- Example: Current date
SELECT NOW() AS current_datetime;

-- Explanation
-- Scalar Function → returns a single value for each row
-- UPPER() → converts text to uppercase
-- LOWER() → converts text to lowercase
-- LENGTH() → returns number of characters
-- ROUND() → rounds numeric values
-- NOW() → returns current date and time

-- Important Note:
-- Scalar functions work on individual rows
-- They can be used in SELECT, WHERE, ORDER BY, etc.
-- Different databases may have slightly different function names

-- Example Table Data

-- | id | name  | department | salary |
-- | -- | ----- | ---------- | ------ |
-- | 1  | Rahul | IT         | 60000  |
-- | 2  | Anita | HR         | 45000  |

-- Example Output (UPPER)

-- | upper_name |
-- | ---------- |
-- | RAHUL      |
-- | ANITA      |

-- Example Output (LENGTH)

-- | name  | name_length |
-- | ----- | ----------- |
-- | Rahul | 5           |
-- | Anita | 5           |