-- Use COUNT function on employees table
-- This function is used to count the number of rows (records)

-- Table used:
-- employees → stores employee details like id, name, department, salary

-- Count total number of employees
SELECT COUNT(*) AS total_employees
FROM employees;

-- Count employees department-wise
SELECT department, COUNT(*) AS total_employees
FROM employees
GROUP BY department;

-- COUNT with condition
SELECT COUNT(*) AS it_employees
FROM employees
WHERE department = 'IT';

-- Count non-null values in a column
SELECT COUNT(salary) AS salary_count
FROM employees;

-- Explanation
-- COUNT() → aggregate function used to count rows
-- * → counts all rows including duplicates
-- COUNT(column) → counts only non-null values in that column
-- AS total_employees → gives a name (alias) to the result
-- FROM → specifies the table
-- GROUP BY → groups rows to count per group
-- WHERE → filters rows before counting

-- Important Note:
-- COUNT(*) includes all rows
-- COUNT(column) ignores NULL values

-- Example Table Data

-- | id | name  | department | salary |
-- | -- | ----- | ---------- | ------ |
-- | 1  | Rahul | IT         | 60000  |
-- | 2  | Anita | HR         | 45000  |
-- | 3  | Ravi  | IT         | 50000  |

-- Example Output (Total Employees)

-- | total_employees |
-- | --------------- |
-- | 3               |

-- Example Output (Department-wise)

-- | department | total_employees |
-- | ---------- | --------------- |
-- | IT         | 2               |
-- | HR         | 1               |