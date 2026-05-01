-- Modify VIEW in employees table
-- This is used to change the structure or query of an existing view

-- Table used:
-- employees → stores employee details like id, name, department, salary

-- Modify view using CREATE OR REPLACE
CREATE OR REPLACE VIEW employee_view AS
SELECT name, salary
FROM employees;

-- Modify view by adding condition
CREATE OR REPLACE VIEW employee_view AS
SELECT name, department, salary
FROM employees
WHERE salary > 50000;

-- Modify view using ALTER (supported in some databases like SQL Server)
ALTER VIEW employee_view AS
SELECT name, department
FROM employees;

-- Explanation
-- CREATE OR REPLACE VIEW → replaces existing view with new definition
-- employee_view → name of the view
-- SELECT → defines new structure of view
-- ALTER VIEW → modifies view (used in some databases)

-- Important Note:
-- You cannot directly change view columns without redefining it
-- Underlying tables must exist
-- Changes affect all users accessing the view

-- Example Before Modification

-- employee_view contains:
-- | name  | department | salary |

-- Example After Modification

-- employee_view contains:
-- | name  | salary |

-- Example After Adding Condition

-- | name  | department | salary |
-- | ----- | ---------- | ------ |
-- | Rahul | IT         | 60000  |  ← only salary > 50000