-- Delete data from employees table
-- This command is used to remove records from the table

-- Table used:
-- employees → stores employee details like id, name, department, salary

-- Delete a specific employee
DELETE FROM employees
WHERE id = 3;

-- Delete employees from a specific department
DELETE FROM employees
WHERE department = 'HR';

-- Explanation
-- DELETE FROM → command used to remove data from a table
-- employees → name of the table
-- WHERE → used to specify which row(s) to delete
-- id = 3 → deletes employee with id 3
-- department = 'HR' → deletes all employees in HR department

-- Important Note:
-- If WHERE condition is not used, all records will be deleted

-- Example Table Data Before Delete

-- | id | name  | department | salary |
-- | -- | ----- | ---------- | ------ |
-- | 1  | Rahul | IT         | 60000  |
-- | 2  | Anita | Admin      | 45000  |
-- | 3  | Ravi  | Finance    | 55000  |

-- Example Table Data After Delete

-- | id | name  | department | salary |
-- | -- | ----- | ---------- | ------ |
-- | 1  | Rahul | IT         | 60000  |
-- | 2  | Anita | Admin      | 45000  |