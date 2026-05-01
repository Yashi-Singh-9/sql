-- Use ABS function in employees table
-- This function is used to return the absolute (positive) value of a number

-- Table used:
-- employees → stores employee details like id, name, department, salary

-- Apply ABS on a value
SELECT ABS(-500) AS positive_value;

-- ABS on salary difference
SELECT name, ABS(salary - 50000) AS salary_difference
FROM employees;

-- ABS with negative values in column
SELECT ABS(salary) AS positive_salary
FROM employees;

-- Explanation
-- ABS() → returns absolute value (removes negative sign)
-- ABS(-500) → returns 500
-- salary - 50000 → calculates difference
-- ABS(salary - 50000) → ensures result is always positive

-- Important Note:
-- Works on numeric data types (INT, FLOAT, DECIMAL)
-- Always returns non-negative value
-- Useful for distance, difference calculations

-- Example Table Data

-- | id | name  | salary  |
-- | -- | ----- | ------- |
-- | 1  | Rahul | 60000   |
-- | 2  | Anita | 45000   |
-- | 3  | Ravi  | -30000  |

-- Example Output (ABS on salary)

-- | positive_salary |
-- | --------------- |
-- | 60000           |
-- | 45000           |
-- | 30000           |

-- Example Output (Difference)

-- | name  | salary_difference |
-- | ----- | ----------------- |
-- | Rahul | 10000             |
-- | Anita | 5000              |