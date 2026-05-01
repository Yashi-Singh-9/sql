-- Use LENGTH function in employees table
-- This function is used to find the number of characters in a string

-- Table used:
-- employees → stores employee details like id, name, department, salary

-- Find length of employee names
SELECT name, LENGTH(name) AS name_length
FROM employees;

-- Find length of department names
SELECT department, LENGTH(department) AS dept_length
FROM employees;

-- LENGTH with condition
SELECT name
FROM employees
WHERE LENGTH(name) > 5;

-- Explanation
-- LENGTH() → returns number of characters in a string
-- name → column on which LENGTH is applied
-- AS name_length → gives a name to the result column
-- WHERE LENGTH(name) > 5 → filters names longer than 5 characters

-- Important Note:
-- Works on text data (VARCHAR, CHAR, etc.)
-- Counts characters (in some databases counts bytes)
-- NULL values return NULL

-- Example Table Data

-- | id | name  | department | salary |
-- | -- | ----- | ---------- | ------ |
-- | 1  | Rahul | IT         | 60000  |
-- | 2  | Anita | HR         | 45000  |
-- | 3  | Mohan | Finance    | 50000  |

-- Example Output (Name Length)

-- | name  | name_length |
-- | ----- | ----------- |
-- | Rahul | 5           |
-- | Anita | 5           |
-- | Mohan | 5           |

-- Example Output (Filtered)

-- | name  |
-- | ----- |
-- | (only names with length > 5 will appear)