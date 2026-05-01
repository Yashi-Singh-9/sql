-- Use CASE statement in employees table
-- CASE is used to apply conditional logic (like IF-ELSE) in SQL

-- Table used:
-- employees → stores employee details like id, name, department, salary

-- Basic CASE example
SELECT name, salary,
CASE
    WHEN salary >= 60000 THEN 'High'
    WHEN salary >= 45000 THEN 'Medium'
    ELSE 'Low'
END AS salary_level
FROM employees;

-- CASE with department condition
SELECT name, department,
CASE
    WHEN department = 'IT' THEN 'Tech Team'
    WHEN department = 'HR' THEN 'Human Resource'
    ELSE 'Other'
END AS dept_category
FROM employees;

-- CASE in ORDER BY
SELECT name, salary
FROM employees
ORDER BY
CASE
    WHEN salary >= 60000 THEN 1
    WHEN salary >= 45000 THEN 2
    ELSE 3
END;

-- Explanation
-- CASE → used for conditional logic
-- WHEN → condition to check
-- THEN → result if condition is true
-- ELSE → default result if no condition matches
-- END → ends the CASE statement
-- AS salary_level → gives name to result column

-- Important Note:
-- Works like IF-ELSE in programming
-- Can be used in SELECT, WHERE, ORDER BY
-- Conditions are checked in order

-- Example Table Data

-- | id | name  | department | salary |
-- | -- | ----- | ---------- | ------ |
-- | 1  | Rahul | IT         | 60000  |
-- | 2  | Anita | HR         | 45000  |
-- | 3  | Ravi  | Sales      | 30000  |

-- Example Output (Salary Level)

-- | name  | salary | salary_level |
-- | ----- | ------ | ------------ |
-- | Rahul | 60000  | High         |
-- | Anita | 45000  | Medium       |
-- | Ravi  | 30000  | Low          |

-- Example Output (Department Category)

-- | name  | department | dept_category   |
-- | ----- | ---------- | --------------- |
-- | Rahul | IT         | Tech Team       |
-- | Anita | HR         | Human Resource  |
-- | Ravi  | Sales      | Other           |