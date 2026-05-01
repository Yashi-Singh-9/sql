-- Use HAVING clause on employees table
-- This clause is used to filter grouped data (after GROUP BY)

-- Table used:
-- employees → stores employee details like id, name, department, salary

-- Show departments with more than 1 employee
SELECT department, COUNT(*) AS total_employees
FROM employees
GROUP BY department
HAVING COUNT(*) > 1;

-- Show departments with total salary greater than 100000
SELECT department, SUM(salary) AS total_salary
FROM employees
GROUP BY department
HAVING SUM(salary) > 100000;

-- HAVING with AVG
SELECT department, AVG(salary) AS avg_salary
FROM employees
GROUP BY department
HAVING AVG(salary) > 50000;

-- Explanation
-- HAVING → used to filter grouped results
-- GROUP BY → groups rows before applying HAVING
-- COUNT(), SUM(), AVG() → aggregate functions used with HAVING
-- HAVING COUNT(*) > 1 → condition applied after grouping
-- WHERE vs HAVING:
-- WHERE → filters rows before grouping
-- HAVING → filters data after grouping

-- Important Note:
-- HAVING is always used with GROUP BY (in most cases)
-- It works on aggregated values, not individual rows

-- Example Table Data

-- | id | name  | department | salary |
-- | -- | ----- | ---------- | ------ |
-- | 1  | Rahul | IT         | 60000  |
-- | 2  | Anita | HR         | 45000  |
-- | 3  | Ravi  | IT         | 50000  |

-- Example Output (Departments with more than 1 employee)

-- | department | total_employees |
-- | ---------- | --------------- |
-- | IT         | 2               |

-- Example Output (Departments with total salary > 100000)

-- | department | total_salary |
-- | ---------- | ------------ |
-- | IT         | 110000       |