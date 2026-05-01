-- `ROW_NUMBER()` is a window function that assigns a unique sequential number to each row within a result set, based on the order specified.

-- Syntax:
-- `ROW_NUMBER() OVER (PARTITION BY partition_column ORDER BY order_column)`

-- Explanation of Parameters:
-- `PARTITION BY` → divides the result set into groups (optional). ROW_NUMBER() restarts numbering for each partition.
-- `ORDER BY` → defines the order in which the row numbers are assigned.

-- Example Query:

SELECT
    id,
    name,
    department,
    salary,
    ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) AS row_num
FROM employees;

-- Explanation:
-- `id, name, department, salary` → columns we are selecting
-- `ROW_NUMBER()` → assigns a unique number to each row in the partition
-- `OVER (PARTITION BY department ORDER BY salary DESC)` → numbers reset for each department, ordered by salary descending

-- Example Output:

| -- | id | name  | department | salary | row_num |
| -- | -- | ----- | ---------- | ------ | ------- |
| -- | 3  | Sita  | IT         | 55000  | 1       |
| -- | 1  | Rahul | IT         | 50000  | 2       |
| -- | 4  | Rohit | HR         | 47000  | 1       |
| -- | 2  | Anita | HR         | 45000  | 2       |
