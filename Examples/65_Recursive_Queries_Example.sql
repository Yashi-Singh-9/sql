-- **Recursive Queries** allow a query to refer to its own result set, enabling operations like traversing hierarchical data (e.g., organizational charts, bill of materials).

-- Syntax:

WITH RECURSIVE cte_name (columns) AS
(
    -- Anchor member: the starting point of recursion
    SELECT columns
    FROM table_name
    WHERE condition

    UNION ALL

    -- Recursive member: references the CTE itself
    SELECT columns
    FROM table_name
    INNER JOIN cte_name
    ON table_name.parent_id = cte_name.id
)
SELECT *
FROM cte_name;

-- Explanation of Components:
-- `WITH RECURSIVE cte_name` → defines a Common Table Expression (CTE) that can reference itself
-- **Anchor member** → the base query that starts the recursion
-- **Recursive member** → the query that repeats, using the previous results to build new rows
-- `UNION ALL` → combines anchor and recursive results

-- Example Scenario:
-- We have a table of employees with managers, and we want to find the reporting hierarchy.

-- Table: employees_hierarchy

| -- | id | name  | manager_id |
| -- | -- | ----- | ---------- |
| -- | 1  | Rahul | NULL       |
| -- | 2  | Anita | 1          |
| -- | 3  | Sita  | 1          |
| -- | 4  | Rohit | 2          |

-- Example Query:

WITH RECURSIVE hierarchy AS
(
    -- Anchor member: top-level employees (no manager)
    SELECT id, name, manager_id, 0 AS level
    FROM employees_hierarchy
    WHERE manager_id IS NULL

    UNION ALL

    -- Recursive member: employees reporting to previous level
    SELECT e.id, e.name, e.manager_id, h.level + 1
    FROM employees_hierarchy e
    INNER JOIN hierarchy h
    ON e.manager_id = h.id
)
SELECT *
FROM hierarchy
ORDER BY level, id;

-- Explanation:
-- Anchor: selects Rahul (top-level, no manager) with `level = 0`
-- Recursive: finds employees whose `manager_id` matches the previous `id` and increments `level`
-- `level` → indicates hierarchy depth

-- Example Output:

| -- | id | name  | manager_id | level |
| -- | -- | ----- | ---------- | ----- |
| -- | 1  | Rahul | NULL       | 0     |
| -- | 2  | Anita | 1          | 1     |
| -- | 3  | Sita  | 1          | 1     |
| -- | 4  | Rohit | 2          | 2     |