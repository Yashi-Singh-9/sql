-- Use CROSS JOIN between employees and departments table
-- CROSS JOIN returns all possible combinations of rows from both tables

-- Tables used:
-- employees → first table
-- departments → second table

-- employees table
-- | id | name  |
-- | -- | ----- |

-- departments table
-- | department_name |
-- | --------------- |

-- CROSS JOIN example
SELECT e.name, d.department_name
FROM employees e
CROSS JOIN departments d;

-- Explanation
-- CROSS JOIN → returns Cartesian product (all combinations)
-- employees e → first table
-- departments d → second table
-- Each row of employees is combined with every row of departments

-- Important Note:
-- No condition (ON) is used in CROSS JOIN
-- Total rows = (rows in employees) × (rows in departments)
-- Can produce very large result sets

-- Example Table Data

-- employees
-- | id | name  |
-- | -- | ----- |
-- | 1  | Rahul |
-- | 2  | Anita |

-- departments
-- | department_name |
-- | --------------- |
-- | IT              |
-- | HR              |

-- Example Output (CROSS JOIN)

-- | name  | department_name |
-- | ----- | --------------- |
-- | Rahul | IT              |
-- | Rahul | HR              |
-- | Anita | IT              |
-- | Anita | HR              |

-- Note:
-- Every employee is paired with every department