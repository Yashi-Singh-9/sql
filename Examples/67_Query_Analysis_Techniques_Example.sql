-- **Query Analysis Techniques** are methods used to understand, optimize, and improve SQL query performance. They help detect bottlenecks, reduce execution time, and make queries more efficient.

-- 1. **EXPLAIN / EXPLAIN PLAN**

-- **Purpose:** Shows how the database executes a query, including the order of operations, indexes used, and estimated costs.

-- **Example Query:**

EXPLAIN
SELECT *
FROM employees
WHERE department = 'IT';

-- **Explanation:**
-- The database outputs the query execution plan.
-- It indicates which indexes are used, whether a full table scan occurs, and the cost of each step.

-- 2. **SHOW PROFILE / Execution Time Analysis**

-- **Purpose:** Measures the actual time and resources consumed by a query.
-- Useful for detecting slow queries and understanding resource usage.

-- **Example Query (MySQL):**

SET profiling = 1;

SELECT *
FROM employees
WHERE salary > 50000;

SHOW PROFILES;

-- **Explanation:**
-- `SET profiling = 1` → enables query profiling
-- `SHOW PROFILES` → shows execution time for each query executed

-- 3. **Index Usage Analysis**

-- **Purpose:** Determines if indexes are used effectively to speed up queries.
-- Adding proper indexes can drastically improve performance.

-- Example:
-- If a query on `employees.department` is slow, creating an index can help:

CREATE INDEX idx_department
ON employees(department);

-- **Explanation:**
-- Queries filtering by `department` now use the index instead of scanning the entire table

-- 4. **Query Refactoring**

-- **Purpose:** Simplifies complex queries, reduces redundant calculations, and improves performance.
-- Techniques include:

-- Using **CTEs** instead of subqueries
-- Avoiding `SELECT *` and selecting only required columns
-- Minimizing joins and nested queries
-- Using `EXISTS` instead of `IN` for large datasets

-- 5. **Database-Specific Tools**

-- Most databases have built-in tools for query analysis:

-- **SQL Server:** `SET STATISTICS IO ON`, `SET STATISTICS TIME ON`, Execution Plans
-- **Oracle:** `AUTOTRACE`, `SQL_TRACE`
-- **PostgreSQL:** `EXPLAIN ANALYZE`

-- Example: Using EXPLAIN ANALYZE in PostgreSQL

EXPLAIN ANALYZE
SELECT *
FROM employees
WHERE salary > 50000;

-- **Explanation:**
-- Shows actual run-time, number of rows processed, and whether indexes were used

-- Summary: Query analysis involves understanding **how queries run**, **measuring performance**, **checking indexes**, and **refactoring queries** for efficiency.
