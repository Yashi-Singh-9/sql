-- Use BEGIN in SQL
-- BEGIN is used to start a transaction

-- A transaction is a group of SQL statements executed together

-- Start a transaction
BEGIN;

-- Example transaction
BEGIN;

UPDATE employees
SET salary = salary - 5000
WHERE id = 1;

UPDATE employees
SET salary = salary + 5000
WHERE id = 2;

-- Save changes
COMMIT;

-- If error occurs, undo changes
-- ROLLBACK;

-- Explanation
-- BEGIN → starts a transaction
-- Transaction → group of SQL operations treated as one unit
-- COMMIT → saves all changes permanently
-- ROLLBACK → cancels all changes if something goes wrong

-- Important Note:
-- Ensures data consistency and integrity
-- Used in banking, payments, critical operations
-- Works with ACID properties

-- Example Scenario

-- Before Transaction
-- | id | name  | salary |
-- | -- | ----- | ------ |
-- | 1  | Rahul | 60000  |
-- | 2  | Anita | 45000  |

-- After Transaction (COMMIT)

-- | id | name  | salary |
-- | -- | ----- | ------ |
-- | 1  | Rahul | 55000  |
-- | 2  | Anita | 50000  |

-- If ROLLBACK is used:
-- Data remains unchanged