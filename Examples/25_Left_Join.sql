-- Use LEFT JOIN between employees and departments table
-- LEFT JOIN returns all records from the left table
-- and matching records from the right table

-- Tables used:
-- employees → left table (main table)
-- departments → right table

-- employees table
-- | id | name  | department_id | salary |
-- | -- | ----- | ------------- | ------ |

-- departments table
-- | department_id | department_name |
-- | ------------- | --------------- |

-- LEFT JOIN example
SELECT e.name, d.department_name, e.salary
FROM employees e
LEFT JOIN departments d
ON e.department_id = d.department_id;

-- Explanation
-- LEFT JOIN → returns all rows from left table + matched rows from right table
-- employees e → left table
-- departments d → right table
-- ON → join condition
-- e.department_id = d.department_id → matching column

-- Important Note:
-- If no match is found in right table, NULL values are returned
-- All rows from left table are always included

-- Example Table Data

-- employees
-- | id | name  | department_id | salary |
-- | -- | ----- | ------------- | ------ |
-- | 1  | Rahul | 1             | 60000  |
-- | 2  | Anita | 2             | 45000  |
-- | 3  | Ravi  | 3             | 50000  |

-- departments
-- | department_id | department_name |
-- | ------------- | --------------- |
-- | 1             | IT              |
-- | 2             | HR              |

-- Example Output (LEFT JOIN)

-- | name  | department_name | salary |
-- | ----- | --------------- | ------ |
-- | Rahul | IT              | 60000  |
-- | Anita | HR              | 45000  |
-- | Ravi  | NULL            | 50000  |

-- Note:
-- Ravi is included even though department_id = 3
-- does not exist in departments table
-- department_name is NULL for Ravi