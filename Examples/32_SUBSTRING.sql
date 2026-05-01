-- Use SUBSTRING function in employees table
-- This function is used to extract a part of a string

-- Table used:
-- employees → stores employee details like id, name, department, salary

-- Extract first 3 characters of name
SELECT name, SUBSTRING(name, 1, 3) AS short_name
FROM employees;

-- Extract characters from position 2 to 4
SELECT name, SUBSTRING(name, 2, 3) AS part_name
FROM employees;

-- SUBSTRING with condition
SELECT name
FROM employees
WHERE SUBSTRING(name, 1, 1) = 'R';

-- Explanation
-- SUBSTRING() → extracts part of a string
-- name → column used
-- 1 → starting position (starts from 1)
-- 3 → number of characters to extract
-- SUBSTRING(name, 1, 3) → gets first 3 letters
-- WHERE SUBSTRING(name, 1, 1) = 'R' → filters names starting with 'R'

-- Important Note:
-- Works on text data (VARCHAR, CHAR, etc.)
-- Position starts from 1 (not 0)
-- Different databases may use SUBSTR() instead of SUBSTRING()

-- Example Table Data

-- | id | name   | department | salary |
-- | -- | ------ | ---------- | ------ |
-- | 1  | Rahul  | IT         | 60000  |
-- | 2  | Anita  | HR         | 45000  |
-- | 3  | Mohan  | Finance    | 50000  |

-- Example Output (First 3 Characters)

-- | name  | short_name |
-- | ----- | ---------- |
-- | Rahul | Rah        |
-- | Anita | Ani        |
-- | Mohan | Moh        |

-- Example Output (Filtered)

-- | name  |
-- | ----- |
-- | Rahul |