-- LAG is a window function used to access data from a previous row in the same result set without using a self-join.

-- Syntax:
-- LAG(column_name, offset, default_value) OVER (PARTITION BY partition_column ORDER BY order_column)

-- Explanation of Parameters:
-- column_name → the column from which you want to get the previous row’s value
-- offset → how many rows back you want to look (default is 1)
-- default_value → value to return if there is no previous row (optional)
-- PARTITION BY → groups rows for the function (optional)
-- ORDER BY → defines the order in which the rows are evaluated

-- Example Query:

SELECT
    id,
    name,
    department,
    salary,
    LAG(salary, 1, 0) OVER (PARTITION BY department ORDER BY id) AS prev_salary
FROM employees;


-- Explanation:
-- `id, name, department, salary` → columns we are selecting
-- `LAG(salary, 1, 0)` → fetches the salary of the previous employee in the same department; if no previous row exists, returns 0
-- `OVER (PARTITION BY department ORDER BY id)` → looks at previous rows within the same department, ordered by `id`

-- Example Output:

| -- | id | name  | department | salary | prev_salary |
| -- | -- | ----- | ---------- | ------ | ----------- |
| -- | 1  | Rahul | IT         | 50000  | 0           |
| -- | 3  | Sita  | IT         | 55000  | 50000       |
| -- | 2  | Anita | HR         | 45000  | 0           |
| -- | 4  | Rohit | HR         | 47000  | 45000       |

