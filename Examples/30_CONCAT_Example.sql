-- Use CONCAT function in employees table
-- This function is used to combine (join) two or more strings into one

-- Table used:
-- employees → stores employee details like id, name, department, salary

-- Combine name and department
SELECT CONCAT(name, ' - ', department) AS employee_info
FROM employees;

-- Combine multiple columns
SELECT CONCAT(id, ' ', name, ' ', department) AS full_info
FROM employees;

-- CONCAT with text
SELECT CONCAT('Employee: ', name) AS label_name
FROM employees;

-- Explanation
-- CONCAT() → joins multiple strings into one
-- name, department → columns being combined
-- ' - ' → separator (can be space, dash, etc.)
-- AS employee_info → gives a name to the result column

-- Important Note:
-- Works with text (VARCHAR, CHAR, etc.)
-- NULL values may return NULL (depends on database)
-- Used for formatting output

-- Example Table Data

-- | id | name  | department | salary |
-- | -- | ----- | ---------- | ------ |
-- | 1  | Rahul | IT         | 60000  |
-- | 2  | Anita | HR         | 45000  |

-- Example Output (CONCAT)

-- | employee_info |
-- | ------------- |
-- | Rahul - IT    |
-- | Anita - HR    |

-- Example Output (Full Info)

-- | full_info        |
-- | ---------------- |
-- | 1 Rahul IT       |
-- | 2 Anita HR       |