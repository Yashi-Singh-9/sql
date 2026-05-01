-- Use ROUND function in employees table
-- This function is used to round a number to a specified number of decimal places

-- Table used:
-- employees → stores employee details like id, name, department, salary

-- Round a number to nearest integer
SELECT ROUND(45.67) AS rounded_value;

-- Round salary to 2 decimal places
SELECT salary, ROUND(salary, 2) AS rounded_salary
FROM employees;

-- Round after calculation
SELECT name, ROUND(salary / 1000, 1) AS salary_in_thousands
FROM employees;

-- Explanation
-- ROUND() → rounds a number to nearest value
-- ROUND(45.67) → returns 46
-- ROUND(number, decimal_places) → rounds to given decimals
-- salary → column used
-- ROUND(salary / 1000, 1) → divides and rounds to 1 decimal place

-- Important Note:
-- Works on numeric data types (INT, FLOAT, DECIMAL)
-- If decimal places not specified → rounds to nearest integer
-- Rounds up if decimal >= 0.5, otherwise rounds down

-- Example Table Data

-- | id | name  | salary   |
-- | -- | ----- | -------- |
-- | 1  | Rahul | 60000.75 |
-- | 2  | Anita | 45000.25 |

-- Example Output (ROUND)

-- | rounded_value |
-- | ------------- |
-- | 46            |

-- Example Output (Rounded Salary)

-- | salary   | rounded_salary |
-- | -------- | -------------- |
-- | 60000.75 | 60000.75       |
-- | 45000.25 | 45000.25       |

-- Example Output (Thousands)

-- | name  | salary_in_thousands |
-- | ----- | ------------------- |
-- | Rahul | 60.0                |
-- | Anita | 45.0                |