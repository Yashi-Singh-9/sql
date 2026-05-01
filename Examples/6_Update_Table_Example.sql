-- Update data in employees table
-- This command is used to modify existing records in the table

-- Table used:
-- employees → stores employee details like id, name, department, salary

-- Update salary of a specific employee
UPDATE employees
SET salary = 60000
WHERE id = 1;

-- Update department of a specific employee
UPDATE employees
SET department = 'Admin'
WHERE id = 2;

-- Explanation
-- UPDATE → command used to modify existing data in a table
-- employees → name of the table
-- SET → specifies the column(s) to be updated
-- salary = 60000 → new value assigned to salary column
-- WHERE → used to select which row(s) to update
-- id = 1 → condition to update only that specific employee

-- Important Note:
-- If WHERE condition is not used, all rows will be updated

-- Example Table Data Before Update

-- | id | name  | department | salary |
-- | -- | ----- | ---------- | ------ |
-- | 1  | Rahul | IT         | 50000  |
-- | 2  | Anita | HR         | 45000  |

-- Example Table Data After Update

-- | id | name  | department | salary |
-- | -- | ----- | ---------- | ------ |
-- | 1  | Rahul | IT         | 60000  |
-- | 2  | Anita | Admin      | 45000  |