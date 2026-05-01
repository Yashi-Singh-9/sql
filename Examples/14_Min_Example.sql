-- Use MIN function on employees table
-- This function is used to find the minimum (smallest) value in a column

-- Table used:
-- employees → stores employee details like id, name, department, salary

-- Find minimum salary of all employees
SELECT MIN(salary) AS min_salary
FROM employees;

-- Find minimum salary department-wise
SELECT department, MIN(salary) AS min_salary
FROM employees
GROUP BY department;

-- MIN with condition
SELECT MIN(salary) AS it_min_salary
FROM employees
WHERE department = 'IT';

-- Explanation
-- MIN() → aggregate function used to find smallest value
-- salary → column on which MIN is applied
-- AS min_salary → gives a name (alias) to the result
-- FROM → specifies the table
-- GROUP BY → groups data to find minimum per group
-- WHERE → filters rows before finding minimum

-- Important Note:
-- MIN works on numeric, date, and even text columns
-- NULL values are ignored in MIN calculation

-- Example Table Data

-- | id | name  | department | salary |
-- | -- | ----- | ---------- | ------ |
-- | 1  | Rahul | IT         | 60000  |
-- | 2  | Anita | HR         | 45000  |
-- | 3  | Ravi  | IT         | 50000  |

-- Example Output (Minimum Salary)

-- | min_salary |
-- | ---------- |
-- | 45000      |

-- Example Output (Department-wise)

-- | department | min_salary |
-- | ---------- | ---------- |
-- | IT         | 50000      |
-- | HR         | 45000      |