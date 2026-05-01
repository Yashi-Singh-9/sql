-- `UNPIVOT` is used to transform columns into rows, essentially the reverse of `PIVOT`. It is helpful when you want to normalize wide tables into a long format.

-- Syntax:

SELECT unpivoted_column, value_column
FROM
    table_name
UNPIVOT
(
    value_column FOR unpivoted_column IN (column1, column2, ...)
) AS unpivot_table;

-- Explanation of Parameters:
-- `value_column` → the column that will hold the values from the original columns
-- `unpivoted_column` → the column that will hold the original column names
-- `(column1, column2, ...)` → the columns you want to transform into rows

-- Example Scenario:
-- We want to convert our previous pivoted salary table back into a row format.

-- Example Query:

SELECT name, department, salary
FROM
(
    SELECT name, [IT], [HR]
    FROM employees
    PIVOT
    (
        SUM(salary)
        FOR department IN ([IT], [HR])
    ) AS pivot_table
) AS p
UNPIVOT
(
    salary FOR department IN ([IT], [HR])
) AS unpivot_table;

-- Explanation:
-- First, we create a pivoted table with `IT` and `HR` as columns.
-- `UNPIVOT (salary FOR department IN ([IT], [HR]))` → turns the `IT` and `HR` columns back into rows under `department` with their `salary` values.

-- Example Output:

| -- | name  | department | salary |
| -- | ----- | ---------- | ------ |
| -- | Rahul | IT         | 50000  |
| -- | Sita  | IT         | 55000  |
| -- | Anita | HR         | 45000  |
| -- | Rohit | HR         | 47000  |
