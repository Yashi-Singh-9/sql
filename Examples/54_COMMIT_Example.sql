-- Use COMMIT in SQL
-- COMMIT is used to save a transaction permanently in the database

-- Start a transaction
BEGIN;

-- Example operations
UPDATE employees
SET salary = salary - 5000
WHERE id = 1;

UPDATE employees
SET salary = salary + 5000
WHERE id = 2;

-- Save changes permanently
COMMIT;

-- Explanation
-- COMMIT → saves all changes made during the transaction
-- BEGIN → starts the transaction
-- All operations between BEGIN and COMMIT are treated as one unit
-- After COMMIT, changes cannot be undone

-- Important Note:
-- Makes data changes permanent
-- Ensures durability (ACID property)
-- Cannot rollback after COMMIT

-- Example Scenario

-- Before COMMIT
-- | id | name  | salary |
-- | -- | ----- | ------ |
-- | 1  | Rahul | 60000  |
-- | 2  | Anita | 45000  |

-- After COMMIT

-- | id | name  | salary |
-- | -- | ----- | ------ |
-- | 1  | Rahul | 55000  |
-- | 2  | Anita | 50000  |

-- Note:
-- If COMMIT is not executed, changes may not be saved