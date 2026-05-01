-- `PIVOT` is used to rotate rows into columns, making it easier to summarize and analyze data.

-- Syntax:

SELECT *
FROM
(
    SELECT column1, column2, value_column
    FROM table_name
) AS source_table
PIVOT
(
    AGGREGATE_FUNCTION(value_column)
    FOR column2 IN (column_value1, column_value2, ...)
) AS pivot_table;

-- Explanation of Parameters:
-- `AGGREGATE_FUNCTION` → e.g., SUM, COUNT, MAX, used to aggregate values while pivoting
-- `FOR column2 IN (...)` → the column whose values will become new column headers
-- `value_column` → the column whose values fill the pivoted columns

-- Example Scenario:
We want to see total salary per department for each employee.

-- Example Query:

SELECT *
FROM
(
    SELECT name, department, salary
    FROM employees
) AS source_table
PIVOT
(
    SUM(salary)
    FOR department IN ([IT], [HR])
) AS pivot_table;


-- Explanation:
-- `SELECT name, department, salary FROM employees` → prepares the data for pivoting
-- `SUM(salary)` → adds up salaries for each employee under the new columns
-- `FOR department IN ([IT], [HR])` → creates new columns `IT` and `HR` for each department

-- Example Output:

| -- | name  | IT    | HR    |
| -- | ----- | ----- | ----- |
| -- | Rahul | 50000 | NULL  |
| -- | Sita  | 55000 | NULL  |
| -- | Anita | NULL  | 45000 |
| -- | Rohit | NULL  | 47000 |