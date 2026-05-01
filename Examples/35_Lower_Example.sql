-- Use LOWER function in employees table
-- This function is used to convert text into lowercase letters

-- Table used:
-- employees → stores employee details like id, name, department, salary

-- Convert employee names to lowercase
SELECT name, LOWER(name) AS lower_name
FROM employees;

-- Convert department names to lowercase
SELECT department, LOWER(department) AS lower_department
FROM employees;

-- LOWER with condition
SELECT name
FROM employees
WHERE LOWER(department) = 'it';

-- Explanation
-- LOWER() → converts text to lowercase
-- name → column used
-- LOWER(name) → converts name into small letters
-- AS lower_name → alias for result column
-- WHERE LOWER(department) = 'it' → compares in lowercase

-- Important Note:
-- Works on text data (VARCHAR, CHAR, etc.)
-- Useful for case-insensitive comparisons
-- Does not change original data, only displays modified result

-- Example Table Data

-- | id | name  | department | salary |
-- | -- | ----- | ---------- | ------ |
-- | 1  | RAHUL | IT         | 60000  |
-- | 2  | ANITA | HR         | 45000  |

-- Example Output (LOWER)

-- | name  | lower_name |
-- | ----- | ---------- |
-- | RAHUL | rahul      |
-- | ANITA | anita      |

-- Example Output (Department Lowercase)

-- | department | lower_department |
-- | ---------- | ---------------- |
-- | IT         | it               |
-- | HR         | hr               |