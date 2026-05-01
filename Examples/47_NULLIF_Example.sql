-- Use NULLIF function in employees table
-- This function compares two expressions and returns NULL if they are equal

-- Table used:
-- employees → stores employee details like id, name, department, salary

-- Basic NULLIF example
SELECT NULLIF(10, 10) AS result;

-- NULLIF with different values
SELECT NULLIF(10, 5) AS result;

-- NULLIF with columns
SELECT name, salary,
NULLIF(salary, 50000) AS updated_salary
FROM employees;

-- Avoid division by zero using NULLIF
SELECT salary / NULLIF(salary, 0) AS safe_division
FROM employees;

-- Explanation
-- NULLIF(a, b) → returns NULL if a = b, otherwise returns a
-- NULLIF(10, 10) → returns NULL
-- NULLIF(10, 5) → returns 10
-- NULLIF(salary, 50000) → returns NULL if salary is 50000
-- salary / NULLIF(salary, 0) → prevents division by zero error

-- Important Note:
-- Useful for handling special conditions
-- Often used with calculations to avoid errors
-- Works with numeric and text values

-- Example Table Data

-- | id | name  | salary |
-- | -- | ----- | ------ |
-- | 1  | Rahul | 60000  |
-- | 2  | Anita | 50000  |
-- | 3  | Ravi  | 0      |

-- Example Output (NULLIF)

-- | result |
-- | ------ |
-- | NULL   |

-- Example Output (Column Usage)

-- | name  | salary | updated_salary |
-- | ----- | ------ | -------------- |
-- | Rahul | 60000  | 60000          |
-- | Anita | 50000  | NULL           |
-- | Ravi  | 0      | 0              |