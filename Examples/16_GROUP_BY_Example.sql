-- Use GROUP BY on employees table
-- This clause is used to group rows that have the same values
-- and perform operations like COUNT, SUM, AVG on each group

-- Table used:
-- employees → stores employee details like id, name, department, salary

-- Group employees by department
SELECT department
FROM employees
GROUP BY department;

-- Count employees in each department
SELECT department, COUNT(*) AS total_employees
FROM employees
GROUP BY department;

-- Find total salary department-wise
SELECT department, SUM(salary) AS total_salary
FROM employees
GROUP BY department;

-- Find average salary department-wise
SELECT department, AVG(salary) AS avg_salary
FROM employees
GROUP BY department;

-- Explanation
-- GROUP BY → groups rows based on a column
-- department → column used for grouping
-- COUNT() → counts number of rows in each group
-- SUM() → calculates total per group
-- AVG() → calculates average per group
-- SELECT department → shows grouped column

-- Important Note:
-- GROUP BY is usually used with aggregate functions
-- All columns in SELECT must be either grouped or aggregated

-- Example Table Data

-- | id | name  | department | salary |
-- | -- | ----- | ---------- | ------ |
-- | 1  | Rahul | IT         | 60000  |
-- | 2  | Anita | HR         | 45000  |
-- | 3  | Ravi  | IT         | 50000  |

-- Example Output (Grouped by Department)

-- | department | total_employees |
-- | ---------- | --------------- |
-- | IT         | 2               |
-- | HR         | 1               |

-- Example Output (Total Salary per Department)

-- | department | total_salary |
-- | ---------- | ------------ |
-- | IT         | 110000       |
-- | HR         | 45000        |