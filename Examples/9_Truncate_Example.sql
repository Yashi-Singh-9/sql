-- Truncate table employees
-- This command is used to remove all records from the table quickly

-- Table used:
-- employees → stores employee details like id, name, department, salary

-- Remove all data from table
TRUNCATE TABLE employees;

-- Explanation
-- TRUNCATE TABLE → command used to delete all rows from a table
-- employees → name of the table
-- Removes all records but keeps the table structure intact
-- Faster than DELETE because it does not delete row by row

-- Important Note:
-- TRUNCATE cannot be rolled back in most databases
-- WHERE condition cannot be used with TRUNCATE
-- It resets auto-increment values (in many databases)

-- Difference between DELETE and TRUNCATE:
-- DELETE → removes selected rows (can use WHERE)
-- TRUNCATE → removes all rows (no WHERE, faster)

-- Example Table Data Before TRUNCATE

-- | id | name  | department | salary |
-- | -- | ----- | ---------- | ------ |
-- | 1  | Rahul | IT         | 60000  |
-- | 2  | Anita | Admin      | 45000  |

-- Example Table Data After TRUNCATE

-- (No rows, table is empty but structure still exists)