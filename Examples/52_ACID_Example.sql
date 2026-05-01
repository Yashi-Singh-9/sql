-- ACID Properties in Database
-- ACID ensures reliable and safe transactions in a database

-- A → Atomicity
-- C → Consistency
-- I → Isolation
-- D → Durability

-- Explanation

-- Atomicity
-- A transaction is treated as a single unit
-- Either all operations are completed or none
-- Example:
-- Transfer money → debit + credit must both succeed

-- Consistency
-- Ensures database remains in a valid state
-- Rules, constraints are always maintained
-- Example:
-- Balance cannot become negative if rule exists

-- Isolation
-- Transactions do not interfere with each other
-- Each transaction runs independently
-- Example:
-- Two users updating same data do not conflict

-- Durability
-- Once a transaction is committed, it is permanent
-- Data is not lost even if system crashes
-- Example:
-- After payment success, data is محفوظ (saved permanently)

-- Important Note:
-- ACID properties are essential for transactional databases
-- Used in banking systems, financial apps, etc.

-- Example Scenario (Transaction)

-- START TRANSACTION;

-- UPDATE accounts SET balance = balance - 1000 WHERE id = 1;
-- UPDATE accounts SET balance = balance + 1000 WHERE id = 2;

-- COMMIT;

-- If any step fails:
-- ROLLBACK;

-- This ensures ACID properties are maintained