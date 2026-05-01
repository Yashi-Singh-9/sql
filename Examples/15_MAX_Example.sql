-- Use MAX function on employees table
-- This function is used to find the maximum (largest) value in a column

-- Table used:
-- employees → stores employee details like id, name, department, salary

-- Find maximum salary of all employees
SELECT MAX(salary) AS max_salary
FROM employees;

-- Find maximum salary department-wise
SELECT department, MAX(salary) AS max_salary
FROM employees
GROUP BY department;

-- MAX with condition
SELECT MAX(salary) AS it_max_salary
FROM employees
WHERE department = 'IT';

-- Explanation
-- MAX() → aggregate function used to find largest value
-- salary → column on which MAX is applied
-- AS max_salary → gives a name (alias) to the result
-- FROM → specifies the table
-- GROUP BY → groups data to find maximum per group
-- WHERE → filters rows before finding maximum

-- Important Note:
-- MAX works on numeric, date, and text columns
-- NULL values are ignored in MAX calculation

-- Example Table Data

-- | id | name  | department | salary |
-- | -- | ----- | ---------- | ------ |
-- | 1  | Rahul | IT         | 60000  |
-- | 2  | Anita | HR         | 45000  |
-- | 3  | Ravi  | IT         | 50000  |

-- Example Output (Maximum Salary)

-- | max_salary |
-- | ---------- |
-- | 60000      |

-- Example Output (Department-wise)

-- | department | max_salary |
-- | ---------- | ---------- |
-- | IT         | 60000      |
-- | HR         | 45000      |