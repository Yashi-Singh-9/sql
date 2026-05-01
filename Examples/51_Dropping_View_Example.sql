-- Drop VIEW in employees table
-- This command is used to delete an existing view from the database

-- View used:
-- employee_view → virtual table created from employees table

-- Drop a view
DROP VIEW employee_view;

-- Drop view only if it exists
DROP VIEW IF EXISTS employee_view;

-- Explanation
-- DROP VIEW → command used to delete a view
-- employee_view → name of the view
-- IF EXISTS → prevents error if view does not exist

-- Important Note:
-- Only the view is deleted, not the actual table data
-- Underlying tables (like employees) remain unchanged
-- Cannot be recovered after deletion (in most databases)

-- Example Before DROP VIEW

-- Views in database:
-- employee_view

-- Example After DROP VIEW

-- Views in database:
-- (employee_view no longer exists)

-- Table (employees) still exists:

-- | id | name  | department | salary |
-- | -- | ----- | ---------- | ------ |