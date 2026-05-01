-- Use CHECK constraint in employees table
-- This constraint is used to limit the values that can be inserted into a column

-- Table used:
-- employees → stores employee details like id, name, department, salary

-- Create table with CHECK constraint
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    department VARCHAR(50),
    salary INT CHECK (salary > 0)
);

-- CHECK with multiple conditions
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    age INT CHECK (age >= 18),
    salary INT CHECK (salary >= 30000)
);

-- Add CHECK constraint to existing table
ALTER TABLE employees
ADD CONSTRAINT chk_salary CHECK (salary <= 100000);

-- Explanation
-- CHECK → ensures values meet a specific condition
-- salary > 0 → salary must be greater than 0
-- age >= 18 → employee must be at least 18 years old
-- ADD CONSTRAINT → used to add CHECK later
-- chk_salary → name of the constraint

-- Important Note:
-- CHECK works at column level or table level
-- Prevents invalid data entry
-- Conditions must be logical expressions

-- Example Table Data (Valid)

-- | id | name  | age | salary |
-- | -- | ----- | --- | ------ |
-- | 1  | Rahul | 25  | 50000  |
-- | 2  | Anita | 30  | 45000  |

-- Invalid Example (Not Allowed)

-- | id | name  | age | salary |
-- | -- | ----- | --- | ------ |
-- | 3  | Ravi  | 16  | 40000  | ← age < 18 (not allowed)

-- | id | name  | age | salary |
-- | -- | ----- | --- | ------ |
-- | 4  | Amit  | 28  | -1000  | ← salary < 0 (not allowed)