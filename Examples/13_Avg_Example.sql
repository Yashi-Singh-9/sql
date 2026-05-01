-- Use AVG function on employees table
-- This function is used to calculate the average value of a numeric column

-- Table used:
-- employees → stores employee details like id, name, department, salary

-- Calculate average salary of all employees
SELECT AVG(salary) AS avg_salary
FROM employees;

-- Calculate average salary department-wise
SELECT department, AVG(salary) AS avg_salary
FROM employees
GROUP BY department;

-- AVG with condition
SELECT AVG(salary) AS it_avg_salary
FROM employees
WHERE department = 'IT';

-- Explanation
-- AVG() → aggregate function used to calculate average
-- salary → column on which AVG is applied
-- AS avg_salary → gives a name (alias) to the result
-- FROM → specifies the table
-- GROUP BY → groups data to calculate average per group
-- WHERE → filters rows before calculating average

-- Important Note:
-- AVG works only on numeric columns (INT, FLOAT, etc.)
-- NULL values are ignored in AVG calculation

-- Example Table Data

-- | id | name  | department | salary |
-- | -- | ----- | ---------- | ------ |
-- | 1  | Rahul | IT         | 60000  |
-- | 2  | Anita | HR         | 45000  |
-- | 3  | Ravi  | IT         | 50000  |

-- Example Output (Average Salary)

-- | avg_salary |
-- | ---------- |
-- | 51666.67   |

-- Example Output (Department-wise)

-- | department | avg_salary |
-- | ---------- | ---------- |
-- | IT         | 55000      |
-- | HR         | 45000      |