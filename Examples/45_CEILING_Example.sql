-- Use CEILING function in employees table
-- This function is used to return the smallest integer greater than or equal to a number

-- Table used:
-- employees → stores employee details like id, name, department, salary

-- Apply CEILING on a number
SELECT CEILING(45.23) AS ceiling_value;

-- Apply CEILING on salary
SELECT salary, CEILING(salary) AS ceiling_salary
FROM employees;

-- CEILING after calculation
SELECT name, CEILING(salary / 1000) AS salary_in_thousands
FROM employees;

-- Explanation
-- CEILING() → rounds a number up to the nearest integer
-- CEILING(45.23) → returns 46
-- salary → column used
-- CEILING(salary) → removes decimal and rounds up
-- CEILING(salary / 1000) → divides and rounds up

-- Important Note:
-- Works on numeric data types (INT, FLOAT, DECIMAL)
-- Always rounds upward (towards larger integer)
-- Opposite of FLOOR()

-- Example Table Data

-- | id | name  | salary   |
-- | -- | ----- | -------- |
-- | 1  | Rahul | 60000.25 |
-- | 2  | Anita | 45000.75 |

-- Example Output (CEILING)

-- | ceiling_value |
-- | ------------- |
-- | 46            |

-- Example Output (Ceiling Salary)

-- | salary   | ceiling_salary |
-- | -------- | -------------- |
-- | 60000.25 | 60001          |
-- | 45000.75 | 45001          |

-- Example Output (Thousands)

-- | name  | salary_in_thousands |
-- | ----- | ------------------- |
-- | Rahul | 61                  |
-- | Anita | 46                  |