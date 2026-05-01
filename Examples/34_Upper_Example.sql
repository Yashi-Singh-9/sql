-- Use REPLACE function in employees table
-- This function is used to replace part of a string with another value

-- Table used:
-- employees → stores employee details like id, name, department, salary

-- Replace 'IT' with 'Information Tech'
SELECT department, REPLACE(department, 'IT', 'Information Tech') AS updated_department
FROM employees;

-- Replace part of name
SELECT name, REPLACE(name, 'a', '@') AS modified_name
FROM employees;

-- REPLACE with condition
SELECT name
FROM employees
WHERE REPLACE(name, 'a', '') = 'Rhul';

-- Explanation
-- REPLACE() → replaces a substring with another substring
-- department → column used
-- 'IT' → text to be replaced
-- 'Information Tech' → new replacement text
-- AS updated_department → alias for result
-- REPLACE(name, 'a', '@') → replaces all 'a' with '@'

-- Important Note:
-- Works on text data (VARCHAR, CHAR, etc.)
-- Replaces all occurrences of the specified substring
-- Case sensitivity depends on database

-- Example Table Data

-- | id | name  | department | salary |
-- | -- | ----- | ---------- | ------ |
-- | 1  | Rahul | IT         | 60000  |
-- | 2  | Anita | HR         | 45000  |

-- Example Output (Department Replace)

-- | department | updated_department     |
-- | ---------- | ---------------------- |
-- | IT         | Information Tech       |
-- | HR         | HR                     |

-- Example Output (Name Replace)

-- | name  | modified_name |
-- | ----- | ------------- |
-- | Rahul | R@hul         |
-- | Anita | Anit@         |