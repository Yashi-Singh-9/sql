-- Create a table named employees
-- A table is used to store related data in rows and columns

-- Table structure:
-- id          : unique identifier for each employee
-- name        : employee name
-- department  : department where the employee works
-- salary      : employee salary

CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(50),
    salary INT
);

-- Explanation
-- CREATE TABLE → command used to create a new table in the database
-- employees → name of the table
-- id INT → integer column for employee ID
-- PRIMARY KEY → ensures each row has a unique ID
-- VARCHAR(50) → text column that can store up to 50 characters
-- salary INT → integer column to store salary

-- Example Table Structure

-- | id | name  | department | salary |
-- | -- | ----- | ---------- | ------ |
-- | 1  | Rahul | IT         | 50000  |
-- | 2  | Anita | HR         | 45000  |
