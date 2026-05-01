-- Use SELF JOIN on employees table
-- SELF JOIN is used to join a table with itself

-- Table used:
-- employees → stores employee details including manager relationship

-- employees table (example with manager_id)
-- | id | name  | manager_id |
-- | -- | ----- | ---------- |

-- SELF JOIN example
SELECT e.name AS employee, m.name AS manager
FROM employees e
JOIN employees m
ON e.manager_id = m.id;

-- Explanation
-- SELF JOIN → joining the same table with itself
-- employees e → first instance (employee)
-- employees m → second instance (manager)
-- e.manager_id = m.id → links employee to their manager
-- AS → used to rename columns for clarity

-- Important Note:
-- Table must have a relationship with itself (like manager_id)
-- Aliases are required to differentiate the same table
-- Commonly used for hierarchical data

-- Example Table Data

-- | id | name  | manager_id |
-- | -- | ----- | ---------- |
-- | 1  | Rahul | NULL       |
-- | 2  | Anita | 1          |
-- | 3  | Ravi  | 1          |

-- Example Output (SELF JOIN)

-- | employee | manager |
-- | -------- | ------- |
-- | Anita    | Rahul   |
-- | Ravi     | Rahul   |

-- Note:
-- Rahul is not shown as employee because manager_id is NULL
-- SELF JOIN helps represent relationships within the same table