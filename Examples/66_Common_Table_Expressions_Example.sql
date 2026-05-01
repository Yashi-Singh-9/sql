-- **CTE (Common Table Expression)** is a temporary result set that you can reference within a `SELECT`, `INSERT`, `UPDATE`, or `DELETE` statement. It improves readability, simplifies complex queries, and can be recursive.

-- Syntax:

WITH cte_name (column1, column2, ...) AS
(
    -- CTE query
    SELECT column1, column2, ...
    FROM table_name
    WHERE condition
)
SELECT *
FROM cte_name;

-- Explanation of Components:
-- `WITH cte_name` → defines the name of the CTE
-- `(column1, column2, …)` → optional list of column names for the CTE
-- The query inside parentheses → defines the temporary result set
-- The CTE can be referenced like a regular table in the following `SELECT` (or other) statement

-- Example Scenario:
-- Suppose we want to find employees with salaries greater than 45000 from the `employees` table.

-- Example Query:

WITH high_salary_employees AS
(
    SELECT id, name, department, salary
    FROM employees
    WHERE salary > 45000
)
SELECT *
FROM high_salary_employees
ORDER BY salary DESC;

-- Explanation:
-- `WITH high_salary_employees AS (...)` → defines the CTE containing employees with salary > 45000
-- `SELECT * FROM high_salary_employees` → references the CTE like a table
-- `ORDER BY salary DESC` → sorts the results by salary in descending order

-- Example Output:

| -- | id | name  | department | salary |
| -- | -- | ----- | ---------- | ------ |
| -- | 3  | Sita  | IT         | 55000  |
| -- | 1  | Rahul | IT         | 50000  |


-- Extra Note:

-- CTEs can also be **recursive**, which is useful for hierarchical queries (like employee-manager relationships). They can also **simplify complex queries** by breaking them into smaller, readable parts.