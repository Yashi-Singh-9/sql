-- Use NOT NULL constraint in employees table
-- This constraint ensures that a column cannot have NULL (empty) values

-- Table used:
-- employees → stores employee details like id, name, department, salary

-- Create table with NOT NULL constraint
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    department VARCHAR(50) NOT NULL,
    salary INT
);

-- Add NOT NULL constraint to existing table
ALTER TABLE employees
MODIFY name VARCHAR(50) NOT NULL;

-- Explanation
-- NOT NULL → ensures a column must have a value
-- name NOT NULL → name cannot be empty
-- department NOT NULL → department must be provided
-- MODIFY → used to change column definition

-- Important Note:
-- NULL means no value (not zero, not empty string)
-- NOT NULL prevents missing or incomplete data
-- Multiple columns can have NOT NULL constraint

-- Example Table Data (Valid)

-- | id | name  | department | salary |
-- | -- | ----- | ---------- | ------ |
-- | 1  | Rahul | IT         | 60000  |
-- | 2  | Anita | HR         | 45000  |

-- Invalid Example (Not Allowed)

-- | id | name  | department |
-- | -- | ----- | ---------- |
-- | 3  | NULL  | IT         | ← Not allowed (name is NOT NULL)

-- | id | name  | department |
-- | -- | ----- | ---------- |
-- | 4  | Ravi  | NULL       | ← Not allowed (department is NOT NULL)