-- Drop table employees
-- This command is used to completely remove a table from the database

-- Table used:
-- employees → stores employee details like id, name, department, salary

-- Delete the entire table
DROP TABLE employees;

-- Drop a database
DROP DATABASE company_db;

-- Explanation
-- DROP TABLE → command used to delete a table completely
-- employees → name of the table
-- Removes both data and table structure permanently

-- DROP DATABASE → command used to delete entire database
-- company_db → name of the database
-- Removes all tables and data inside the database

-- Important Note:
-- DROP deletes everything permanently (structure + data)
-- Cannot be rolled back in most databases
-- Use carefully!

-- Difference between DROP and TRUNCATE:
-- TRUNCATE → deletes only data, keeps table structure
-- DROP → deletes entire table (structure + data)

-- Example Before DROP TABLE

-- Tables in database:
-- employees

-- Example After DROP TABLE

-- Tables in database:
-- (employees table no longer exists)