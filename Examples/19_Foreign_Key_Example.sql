-- Use FOREIGN KEY in employees table
-- A foreign key is used to create a relationship between two tables

-- Tables used:
-- departments → parent table (contains primary key)
-- employees → child table (contains foreign key)

-- Create parent table
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50)
);

-- Create child table with foreign key
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    department_id INT,
    salary INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- FOREIGN KEY with ON DELETE and ON UPDATE
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    department_id INT,
    salary INT,
    FOREIGN KEY (department_id)
    REFERENCES departments(department_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- Explanation
-- FOREIGN KEY → links one table to another
-- department_id → column in employees table
-- REFERENCES departments(department_id) → connects to primary key
-- Parent table → departments
-- Child table → employees

-- ON DELETE CASCADE → if a department is deleted,
-- all related employees are also deleted

-- ON UPDATE CASCADE → if department_id changes,
-- it automatically updates in employees table

-- Important Note:
-- Ensures referential integrity (valid relationships)
-- Prevents invalid data entry
-- Cannot insert a foreign key value that does not exist in parent table

-- Example Table Data (departments)

-- | department_id | department_name |
-- | ------------- | --------------- |
-- | 1             | IT              |
-- | 2             | HR              |

-- Example Table Data (employees)

-- | id | name  | department_id | salary |
-- | -- | ----- | ------------- | ------ |
-- | 1  | Rahul | 1             | 60000  |
-- | 2  | Anita | 2             | 45000  |

-- Example Behavior (ON DELETE CASCADE)

-- If department_id = 1 is deleted from departments
-- Then employee Rahul (department_id = 1) will also be deleted automatically

-- Invalid Example (Not Allowed)

-- | id | name  | department_id |
-- | -- | ----- | ------------- |
-- | 3  | Ravi  | 5             | ← No matching department_id in parent table