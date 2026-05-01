-- Use MOD function in employees table
-- This function is used to find the remainder after division

-- Table used:
-- employees → stores employee details like id, name, department, salary

-- Find remainder of a number
SELECT MOD(10, 3) AS remainder;

-- Apply MOD on salary
SELECT name, MOD(salary, 1000) AS salary_remainder
FROM employees;

-- Use MOD to check even or odd
SELECT id, name,
MOD(id, 2) AS even_odd_check
FROM employees;

-- Explanation
-- MOD(a, b) → returns remainder when a is divided by b
-- MOD(10, 3) → returns 1
-- salary % 1000 → finds leftover after dividing salary by 1000
-- MOD(id, 2) → returns 0 (even) or 1 (odd)

-- Important Note:
-- Works on numeric data types
-- Used in calculations, patterns, and conditions
-- Can also be written as: a % b (in many databases)

-- Example Table Data

-- | id | name  | salary |
-- | -- | ----- | ------ |
-- | 1  | Rahul | 60000  |
-- | 2  | Anita | 45000  |
-- | 3  | Ravi  | 50000  |

-- Example Output (MOD)

-- | remainder |
-- | --------- |
-- | 1         |

-- Example Output (Salary Remainder)

-- | name  | salary_remainder |
-- | ----- | ---------------- |
-- | Rahul | 0                |
-- | Anita | 0                |
-- | Ravi  | 0                |

-- Example Output (Even/Odd Check)

-- | id | name  | even_odd_check |
-- | -- | ----- | -------------- |
-- | 1  | Rahul | 1              | ← Odd
-- | 2  | Anita | 0              | ← Even
-- | 3  | Ravi  | 1              | ← Odd