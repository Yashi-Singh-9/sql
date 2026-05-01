-- Use LEAD function in employees table
-- This function is used to access data from the next row in the result set

-- Table used:
-- employees → stores employee details like id, name, department, salary

-- Get next employee salary
SELECT name, salary,
LEAD(salary, 1) OVER (ORDER BY salary DESC) AS next_salary
FROM employees;

-- Get salary two rows ahead
SELECT name, salary,
LEAD(salary, 2) OVER (ORDER BY salary DESC) AS salary_2_ahead
FROM employees;

-- LEAD with partition (department)
SELECT name, department, salary,
LEAD(salary, 1) OVER (PARTITION BY department ORDER BY salary DESC) AS next_in_dept
FROM employees;

-- Explanation
-- LEAD(column, offset) → accesses value from next row
-- offset → how many rows ahead (default = 1)
-- OVER(ORDER BY salary DESC) → defines order for looking ahead
-- PARTITION BY → optional, separates ranking within groups

-- Important Note:
-- Useful for comparing current row with future rows
-- Often used in analytics, trend analysis, and running calculations
-- Can return NULL if there is no next row

-- Example Table Data

-- | id | name  | department | salary |
-- | -- | ----- | ---------- | ------ |
-- | 1  | Rahul | IT         | 60000  |
-- | 2  | Anita | IT         | 55000  |
-- | 3  | Ravi  | HR         | 45000  |
-- | 4  | Mohan | HR         | 40000  |

-- Example Output (Global next salary)

-- | name  | salary | next_salary |
-- | ----- | ------ | ----------- |
-- | Rahul | 60000  | 55000       |
-- | Anita | 55000  | 45000       |
-- | Ravi  | 45000  | 40000       |
-- | Mohan | 40000  | NULL        |

-- Example Output (Next in department)

-- | name  | department | salary | next_in_dept |
-- | ----- | ---------- | ------ | ------------- |
-- | Rahul | IT         | 60000  | 55000         |
-- | Anita | IT         | 55000  | NULL          |
-- | Ravi  | HR         | 45000  | 40000         |
-- | Mohan | HR         | 40000  | NULL          |