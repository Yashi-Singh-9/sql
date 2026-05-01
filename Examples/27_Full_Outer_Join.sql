-- Use FULL OUTER JOIN between employees and departments table
-- FULL OUTER JOIN returns all records from both tables
-- matching rows are combined, non-matching rows show NULL

-- Tables used:
-- employees → left table
-- departments → right table

-- employees table
-- | id | name  | department_id | salary |
-- | -- | ----- | ------------- | ------ |

-- departments table
-- | department_id | department_name |
-- | ------------- | --------------- |

-- FULL OUTER JOIN example
SELECT e.name, d.department_name, e.salary
FROM employees e
FULL OUTER JOIN departments d
ON e.department_id = d.department_id;

-- Explanation
-- FULL OUTER JOIN → returns all rows from both tables
-- employees e → left table
-- departments d → right table
-- ON → join condition
-- e.department_id = d.department_id → matching column

-- Important Note:
-- Matching rows are combined
-- Non-matching rows from both tables are included with NULL values
-- Not supported directly in some databases like MySQL (use UNION instead)

-- Example Table Data

-- employees
-- | id | name  | department_id | salary |
-- | -- | ----- | ------------- | ------ |
-- | 1  | Rahul | 1             | 60000  |
-- | 2  | Anita | 2             | 45000  |
-- | 3  | Ravi  | 4             | 50000  |

-- departments
-- | department_id | department_name |
-- | ------------- | --------------- |
-- | 1             | IT              |
-- | 2             | HR              |
-- | 3             | Finance         |

-- Example Output (FULL OUTER JOIN)

-- | name  | department_name | salary |
-- | ----- | --------------- | ------ |
-- | Rahul | IT              | 60000  |
-- | Anita | HR              | 45000  |
-- | Ravi  | NULL            | 50000  |
-- | NULL  | Finance         | NULL   |

-- Note:
-- Ravi is included (no matching department)
-- Finance is included (no matching employee)
-- NULL values appear where no match exists