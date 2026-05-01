-- Select data from employees table
-- This command is used to retrieve (view) data from the table
-- It can also be combined with filtering, grouping, sorting, and joining

-- Table used:
-- employees → stores employee details like id, name, department, salary

-- Basic SELECT
SELECT * FROM employees;

-- SELECT specific columns
SELECT name, salary FROM employees;

-- SELECT with WHERE (filter condition)
SELECT * FROM employees
WHERE department = 'IT';

-- SELECT with ORDER BY (sorting)
SELECT * FROM employees
ORDER BY salary DESC;

-- SELECT with GROUP BY (grouping data)
SELECT department, COUNT(*) AS total_employees
FROM employees
GROUP BY department;

-- SELECT with HAVING (filter grouped data)
SELECT department, COUNT(*) AS total_employees
FROM employees
GROUP BY department
HAVING COUNT(*) > 1;

-- SELECT with JOIN (combine tables)
-- Example assumes another table: departments
SELECT e.name, d.department_name
FROM employees e
JOIN departments d
ON e.department = d.department_id;

-- Explanation
-- SELECT → used to retrieve data
-- FROM → specifies the table to get data from
-- WHERE → filters rows based on condition
-- JOIN → combines data from multiple tables
-- GROUP BY → groups rows based on a column
-- HAVING → filters grouped results
-- ORDER BY → sorts the result (ASC/DESC)

-- Related Commands (used with data handling)
-- INSERT → adds new data into table
-- UPDATE → modifies existing data
-- DELETE → removes data from table

-- Example Output

-- | id | name  | department | salary |
-- | -- | ----- | ---------- | ------ |
-- | 1  | Rahul | IT         | 60000  |
-- | 2  | Anita | Admin      | 45000  |