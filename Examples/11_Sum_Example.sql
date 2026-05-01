-- Use SUM function on employees table
-- This function is used to calculate the total of a numeric column

-- Table used:
-- employees → stores employee details like id, name, department, salary

-- Calculate total salary of all employees
SELECT SUM(salary) AS total_salary
FROM employees;

-- Calculate total salary department-wise
SELECT department, SUM(salary) AS total_salary
FROM employees
GROUP BY department;

-- SUM with condition
SELECT SUM(salary) AS it_total_salary
FROM employees
WHERE department = 'IT';

-- Explanation
-- SUM() → aggregate function used to calculate total
-- salary → column on which SUM is applied
-- AS total_salary → gives a name (alias) to the result
-- FROM → specifies the table
-- GROUP BY → groups data to calculate sum per group
-- WHERE → filters rows before calculating sum

-- Important Note:
-- SUM works only on numeric columns (INT, FLOAT, etc.)
-- NULL values are ignored in SUM calculation

-- Example Table Data

-- | id | name  | department | salary |
-- | -- | ----- | ---------- | ------ |
-- | 1  | Rahul | IT         | 60000  |
-- | 2  | Anita | HR         | 45000  |
-- | 3  | Ravi  | IT         | 50000  |

-- Example Output (Total Salary)

-- | total_salary |
-- | ------------ |
-- | 155000       |

-- Example Output (Department-wise)

-- | department | total_salary |
-- | ---------- | ------------ |
-- | IT         | 110000       |
-- | HR         | 45000        |