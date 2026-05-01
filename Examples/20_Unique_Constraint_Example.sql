-- Use UNIQUE constraint in employees table
-- This constraint ensures that all values in a column are different (no duplicates)

-- Table used:
-- employees → stores employee details like id, name, department, salary

-- Create table with UNIQUE constraint
CREATE TABLE employees (
    id INT PRIMARY KEY,
    email VARCHAR(100) UNIQUE,
    name VARCHAR(50),
    department VARCHAR(50),
    salary INT
);

-- Add UNIQUE constraint to existing table
ALTER TABLE employees
ADD CONSTRAINT unique_email UNIQUE (email);

-- UNIQUE on multiple columns (composite unique)
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(50),
    email VARCHAR(100),
    UNIQUE (name, department)
);

-- Explanation
-- UNIQUE → ensures all values in a column are different
-- email → column where duplicate values are not allowed
-- ADD CONSTRAINT → used to add constraint later
-- UNIQUE (name, department) → combination must be unique

-- Important Note:
-- UNIQUE allows NULL values (in most databases)
-- A table can have multiple UNIQUE constraints
-- PRIMARY KEY is automatically UNIQUE (but UNIQUE is not always PRIMARY KEY)

-- Example Table Data (Valid)

-- | id | email            | name  | department |
-- | -- | ---------------- | ----- | ---------- |
-- | 1  | rahul@gmail.com  | Rahul | IT         |
-- | 2  | anita@gmail.com  | Anita | HR         |

-- Invalid Example (Not Allowed)

-- | id | email            | name  |
-- | -- | ---------------- | ----- |
-- | 3  | rahul@gmail.com  | Ravi  | ← Duplicate email not allowed

-- Example for Composite UNIQUE (name + department)

-- | name  | department |
-- | ----- | ---------- |
-- | Rahul | IT         |
-- | Rahul | HR         |  ← Allowed (different department)
-- | Rahul | IT         |  ← Not allowed (duplicate combination)