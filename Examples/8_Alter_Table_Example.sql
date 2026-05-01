-- Alter table structure in employees table
-- This command is used to modify the structure of an existing table

-- Table used:
-- employees → stores employee details like id, name, department, salary

-- Add a new column
ALTER TABLE employees
ADD email VARCHAR(100);

-- Modify an existing column
ALTER TABLE employees
MODIFY salary BIGINT;

-- Rename a column
ALTER TABLE employees
RENAME COLUMN name TO employee_name;

-- Drop (delete) a column
ALTER TABLE employees
DROP COLUMN email;

-- Explanation
-- ALTER TABLE → command used to change table structure
-- employees → name of the table
-- ADD → adds a new column
-- email VARCHAR(100) → new column with text up to 100 characters
-- MODIFY → changes datatype or size of a column
-- salary BIGINT → changes salary type to BIGINT
-- RENAME COLUMN → renames an existing column
-- name TO employee_name → changes column name
-- DROP COLUMN → removes a column from the table

-- Important Note:
-- ALTER is used only for structure changes, not for data changes

-- Example Table Structure Before ALTER

-- | id | name  | department | salary |
-- | -- | ----- | ---------- | ------ |

-- Example Table Structure After ADD Column

-- | id | name  | department | salary | email |
-- | -- | ----- | ---------- | ------ | ----- |

-- Example Table Structure After RENAME

-- | id | employee_name | department | salary |
-- | -- | ------------- | ---------- | ------ |