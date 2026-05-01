-- Use COALESCE function in employees table
-- This function returns the first non-NULL value from a list

-- Table used:
-- employees → stores employee details like id, name, department, salary

-- Basic COALESCE example
SELECT COALESCE(NULL, NULL, 10, 20) AS result;

-- COALESCE with columns
SELECT name, department,
COALESCE(department, 'Not Assigned') AS dept_value
FROM employees;

-- COALESCE with multiple columns
SELECT name,
COALESCE(NULL, salary, 0) AS final_salary
FROM employees;

-- Explanation
-- COALESCE() → returns first non-NULL value
-- COALESCE(NULL, NULL, 10, 20) → returns 10
-- department → column used
-- 'Not Assigned' → default value if NULL
-- COALESCE(NULL, salary, 0) → returns salary if not NULL, else 0

-- Important Note:
-- Useful for handling NULL values
-- Can take multiple arguments
-- Stops checking once it finds first non-NULL value

-- Example Table Data

-- | id | name  | department | salary |
-- | -- | ----- | ---------- | ------ |
-- | 1  | Rahul | IT         | 60000  |
-- | 2  | Anita | NULL       | 45000  |
-- | 3  | Ravi  | Sales      | NULL   |

-- Example Output (Department Handling)

-- | name  | department | dept_value   |
-- | ----- | ---------- | ------------ |
-- | Rahul | IT         | IT           |
-- | Anita | NULL       | Not Assigned |
-- | Ravi  | Sales      | Sales        |

-- Example Output (Salary Handling)

-- | name  | final_salary |
-- | ----- | ------------ |
-- | Rahul | 60000        |
-- | Anita | 45000        |
-- | Ravi  | 0            |