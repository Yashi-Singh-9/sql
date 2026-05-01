-- Create VIEW in employees table
-- A VIEW is a virtual table based on a SQL query

-- Table used:
-- employees → stores employee details like id, name, department, salary

-- Create a simple view
CREATE VIEW employee_view AS
SELECT name, department, salary
FROM employees;

-- View with condition
CREATE VIEW it_employees AS
SELECT name, salary
FROM employees
WHERE department = 'IT';

-- View with JOIN
CREATE VIEW employee_details AS
SELECT e.name, d.department_name, e.salary
FROM employees e
JOIN departments d
ON e.department_id = d.department_id;

-- Display data from view
SELECT * FROM employee_view;

-- Update view (replace)
CREATE OR REPLACE VIEW employee_view AS
SELECT name, salary
FROM employees;

-- Drop view
DROP VIEW employee_view;

-- Explanation
-- VIEW → virtual table created from a query
-- CREATE VIEW → creates a new view
-- SELECT → defines what data the view shows
-- employee_view → name of the view
-- CREATE OR REPLACE → updates existing view
-- DROP VIEW → deletes the view

-- Important Note:
-- VIEW does not store data physically
-- It fetches data from original tables
-- Useful for security and simplifying complex queries

-- Example Table Data (employees)

-- | id | name  | department | salary |
-- | -- | ----- | ---------- | ------ |
-- | 1  | Rahul | IT         | 60000  |
-- | 2  | Anita | HR         | 45000  |

-- Example Output (employee_view)

-- | name  | department | salary |
-- | ----- | ---------- | ------ |
-- | Rahul | IT         | 60000  |
-- | Anita | HR         | 45000  |