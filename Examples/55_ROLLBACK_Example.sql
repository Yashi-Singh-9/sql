-- Use ROLLBACK in SQL
-- ROLLBACK is used to undo changes made during a transaction

-- Start a transaction
BEGIN;

-- Example operations
UPDATE employees
SET salary = salary - 5000
WHERE id = 1;

UPDATE employees
SET salary = salary + 5000
WHERE id = 2;

-- Undo all changes
ROLLBACK;

-- Explanation
-- ROLLBACK → cancels all changes made in the transaction
-- BEGIN → starts the transaction
-- All operations between BEGIN and ROLLBACK are undone
-- Database returns to previous state

-- Important Note:
-- Used when an error occurs
-- Helps maintain data integrity
-- Cannot undo changes after COMMIT

-- Example Scenario

-- Before Transaction
-- | id | name  | salary |
-- | -- | ----- | ------ |
-- | 1  | Rahul | 60000  |
-- | 2  | Anita | 45000  |

-- After ROLLBACK

-- | id | name  | salary |
-- | -- | ----- | ------ |
-- | 1  | Rahul | 60000  |
-- | 2  | Anita | 45000  |

-- Note:
-- Changes are completely discarded