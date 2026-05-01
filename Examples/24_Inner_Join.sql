-- Use INNER JOIN between employees and departments table
-- INNER JOIN is used to combine data from two tables based on a matching condition

-- Tables used:
-- employees → stores employee details
-- departments → stores department details

-- employees table
-- | id | name  | department_id | salary |
-- | -- | ----- | ------------- | ------ |

-- departments table
-- | department_id | department_name |
-- | ------------- | --------------- |

-- INNER JOIN example
SELECT e.name, d.department_name, e.salary
FROM employees e
INNER JOIN departments d
ON e.department_id = d.department_id;

-- Explanation
-- INNER JOIN → returns only matching rows from both tables
-- employees e → alias 'e' for employees table
-- departments d → alias 'd' for departments table
-- ON → specifies the join condition
-- e.department_id = d.department_id → matching column

-- Important Note:
-- Only rows with matching values in both tables are returned
-- Non-matching rows are excluded
-- Most commonly used JOIN

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

-- Example Output (INNER JOIN)

-- | name  | department_name | salary |
-- | ----- | --------------- | ------ |
-- | Rahul | IT              | 60000  |
-- | Anita | HR              | 45000  |

-- Note:
-- Ravi is not shown because department_id = 3
-- does not exist in departments table