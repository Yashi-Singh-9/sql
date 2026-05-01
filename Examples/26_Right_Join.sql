-- Use RIGHT JOIN between employees and departments table
-- RIGHT JOIN returns all records from the right table
-- and matching records from the left table

-- Tables used:
-- employees → left table
-- departments → right table (main table)

-- employees table
-- | id | name  | department_id | salary |
-- | -- | ----- | ------------- | ------ |

-- departments table
-- | department_id | department_name |
-- | ------------- | --------------- |

-- RIGHT JOIN example
SELECT e.name, d.department_name, e.salary
FROM employees e
RIGHT JOIN departments d
ON e.department_id = d.department_id;

-- Explanation
-- RIGHT JOIN → returns all rows from right table + matched rows from left table
-- employees e → left table
-- departments d → right table
-- ON → join condition
-- e.department_id = d.department_id → matching column

-- Important Note:
-- If no match is found in left table, NULL values are returned
-- All rows from right table are always included

-- Example Table Data

-- employees
-- | id | name  | department_id | salary |
-- | -- | ----- | ------------- | ------ |
-- | 1  | Rahul | 1             | 60000  |
-- | 2  | Anita | 2             | 45000  |

-- departments
-- | department_id | department_name |
-- | ------------- | --------------- |
-- | 1             | IT              |
-- | 2             | HR              |
-- | 3             | Finance         |

-- Example Output (RIGHT JOIN)

-- | name  | department_name | salary |
-- | ----- | --------------- | ------ |
-- | Rahul | IT              | 60000  |
-- | Anita | HR              | 45000  |
-- | NULL  | Finance         | NULL   |

-- Note:
-- Finance department is included even though no employee exists for it
-- employee columns (name, salary) are NULL for unmatched rows