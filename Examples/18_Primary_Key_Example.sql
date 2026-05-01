-- Use PRIMARY KEY in employees table
-- A primary key is used to uniquely identify each record in a table

-- Table used:
-- employees → stores employee details like id, name, department, salary

-- Create table with primary key
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(50),
    salary INT
);

-- Add primary key to existing table
ALTER TABLE employees
ADD PRIMARY KEY (id);

-- Explanation
-- PRIMARY KEY → uniquely identifies each row in a table
-- id → column used as primary key
-- No two rows can have the same primary key value
-- PRIMARY KEY cannot be NULL

-- Important Note:
-- Each table can have only one primary key
-- It can be a single column or multiple columns (composite key)
-- Automatically creates a unique index for fast access

-- Example Table Data

-- | id | name  | department | salary |
-- | -- | ----- | ---------- | ------ |
-- | 1  | Rahul | IT         | 60000  |
-- | 2  | Anita | HR         | 45000  |

-- Invalid Example (Not Allowed)

-- | id | name  |
-- | -- | ----- |
-- | 1  | Rahul |
-- | 1  | Ravi  |  ← Duplicate ID (Not allowed in PRIMARY KEY)

-- | id | name  |
-- | -- | ----- |
-- | NULL | Amit | ← NULL value not allowed