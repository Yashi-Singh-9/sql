-- Use FLOOR function in employees table
-- This function is used to return the largest integer less than or equal to a number

-- Table used:
-- employees → stores employee details like id, name, department, salary

-- Apply FLOOR on salary
SELECT salary, FLOOR(salary) AS floor_salary
FROM employees;

-- FLOOR with decimal values
SELECT FLOOR(45.67) AS result;

-- FLOOR after calculation
SELECT name, FLOOR(salary / 1000) AS salary_in_thousands
FROM employees;

-- Explanation
-- FLOOR() → rounds a number down to the nearest integer
-- salary → column used
-- FLOOR(salary) → removes decimal part (if any)
-- FLOOR(45.67) → returns 45
-- FLOOR(salary / 1000) → divides and rounds down

-- Important Note:
-- Works on numeric data types (INT, FLOAT, DECIMAL)
-- Always rounds downward (towards smaller integer)
-- Opposite of CEILING()

-- Example Table Data

-- | id | name  | salary   |
-- | -- | ----- | -------- |
-- | 1  | Rahul | 60000.75 |
-- | 2  | Anita | 45000.50 |

-- Example Output (FLOOR)

-- | salary   | floor_salary |
-- | -------- | ------------ |
-- | 60000.75 | 60000        |
-- | 45000.50 | 45000        |

-- Example Output (Direct Value)

-- | result |
-- | ------ |
-- | 45     |