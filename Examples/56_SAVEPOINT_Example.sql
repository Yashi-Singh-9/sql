-- Use SAVEPOINT in SQL
-- SAVEPOINT is used to create a point inside a transaction to rollback partially

-- Start a transaction
BEGIN;

-- First operation
UPDATE employees
SET salary = salary - 5000
WHERE id = 1;

-- Create a savepoint
SAVEPOINT sp1;

-- Second operation
UPDATE employees
SET salary = salary + 3000
WHERE id = 2;

-- Create another savepoint
SAVEPOINT sp2;

-- Third operation
UPDATE employees
SET salary = salary + 2000
WHERE id = 3;

-- Rollback to a specific savepoint
ROLLBACK TO sp1;

-- Commit remaining changes
COMMIT;

-- Explanation
-- SAVEPOINT → creates a checkpoint inside a transaction
-- sp1, sp2 → names of savepoints
-- ROLLBACK TO sp1 → undo changes after sp1
-- COMMIT → saves remaining valid changes

-- Important Note:
-- Allows partial rollback instead of full rollback
-- Useful in complex transactions
-- Savepoints are cleared after COMMIT or full ROLLBACK

-- Example Scenario

-- Before Transaction
-- | id | name  | salary |
-- | -- | ----- | ------ |
-- | 1  | Rahul | 60000  |
-- | 2  | Anita | 45000  |
-- | 3  | Ravi  | 50000  |

-- After ROLLBACK TO sp1 and COMMIT

-- | id | name  | salary |
-- | -- | ----- | ------ |
-- | 1  | Rahul | 55000  |  ← applied
-- | 2  | Anita | 45000  |  ← rolled back
-- | 3  | Ravi  | 50000  |  ← rolled back

-- Note:
-- Only changes before SAVEPOINT sp1 are saved