-- Insert data into employees table
-- This command is used to add new records (rows) into the table

-- Table used:
-- employees → stores employee details like id, name, department, salary

-- Insert a single record
INSERT INTO employees (id, name, department, salary)
VALUES (1, 'Rahul', 'IT', 50000);

-- Insert multiple records
INSERT INTO employees (id, name, department, salary)
VALUES
(2, 'Anita', 'HR', 45000),
(3, 'Ravi', 'Finance', 55000);

-- Explanation
-- INSERT INTO → command used to add data into a table
-- employees → name of the table where data is inserted
-- (id, name, department, salary) → columns where values will go
-- VALUES → keyword used to specify the data
-- (1, 'Rahul', 'IT', 50000) → one row of data
-- Multiple rows can be inserted by separating with commas

-- Example Table Data After Insert

-- | id | name  | department | salary |
-- | -- | ----- | ---------- | ------ |
-- | 1  | Rahul | IT         | 50000  |
-- | 2  | Anita | HR         | 45000  |
-- | 3  | Ravi  | Finance    | 55000  |